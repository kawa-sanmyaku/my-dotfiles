#!/bin/bash

cp -r dotfiles/. ~/.config/
cp .bashrc ~/

read -p "Copy .face.icon to ~ (Y/N)?: " choice
case $choice in
        [Yy] )
		cp /usr/share/sddm/faces/.face.icon ~/
		setfacl -m u:sddm:x ~/
		setfacl -m u:sddm:r ~/.face.icon
		echo "Use 'cp /path/to/image.png ~/.face.icon' to set your user profile pic, this will be displayed by kitty, nwg-menu, and the greeter ^-^"
                ;;
        [Nn] )
                echo "u-u"
                ;;
        * )
                echo "Ah?"
                ;;
esac

exit
