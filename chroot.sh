#!/bin/bash

sed -i '/^#\[multilib]/s/^#//g' /etc/pacman.conf && sed -i '/\[multilib]/{N;s/\n#/\n/}' /etc/pacman.conf

# Install packages and enable services

pacman -Sy \
efibootmgr grub \
amd-ucode apparmor brightnessctl fastfetch firewalld networkmanager network-manager-applet neovim power-profiles-daemon rsync sudo \
\
egl-wayland lib32-mesa lib32-nvidia-utils lib32-vulkan-icd-loader lib32-vulkan-radeon libva-nvidia-driver nvidia-dkms nvidia-prime nvidia-settings nvidia-utils vulkan-icd-loader vulkan-radeon \
\
materia-gtk-theme noto-fonts-cjk noto-fonts-emoji noto-fonts-extra papirus-icon-theme ttf-font-awesome ttf-meslo-nerd \
\
sddm weston \
hyprland \
dunst pavucontrol pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber xdg-desktop-portal-gtk xdg-desktop-portal-hyprland polkit-kde-agent qt5-wayland qt6-wayland \
waybar swww wofi hyprpicker cliphist nemo nemo-fileroller hyprlock \
firefox grim inkscape kitty krita mpd ncmpcpp nwg-menu slurp wine wine-mono wine-gecko winetricks zenity

systemctl enable apparmor.service
systemctl enable firewalld
systemctl enable NetworkManager
systemctl enable power-profiles-daemon
systemctl enable sddm

# Bootloader and stuff to make NVIDIA card work properly

sed -i '/MODULES=()/s//MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf && sed -i '/GRUB_CMDLINE_LINUX_DEFAULT="/s//GRUB_CMDLINE_LINUX_DEFAULT="lsm=landlock,lockdown,yama,integrity,apparmor,bpf nvidia-drm.modeset=1 nvidia-drm.fbdev=1 nvidia.NVreg_EnableGpuFirmware=0 /' /etc/default/grub
mkinitcpio -P
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ARCH
grub-mkconfig -o /boot/grub/grub.cfg

# Locale

echo -n "Timezone (Region/City)? : "
read TIMEZONE
ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc
echo -n "Locale UTF-8 (xx_XX)? : "
read LOCALE
sed -i "/$LOCALE.UTF-8/s/^#//g" /etc/locale.gen
locale-gen
echo LANG=$LOCALE.UTF-8 > /etc/locale.conf

# Computer name and user

echo -n "What is my name? : "
read HOSTNAME
echo $HOSTNAME > /etc/hostname

echo -n "What is your name? : "
read USERNAME
useradd -mG wheel $USERNAME
usermod -aG input $USERNAME
passwd $USERNAME

echo "Set root password..."
passwd

# Make config file for greeter

mkdir -p /etc/sddm.conf.d
cat > /etc/sddm.conf.d/sddm.conf<< EOF
[General]
DisplayServer=wayland

[Theme]
Current=
EnableAvatars=true
FacesDir=/usr/share/sddm/faces
ThemeDir=/usr/share/sddm/themes
EOF

# Enable touchpad click for greeter

mkdir -p /etc/xdg/weston
cat > /etc/xdg/weston/weston.ini<< EOF
[libinput]
enable-tap=true
EOF
chmod go+r /etc/xdg/weston/weston.ini

# Custom

read -p "Add dotfiles (Y/N)?: " choice
case $choice in
        [Yy] )
                echo "^-^"
		cp -r dotfiles/. /home/$USERNAME/.config/
		cp .bashrc /home/$USERNAME/
                ;;
        [Nn] )
                echo "u-u"
                ;;
        * )
                echo "Ah?"
                ;;
esac

# Default face in user directory and give ownership to user

cp /usr/share/sddm/faces/.face.icon /home/$USERNAME/
chown -R $USERNAME /home/$USERNAME
setfacl -m u:sddm:x /home/$USERNAME/
setfacl -m u:sddm:r /home/$USERNAME/.face.icon

# Finish

echo "EDITOR=nvim visudo before you reboot..."
exit
