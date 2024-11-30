# my-dotfiles
![alt text](https://github.com/kawa-sanmyaku/my-dotfiles/blob/main/docs/dotpic1.png)

Bar: [waybar](https://github.com/Alexays/Waybar)

Explorer: [nemo](https://github.com/linuxmint/nemo)

GTK theme: [materia](https://github.com/nana-4/materia-theme) (not pictured)

Icons: [papirus-icon-theme](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme)

Launcher: [wofi](https://sr.ht/~scoopta/wofi/)

Start menu: [nwg-menu](https://github.com/nwg-piotr/nwg-menu)

Wallpaper: [mitsubasa](https://f4.bcbits.com/img/0030581061_130.jpg)

# notes
* *The hyprland.conf includes some window rules for programs like REAPER and MuLab, you can delete those if you want*

* *The dot.sh script will copy the dotfiles and ask if you want to place .face.icon in your home directory*

* *waybar and wofi use style.css, while nwg-menu imports from it into its own css file*

* *Windows are not transparent by default anymore except kitty*

* *Every time the terminal is cleared, fastfetch will run again, I think the fetch is aesthetic ^-^*

# chroot.sh
I made because I'm lazy >.&lt; if my system ever breaks, I don't want to have to set everything up again

It is meant to be run in a chroot environment in Arch-based distributions; it's a very simple script that installs a bunch of packages including libraries, drivers, a window manager, etc., as well as sddm and weston

It also adds NVIDIA modules to /etc/mkinitcpio.conf, adds kernel parameters to /etc/default/grub, installs grub, prompts for a time zone, a locale, user name, etc., enables touchpad input for sddm...

If you want to use this script, it's better to clone it and modify as desired; make your own improvements, maybe even make your own script; I'm not a dev so I had to follow some tutorials... don't expect the script to be perfect, or good at all

DO NOT USE THE SCRIPT AS-IS IF YOU DON'T KNOW WHAT YOU'RE DOING, BECAUSE I DON'T KNOW WHAT I'M DOING MYSELF >.<

The sudoers file must be edited manually after the script is done running, since it seems like a bad idea to let a script do that
