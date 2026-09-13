---
icon: lucide/file-cog
tags:
    - Overview
    - Features
---

# Overview

Follow the [Arch Linux](installation/arch-linux.md) or
[WSL2](installation/wsl2.md) installation guide, then
[deploy and configure](usage.md) the dotfiles.

Review the [applications](applications.md) and
[keybindings](keybindings/keyd.md) for daily use.

## ✨ Features

- Fast updates with [Rolling-release][rolling-release-link] system
- More-responsive
    - [Zen Kernel][zen-kernel-link]
    - [zram-generator][zram-generator-link]
    - [systemd-oomd][systemd-oomd-link]
    - [irqbalance][irqbalance-link]
    - [cpupower][cpupower-link]
    - [tlp][tlp-link]
    - [thermald][thermald-link]
- Parallelized [init process][init-link]
    - [systemd][systemd-link]
    - [systemd-network][systemd-network-link]
    - [systemd-resolved][systemd-resolved-link]
    - [systemd-timesyncd][systemd-timesyncd-link]
- Secure [display server][display-server-link] with [Wayland protocol][wayland-link]
- Efficiently and automatically organize desktop with [Tiling Window Manager][tiling-window-manager-link]
- [Transparent file compression][transparent-file-compression-link]
    - [Btrfs][btrfs-link]
    - [zstd][zstd-link]
- Minimal latency [sound server][sound-server-link] with [PipeWire][pipe-wire-link]
- [Full-disk encryption (FDE)][fde-link]
    - [dm-crypt][dm-crypt-link]
    - [LVM][lvm-link]
    - [LUKS][luks-link]
    - [systemd-cryptenroll][systemd-cryptenroll-link]
    - [TPM2][tpm-link]
- Passwordless sudo with [PAM U2F module][pam-u2f-module-link]
- User-related information encryption with [systemd-homed][systemd-homed-link]
- [Improving Boot process][boot-process-link]
    - [uncompressed initramfs][uncompressed-initramfs-link]
    - [Silent boot][silent-boot-link]
    - [systemd-boot][systemd-boot-link]
- [UEFI Secure Boot][uefi-secure-boot-link]
    - [unified kernel image (UKI)][uki-link]
    - [sbctl][sbctl-link]
- Enhance password security with [1Password][1password-link] and [Ente Auth][ente-auth-link]
- End-to-end encryption (E2EE)
    - [Signal][signal-link]
    - [Proton Mail][proton-mail-link]
    - [Tresorit][tresorit-link]
    - [Ente Photos][ente-photos-link]
    - [Obsidian][obsidian-link]
- Privacy focused web browsing
    - Search shortcuts for [DuckDuckGo][duckduckgo-link]
    - [Strict Enhanced Tracking Protection][strict-etp-link]
    - [HTTPS-Only Mode][https-only-mode-link]
    - [Multi-Account Containers][multi-account-containers-link]
    - [uBlock Origin][ublock-origin-link]
    - [LibRedirect][libredirect-link]
- Block incoming connections without allowed with [ufw][ufw-link]
- Detect rootkit with [rkhunter][rkhunter-link]
- Detect package vulnerabilities with [arch-audit][arch-audit-link]
- Support Onion over VPN with [Tor Browser][tor-browser-link] and [OpenVPN][openvpn-link]
- Prevent DNS leak and IPv6 leak
- Command abbreviation and snippets for pentesting with [zsh][zsh-link] and [pet][pet-link]
- Available a large amount of cyber security tools with [BlackArch repository][blackarch-link]
- Available prebuilt binaries with [Chaotic-AUR repository][chaotic-aur-link]
- Support for OSC
    - OSC 8 - hyperlinks (tmux + eza + rg + fd + delta + ls)
    - OSC 52 - clipboard integration for copy only (tmux + neovim)
    - OSC 133 - shell integration (tmux + powerlevel10k)
- Ergonomic keybinds with [keyd][keyd-link]
    - Thumb cluster
    - Dual function keys
        - [xcape][xcape-link]
        - [Space Cadet shift][space-cadet-shift-link]

