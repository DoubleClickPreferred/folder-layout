Assumed layout:

```
core/
   unix/
      scripts/
         review-install.sh
      .profile
      bookmarks.txt
   wezterm/
      wezterm.lua
   0-review-installation.bat
   1-maybe-edit-bat-file.txt
   2-set-basic-environment-variables.bat
   2-set-basic-environment-variables.lua
   3-edit-the-registry.txt
   4-clone-base-project.bat
duplicati/
   1-restore-bin-folder.bat
   2-clone-core.bat
   duplicati-2.0.7.1_beta_2023-05-25-x64.msi
static/
   bin/
      npp-8.5.7.portable.x64/
      PortableGit-2.41.0-64-bit/
      w64devkit/
      WezTerm/
work/
   archives/
      notepad++/
   in-progress/
```


0-review-installation.bat
-----------------------
Request the version number of each portable software. If the portable software is not appropriately referenced in the PATH variable, this script will fail to get the version number and you will know that the portable software is not configured.


1-maybe-edit-bat-file.txt
-----------------------
Explain in details how to maintain the next script and how it is working.


2-set-basic-environment-variables.bat
---------------------------------
Set up several environment variables. Read the file for the exact details.


2-set-basic-environment-variables.lua
---------------------------------
Called by the previous file.

This Lua script will safely add to the PATH variable the path of each portable software located in the *static/bin/* folder. By safely, I mean:
- if the path is not registered, it will added at the front of the PATH variable
- if a path is already registered, the new path always override the registered path (so, if both paths are identical, the registered path stays the same, no duplicated entries in PATH. And if different, the registered path is updated, no conflicting entries in PATH.)

You have to explicitly configure every portable software to reference in the variable 'finalFolderNameByProgramName', line 134. This is because not every portable software from the *static/bin/* folder needs to be called from the terminal. Additionally, it allows you to specify in which subfolder the .exe file can be found. Set to the empty string if the .exe is directly in the software folder itself.

This script is idempotent: you can run it as many times as you like, the result should be as desired, regardless of the starting point.


3-edit-the-registry.txt
---------------------
I could have made a script for some manipulations about Notepad++ and WinMerge.
I did not have the courage to dive in CMD complexities here so I just wrote down what needs to be done.


4-clone-base-project.bat
----------------------
I keep clones of my repositories on a USB key. I'm not sure you should do that. Maybe you can use Github or Gitlab. Regardless, this script ensures you can clone back to your PC some basic projects. For me, that is the one holding my Notepad++ config.

Note:
- if you want to use a USB key, change the *KEYNAME* in the script. Indeed, it runs a command first, to find the proper device letter of the key, so as to then use the right path in Git commands.
- I named the remote 'usbKey': you may want to change it.
- the main branch is called 'main'.
- you may want to adapt the paths too.


5-install-by-installers.txt
------------------------
Some softwares have no portable versions. This file lists all these softwares, so that I do not forget about them.


unix/wezterm.lua
--------------
Configuration for [WezTerm](https://wezfurlong.org/wezterm/index.html). WezTerm knows the path to this file thanks to the environment variable *WEZTERM_CONFIG_FILE* which is automatically setup by *2-set-basic-environment-variables.bat*.

The configuration is written in Lua but specific knowledge of Lua is not required. It's all about setting various field of the *config* object, using classic data like boolean, number and strings. The most complex code is passing a callback function to some WezTerm event. 

Here is what you have to edit yourself:
- the font, line 39
   `config.font = wezterm.font('YOUR FONT')`
- the size at startup, line 46
   `muxWindow:gui_window():set_inner_size(1500, 900)`
- the position at startup, line 47
   `muxWindow:gui_window():set_position(150, 100)`

I then configured the [Solarized color scheme](https://ethanschoonover.com/solarized/) (see more about Colors & Appearance [here](https://wezfurlong.org/wezterm/config/appearance.html) and various [key bindings](https://wezfurlong.org/wezterm/config/keys.html) and [mouse bindings](https://wezfurlong.org/wezterm/config/mouse.html).