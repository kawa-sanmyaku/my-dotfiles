#!/bin/bash

sed -i '/^#\[multilib]/s/^#//g' /etc/pacman.conf && sed -i '/\[multilib]/{N;s/\n#/\n/}' /etc/pacman.conf

# Install packages and enable services

pacman -Sy \
efibootmgr grub \
amd-ucode brightnessctl fastfetch firewalld git networkmanager network-manager-applet neovim rsync sudo \
\
lib32-mesa vulkan-radeon lib32-vulkan-radeon nvidia-dkms nvidia-prime nvidia-settings nvidia-utils lib32-nvidia-utils vulkan-icd-loader lib32-vulkan-icd-loader libva-nvidia-driver \
\
sddm weston \
dunst egl-wayland hyprland hyprlock kitty nemo nwg-menu polkit-kde-agent pipewire pipewire-alsa pipewire-jack pipewire-pulse pavucontrol swww waybar wireplumber wofi \
noto-fonts-cjk noto-fonts-emoji noto-fonts-extra ttf-font-awesome ttf-meslo-nerd \
firefox inkscape krita mpd ncmpcpp wine wine-mono wine-gecko winetricks zenity

systemctl enable firewalld
systemctl enable NetworkManager
systemctl enable power-profiles-daemon
systemctl enable sddm

# Bootloader and stuff to make NVIDIA card work properly

sed -i '/MODULES=()/s//MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm/)' /etc/mkinitcpio.conf && sed -i '/loglevel=3 quiet/s//loglevel=3 quiet nvidia-drm.modeset=1 nvidia-drm.fbdev=1 nvidia.NVreg_EnableGpuFirmware=0/' /etc/default/grub
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

# Finish

echo "EDITOR=nvim visudo before you reboot..."
exit
