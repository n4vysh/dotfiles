# [dotfiles](https://n4vysh.github.io/dotfiles/)

![overview][overview-link]

| Bootsplash                          | Login screen                       |
| :---------------------------------- | :--------------------------------- |
| ![bootsplash-link][bootsplash-link] | ![login-screen][login-screen-link] |

| No window                   | Lock screen                      |
| :-------------------------- | :------------------------------- |
| ![no window][nowindow-link] | ![lock-screen][lock-screen-link] |

[overview-link]: ./docs/assets/screenshots/overview.png
[bootsplash-link]: ./docs/assets/screenshots/bootsplash.png
[login-screen-link]: ./docs/assets/screenshots/login-screen.png
[nowindow-link]: ./docs/assets/screenshots/no-window.png
[lock-screen-link]: ./docs/assets/screenshots/lock-screen.png

- **Distro**: [Arch Linux][archlinux-link]
- **Dotfiles Manager**: [chezmoi][chezmoi-link]
- **Display Manager**: [ly][ly-link]
- **Window Manager**: [Hyprland][hyprland-link]
- **Shell**: [Zsh][zsh-link]
- **Editor**: [Neovim][neovim-link]
- **Coding Agent**: [OpenCode][opencode-link]
- **File Manager**: [yazi][yazi-link]
- **Terminal Multiplexer**: [Tmux][tmux-link]
- **Terminal Emulator**: [Ghostty][ghostty-link]

[package list](./home/.chezmoidata/packages.yaml)

[archlinux-link]: https://github.com/archlinux
[chezmoi-link]: https://github.com/twpayne/chezmoi
[ly-link]: https://github.com/fairyglade/ly
[hyprland-link]: https://github.com/hyprwm/Hyprland
[zsh-link]: https://github.com/zsh-users/zsh
[neovim-link]: https://github.com/neovim/neovim
[opencode-link]: https://github.com/anomalyco/opencode
[ghostty-link]: https://github.com/ghostty-org/ghostty
[tmux-link]: https://github.com/tmux/tmux
[yazi-link]: https://github.com/sxyazi/yazi

## ⚡️ Requirements

- [Arch Linux][archlinux-link]
  (installation guide: [native][install-guide-link] / [wsl][install-guide-wsl-link])

[install-guide-link]: ./docs/installation/arch-linux.md
[install-guide-wsl-link]: ./docs/installation/wsl2.md

## 🚀 Usage

### Deploy dotfiles

> [!CAUTION]
> Do not use blindly. Running this will overwrite your dotfiles.

Deploy dotfiles to home directory following commands.

```sh
sudo pacman -S --noconfirm --needed chezmoi &&
    chezmoi init n4vysh &&
    chezmoi apply
```

Install packages with [chezmoi scripts][chezmoi-scripts-link]
when running `chezmoi apply`.

[chezmoi-scripts-link]: https://github.com/twpayne/chezmoi/blob/master/assets/chezmoi.io/docs/user-guide/use-scripts-to-perform-actions.md

## 📜 License

This project distributed under the [Unlicense][unlicense-link].
See the [UNLICENSE](./UNLICENSE) file for details.

[unlicense-link]: https://choosealicense.com/licenses/unlicense/
