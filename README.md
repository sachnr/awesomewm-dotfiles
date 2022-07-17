# Dotfiles
Awesome wm dotfiles

<div align="center">
    <h3>Gruvbox</h3>
</div>

![](https://i.imgur.com/CjwqHwr.png)

<div align="center">
    <h3>Nord</h3>
</div>

![](https://i.imgur.com/KgH0D21.png)

## Archlinux

### yay
```bash
$ sudo pacman -S base-devel git
$ git clone https://aur.archlinux.org/yay.git ~/Downloads/yay
$ cd ~/Downloads/yay
$ makepkg -si
```
### window manager
```bash
$ yay -S awesome-git
```
### picom
```bash
$ git clone https://github.com/dccsillag/picom.git ~/Downloads/picom
$ cd ~/Downloads/picom
$ git submodule update --init --recursive
$ meson --buildtype=release . build
$ ninja -C build
$ ninja -C build install
```
### Fonts
```bash
$ yay -S nerd-fonts-roboto-mono material-icons-git ttf-roboto ttf-ms-win11-auto
```
### Laptop
```bash
pacman -S acpi acpid acpi_call brightnessctl upower
```
### Network
```bash
pacman -S nm-connection-editor networkmanager network-manager-applet bluez-utils bluez blueman
```
### Media
```bash
pacman -S ffmpeg mpv mpd mpc mpdris2 python-mutagen ncmpcpp playerctl
```
### packages
```bash
$ yay -S i3lock-color caffeine-ng lxappearance-gtk3
$ pacman -S alacritty flameshot papirus-icon-theme ufw redshift rofi mtpfs gvfs-mtp
$ pacman -S gnome-system-monitor xfce4-power-manager nemo polkit-gnome gtk3
```
### Pulseaudio
```bash
$ pacman -S pulseaudio pulseaudio-alsa pulseaudio-bluetooth pulseaudio-jack alsa-utils
```
### Systemd
```bash
$ sudo systemctl enable --now mpd
$ sudo systemctl enable --now bluetooth
$ sudo systemctl enable --now NetworkManager
```
### install config
```bash
$ git clone --recurse-submodules https://github.com/sachnr/dotfiles.git ~/.config/awesome
$ cd ~/.config/awesome
$ git submodule update --remote --merge
```


