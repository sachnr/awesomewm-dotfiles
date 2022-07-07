# Dotfiles
personal repo for syncing data on new linux installations

<a href="url"><img src="https://i.imgur.com/8pl9sEh.png" width="720" ></a>

## Archlinux

### install yay
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
### packages
```bash
$ yay -S i3lock-fancy ttf-roboto caffeine-ng lxappearance-gtk3 nerd-fonts-roboto-mono material-icons-git 
$ pacman -S acpi acpid acpi_call alacritty bluez-utils bluez blueman brightnessctl flameshot ffmpeg 
$ pacman -S gnome-system-monitor xfce4-power-manager nautilus polkit-gnome rofi upower
$ pacman -S nm-connection-editor papirus-icon-theme networkmanager network-manager-applet
$ pacman -S mpv mpd mpc mpdris2 python-mutagen ncmpcpp playerctl
```
### Pulseaudio
```bash
$ pacman -S pulseaudio pulseaudio-alsa pulseaudio-bluetooth pulseaudio-jack
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
### extra packages(optional)
```bash
$ pacman -S vscode gpick pavucontrol ufw 
$ yay -S code-marketplace ttf-google-sans nautilus-open-any-terminal
```


