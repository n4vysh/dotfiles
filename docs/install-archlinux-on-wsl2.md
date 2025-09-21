# Install Arch Linux on WSL2

I use WSL only at work because the security software
and Mobile Device Management software
at my current company do not support Linux Desktop.
Probably work following setup.

- Window Manager: [GlazeWM][glazewm-link]
- Terminal Emulator: [WezTerm][wezterm-link]

[package list](./src/.chezmoidata/packages.yaml)

[glazewm-link]: https://github.com/glzr-io/glazewm
[wezterm-link]: https://wezterm.org/

## 🪟 Windows

Install chezmoi with [winget][winget-link] and deploy dotfiles.

```pwsh
winget install -e --id twpayne.chezmoi

# install scoop for font installation
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

chezmoi init n4vysh && chezmoi apply
```

[winget-link]: https://github.com/microsoft/winget-cli

### ⌨️ Custom keybinds

Deploy [remap.skl][sharpkeys-config-link] and [hotkeys.ahk][ahk-config-link]
to remap following keys and shortcuts
with [SharpKeys][sharpkeys-link] and [AutoHotKey][ahk-link].

| Physical key   | Mapped To      | Note                        |
| :------------- | :------------- | :-------------------------- |
| `Super (Left)` | `F13`          |                             |
| `Menu`         | `Super (Left)` |                             |
| `Alt (Right)`  | `Ctrl (Right)` | `Escape` when pressed alone |
| `Alt (Left)`   | `Alt (Left)`   |                             |

[sharpkeys-config-link]: ../misc/wsl/remap.skl
[ahk-config-link]: ../src/dot_glzr/glazewm/hotkeys.ahk
[sharpkeys-link]: https://github.com/randyrants/sharpkeys
[ahk-link]: https://www.autohotkey.com/

### 📦 List of applications

| Category      | Name                            |
| :------------ | :------------------------------ |
| Launcher      | [ueli][ueli-link]               |
| Screen record | [ScreenToGif][screentogif-link] |

[ueli-link]: https://ueli.app/
[screentogif-link]: https://www.screentogif.com/

### 🗛 Font

Download [NerdFontsSymbolsOnly][nerdfonts-link] and [Noto Sans JP][noto-sans-link]
and install its.

[nerdfonts-link]: https://github.com/ryanoasis/nerd-fonts/releases
[noto-sans-link]: https://fonts.google.com/noto/specimen/Noto+Sans+JP

## 🐧 WSL

[Install Arch Linux][install-wsl-link] and set default distribution.

```pwsh
wsl --install archlinux
```

```sh
pacman -Syu zsh sudo

username="$(
    powershell.exe '$env:USERNAME' |
        tr -d '\r' |
        tr '[:upper:]' '[:lower:]'
)"
useradd -m -G wheel -s /bin/zsh "$username"
passwd "$username"
echo "%wheel ALL=(ALL) ALL" > /etc/sudoers.d/wheel
chmod 440 /etc/sudoers.d/wheel
exit
```

```pwsh
wsl --manage archlinux --set-default-user $env:USERNAME.ToLower()
wezterm
```

[install-wsl-link]: https://wiki.archlinux.org/title/Install_Arch_Linux_on_WSL
