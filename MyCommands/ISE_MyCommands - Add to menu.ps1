
# this line will add a new custom command with the keyboard shortcut ALT+T:
$psise.CurrentPowerShellTab.AddOnsMenu.Submenus.Add('Start Regedit', { regedit.exe }, 'ALT+T')

# this line will add a new custom command without a keyboard shortcut:
$psise.CurrentPowerShellTab.AddOnsMenu.Submenus.Add('Get Script Path', { $psise.CurrentFile.FullPath }, $null)

# these lines will first add a submenu, then add commands to it:
$parent = $psise.CurrentPowerShellTab.AddOnsMenu.SubMenus.Add('My Tools', $null, $null)
$parent.Submenus.Add('Close All Editors', { $psise.CurrentPowerShellTab.Files.Clear() }, 'ALT+X' )
$parent.Submenus.Add('Open powertheshell.com', { Start-Process www.powertheshell.com }, 'ALT+P' )

# all commands will be defined once you run this script
# to define commands permanently, place this code into your profile script
# the path to the profile script can be found in $profile. You may have to create the file and subfolder first.

