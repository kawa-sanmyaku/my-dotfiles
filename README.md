# my-chroot-script
A script I made because I'm lazy >.&lt;

It is meant to be run in a chroot environment in Arch-based distributions; it's a very simple script that installs a bunch of packages including libraries, drivers, a window manager, etc., as well as sddm and weston

It also adds NVIDIA modules to /etc/mkinitcpio.conf, kernel parameters to /etc/default/grub, and installs grub

After it's done installing packages it will ask for a time zone, generate the locale, and ask for a user name and a computer/host name, after which it'll make config files for sddm and weston to 1) explicitly tell sddm to use weston via the DisplayServer=wayland setting, and 2) enable touchpad click at the greeter (this script was written with a laptop in mind)

If you want to use this script, it's better to clone it and modify as desired; make your own improvements, maybe even make your own script; I'm not a dev so I had to follow some tutorials...

DO NOT USE THE SCRIPT AS-IS IF YOU DON'T KNOW WHAT YOU'RE DOING, BECAUSE I DON'T KNOW WHAT I'M DOING MYSELF >.<

Oh and you have to manually edit the sudoers file, I haven't quite figured out a way to do it safely in bash but will update if I do ^^
