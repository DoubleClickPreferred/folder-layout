-- Utilities

local function asWindowsPathname(string)
  -- only return the first result
  local windowsPath = String.gsub(string, "/", "\\")
  return windowsPath
end

local function listFolderNamesOnly(folderPathname)
  local table = {}
  local file, message = io.popen('dir /ad /b ' .. asWindowsPathname(folderPathname))

  if message ~= nil then
    print('listFolderNamesOnly message: ' .. message)
  end

  if file ~= nil then
    local i = 0
    for line in file:lines() do
      i = i + 1
      table[i] = line
    end

    io.close(file)
  end

  return table
end

local tableDeepEqual, deepEqual

function tableDeepEqual(expectedTable, obtainedTable)
  local treatedKeys = {}

  -- check that all (key, value) from expectedTable are in obtainedTable
  for key, value in pairs(expectedTable) do
    treatedKeys[key] = true
    if not deepEqual(value, obtainedTable[key]) then
      return false
    end
  end

  -- reverse check: since we built the list treatedKeys, if one key from obtainedTable is not referenced in treatedKeys, then that key is not in expectedTable and that's enough to tell that the tables are not equal
  for key in pairs(obtainedTable) do
    if not treatedKeys[key] then
      return false
    end
  end

  -- if we get here, it means that the previous eliminatory checks saw no differences
  -- => the tables are equal
  return true
end

function deepEqual(expectedValue, obtainedValue)
  local expectedType = type(expectedValue)
  local obtainedType = type(obtainedValue)

  if expectedType ~= obtainedType then
    return false
  elseif expectedType == "table" then
    return tableDeepEqual(expectedValue, obtainedValue)
  else
    return expectedValue == obtainedValue
  end
end

local function indexOf(referenceValue, table)
  local matchingIndex = -1
  for index, value in ipairs(table) do
    if deepEqual(referenceValue, value) then
      matchingIndex = index
      break
    end
  end
  return matchingIndex
end

local function split(string, separator)
   local table = {}
   
   for field,s in string.gmatch(string, "([^"..separator.."]*)("..separator.."?)") do
      Table.insert(table, field)
      
      if s == "" then
         return table
      end
   end
end

local function join(table, separator)
   local string = ""
   
   for index, value in ipairs(table) do
      if index > 1 then
         string = string .. separator
      end
      
      string = string .. value
   end

   return string
end

local function concatenate(targetTable, sourceTable)
   local targetLength, sourceLength
   
   targetLength = #targetTable
   sourceLength = #sourceTable
   
   for index=1, sourceLength do
      targetTable[targetLength + index] = sourceTable[index]
   end
   
   return targetTable
end

local function copyTable(table)
   local copiedTable, length
   
   copiedTable = {}
   length = #table
   
   for index=1, length do
      copiedTable[index] = table[index]
   end
   
   return copiedTable
end


-- Dedicated functions

local finalFolderNameByProgramName = {
   fd = '',
   fzf = '',
   hashlink = '',
   haxe = '',
   jdk = 'bin',
   lua = '',
   maven = 'bin',
   node = '',
   PortableGit = 'cmd',
   ripgrep = '',
   w64devkit = 'bin',
}

local function ensureFolderPathname(absoluteFolder)
   local lastCharacter = String.sub(absoluteFolder, String.len(absoluteFolder))

   if lastCharacter == "\\" then
      return absoluteFolder
   else
      return absoluteFolder .. "\\"
   end
end

local function getProgramName(folderName)
   local fields = split(folderName, "-")
   return fields[1]
end

local function compareStringIgnoreCase(stringA, stringB)
   return String.lower(stringA) < String.lower(stringB)
end

local function makeProgramLocationByProgramName(binAbsoluteFolder)
   local folderNames, programName, programNames, programLocationByProgramName, finalFolderName
   
   folderNames = listFolderNamesOnly(binAbsoluteFolder)
   programName = ""
   programNames = {}
   programLocationByProgramName = {}
   
   for index, folderName in ipairs(folderNames) do
      programName = getProgramName(folderName)
      Table.insert(programNames, programName)
      
      finalFolderName = finalFolderNameByProgramName[programName]
      if finalFolderName == nil then
         programLocationByProgramName[programName] = ""
      elseif finalFolderName == '' then
         programLocationByProgramName[programName] = binAbsoluteFolder .. folderName
      else
         programLocationByProgramName[programName] = binAbsoluteFolder .. folderName .. "\\" .. finalFolderName
      end
   end
   
   Table.sort(programNames, compareStringIgnoreCase)
   
   return programLocationByProgramName, programNames
