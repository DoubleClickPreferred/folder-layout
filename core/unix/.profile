#-------------
# Base folders
#-------------

# Assumed layout:
#
# core/
#   <home>/
#     scripts/
#       review-install.sh
#     .profile -> this very file
# static/
#   bin/
# work/
#   in-progress/

export CORE_FOLDER=$(realpath ~/..)



#----------------------
# Environment variables
#----------------------

export WORK_FOLDER=$(realpath $CORE_FOLDER/../work/in-progress)



#---------------------------------------------------------------------------
# Prompt: newline, show the full current path in green, newline, dollar sign
#---------------------------------------------------------------------------

PS1="$(printf '\n\x1b[32;1m\\w\x1b[0m\n$ ')"



#--------
# Aliases
#--------

## ...for Unix
alias ll='ls -al'
alias fresh='source ~/.profile'


## ... for Windows
alias ex='explorer .'
alias cls='clear'


## ...for Lua
function rgl() {
   rg $1 -tlua
}


## ...for Typescript
function rgt() {
   rg --ignore-vcs --type-add 'ts:*.mts' --type-add 'js:*.mjs' -tts -tjs -tless --iglob !**/js/* --iglob !node_modules/* "$*"
}

alias nt='cls && npm test onlyLastModified skipTimeboxedTests'
alias nta='cls && npm test'


## ...for the review command
function review() {
   local command_name="$1"

   case "$command_name" in
      install)
         . ~/scripts/review-install.sh
         ;;

      *)
         echo "Unknown command name [$command_name]"
         ;;
   esac
}


## ...for bookmarks
searchBookmarks() {
   local targetFolder=$(cat ~/bookmarks.txt | fzf)
   if [[ $targetFolder != '' ]]; then
      cd "$targetFolder"
   fi
}

goToBookmark() {
   local lineNumber="$1"
   local targetFolder=$(sed -n "${lineNumber}p" ~/bookmarks.txt)
   if [[ $targetFolder != '' ]]; then
      cd "$targetFolder"
   fi
}



#----------------
# Starting folder
#----------------

cd "$WORK_FOLDER"
