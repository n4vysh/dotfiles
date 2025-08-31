# Install Arch Linux without virtualization

## Acquire an installation image

- <https://archlinux.org/download/>

```sh
read -rp 'ISO URL: ' iso_url
read -rp 'ISO PGP signature URL: ' iso_sig_url
wget -P ~/Downloads/ "$iso_url"
wget -P ~/Downloads/ "$iso_sig_url"
gpg \
  --keyserver-options auto-key-retrieve \
  --verify \
  ~/Downloads/archlinux-*.*.*-x86_64.iso.sig
```

## Prepare an installation medium

```sh
ls -l /dev/disk/by-id/usb-*
# NOTE: check USB drive is not mounted
lsblk
# /dev/disk/by-id/usb-My_flash_drive
read -rp 'drive path: ' usb_path
sudo dd \
  bs=4M \
  if="$(find ~/Downloads/archlinux-*.*.*-x86_64.iso)" \
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

```sh
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

```sh
tmux
tmux set -g mode-keys vi
```

## Authenticate to the wireless network

```sh
iwctl
```

```txt
[iwd]# device list
[iwd]# station <device> scan
[iwd]# station <device> get-networks
[iwd]# station <device> connect <SSID>
```

## Execute install script

```sh
bash <(
  curl -s https://raw.githubusercontent.com/n4vysh/dotfiles/main/scripts/bootstrap.bash
)
reboot
```

## Post-installation

login privileged user and create unprivileged user

```sh
homectl create n4vysh --member-of=wheel --storage=directory
exit
```
