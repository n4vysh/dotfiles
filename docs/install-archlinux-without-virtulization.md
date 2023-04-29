# Install Arch Linux without virtualization

## Acquire an installation image

- <https://www.archlinux.jp/download/>
- <https://www.archlinux.jp/mirrors/status/>

## Prepare an installation medium

```bash
lsblk
dd \
  bs=4M \
  if=path/to/archlinux-version-x86_64.iso \
  of=/dev/sdx \
  conv=fsync \
  oflag=direct \
  status=progress
```

## Boot the live environment

In the case of VAIO SX14, Press the power button while holding down the [F3]
button. Since rescue mode screen is displayed, and then select "Start BIOS
setup". Putting firmware in "Setup Mode" for secure boot in BIOS setup menu and
exit. Select "Start from medium" to boot the live environment.

[Setup Mode](https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface/Secure_Boot#Putting_firmware_in_%22Setup_Mode%22)

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
iwctl
bash <(
  curl -s https://raw.githubusercontent.com/n4vysh/dotfiles/main/scripts/bootstrap.bash
) -p
exit
```

login unprivileged user

```bash
iwctl
bash <(
  curl -s https://raw.githubusercontent.com/n4vysh/dotfiles/main/scripts/bootstrap.bash
) -u
exit
```
