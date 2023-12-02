# Install Arch Linux without virtualization

## Acquire an installation image

- <https://archlinux.org/download/>

```bash
read -rp 'ISO URL: ' iso_url
read -rp 'ISO PGP signature URL: ' iso_sig_url
aria2c -d ~/Downloads/ "$iso_url"
wget -P ~/Downloads/ "$iso_sig_url"
gpg \
  --keyserver-options auto-key-retrieve \
  --verify \
  ~/Downloads/archlinux-*.*.*-x86_64.iso.sig
```

## Prepare an installation medium

```bash
ls -l /dev/disk/by-id/usb-*
lsblk
# /dev/disk/by-id/usb-My_flash_drive
read -rp 'drive path: ' usb_path
dd \
  bs=4M \
  if=~/Downloads/archlinux-*.*.*-x86_64.iso \
  of="$usb_path" \
  conv=fsync \
  oflag=direct \
  status=progress
```

## Boot the live environment

Run following procedures to put firmware in [Setup Mode][setup-mode-link]
and boot the live environment.

<!-- editorconfig-checker-disable -->

1. Press the power button while holding down the `F3` button.
1. Since rescue mode screen is displayed, and then select "Start BIOS setup".
1. When the “PHOENIX SECURECORE TECHNOLOGY SETUP” screen is displayed,
   press the `↓` key and select "Secure Boot" menu, and press the `Enter` key.
1. Press the `→` key, select "Clear All Secure Boot Settings", and press
   the `Enter` key.
1. Press the `↓` key, select "Exit", and `Enter` key.
1. Select "Start from medium" to boot the live environment.

<!-- editorconfig-checker-enable -->

[setup-mode-link]: https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface/Secure_Boot#Putting_firmware_in_%22Setup_Mode%22

## Wipe all data left on the device

```bash
lvremove /dev/volume/home
lvremove /dev/volume/root
lvscan
vgremove /dev/volume
vgscan
pvremove /dev/mapper/cryptlvm
pvscan
cryptsetup close cryptlvm
sgdisk -Z /dev/nvme0n1
dd if=/dev/zero of=/dev/nvme0n1 bs=4096 status=progress
```

## Launch tmux

```bash
tmux
tmux set -g mode-keys vi
```

## Authenticate to the wireless network

```bash
iwctl
```

```txt
[iwd]# device list
[iwd]# station <device> scan
[iwd]# station <device> get-networks
[iwd]# station <device> connect <SSID>
```

## Execute install script

```bash
bash <(
  curl -s https://raw.githubusercontent.com/n4vysh/dotfiles/main/scripts/bootstrap.bash
)
reboot
```

## Post-installation

login privileged user

```bash
tmux
tmux set -g mode-keys vi
bash <(
  curl -s https://raw.githubusercontent.com/n4vysh/dotfiles/main/scripts/bootstrap.bash
) -p
exit
```

login unprivileged user

```bash
tmux
tmux set -g mode-keys vi
bash <(
  curl -s https://raw.githubusercontent.com/n4vysh/dotfiles/main/scripts/bootstrap.bash
) -u
exit
```
