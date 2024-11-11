# my-chroot-script
A script I made because I'm lazy >.&lt;

It is meant to be run in a chroot environment in Arch-based distributions; it's a very simple script that installs a bunch of packages including libraries, drivers, a window manager, etc., as well as sddm and weston

It also adds NVIDIA modules to /etc/mkinitcpio.conf, kernel parameters to /etc/default/grub, and installs grub

An icon theme and a GTK theme are included but this script doesn't set those up, or any other form of customization; they're instead set by a Hyprland config which I'll upload one day

After it's done installing packages it will ask for a time zone, generate the locale, and ask for a user name and a computer/host name, after which it'll make config files for sddm and weston to 1) explicitly tell sddm to use weston via the DisplayServer=wayland setting, and 2) enable touchpad click at the greeter (this script was written with a laptop in mind)

If you want to use this script, it's better to clone it and modify as desired; make your own improvements, maybe even make your own script; I'm not a dev so I had to follow some tutorials... don't expect the script to be perfect

DO NOT USE THE SCRIPT AS-IS IF YOU DON'T KNOW WHAT YOU'RE DOING, BECAUSE I DON'T KNOW WHAT I'M DOING MYSELF >.<

The sudoers file must be edited manually after the script is done running, since it seems like a bad idea to let a script do that
