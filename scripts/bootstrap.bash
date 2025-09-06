#!/bin/bash
#
# Install packages and configure archlinux.

set -eEu
shopt -s inherit_errexit

on_error() {
	_log::fatal "${BASH_SOURCE[1]}:${BASH_LINENO[0]} - '${BASH_COMMAND}' failed" >&2
}

trap on_error ERR

readonly SCRIPT_NAME="bootstrap"
readonly ARGC="${#}"
readonly USERNAME=n4vysh

readonly MAIN_COLOR='#4289ff'
readonly SUB_COLOR='#7aa2f7'
readonly ACCENT_COLOR_1='#FBBF24'
readonly ACCENT_COLOR_2='#f7768e'

readonly BLOCK_DEVICE=nvme0n1
readonly PARTITIONS=(nvme0n1p1 nvme0n1p2)

# Partition the disks
#
# | Mount point | Partition        | Partition type | Filesystem | Size  |
# |:------------|:-----------------|:---------------|:-----------|:------|
# | /boot       | ${PARTITIONS[0]} | EFI System     | FAT32      | 1GB   |
# | /           | ${PARTITIONS[1]} | Linux LVM      | Btrfs      | 200GB |
# | /home       | ${PARTITIONS[1]} | Linux LVM      | Btrfs      | rest  |

export XDG_DATA_HOME=${XDG_DATA_HOME:-${HOME}/.local/share}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-${HOME}/.config}

#######################################
# Parse command options
# Globals:
#   ARGC
#   OPTARG
#   OPTIND
# Arguments:
#   Options
#######################################
main() {
	if ((ARGC == 0)); then
		if _runtime::is_archiso; then
			_install
		else
			_log::fatal 'try Arch Linux live system'
		fi
	else
		while getopts h opt; do
			case $opt in
			h)
				_print_usage
				;;
			\?)
				_log::fatal "illegal option -- $OPTARG"
				;;
			esac
		done

		shift $((OPTIND - 1))
	fi
}

#######################################
# Print command usage
# Globals:
#   SCRIPT_NAME
#######################################
_print_usage() {
	# editorconfig-checker-disable
	cat <<-EOF 1>&2
		$(_color::main "${SCRIPT_NAME} is installer of Arch Linux")

		$(_color::main "Usage:")
		  ${SCRIPT_NAME} [options]

		$(_color::main "OPTIONS:")
		  $(_color::sub "-h") show list of command-line options
	EOF
	# editorconfig-checker-enable
	exit 1
}

