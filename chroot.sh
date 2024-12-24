#!/bin/bash

read -p "Timezone (Region/City)?: " TIMEZONE
read -p "Locale UTF-8 (xx_XX)? : " LOCALE
read -p "What is my name? : " HOSTNAME
read -p "What is your name? : " USERNAME

sed -i '/^#\[multilib]/s/^#//g' /etc/pacman.conf && sed -i '/\[multilib]/{N;s/\n#/\n/}' /etc/pacman.conf

# Install packages and enable services

pacman -Sy \
efibootmgr grub \
amd-ucode apparmor brightnessctl dnsmasq fastfetch firewalld networkmanager neovim power-profiles-daemon sudo \
\
egl-wayland lib32-mesa lib32-nvidia-utils lib32-vulkan-icd-loader lib32-vulkan-radeon libva-nvidia-driver nvidia-dkms nvidia-prime nvidia-settings nvidia-utils vulkan-icd-loader vulkan-radeon \
\
noto-fonts-cjk noto-fonts-emoji noto-fonts-extra \
\
sddm weston \
plasma-meta \
ark dolphin firefox inkscape kitty krita qemu-desktop virt-manager wine wine-mono wine-gecko winetricks zenity

systemctl enable apparmor.service
systemctl enable firewalld
systemctl enable libvirtd.socket
systemctl enable NetworkManager
systemctl enable power-profiles-daemon
systemctl enable sddm

# Bootloader and stuff to make NVIDIA card work properly

sed -i '/MODULES=()/s//MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf && sed -i '/GRUB_CMDLINE_LINUX_DEFAULT="/s//GRUB_CMDLINE_LINUX_DEFAULT="lsm=landlock,lockdown,yama,integrity,apparmor,bpf nvidia-drm.modeset=1 nvidia-drm.fbdev=1 nvidia.NVreg_EnableGpuFirmware=0 /' /etc/default/grub
mkinitcpio -P
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ARCH
grub-mkconfig -o /boot/grub/grub.cfg

# Locale

ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc
sed -i "/$LOCALE.UTF-8/s/^#//g" /etc/locale.gen
locale-gen
echo LANG=$LOCALE.UTF-8 > /etc/locale.conf

# Computer name and user

echo $HOSTNAME > /etc/hostname

useradd -mG wheel $USERNAME
usermod -aG input $USERNAME
usermod -aG libvirt $USERNAME
passwd $USERNAME

echo "Set root password..."
passwd

# Make config file for greeter

mkdir -p /etc/sddm.conf.d
cat > /etc/sddm.conf.d/sddm.conf<< EOF
[General]
DisplayServer=wayland

[Theme]
Current=breeze
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

# Add some dotfiles

cp -r dotfiles/. /home/$USERNAME/.config
cp .bashrc /home/$USERNAME/

# Default face in user directory and give ownership to user

cp /usr/share/sddm/faces/.face.icon /home/$USERNAME/
chown -R $USERNAME /home/$USERNAME
setfacl -m u:sddm:x /home/$USERNAME/
setfacl -m u:sddm:r /home/$USERNAME/.face.icon

# Finish

echo "EDITOR=nvim visudo before you reboot..."
exit
