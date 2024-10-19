# Install Arch Linux on WSL2

I use WSL only at work because the security software
and Mobile Device Management software
at my current company do not support Linux Desktop.
Probably work following setup.

## Packages

### [winget][winget-link]

Install some packages with winget.

```pwsh
winget install -e --id wez.wezterm
winget install -e --id Mozilla.Firefox
winget install -e --id LGUG2Z.komorebi --version 0.1.23
winget install -e --id OliverSchwendener.ueli
winget install -e --id RandyRants.SharpKeys
winget install -e --id Lexikos.AutoHotkey
winget install -e --id SlackTechnologies.Slack
winget install -e --id PortSwigger.BurpSuite.Community
winget install -e --id WiresharkFoundation.Wireshark
winget install -e --id Insecure.Nmap
winget install -e --id OpenVPNTechnologies.OpenVPN
winget install -e --id QMK.QMKToolbox
winget install -e --id JGraph.Draw
winget install -e --id hrkfdn.ncspot
winget install -e --id Espanso.Espanso
winget install -e --id NickeManarin.ScreenToGif
winget install -e --id Gyan.FFmpeg
```

[winget-link]: https://github.com/microsoft/winget-cli

### [Scoop][scoop-link]

Install scoop command and some packages.

```pwsh
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex
scoop install git
scoop bucket add extras
scoop bucket add nerd-fonts
scoop install archwsl win32yank mpv yt-dlp sudo
sudo scoop install -g firacode
```

[scoop-link]: https://scoop.sh/

## Keyboard

Deploy [remap.skl][sharpkeys-config-link] and [remap.ahk][ahk-config-link]
to remap following keys and shortcuts
with [SharpKeys][sharpkeys-link] and [AutoHotKey][ahk-link].

| Physical key   | Mapped To      | Note                        |
| :------------- | :------------- | :-------------------------- |
| `Super (Left)` | `F13`          |                             |
| `Menu`         | `Super (Left)` |                             |
| `Alt (Right)`  | `Ctrl (Right)` | `Escape` when pressed alone |
| `Alt (Left)`   | `Alt (Left)`   |                             |

[sharpkeys-config-link]: ../misc/wsl/misc/remap.skl
[ahk-config-link]: ../misc/wsl/misc/remap.ahk
[sharpkeys-link]: https://github.com/randyrants/sharpkeys
[ahk-link]: https://www.autohotkey.com/

## Font

Download [NerdFontsSymbolsOnly][nerdfonts-link] and [Noto Sans JP][noto-sans-link]
and install its.

[nerdfonts-link]: https://github.com/ryanoasis/nerd-fonts/releases
[noto-sans-link]: https://fonts.google.com/noto/specimen/Noto+Sans+JP

## WSL

[Install wsl command][install-wsl-link].

```pwsh
wsl --install
```

[Install ArchWSL][archwsl-setup-link].

Install [wslu][wslu-link].

```bash
pacman-key -r A2861ABFD897DD37
pacman-key --lsign-key A2861ABFD897DD37
cat <<EOF >>/etc/pacman.conf

[wslutilities]
Server = https://pkg.wslutiliti.es/arch/
EOF
pacman -Sy && pacman -S wslu
```

[Disable WSLg][wslconfig-link] to make faster startup time.

```bash
user=$(powershell.exe '$env:UserName' | sed -e 's/\r//g')
cp "$XDG_DATA_HOME/dotfiles/misc/wsl/misc/.wslconfig" >"/mnt/c/Users/$user/.wslconfig"
```

[Enable systemd support][systemd-doc-link] without [wrapper scripts][genie-link]
and [disable launching Windows processes][interop-doc-link]
to [make faster auto-completion][path-issue-link].

```bash
cp "$XDG_DATA_HOME/dotfiles/misc/wsl/misc/etc/wsl.conf" >/etc/wsl.conf
```

Deploy wrapper scripts to [prevent invalid argument error][argument-issue-link].

```bash
(
  dir="$XDG_DATA_HOME/dotfiles/misc/wsl/src"
  cd "$dir"
  fd . .local/bin/ |
    xargs -I {} ln -sv "$dir/{}" "$HOME/{}"
)
```

Deploy dotfiles to Windows user directory.

```bash
user=$(powershell.exe '$env:UserName' | sed -e 's/\r//g')
dir="/mnt/c/Users/$user"
cp -iv \
  "$XDG_DATA_HOME/dotfiles/misc/wsl/misc/komorebi.json" \
  "$dir/komorebi.json"
cp -iv \
  "$XDG_DATA_HOME/dotfiles/misc/wsl/misc/komorebi.json" \
  "$dir/komorebi.ahk"
dir="/mnt/c/Users/$user/.config"
mkdir "$dir/wezterm/"
cp -iv \
  "$XDG_DATA_HOME/dotfiles/misc/wsl/src/.config/wezterm/wezterm.lua" \
  "$dir/wezterm/"
mkdir "$dir/mpv/"
cp -iv \
  "$XDG_DATA_HOME/dotfiles/misc/wsl/src/.config/mpv/mpv.conf" \
  "$dir/mpv/"
appdata=$(powershell.exe '$env:AppData' | sed -e 's/\r//g')
dir="/mnt/c/Users/$appdata"
mkdir "$dir/ncspot/"
cp -iv \
  "$XDG_DATA_HOME/dotfiles/misc/wsl/src/.config/ncspot/config.toml" \
  "$dir/ncspot/"
```

Deploy dotfiles to WSL user directory.

```bash
(
  dir="$XDG_DATA_HOME/dotfiles/misc/wsl/src"
  cd "$dir"
  fd \
    --hidden . \
    -E .local/bin/ \
    -E .config/wezterm/ \
    -E .config/mpv/ \
    -E .config/ncspot/ \
    -t f |
    xargs -I {} ln -sv "$dir/{}" "$HOME/{}"
)
```

Deploy etc files.

```bash
sudo cp -iv \
  misc/wsl/misc/etc/systemd/system/systemd-timesyncd.service.d/override.conf \
  /etc/systemd/system/systemd-timesyncd.service.d/
```

Set wallpaper and account icon for Windows.

```bash
sudo pacman -S archlinux-wallpaper
cp /usr/share/backgrounds/archlinux/split.png ~/Downloads/wallpaper.png
yay -S archlinux-artwork
convert \
  -density 1200 \
  -background black \
  /usr/share/archlinux/icons/archlinux-icon-crystal-256.svg \
  ~/Downloads/archlinux-icon.png
```

Tweak dotfiles.

```bash
cat <<EOF >>~/.config/lazygit/config.yml
os:
  copyToClipboardCmd: printf {{text}} | win32yank.exe -i
EOF
```

[install-wsl-link]: https://learn.microsoft.com/en-us/windows/wsl/install
[archwsl-setup-link]: https://wsldl-pg.github.io/ArchW-docs/How-to-Setup
[wslu-link]: https://wslutiliti.es/wslu/
[wslconfig-link]: https://learn.microsoft.com/en-us/windows/wsl/wsl-config#configuration-setting-for-wslconfig
[genie-link]: https://github.com/arkane-systems/genie
[systemd-doc-link]: https://learn.microsoft.com/en-us/windows/wsl/wsl-config#systemd-support
[interop-doc-link]: https://learn.microsoft.com/en-us/windows/wsl/wsl-config#interop-settings
[path-issue-link]: https://github.com/microsoft/WSL/issues/4234#issuecomment-505609403
[argument-issue-link]: https://github.com/microsoft/WSL/issues/6170#issuecomment-882501566
