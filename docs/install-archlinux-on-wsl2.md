# Install Arch Linux on WSL2

I use WSL only at work because the security software
and Mobile Device Management software
at my current company do not support Linux Desktop.
Probably work following setup.

## Windows

Install chezmoi with [winget][winget-link] and deploy dotfiles.

```pwsh
winget install -e --id twpayne.chezmoi

chezmoi init n4vysh && chezmoi apply
```

[winget-link]: https://github.com/microsoft/winget-cli

### Keyboard

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

### Font

Download [NerdFontsSymbolsOnly][nerdfonts-link] and [Noto Sans JP][noto-sans-link]
and install its.

[nerdfonts-link]: https://github.com/ryanoasis/nerd-fonts/releases
[noto-sans-link]: https://fonts.google.com/noto/specimen/Noto+Sans+JP

## WSL

[Install Arch Linux][install-wsl-link] and set default distribution.

```pwsh
wsl --install archlinux
```

[install-wsl-link]: https://learn.microsoft.com/en-us/windows/wsl/install
