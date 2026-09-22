---
icon: lucide/settings
tags:
    - Getting started
    - Configuration
---

# 🚀 Usage

## Deploy dotfiles

<!-- rumdl-disable MD046 -->
!!! danger

    Do not use blindly. Running this will overwrite your dotfiles.
<!-- rumdl-enable MD046 -->

Deploy dotfiles to home directory following commands.

```sh
sudo pacman -S --noconfirm --needed chezmoi &&
    chezmoi init n4vysh &&
    chezmoi apply
```

Install packages with [chezmoi scripts][chezmoi-scripts-link]
when running `chezmoi apply`.

[chezmoi-scripts-link]: https://github.com/twpayne/chezmoi/blob/master/assets/chezmoi.io/docs/user-guide/use-scripts-to-perform-actions.md

## Configure Tresorit

``` sh
tresorit-cli login
tresorit-cli sync --start Documents --path ~/Documents
tresorit-cli sync --start Music --path ~/Music
tresorit-cli sync --start Pictures --path ~/Pictures
tresorit-cli sync --start Videos --path ~/Videos
```

## Configure Firefox

Install addons refer to the [collections][collections-link]
and restore settings from following files in [extras/firefox/](https://github.com/n4vysh/dotfiles/blob/main/extras/firefox/) directory.

| Addon name                          | File name                                         |
| :---------------------------------- | :------------------------------------------------ |
| [uBlock Origin][ublock-origin-link] | [ublock.txt](https://github.com/n4vysh/dotfiles/blob/main/extras/firefox/ublock.txt)             |
| [LibRedirect][libredirect-link]     | [libredirect.json](https://github.com/n4vysh/dotfiles/blob/main/extras/firefox/libredirect.json) |
| [ZeroOmega][zero-omega-link]        | [zero-omega.bak](https://github.com/n4vysh/dotfiles/blob/main/extras/firefox/zero-omega.bak)     |
| [Translate Web Pages][twp-link]     | [twp.txt](https://github.com/n4vysh/dotfiles/blob/main/extras/firefox/twp.txt)                   |

[collections-link]: https://addons.mozilla.org/en-US/firefox/collections/17575539/n4vysh/
[ublock-origin-link]: https://github.com/gorhill/uBlock
[libredirect-link]: https://github.com/libredirect/browser_extension
[zero-omega-link]: https://github.com/zero-peak/ZeroOmega
[twp-link]: https://github.com/FilipePS/Traduzir-paginas-web