#######################################
# Install packages on live system
# Globals:
#   PARTITIONS[1]
# Arguments:
#   None
#######################################
_install() {
	_verify_boot_mode

	_verify_internet_connection

	_log::info 'Update the system clock of live environment'
	timedatectl set-ntp true

	_configure_disks

	_log::info 'Update the latest mirror list of pacman in live environment'
	if ! [[ -e /etc/pacman.d/mirrorlist.bak ]]; then
		cp -fv /etc/pacman.d/mirrorlist{,.bak}
		sed \
			-i \
			-e 's/\(--latest\) 20/\1 30/' \
			-e 's/\(--sort\) age/\1 rate/' \
			/etc/xdg/reflector/reflector.conf
		if ! grep -- --verbose /etc/xdg/reflector/reflector.conf; then
			printf '\n# Print extra information\n--verbose\n' >>/etc/xdg/reflector/reflector.conf
		fi
		systemctl start reflector.service
	else
		_log::warn 'already updated -- skipping'
	fi

	_log::info 'Download dotfiles repository in live environment'
	if ! [[ -e /tmp/dotfiles/ ]]; then
		branch=main
		mkdir -p /tmp/dotfiles/
		curl -L \
			"https://github.com/$USERNAME/dotfiles/archive/refs/heads/{$branch.tar.gz}" |
			tar xz -C /tmp/dotfiles/ --strip-components 1
		# NOTE: make dotfiles readable to configure by unprivileged user
		chmod 777 /tmp/dotfiles/
	else
		_log::warn 'dotfiles already exists -- skipping'
	fi

	_log::info 'Install the base packages'
	yes '' | bash -c "pacstrap /mnt $(
		sed -n '/# base/,/# .*/p' /tmp/dotfiles/src/.chezmoidata/packages.yaml |
			grep -v '#' |
			awk '{ print $2 }' |
			tr '\n' ' '
	)"

	_log::info 'Copy reflector config from live environment'
	cp -fv /{,mnt/}etc/xdg/reflector/reflector.conf

	_log::info 'Deploy config files from live environment'
	dir=/tmp/dotfiles
	mkdir -p \
		/mnt/etc/iwd/ \
		/mnt/etc/systemd/resolved.conf.d/ \
		/mnt/etc/systemd/journald.conf.d/ \
		/mnt/etc/systemd/logind.conf.d/ \
		/mnt/etc/systemd/system.conf.d/ \
		/mnt/etc/systemd/system/systemd-fsck-root.service.d/ \
		/mnt/etc/systemd/system/systemd-fsck@.service.d/ \
		/mnt/etc/systemd/system/display-manager.service.d/
	xargs -I {} cp -v "$dir/misc/{}" /mnt/{} <<-EOF
		etc/iwd/main.conf
		etc/systemd/network/20-wired.network
		etc/systemd/network/25-wireless.network
		etc/systemd/resolved.conf.d/dns_servers.conf
		etc/systemd/journald.conf.d/system_max_use.conf
		etc/systemd/logind.conf.d/handle_power_key.conf
		etc/systemd/logind.conf.d/handle_lid_switch.conf
		etc/systemd/system.conf.d/default_timeout_stop_sec.conf
		etc/systemd/system/systemd-fsck-root.service.d/io.conf
		etc/systemd/system/systemd-fsck@.service.d/io.conf
		etc/systemd/system/display-manager.service.d/color.conf
		etc/systemd/system/rkhunter.service
		etc/systemd/system/rkhunter.timer
		etc/makepkg.conf.d/makepkg.conf
		etc/modprobe.d/disable-overlay-redirect-dir.conf
		etc/sudoers.d/env-keep
		etc/sudoers.d/pwfeedback
		etc/sudoers.d/wheel
	EOF

	_log::info 'Configure fstab'

	# NOTE: /etc/fstab is already placed by arch-install-scripts package
	if ! grep -q "/dev/" /mnt/etc/fstab; then
		genfstab -U /mnt >>/mnt/etc/fstab
	else
		_log::warn 'fstab already updated -- skipping'
	fi

	_log::info 'Configure time zone'
	arch-chroot /mnt ln -sfv /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
	_log::info 'Set system time from hardware clock'
	arch-chroot /mnt hwclock --systohc

	_log::info 'Configure locale'
	arch-chroot /mnt sed -i -e '/^#en_US.UTF-8 UTF-8  $/s/#//' /etc/locale.gen
	arch-chroot /mnt locale-gen
	cp -fv /tmp/dotfiles/misc/etc/locale.conf /mnt/etc/

	_log::info 'Configure keyboard'
	arch-chroot /mnt bash -c 'echo KEYMAP=us >/etc/vconsole.conf'

	_log::info 'Configure hostname'
	cp -fv /tmp/dotfiles/misc/etc/hostname /mnt/etc/

	_log::info 'Configure Bootsplash'
	sed \
		-e 's/#1793d1/#ffffff/g' \
		-e '/<path d="m235/,/<path d="m239/d' \
		/usr/share/pixmaps/archlinux-logo.svg |
		arch-chroot /mnt magick -size 80x80 -background 'rgb(0,0,0)' - \
			/usr/share/systemd/bootctl/splash-arch-custom.bmp
	xargs -I {} cp "$dir/misc/{}" /mnt/{} <<-EOF
		etc/sysctl.d/20-quiet-printk.conf
	EOF
	cat <<-EOF | sudo tee /mnt/etc/issue >/dev/null
		\S{PRETTY_NAME} \r (\l) $(setterm -cursor on -blink off) $(echo -e '\033[?16;0;224c')

	EOF

	_log::info 'Register tpm device in a LUKS slot'
	systemd-cryptenroll --tpm2-device=list
	systemd-cryptenroll --tpm2-device=auto "/dev/${PARTITIONS[1]}"
	systemd-cryptenroll /dev/nvme0n1p2

	_log::info 'Configure Boot loader'
	arch-chroot /mnt bootctl install
	xargs -I {} cp "$dir/misc/{}" /mnt/{} <<-EOF
		boot/loader/loader.conf
		etc/kernel/cmdline
	EOF
	sed -i -e \
		"s/{UUID}/$(blkid -t TYPE=crypto_LUKS -s UUID -o value)/g" \
		/mnt/etc/kernel/cmdline

	_configure_secure_boot

	_log::info 'Configure initramfs'
	# NOTE: 1. use systemd hook and remove fsck hook to hide fsck message
	#       2. add microcode hook after autodetect hook for release stability and security updates
	#       3. systemd support for emergency target, rescue target, and debug shell,
	#       so remove busybox recovery shell of base hook
	#       4. add lvm2, sd-vconsole, and sd-encrypt hook to use LVM on LUKS
	#
	#       https://wiki.archlinux.org/title/Fsck#Mechanism
	#       https://wiki.archlinux.org/title/silent_boot#fsck
	#       https://wiki.archlinux.org/title/mkinitcpio#Common_hooks
	#       https://wiki.archlinux.org/title/dm-crypt/Encrypting_an_entire_system#Configuring_mkinitcpio_2
	arch-chroot /mnt sed \
		-i \
		-E \
		-e '/^HOOKS/s/base udev/systemd/' \
		-e '/^HOOKS/s/autodetect modconf/autodetect microcode modconf/' \
		-e '/^HOOKS/s/keymap consolefont/sd-vconsole/' \
		-e '/^HOOKS/s/(block) (filesystems)/\1 sd-encrypt lvm2 \2/' \
		-e '/^HOOKS/s/(filesystems) fsck/\1/' \
		/etc/mkinitcpio.conf
	if ! grep -q "COMPRESSION='cat'" /mnt/etc/mkinitcpio.conf; then
		echo "COMPRESSION='cat'" >>/mnt/etc/mkinitcpio.conf
	else
		_log::warn 'mkinitcpio compression already updated -- skipping'
	fi
	arch-chroot /mnt sed \
		-i \
		-e '/^.*_image=/s/^/#/' \
		-e '/^#.*_uki=/s/^#//' \
		-e 's|/efi/EFI|/boot/EFI|g' \
		-e '/^#default_options=/s/^#//' \
		-e 's/splash-arch.bmp/splash-arch-custom.bmp/g' \
		/etc/mkinitcpio.d/linux-zen.preset
	arch-chroot /mnt cp -v \
		/usr/lib/systemd/system/systemd-fsck{@,-root}.service /etc/systemd/system
	arch-chroot /mnt mkinitcpio -P

	arch-chroot /mnt sbctl env ESP_PATH=/boot/efi verify
	arch-chroot /mnt sbctl list-files

	_log::info 'Set the root password'
	arch-chroot /mnt passwd

	_log::info 'Configure network'
	arch-chroot /mnt systemctl enable \
		systemd-networkd.service \
		systemd-resolved.service \
		iwd.service \
		reflector.timer
	arch-chroot /mnt systemctl mask \
		systemd-networkd-wait-online.service

	_log::info 'Configure user daemon'
	arch-chroot /mnt systemctl enable \
		systemd-homed.service

	_log::info 'Configure the regulatory domain'
	arch-chroot /mnt sed \
		-i \
		-e '/^#WIRELESS_REGDOM="JP"$/s/#//' \
		/etc/conf.d/wireless-regdom

	_log::info 'Copy network passphrase from live environment'
	cp -frv /var/lib/iwd/ /mnt/var/lib/

	_log::info 'Copy dotfiles repository from live environment'
	cp -r /{,mnt/}tmp/dotfiles/

	_log::info 'Unmount the filesystems'
	umount -R /mnt
}