end

local function getRegisteredProgramLocations()
   local registeredProgramLocationsString, file, message, lineIterator
   
   registeredProgramLocationsString = ""
   
   -- os.getenv("PATH") will return a string of *all* program locations: the system-wide program locations + the user-specific program locations
   -- We want to modify only the user-specific ones so we need to get these program locations and leave aside the system-wide program locations
   -- Thanks to Manohar Reddy Poreddy for this spot-on CMD code which does exactly that!
   -- see https://stackoverflow.com/questions/19287379/how-do-i-add-to-the-windows-path-variable-using-setx-having-weird-problems#26947177
   file, message = io.popen('for /f "usebackq tokens=2,*" %A in (`reg query HKCU\\Environment /v PATH`) do @echo %B')

   if message ~= nil then
      print('getRegisteredProgramLocations message: ' .. message)
   end

   if file ~= nil then
      lineIterator = file:lines()
      registeredProgramLocationsString = lineIterator()
      io.close(file)
   end
   
   return split(registeredProgramLocationsString, ";")
end

local function indexOfProgramName(programName, registeredProgramLocations, binAbsoluteFolder)
   local foundIndex, startIndex
   
   foundIndex = -1
   
   for index, registeredProgramLocation in ipairs(registeredProgramLocations) do
      startIndex = String.find(registeredProgramLocation, "\\" .. programName .. "[^\\]*")
      
      if startIndex then
         foundIndex = index
         break
      end
   end
   
   return foundIndex
end

local function adaptRegisteredProgramLocations(binAbsoluteFolder)
   local programLocationByProgramName, programNames, registeredProgramLocations, additionalProgramLocations, adaptedProgramLocations, programLocation, foundIndex, registeredProgramLocation, prefixStartIndex, folderName
   
   programLocationByProgramName, programNames = makeProgramLocationByProgramName(binAbsoluteFolder)
   registeredProgramLocations = getRegisteredProgramLocations()
   additionalProgramLocations = {}
   adaptedProgramLocations = copyTable(registeredProgramLocations)
   
   for index, programName in ipairs(programNames) do
      programLocation = programLocationByProgramName[programName]
      
      if programLocation == "" then
         print('- ' .. programName .. '\n\t ignored as it is not configured in finalFolderNameByProgramName\n')
      else
         foundIndex = indexOfProgramName(programName, registeredProgramLocations, binAbsoluteFolder)
         
         if foundIndex == -1 then
            print("- " .. programName .. "\n\t added in front of PATH\n")
            Table.insert(additionalProgramLocations, programLocation)
         else
            registeredProgramLocation = registeredProgramLocations[foundIndex]
            prefixStartIndex = String.find(registeredProgramLocation, binAbsoluteFolder)
            
            if prefixStartIndex == 1 then
               if registeredProgramLocation == programLocation then
                  print("- " .. programName .. "\n\t is already registered with its available location: " .. programLocation .. "\n")
               else
                  print("- " .. programName .. "\n\t to register at its available location: " .. programLocation .. "\n")
                  adaptedProgramLocations[foundIndex] = programLocation
               end
            elseif prefixStartIndex == nil then
               print("- " .. programName .. "\n\t is already registered but outside of the bin folder: " .. registeredProgramLocation .. "\n")
            else
               print("- " .. programName .. "\n\t is already registered, at a weird location: " .. registeredProgramLocation .. "\n")
            end
         end
      end
   end
   
   return concatenate(additionalProgramLocations, adaptedProgramLocations)
end

local function updatePathEnvironmentVariable(adaptedRegisteredProgramLocations)
   local pathValue, file, message
   
   pathValue = join(adaptedRegisteredProgramLocations, ";")
   file, message = io.popen('setx PATH "' .. pathValue .. '"')

   if message ~= nil then
      print('updatePathEnvironmentVariable message: ' .. message)
   end

   if file ~= nil then
      for line in file:lines() do
         print(line)
      end
      io.close(file)
   end
end

local function main(binAbsoluteFolder)
   print("Adapting program locations with the programs available at " .. binAbsoluteFolder .. "\n")
   local adaptedRegisteredProgramLocations = adaptRegisteredProgramLocations(ensureFolderPathname(binAbsoluteFolder))
   updatePathEnvironmentVariable(adaptedRegisteredProgramLocations)
end

main(arg[1])