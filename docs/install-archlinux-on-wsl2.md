# Install Arch Linux on WSL2

I use WSL only at work because the security software
and Mobile Device Management software
at my current company do not support Linux Desktop.
Probably work following setup.

- Window Manager: [GlazeWM][glazewm-link]
- Terminal Emulator: [WezTerm][wezterm-link]

[package list](../home/.chezmoidata/packages.yaml)

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

Update the bundled `OpenConsole.exe` and `conpty.dll` as a matched pair
if WezTerm v20240203.

1. Close all WezTerm windows.
2. Download `Microsoft.Windows.Console.ConPTY.1.24.260402001.nupkg` from the
   [Microsoft Terminal v1.24.10921.0 release][conpty-release-link].
3. Extract the downloaded NuGet package.
4. Copy the following files into `C:\Program Files\WezTerm` with Administrator
   permissions, replacing the bundled files.
   - `build/native/runtimes/x64/OpenConsole.exe` to `OpenConsole.exe`
   - `runtimes/win-x64/native/conpty.dll` to `conpty.dll`
5. Restart WezTerm.

A WezTerm upgrade can overwrite these files, so repeat the procedure when
necessary.

References:

- [WezTerm Discussion #6588][wezterm-discussion-link]
- [WezTerm Issue #7774][wezterm-issue-link]

[winget-link]: https://github.com/microsoft/winget-cli
[conpty-release-link]: https://github.com/microsoft/terminal/releases/tag/v1.24.10921.0
[wezterm-discussion-link]: https://github.com/wezterm/wezterm/discussions/6588#discussioncomment-11956378
[wezterm-issue-link]: https://github.com/wezterm/wezterm/issues/7774

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
[ahk-config-link]: ../home/dot_glzr/glazewm/hotkeys.ahk
[sharpkeys-link]: https://github.com/randyrants/sharpkeys
[ahk-link]: https://www.autohotkey.com/

### 📦 List of applications

| Category      | Name                                |
| :------------ | :---------------------------------- |
| Status bar    | [YASB][yasb-link]                   |
| Launcher      | [Flow Launcher][flow-launcher-link] |
| Screen record | [ScreenToGif][screentogif-link]     |

[yasb-link]: https://github.com/amnweb/yasb
[flow-launcher-link]: https://github.com/Flow-Launcher/Flow.Launcher
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
(
    set -x

    pacman -Syu --noconfirm zsh sudo &&
        username="$(powershell.exe '$env:USERNAME.ToLower()' | tr -d '\r')" &&
        useradd -m -G wheel -s /bin/zsh "$username" &&
        passwd "$username" &&
        echo "%wheel ALL=(ALL) ALL" > /etc/sudoers.d/wheel &&
        chmod 440 /etc/sudoers.d/wheel &&
        hostnamectl set-hostname localhost
)

exit
```

```pwsh
wsl --manage archlinux --set-default-user $env:USERNAME.ToLower()
wezterm
```

[install-wsl-link]: https://wiki.archlinux.org/title/Install_Arch_Linux_on_WSL