#######################################
# Verify boot mode
# Globals:
#   None
# Arguments:
#   None
#######################################
_verify_boot_mode() {
	_log::info 'Verify boot mode of live environment'
	if ! [[ -d /sys/firmware/efi/efivars ]]; then
		_log::fatal 'UEFI mode is disabled'
	else
		_log::info 'UEFI mode is enabled'
	fi
}

#######################################
# Verify internet connection
# Globals:
#   None
# Arguments:
#   None
#######################################
_verify_internet_connection() {
	_log::info 'Verify the internet connection'
	if ! nc -zw1 google.com 443; then
		_log::fatal 'No connection is available'
	fi
}

#######################################
# Verify Arch Linux
# Globals:
#   None
# Arguments:
#   None
#######################################
_verify_arch_linux() {
	if ! _runtime::is_arch_linux; then
		_log::fatal 'try newly installed Arch Linux system'
	fi
}

#######################################
# Setup LVM on LUKS
# Globals:
#   BLOCK_DEVICE
#   PARTITIONS[0]
#   PARTITIONS[1]
# Arguments:
#   None
#######################################
_configure_disks() {
	_log::info 'Create the PARTITIONS'
	sgdisk -n 0::+1G -t 0:EF00 -c 0:'EFI System' "/dev/$BLOCK_DEVICE"
	sgdisk -n 0::: -t 0:8E00 -c 0:'Linux LVM' "/dev/$BLOCK_DEVICE"
	sgdisk -p "/dev/$BLOCK_DEVICE"

	_log::info 'Format the partition'
	mkfs.vfat -F 32 "/dev/${PARTITIONS[0]}"

	_log::info 'Encrypt the disk'
	cryptsetup -v luksFormat "/dev/${PARTITIONS[1]}"
	cryptsetup open --type luks "/dev/${PARTITIONS[1]}" cryptlvm

	_log::info 'Create the physical volume'
	pvcreate /dev/mapper/cryptlvm

	_log::info 'Create the volume group'
	vgcreate volume /dev/mapper/cryptlvm

	_log::info 'Create the logical volumes'
	lvcreate -y volume -L 200GB -n root
	lvcreate -y volume -l 100%FREE -n home

	_log::info 'Format the logical volumes'
	mkfs.btrfs /dev/volume/root
	mkfs.btrfs /dev/volume/home

	_log::info 'Mount the filesystems'
	mount -o defaults,relatime,space_cache=v2,ssd,compress=zstd /dev/volume/root /mnt
	mount --mkdir -o defaults,relatime,space_cache=v2,ssd,compress=zstd /dev/volume/home /mnt/home
	mount --mkdir -o uid=0,gid=0,fmask=0077,dmask=0077 "/dev/${PARTITIONS[0]}" /mnt/boot
}

