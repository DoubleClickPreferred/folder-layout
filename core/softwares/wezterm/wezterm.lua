-- Pull in the wezterm API
local wezterm = require 'wezterm'

local config = {} -- table to hold the configuration

if wezterm.config_builder then
   -- override the config table with the config_builder, if available: provide clearer messages when something is misconfigured
   config = wezterm.config_builder()
end


--
-- UNDERLYING SHELL
--

config.default_prog = { 'c:\\home\\static\\bin\\w64devkit\\bin\\sh.exe', '-l' } -- '-l' to load .profile from HOME
config.set_environment_variables = {
   HOME = 'c:\\home\\core\\unix',-- home of .profile
}
config.exit_behavior = 'CloseOnCleanExit'
config.window_close_confirmation = 'NeverPrompt'


--
-- GLOBAL STYLES
--

-- show retro tab_bar
config.enable_tab_bar = true
config.use_fancy_tab_bar = false

-- show scroll_bar
config.enable_scroll_bar = true
config.scroll_to_bottom_on_input = true
config.scrollback_lines = 3500


-- font styles
config.font = wezterm.font('YOUR FONT')
config.font_size=11

-- set the position of the window at startup
wezterm.on('gui-startup', function(cmd)
   local muxTab, pane, muxWindow = wezterm.mux.spawn_window(cmd or {})
   -- muxWindow:gui_window():toggle_fullscreen()
   muxWindow:gui_window():set_inner_size(1500, 900)
   muxWindow:gui_window():set_position(150, 100)
end)

-- color_schemes
local solarized_dark_color_scheme_name = 'Solarized Dark (Gogh)'
local solarized_light_color_scheme_name = 'Solarized (light) (terminal.sexy)'

local builtin_color_schemes = wezterm.get_builtin_color_schemes()
local solarized_dark_color_scheme = builtin_color_schemes[solarized_dark_color_scheme_name]
local solarized_light_color_scheme = builtin_color_schemes[solarized_light_color_scheme_name]

solarized_dark_color_scheme.scrollbar_thumb = '#586e75'
solarized_light_color_scheme.scrollbar_thumb = '#93a1a1'

config.color_schemes = {
   [solarized_dark_color_scheme_name] = solarized_dark_color_scheme,
   [solarized_light_color_scheme_name] = solarized_light_color_scheme,
}
config.color_scheme = solarized_light_color_scheme_name

-- tab_bar style
local solarized_dark_tab_bar = {
   background = '#073642',-- color of the strip that goes along the top of the window
   active_tab = {
      bg_color = '#002b36',-- color of the background
      fg_color = '#586e75',-- color of the text
      intensity = 'Bold',-- Half, Normal, Bold
      underline = 'None',-- None, Single, Double
      italic = false,
      strikethrough = false,
   },
   inactive_tab = {
      bg_color = '#073642',
      fg_color = '#586e75',
      intensity = 'Normal',
      underline = 'None',
      italic = false,
      strikethrough = false,
   },
   inactive_tab_hover = {
      bg_color = '#002b36',
      fg_color = '#586e75',
      intensity = 'Normal',
      underline = 'None',
      italic = false,
      strikethrough = false,
   },
   new_tab = {
      bg_color = '#11424f',
      fg_color = '#586e75',
      intensity = 'Bold',
      underline = 'None',
      italic = false,
      strikethrough = false,
   },
   new_tab_hover = {
      bg_color = '#002b36',
      fg_color = '#586e75',
      intensity = 'Bold',
      underline = 'None',
      italic = false,
      strikethrough = false,
   },
}

local solarized_light_tab_bar = {
   background = '#eee8d5',-- color of the strip that goes along the top of the window
   active_tab = {
      bg_color = '#fdf6e3',-- color of the background
      fg_color = '#93a1a1',-- color of the text
      intensity = 'Bold',-- Half, Normal, Bold
      underline = 'None',-- None, Single, Double
      italic = false,
      strikethrough = false,
   },
   inactive_tab = {
      bg_color = '#eee8d5',
      fg_color = '#93a1a1',
      intensity = 'Normal',
      underline = 'None',
      italic = false,
      strikethrough = false,
   },
   inactive_tab_hover = {
      bg_color = '#fdf6e3',
      fg_color = '#93a1a1',
      intensity = 'Normal',
      underline = 'None',
      italic = false,
      strikethrough = false,
   },
   new_tab = {
      bg_color = '#e8e1d0',
      fg_color = '#93a1a1',
      intensity = 'Bold',
      underline = 'None',
      italic = false,
      strikethrough = false,
   },
   new_tab_hover = {
      bg_color = '#fdf6e3',
      fg_color = '#93a1a1',
      intensity = 'Bold',
      underline = 'None',
      italic = false,
      strikethrough = false,
   },
}