[rolling-release-link]: https://en.wikipedia.org/wiki/Rolling_release
[zen-kernel-link]: https://github.com/zen-kernel/zen-kernel
[zram-generator-link]: https://github.com/systemd/zram-generator
[systemd-oomd-link]: https://www.freedesktop.org/software/systemd/man/latest/systemd-oomd.service.html
[irqbalance-link]: https://github.com/irqbalance/irqbalance
[cpupower-link]: https://github.com/torvalds/linux/tree/master/tools/power/cpupower
[tlp-link]: https://github.com/linrunner/TLP
[thermald-link]: https://github.com/intel/thermal_daemon
[uncompressed-initramfs-link]: https://bbs.archlinux.org/viewtopic.php?id=148172
[init-link]: https://wiki.archlinux.org/title/Init
[systemd-link]: https://github.com/systemd/systemd
[systemd-network-link]: https://www.freedesktop.org/software/systemd/man/latest/systemd.network.html
[systemd-resolved-link]: https://www.freedesktop.org/software/systemd/man/latest/systemd-resolved.service.html
[systemd-timesyncd-link]: https://www.freedesktop.org/software/systemd/man/latest/systemd-timesyncd.service.html
[tiling-window-manager-link]: https://en.wikipedia.org/wiki/Tiling_window_manager
[display-server-link]: https://en.wikipedia.org/wiki/Windowing_system#Display_server
[wayland-link]: https://wayland.freedesktop.org/
[transparent-file-compression-link]: https://btrfs.readthedocs.io/en/latest/Compression.html
[btrfs-link]: https://btrfs.readthedocs.io/en/latest/
[zstd-link]: https://github.com/facebook/zstd
[sound-server-link]: https://en.wikipedia.org/wiki/Sound_server
[pipe-wire-link]: https://github.com/PipeWire/pipewire
[fde-link]: https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system#LVM_on_LUKS
[dm-crypt-link]: https://en.wikipedia.org/wiki/Dm-crypt
[lvm-link]: https://en.wikipedia.org/wiki/Logical_Volume_Manager_(Linux)
[luks-link]: https://en.wikipedia.org/wiki/Linux_Unified_Key_Setup
[systemd-cryptenroll-link]: https://www.freedesktop.org/software/systemd/man/latest/systemd-cryptenroll.html
[tpm-link]: https://en.wikipedia.org/wiki/Trusted_Platform_Module
[pam-u2f-module-link]: https://github.com/Yubico/pam-u2f
[systemd-homed-link]: https://systemd.io/HOME_DIRECTORY/
[boot-process-link]: https://wiki.archlinux.org/title/Improving_performance/Boot_process
[silent-boot-link]: https://wiki.archlinux.org/title/Silent_boot
[systemd-boot-link]: https://www.freedesktop.org/software/systemd/man/latest/systemd-boot.html
[uefi-secure-boot-link]: https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface/Secure_Boot
[uki-link]: https://wiki.archlinux.org/title/Unified_kernel_image
[sbctl-link]: https://github.com/Foxboron/sbctl
[1password-link]: https://1password.com/
[ente-auth-link]: https://github.com/ente/ente#ente-auth
[signal-link]: https://github.com/signalapp/Signal-Desktop
[ente-photos-link]: https://github.com/ente/ente#ente-photos
[obsidian-link]: https://obsidian.md/sync
[strict-etp-link]: https://support.mozilla.org/en-US/kb/enhanced-tracking-protection-firefox-desktop
[duckduckgo-link]: https://duckduckgo.com/
[https-only-mode-link]: https://support.mozilla.org/en-US/kb/https-only-prefs
[multi-account-containers-link]: https://github.com/mozilla/multi-account-containers
[ublock-origin-link]: https://github.com/gorhill/uBlock
[libredirect-link]: https://github.com/libredirect/browser_extension
[ufw-link]: https://launchpad.net/ufw
[rkhunter-link]: https://rkhunter.sourceforge.net/
[arch-audit-link]: https://gitlab.archlinux.org/archlinux/arch-audit
[tor-browser-link]: https://www.torproject.org/download/
[openvpn-link]: https://github.com/OpenVPN/openvpn
[pet-link]: https://github.com/knqyf263/pet
[blackarch-link]: https://github.com/BlackArch/blackarch
[chaotic-aur-link]: https://aur.chaotic.cx/
[keyd-link]: https://github.com/rvaiya/keyd
[xcape-link]: https://man.archlinux.org/man/xcape.1.en
[space-cadet-shift-link]: https://github.com/qmk/qmk_firmware/blob/master/docs/features/space_cadet.md