#######################################
# Enroll secure boot signing keys
# Globals:
#   None
# Arguments:
#   None
#######################################
_configure_secure_boot() {
	_log::info 'Configure secure boot'
	# NOTE: use $ESP_PATH to vaoid `failed to find EFI system partition`
	arch-chroot /mnt sbctl status
	arch-chroot /mnt sbctl create-keys
	arch-chroot /mnt sbctl enroll-keys --yes-this-might-brick-my-machine
	arch-chroot /mnt sbctl status
	arch-chroot /mnt sbctl sign -s /boot/EFI/BOOT/BOOTX64.EFI
	arch-chroot /mnt sbctl sign -s /boot/EFI/systemd/systemd-bootx64.efi
}

#######################################
# Return true when archiso
# Globals:
#   None
# Arguments:
#   None
#######################################
_runtime::is_archiso() {
	[[ $(cat /etc/hostname) == archiso ]]
}

#######################################
# Return true when Arch Linux
# Globals:
#   None
# Arguments:
#   None
#######################################
_runtime::is_arch_linux() {
	[[ -f /etc/arch-release ]]
}

#######################################
# Print log output for info level
# Globals:
#   None
# Arguments:
#   Message to print
#######################################
_log::info() {
	echo "$(_print::logprefix "$(_color::sub "INFO")") ""$1"
}

#######################################
# Print log output for warn level
# Globals:
#   None
# Arguments:
#   Message to print
#######################################
_log::warn() {
	echo "$(_print::logprefix "$(_color::accent1 "WARN")") ""$1"
}

#######################################
# Print log output for fatal level
# Globals:
#   None
# Arguments:
#   Message to print
#######################################
_log::fatal() {
	echo -e "$(_print::logprefix "$(_color::accent2 "FATA")") ""$1" >&2
	exit 1
}

#######################################
# Print timestamp with ISO 8601
# Globals:
#   None
# Arguments:
#   None
#######################################
_print::timestamp() {
	echo -n "$(date +'%Y-%m-%dT%H:%M:%S%z')"
}

#######################################
# Print script name, log level, and timestamp before messages
# Globals:
#   SCRIPT_NAME
# Arguments:
#   Log level
#######################################
_print::logprefix() {
	local name
	local level="|$1|"
	local timestamp
	name="[$(_color::main "$SCRIPT_NAME")]"
	timestamp="$(_print::timestamp)"

	echo -n "$name $timestamp $level"
}

#######################################
# Print bold text of true color with escape sequence
# Globals:
#   None
# Arguments:
#   Message to print
#   True Color to print
#######################################
_print::color() {
	local msg=""$1
	local color=""$2
	local r="$((16#${color:1:2}))"
	local g="$((16#${color:3:2}))"
	local b="$((16#${color:5:2}))"
	printf "\x1b[1m\x1b[38;2;%d;%d;%dm%s\x1b[0m" "$r" "$g" "$b" "$msg"
}

#######################################
# Print bold text with main color
# Globals:
#   MAIN_COLOR
# Arguments:
#   Message to print
#######################################
_color::main() {
	_print::color "$1" "$MAIN_COLOR"
}

#######################################
# Print bold text with sub color
# Globals:
#   SUB_COLOR
# Arguments:
#   Message to print
#######################################
_color::sub() {
	_print::color "$1" "$SUB_COLOR"
}

#######################################
# Print bold text with accent color 1
# Globals:
#   ACCENT_COLOR_1
# Arguments:
#   Message to print
#######################################
_color::accent1() {
	_print::color "$1" "$ACCENT_COLOR_1"
}

#######################################
# Print bold text with accent color 2
# Globals:
#   ACCENT_COLOR_2
# Arguments:
#   Message to print
#######################################
_color::accent2() {
	_print::color "$1" "$ACCENT_COLOR_2"
}

main "${@}"