config.colors = {
   tab_bar = solarized_light_tab_bar
}

-- toggle_color_scheme

wezterm.on('toggle_color_scheme', function(window)
   local config_overrides = window:get_config_overrides() or {}

   if config_overrides.color_scheme == solarized_dark_color_scheme_name then
      config_overrides.color_scheme = solarized_light_color_scheme_name
      config_overrides.colors = {
         tab_bar = solarized_light_tab_bar
      }
   else
      -- the default color_scheme being Solarized Light, the default overrides is Solarized Dark
      config_overrides.color_scheme = solarized_dark_color_scheme_name
      config_overrides.colors = {
         tab_bar = solarized_dark_tab_bar
      }
   end
   
   window:set_config_overrides(config_overrides)
end)

--
-- KEYBINDINGS
--

config.disable_default_key_bindings = true

config.keys = {
   -- CTRL-SHIFT-C & CTRL-SHIFT-V to copy & paste (same shortcuts as on a Linux terminal)
   { key = 'C', mods = 'CTRL|SHIFT', action = wezterm.action.CopyTo('Clipboard') },
   { key = 'V', mods = 'CTRL|SHIFT', action = wezterm.action.PasteFrom('Clipboard') },

   -- CTRL-SHIFT-D to close WezTerm (I thought I would use Ctrl-D but its behavior is not always the same. Ctrl-D closes the terminal if used right away. If not, it depends on the state of the shell because the shell does not return the same exit code every time: I got exit code 130 after doing Ctrl-C then Ctrl-D, I can get exit code 127 but do not remember how... So I'm configuring CTRL-SHIFT-D to be sure to have a shortcut which always closes the terminal)
   { key = 'D', mods = 'CTRL|SHIFT', action = wezterm.action.CloseCurrentTab { confirm = false } },
   
   -- CTRL-SHIFT-F calls the searchBookmarks function defined in ~/.profile
   { key = 'F', mods = 'CTRL|SHIFT', action = wezterm.action.Multiple {
         wezterm.action.SendString "searchBookmarks",
         wezterm.action.SendKey { key = 'Enter', mods = 'NONE' },
      },
   },

   -- CTRL-SHIFT-I activates the debug overlay (same shortcut as Developer Tools in browsers)
   { key = 'I', mods = 'CTRL|SHIFT', action = wezterm.action.ShowDebugOverlay },

   -- CTRL-SHIFT-M to toggle the color_scheme
   { key = 'M', mods = 'CTRL|SHIFT', action = wezterm.action.EmitEvent 'toggle_color_scheme' },

   -- CTRL-SHIFT-O to clear the scrollback
   { key = 'O', mods = 'CTRL|SHIFT', action = wezterm.action.Multiple {
         wezterm.action.ClearScrollback 'ScrollbackAndViewport', -- clear everything before the prompt line, so that includes the current directory path since it is displayed on a line before the prompt
         wezterm.action.SendKey { key = 'L', mods = 'CTRL' }, -- when the shell receives Ctrl-L, it redraws the prompt so I get back the current directory path
      },
   },
   
   -- CTRL-SHIFT-P to show the CommandPalette (same shortcut as WezTerm out-of-the-box)
   { key = 'P', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateCommandPalette },
   
   -- CTRL-SHIFT-T calls the searchBookmarks function defined in ~/.profile
   { key = 'T', mods = 'CTRL|SHIFT', action = wezterm.action.SpawnCommandInNewTab },
   
   -- CTRL-SHIFT-1 calls the goToBookmark function defined in ~/.profile
   { key = '1', mods = 'CTRL|SHIFT', action = wezterm.action.Multiple {
         wezterm.action.SendString "goToBookmark 1 && cls",
         wezterm.action.SendKey { key = 'Enter', mods = 'NONE' },
      },
   },
   
   -- CTRL-SHIFT-2 calls the goToBookmark function defined in ~/.profile
   { key = '2', mods = 'CTRL|SHIFT', action = wezterm.action.Multiple {
         wezterm.action.SendString "goToBookmark 2 && cls",
         wezterm.action.SendKey { key = 'Enter', mods = 'NONE' },
      },
   },
   
   -- CTRL-SHIFT-3 calls the goToBookmark function defined in ~/.profile
   { key = '3', mods = 'CTRL|SHIFT', action = wezterm.action.Multiple {
         wezterm.action.SendString "goToBookmark 3 && cls",
         wezterm.action.SendKey { key = 'Enter', mods = 'NONE' },
      },
   },
   
   -- CTRL-SHIFT-4 calls the goToBookmark function defined in ~/.profile
   { key = '4', mods = 'CTRL|SHIFT', action = wezterm.action.Multiple {
         wezterm.action.SendString "goToBookmark 4 && cls",
         wezterm.action.SendKey { key = 'Enter', mods = 'NONE' },
      },
   },
   
   -- CTRL-SHIFT-5 calls the goToBookmark function defined in ~/.profile
   { key = '5', mods = 'CTRL|SHIFT', action = wezterm.action.Multiple {
         wezterm.action.SendString "goToBookmark 5 && cls",
         wezterm.action.SendKey { key = 'Enter', mods = 'NONE' },
      },
   },
   
   -- CTRL-SHIFT-6 calls the goToBookmark function defined in ~/.profile
   { key = '6', mods = 'CTRL|SHIFT', action = wezterm.action.Multiple {
         wezterm.action.SendString "goToBookmark 6 && cls",
         wezterm.action.SendKey { key = 'Enter', mods = 'NONE' },
      },
   },
   
   -- CTRL-SHIFT-7 calls the goToBookmark function defined in ~/.profile
   { key = '7', mods = 'CTRL|SHIFT', action = wezterm.action.Multiple {
         wezterm.action.SendString "goToBookmark 7 && cls",
         wezterm.action.SendKey { key = 'Enter', mods = 'NONE' },
      },
   },

   -- F11 to toggle full-screen (like in Notepad++)
   { key = 'F11', mods = 'NONE', action = wezterm.action.ToggleFullScreen },
}


--
-- MOUSE BINDINGS
--

config.disable_default_mouse_bindings = true

config.mouse_bindings = {
   -- Using the mouse wheel up/down to scroll
   {
      event = { Down = { streak = 1, button = { WheelUp = 1 } } },
      mods = 'NONE',
      action = wezterm.action.ScrollByCurrentEventWheelDelta,
   },
   {
      event = { Down = { streak = 1, button = { WheelDown = 1 } } },
      mods = 'NONE',
      action = wezterm.action.ScrollByCurrentEventWheelDelta,
   },

   -- Using the mouse wheel up/down while holding CTRL to increase/decrease the font size
   {
      event = { Down = { streak = 1, button = { WheelUp = 1 } } },
      mods = 'CTRL',
      action = wezterm.action.IncreaseFontSize,
   },
   {
      event = { Down = { streak = 1, button = { WheelDown = 1 } } },
      mods = 'CTRL',
      action = wezterm.action.DecreaseFontSize,
   },

   -- Alt-Middle reset the font size to its default value
   {
      event = { Down = { streak = 1, button = 'Middle' } },
      mods = 'ALT',
      action = wezterm.action.ResetFontSize,
   },

   -- Left click:
   --   Down & Drag are for selecting text, and the modifiers help to control how the selection is done
   --   Up is not used (by default, it was automatically copying the selected text to the clipboard)
   {
      event = { Down = { streak = 1, button = 'Left' } },
      mods = 'NONE',
      action = wezterm.action.SelectTextAtMouseCursor('Cell')
   },
   {
      event = { Down = { streak = 1, button = 'Left' } },
      mods = 'SHIFT',
      action = wezterm.action.ExtendSelectionToMouseCursor('Cell')
   },
   {
      event = { Down = { streak = 1, button = 'Left' } },
      mods = 'ALT',
      action = wezterm.action.SelectTextAtMouseCursor('Block')
   },
   {
      event = { Down = { streak = 1, button = 'Left' } },
      mods = 'SHIFT|ALT',
      action = wezterm.action.ExtendSelectionToMouseCursor('Block')
   },
   {
      event = { Drag = { streak = 1, button = 'Left' } },
      mods = 'NONE',
      action = wezterm.action.ExtendSelectionToMouseCursor('Cell')
   },
   {
      event = { Drag = { streak = 1, button = 'Left' } },
      mods = 'ALT',
      action = wezterm.action.ExtendSelectionToMouseCursor('Block')
   },

   -- Left double-click selects the word under the cursor
   {
      event = { Down = { streak = 2, button = 'Left' } },
      mods = 'NONE',
      action = wezterm.action.SelectTextAtMouseCursor("Word")
   },

   -- Right click pastes the content of the clipboard
   {
      event = { Down = { streak = 1, button = 'Right' } },
      mods = 'NONE',
      action = wezterm.action.PasteFrom('Clipboard')
   },

   -- CTRL-Click open hyperlinks
   {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'CTRL',
      action = wezterm.action.OpenLinkAtMouseCursor,
   },
   { -- Disable the 'Down' event of CTRL-Click to avoid weird program behaviors
      event = { Down = { streak = 1, button = 'Left' } },
      mods = 'CTRL',
      action = wezterm.action.Nop,
   },
}


-- and finally, return the configuration to wezterm
return config