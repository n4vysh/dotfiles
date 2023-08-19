#!/bin/bash

script_name="bootstrap"
option="${#}"

export XDG_DATA_HOME=${XDG_DATA_HOME:-${HOME}/.local/share}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-${HOME}/.config}

_is_archiso() {
	[[ $(cat /etc/hostname) == archiso ]]
}

_is_container() {
	[[ $CONTAINER == true ]]
}

main() {
	if ((option == 0)); then
		if _is_archiso; then
			_install
		else
			_print_err 'try Arch Linux live system'
			exit 1
		fi
	else
		while getopts puh opt; do
			case $opt in
			p)
				_verify_arch_linux

				if _is_privileged; then
					_configure_with_privileged
				else
					_print_err 'try privileged user'
					exit 1
				fi
				;;
			u)
				_verify_arch_linux

				if ! _is_privileged; then
					_configure_without_privileged
				else
					_print_err 'try unprivileged user'
					exit 1
				fi
				;;
			h)
				_print_usage
				;;
			\?)
				_print_err "illegal option -- $OPTARG"
				exit 1
				;;
			esac
		done

		shift $((OPTIND - 1))
	fi
}

_install() {
	_check_boot_mode

	_verify_internet_connection

	_print 'Update the system clock of live environment'
	timedatectl set-ntp true

	_configure_disks

	_print 'Update the latest mirror list of pacman in live environment'
	if ! [[ -e /etc/pacman.d/mirrorlist.bak ]]; then
		cp -fv /etc/pacman.d/mirrorlist{,.bak}
		sed \
			-i \
			-e 's/\(--latest\) 5/\1 30/' \
			-e '/# Sort the mirrors/s/synchronization time/download rate/' \
			-e 's/\(--sort\) age/\1 rate/' \
			/etc/xdg/reflector/reflector.conf
		grep -- --verbose /etc/xdg/reflector/reflector.conf ||
			printf '\n# Print extra information\n--verbose\n' >>/etc/xdg/reflector/reflector.conf
		systemctl start reflector.service
	else
		_print 'already updated'
	fi

	_print 'Download dotfiles repository in live environment'
	if ! [[ -e /tmp/dotfiles/ ]]; then
		branch=main
		mkdir -p /tmp/dotfiles/
		curl -L \
			"https://github.com/n4vysh/dotfiles/archive/refs/heads/{$branch.tar.gz}" |
			tar xz -C /tmp/dotfiles/ --strip-components 1
	else
		_print 'dotfiles already exists'
	fi

	_print 'Install the base packages'
	yes '' | bash -c "pacstrap /mnt $(tr '\n' ' ' </tmp/dotfiles/misc/pkglist/base.txt)"

	_print 'Copy reflector config from live environment'
	cp -fv /{,mnt/}etc/xdg/reflector/reflector.conf

	_print 'Deploy config files from live environment'
	dir=/tmp/dotfiles
	mkdir -p \
		/mnt/etc/iwd/ \
		/mnt/etc/systemd/resolved.conf.d/ \
		/mnt/etc/systemd/system/systemd-fsck-root.service.d/ \
		/mnt/etc/systemd/system/systemd-fsck@.service.d/
	xargs -I {} cp -v "$dir/misc/{}" /mnt/{} <<-EOF
		etc/iwd/main.conf
		etc/systemd/network/20-wired.network
		etc/systemd/network/25-wireless.network
		etc/systemd/resolved.conf.d/dns_servers.conf
		etc/systemd/system/systemd-fsck-root.service.d/io.conf
		etc/systemd/system/systemd-fsck@.service.d/io.conf
		etc/systemd/system/rkhunter.service
		etc/systemd/system/rkhunter.timer
	EOF

	_print 'Configure fstab'
	if ! [[ -e /mnt/etc/fstab ]]; then
		genfstab -U /mnt >>/mnt/etc/fstab
	else
		_print 'fstab already exists'
	fi

	_print 'Configure time zone'
	arch-chroot /mnt ln -sfv /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
	_print 'Set system time from hardware clock'
	arch-chroot /mnt hwclock --systohc

	_print 'Configure locale'
	arch-chroot /mnt sed -i -e '/#en_US.UTF-8 UTF-8  /s/#//' /etc/locale.gen
	arch-chroot /mnt locale-gen
	cp -fv /tmp/dotfiles/misc/etc/locale.conf /mnt/etc/

	_print 'Configure keyboard'
	arch-chroot /mnt bash -c 'echo KEYMAP=us >/etc/vconsole.conf'

	_print 'Configure hostname'
	cp -fv /tmp/dotfiles/misc/etc/hostname /mnt/etc/

	_print 'Configure initramfs'
	# https://wiki.archlinux.org/title/dm-crypt/Encrypting_an_entire_system#Configuring_mkinitcpio_2
	# https://wiki.archlinux.org/title/silent_boot#fsck
	arch-chroot /mnt sed \
		-i \
		-E \
		-e '/^HOOKS/s/udev/systemd/' \
		-e '/^HOOKS/s/(autodetect) (modconf)/\1 keyboard sd-vconsole \2/' \
		-e '/^HOOKS/s/(modconf) kms keyboard keymap consolefont (block)/\1 \2/' \
		-e '/^HOOKS/s/(block) (filesystems)/\1 sd-encrypt lvm2 \2/' \
		-e '/^HOOKS/s/(filesystems) fsck/\1/' \
		/etc/mkinitcpio.conf
	arch-chroot /mnt cp -v \
		/usr/lib/systemd/system/systemd-fsck{@,-root}.service /etc/systemd/system
	arch-chroot /mnt mkinitcpio -p linux-zen

	_print 'Set the root password'
	arch-chroot /mnt passwd

	_print 'Register keys in a LUKS slot'
	_print 'Waiting for security key device'
	_print 'connect device and press enter key'
	read -r
	arch-chroot /mnt systemd-cryptenroll --fido2-device=list
	arch-chroot /mnt systemd-cryptenroll --fido2-device=auto "/dev/${partitions[1]}"

	_print 'Configure Boot loader'
	arch-chroot /mnt bootctl install
	xargs -I {} cp "$dir/misc/{}" /mnt/{} <<-EOF
		boot/loader/loader.conf
		etc/kernel/cmdline
	EOF
	sed -i -e \
		"s/{UUID}/$(blkid -t TYPE=crypto_LUKS -s UUID -o value)/g" \
		/mnt/etc/kernel/cmdline

	_configure_secure_boot

	_print 'Configure network'
	arch-chroot /mnt systemctl enable \
		systemd-networkd.service \
		systemd-resolved.service \
		iwd.service \
		reflector.timer
	arch-chroot /mnt ln -rsfv /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

	_print 'Copy network passphrase from live environment'
	cp -frv /var/lib/iwd/ /mnt/var/lib/

	_print 'Copy dotfiles repository from live environment'
	cp -r /{,mnt/}tmp/dotfiles/

	_print 'Unmount the filesystems'
	umount -R /mnt
}

_configure_with_privileged() {
	_print 'Configure user'
	username=n4vysh
	systemctl enable --now systemd-homed.service

	homectl create "$username" --member-of=wheel --storage=directory

	_print 'Configure privilege escalation'
	cp -fv /tmp/dotfiles/misc/etc/sudoers.d/* /etc/sudoers.d/
}

_configure_without_privileged() {
	_verify_internet_connection

	_print 'Configure the regulatory domain'
	sudo sed \
		-i \
		-e '/^#WIRELESS_REGDOM="JP"/s/#//' \
		/etc/conf.d/wireless-regdom

	_print 'Configure pacman'
	sudo sed \
		-i \
		-e '/^#Color/s/#//' \
		-e '/^#VerbosePkgLists/s/#//' \
		-e 's/ParallelDownloads = 5/ParallelDownloads = 20/' \
		/etc/pacman.conf

	_print 'Add blackarch repository'
	curl -o '/tmp/#1' 'https://blackarch.org/{strap.sh}'
	echo 5ea40d49ecd14c2e024deecf90605426db97ea0c /tmp/strap.sh | sha1sum -c
	chmod +x /tmp/strap.sh
	sudo /tmp/strap.sh
	# HACK: strap.sh change owner of ~/.gnupg/ to root user,
	#       so change owner to unprivileged user
	sudo chown -R "$USER" ~/.gnupg/

	sudo cp /etc/pacman.d/blackarch-mirrorlist{,.bak}
	rankmirrors -r blackarch /etc/pacman.d/blackarch-mirrorlist.bak |
		sudo tee /etc/pacman.d/blackarch-mirrorlist >/dev/null

	_print 'Install packages'
	sudo bash -c "yes '' | pacman -S --noconfirm --needed --disable-download-timeout $(
		find /tmp/dotfiles/misc/pkglist/ \
			-type f \
			-not -name base.txt \
			-not -name aur.txt \
			-print0 |
			xargs -0 cat |
			tr '\n' ' '
	)"

	_print 'Configure makepkg'
	sudo sed -i -e '/^#MAKEFLAGS/s/#//' /etc/makepkg.conf
	sudo sed \
		-i \
		-e "/^MAKEFLAGS=\"-j2\"/s/-j2/-j$(nproc)/" \
		-e '/^COMPRESSZST/s/zstd -c/zstd --threads=0 -c/' \
		-e '/^BUILDENV/s/!ccache/ccache/' \
		/etc/makepkg.conf

	_print 'Configure pkgfile'
	sudo systemctl start pkgfile-update.service
	sudo systemctl enable --now pkgfile-update.timer

	_print 'Install AUR helper'
	curl -L -o '/tmp/#1' \
		'https://aur.archlinux.org/cgit/aur.git/snapshot/{paru-bin.tar.gz}'
	tar xzvf /tmp/paru-bin.tar.gz -C /tmp/
	cd /tmp/paru-bin/ ||
		exit
	makepkg -si --noconfirm
	cd - ||
		exit

	_print 'Import 1Password signing key'
	curl -sS https://downloads.1password.com/linux/keys/1password.asc |
		gpg --import

	_print 'Install AUR packages'
	# HACK: enter password before running AUR helper to skip selection of package group with yes command
	sudo true
	# HACK: mark news item as read to avoid interruption a pacman transaction
	paru -S --noconfirm --needed --disable-download-timeout --skipreview informant
	sudo informant read --all
	bash -c "yes '' | paru -S --noconfirm --needed --disable-download-timeout --skipreview $(tr '\n' ' ' </tmp/dotfiles/misc/pkglist/aur.txt)"

	_print 'Lock the password of root user'
	sudo passwd -l root

	_print 'Configure securetty'
	sudo sed \
		-i \
		-e '/console/s/^/# /' \
		-e '/tty1/s/^/# /' \
		-e '/tty2/s/^/# /' \
		-e '/tty3/s/^/# /' \
		-e '/tty4/s/^/# /' \
		-e '/tty5/s/^/# /' \
		-e '/tty6/s/^/# /' \
		-e '/ttyS0/s/^/# /' \
		-e '/hvc0/s/^/# /' \
		/etc/securetty

	_print 'Configure firewall'
	sudo systemctl enable --now ufw
	sudo ufw enable
	sudo ufw status verbose

	_print 'Enable irqbalance'
	sudo systemctl enable --now irqbalance.service

	_print 'Clone dotfiles repository'
	if ! [[ -e "$XDG_DATA_HOME/dotfiles/" ]]; then
		git clone https://github.com/n4vysh/dotfiles "$XDG_DATA_HOME/dotfiles/"
	else
		_print 'dotfiles already exists'
	fi

	_print 'Deploy dotfiles'
	# HACK: move default dotfiles to avoid conflict
	mv -v ~/.bashrc{,.bak}
	just --justfile "$XDG_DATA_HOME/dotfiles/justfile"

	_print 'Deploy config files'
	sudo mkdir -p /etc/interception/dual-function-keys/ /etc/docker/
	dir="$XDG_DATA_HOME/dotfiles"
	xargs -I {} sudo cp -v "$dir/misc/{}" /{} <<-EOF
		etc/interception/dual-function-keys/xcape.yaml
		etc/interception/udevmon.yaml
		etc/docker/daemon.json
		etc/polkit-1/rules.d/50-udisks.rules
		etc/systemd/zram-generator.conf
		etc/udev/rules.d/99-lowbat.rules
	EOF

	_print 'Change default shell'
	sudo homectl update --shell="$(which zsh)" "$username"

	_print 'Configure clock synchronization'
	sudo sed -i -e "s/#NTP=/NTP=$(echo {0..3}.jp.pool.ntp.org)/" \
		/etc/systemd/timesyncd.conf
	sudo sed -i -e '/#FallbackNTP/s/#//' /etc/systemd/timesyncd.conf
	sudo systemctl enable --now systemd-timesyncd
	sudo timedatectl set-ntp true
	sudo timedatectl status

	# System administration
	_print 'Configure service management'
	sudo sed -i -e '/#DefaultTimeoutStopSec/s/90s/5s/' /etc/systemd/system.conf
	sudo sed -i -e '/#DefaultTimeoutStopSec/s/#//' /etc/systemd/system.conf
	sudo sed -i -e 's/#SystemMaxUse=/SystemMaxUse=5M/' /etc/systemd/journald.conf

	# Graphical User Interface
	_print 'Configure screen locker'
	mkdir -p "$XDG_DATA_HOME/sway/"
	convert "$dir/misc/lockscreen.svg" "$XDG_DATA_HOME/sway/lockscreen.png"

	# OOM-killer
	_print 'Configure OOM-killer'
	sudo systemctl enable --now systemd-oomd

	# TRIM
	_print 'Configure Periodic TRIM'
	sudo systemctl enable --now fstrim.timer

	# Power management
	_print 'Configure ACPI events'
	sudo sed -i -e 's/#HandlePowerKey=poweroff/HandlePowerKey=suspend/' \
		/etc/systemd/logind.conf

	sudo sed -i -e 's/#HandleLidSwitch=suspend/HandleLidSwitch=ignore/' \
		/etc/systemd/logind.conf

	sudo systemctl restart systemd-logind

	# Multimedia
	_print 'Configure sound'
	pamixer --unmute

	# Input devices
	_print 'Configure keyboard layouts'
	keymap=us

	sudo cp \
		"/usr/share/kbd/keymaps/i386/qwerty/$keymap.map.gz" \
		"/usr/share/kbd/keymaps/$keymap-custom.map.gz"
	sudo gunzip "/usr/share/kbd/keymaps/$keymap-custom.map.gz"
	# Disable caps lock
	sudo bash -c \
		"sed -i -e 's/keycode  58 = Caps_Lock/keycode  58 = VoidSymbol/' /usr/share/kbd/keymaps/$keymap-custom.map"
	# Change right alt to control
	sudo bash -c \
		"echo 'keycode 100 = Control' >>/usr/share/kbd/keymaps/$keymap-custom.map"
	sudo sed -i \
		-e "s|KEYMAP=$keymap|KEYMAP=$keymap-custom|" \
		/etc/vconsole.conf
	sudo systemctl enable --now udevmon.service # for interception tools

	_print 'Configure bluetooth'
	sudo gpasswd -a "$USER" lp
	sudo sed -i -e 's/^#AutoEnable=false$/AutoEnable=true/' /etc/bluetooth/main.conf
	sudo systemctl enable --now bluetooth

	_print 'Configure yubikey'
	sudo systemctl enable --now pcscd.service

	_print 'Configure avrdude'
	sudo gpasswd -a "$USER" uucp
	sudo gpasswd -a "$USER" lock

	_print 'Configure virtualization'
	sudo systemctl enable --now docker
	sudo gpasswd -a "$USER" docker
	dir=$HOME/.docker/
	[[ ! -d $dir ]] && mkdir "$dir"
	file=$dir/config.json
	[[ ! -f $file ]] && echo '{}' >"$file"
	jq <"$file" '
			.
			| . + {
				"detachKeys": "ctrl-\\",
				"credsStore": "pass"
			}
		' |
		sponge "$file"

	sudo systemctl enable --now containerd
	sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 "$(whoami)"
	containerd-rootless-setuptool.sh install
	containerd-rootless-setuptool.sh install-buildkit

	# Utilities
	_print 'Configure password manager'
	sudo ln -sf /usr/bin/pinentry-curses /usr/bin/pinentry

	_print 'Configure mount helper'
	sudo gpasswd --add "$USER" storage

	_print 'Create user directorys'
	mkdir "$HOME"/{Downloads,Public,Workspaces}

	_print 'Configure GNOME keyring'
	sudo sed \
		-i \
		-e '/auth *optional *pam_gnome_keyring.so/! {
			/auth *include *system-local-login/a auth       optional     pam_gnome_keyring.so
		}' /etc/pam.d/login

	sudo sed \
		-i \
		-e '/session *optional *pam_gnome_keyring.so auto_start/! {
			/session *include *system-local-login/a session    optional     pam_gnome_keyring.so auto_start
		}' /etc/pam.d/login

	sudo sed \
		-i \
		-e '/password	optional	pam_gnome_keyring.so/! {
			$ a password	optional	pam_gnome_keyring.so
		}' /etc/pam.d/passwd

	_print 'Setup nix'
	sudo systemctl enable --now nix-daemon.service
	sudo gpasswd -a "$USER" nix-users
	nix-channel --add https://nixos.org/channels/nixpkgs-unstable
	nix-channel --update

	_print 'Install kubectl packages'
	kubectl krew install <"/tmp/dotfiles/misc/kubectl-plugins.txt"

	_print 'Install formatter'
	yarn global add sql-formatter

	_print 'Configure VPN'
	sudo systemctl enable --now nordvpnd
	sudo gpasswd -a "$USER" nordvpn

	_print 'Configure scheduling utility'
	sudo systemctl enable --now atd

	_print 'Configure plocate'
	sudo systemctl start plocate-updatedb.service
	sudo systemctl enable --now plocate-updatedb.timer

	_print 'Configure sshd'
	sudo sed \
		-i \
		-e '/^#PermitRootLogin/s/#//' \
		-e '/^PermitRootLogin/s/prohibit-password/no/' \
		/etc/ssh/sshd_config

	_print 'Configure etckeeper'
	sudo etckeeper init
	sudo git -C /etc/ config --local user.name "etckeeper"
	sudo git -C /etc/ config --local user.email "etckeeper@localhost"
	sudo etckeeper commit "Initial commit"
	sudo systemctl enable --now etckeeper.timer

	_print 'Configure metasploit'
	sudo mkdir -p /var/lib/postgres/data
	sudo chattr +C /var/lib/postgres/data
	sudo -u postgres initdb -D /var/lib/postgres/data
	sudo systemctl enable --now postgresql
	yes no | msfdb init

	_print 'Configure wireshark'
	sudo gpasswd -a "$USER" wireshark

	_print 'Downloads wordlists'
	sudo wordlistctl fetch best110
	sudo wordlistctl fetch -d rockyou
	sudo wordlistctl fetch -d fasttrack
	sudo wordlistctl fetch subdomains-top1million-5000

	_print 'Configure wpscan'
	sudo chown -R n4vysh: ~/.wpscan
	wpscan --update

	_print 'Configure rkhunter'
	lists=(
		/usr/bin/egrep
		/usr/bin/fgrep
		/usr/bin/ldd
		/usr/bin/vendor_perl/GET
		/usr/sbin/s
	)
	for list in "${lists[@]}"; do
		sudo grep "SCRIPTWHITELIST=$list" /etc/rkhunter.conf ||
			sudo tee -a /etc/rkhunter.conf <<<"SCRIPTWHITELIST=$list" >/dev/null
	done
	sudo sed \
		-i \
		-e '/^#ALLOW_SSH_PROT_V1/s/#//' \
		-e '/^ALLOW_SSH_PROT_V1/s/0/2/' \
		/etc/rkhunter.conf

	sudo grep "RTKT_FILE_WHITELIST=/usr/sbin/s" /etc/rkhunter.conf ||
		sudo tee -a /etc/rkhunter.conf <<<"RTKT_FILE_WHITELIST=/usr/sbin/s" >/dev/null
	sudo grep "ALLOWDEVFILE=/dev/shm/PostgreSQL.*" /etc/rkhunter.conf ||
		sudo tee -a /etc/rkhunter.conf <<<"ALLOWDEVFILE=/dev/shm/PostgreSQL.*" >/dev/null
	# For zoom
	sudo grep "ALLOWDEVFILE=/dev/shm/aomshm.*" /etc/rkhunter.conf ||
		sudo tee -a /etc/rkhunter.conf <<<"ALLOWDEVFILE=/dev/shm/aomshm.*" >/dev/null
	sudo grep "ALLOWHIDDENDIR=/etc/.git" /etc/rkhunter.conf ||
		sudo tee -a /etc/rkhunter.conf <<<"ALLOWHIDDENDIR=/etc/.git" >/dev/null
	lists=(
		/etc/.etckeeper
		/etc/.gitignore
		/etc/.updated
		/usr/share/man/man5/.k5identity.5.gz
		/usr/share/man/man5/.k5login.5.gz
	)
	for list in "${lists[@]}"; do
		sudo grep "ALLOWHIDDENFILE=$list" /etc/rkhunter.conf ||
			sudo tee -a /etc/rkhunter.conf <<<"ALLOWHIDDENFILE=$list" >/dev/null
	done
	# NOTE: allow IPC for ueberzug
	sudo grep "ALLOWIPCUSER=$USER" /etc/rkhunter.conf ||
		sudo tee -a /etc/rkhunter.conf <<<"ALLOWIPCUSER=$USER" >/dev/null
	sudo cp -fv "$dir"/misc/etc/pacman.d/hooks/rkhunter-* /etc/pacman.d/hooks/
	# NOTE: use /dev/null to ignore grep warning
	sudo rkhunter --update 2>/dev/null
	sudo rkhunter --config-check 2>/dev/null
	sudo rkhunter --propupd 2>/dev/null
	sudo rkhunter -c --sk 2>/dev/null
	sudo systemctl enable --now rkhunter.timer
}

_is_arch_linux() {
	[[ -f /etc/arch-release ]]
}

_is_privileged() {
	[[ $(id -u) == 0 ]]
}

_print_usage() {
	cat <<-EOF 1>&2
		Usage:
			${script_name} [options]

		OPTIONS
			-h show list of command-line options
			-p configure Arch Linux with privileged user after install
			-u configure Arch Linux with unprivileged user after install
	EOF
	exit 1
}

_print() {
	echo "$script_name: ${1}"
}

_print_err() {
	echo -e "$script_name: \e[31m${1}\e[m"
}

_check_boot_mode() {
	_is_container && return

	_print 'Check boot mode of live environment'
	if ! [[ -d /sys/firmware/efi/efivars ]]; then
		_print_err 'UEFI mode is disabled'
		exit 1
	else
		_print 'UEFI mode is enabled'
	fi
}

_verify_internet_connection() {
	_print 'Verify the internet connection'
	if ! nc -zw1 google.com 443; then
		_print_err 'No connection is available'
		exit 1
	fi
}

_verify_arch_linux() {
	_is_arch_linux ||
		{
			_print_err 'try newly installed Arch Linux system'
			exit 1
		}
}

_configure_disks() {
	# Partition the disks
	#
	# | Mount point | Partition        | Partition type | Filesystem | Size  |
	# |:------------|:-----------------|:---------------|:-----------|:------|
	# | /boot       | ${partitions[0]} | EFI System     | FAT32      | 200MB |
	# | /           | ${partitions[1]} | Linux LVM      | Btrfs      | 30GB  |
	# | /home       | ${partitions[1]} | Linux LVM      | Btrfs      | rest  |

	block_device=nvme0n1
	partitions[0]=nvme0n1p1
	partitions[1]=nvme0n1p2

	_print 'Create the partitions'
	sgdisk -n 0::+200M -t 0:EF00 -c 0:'EFI System' "/dev/$block_device"
	sgdisk -n 0::: -t 0:8E00 -c 0:'Linux LVM' "/dev/$block_device"
	sgdisk -p "/dev/$block_device"

	_print 'Format the partition'
	mkfs.vfat -F 32 "/dev/${partitions[0]}"

	_print 'Encrypt the disk'
	cryptsetup -v luksFormat "/dev/${partitions[1]}"
	cryptsetup open --type luks "/dev/${partitions[1]}" cryptlvm

	_print 'Create the physical volume'
	pvcreate /dev/mapper/cryptlvm

	_print 'Create the volume group'
	vgcreate volume /dev/mapper/cryptlvm

	_print 'Create the logical volumes'
	lvcreate -y volume -L 30GB -n root
	lvcreate -y volume -l 100%FREE -n home

	_print 'Format the logical volumes'
	mkfs.btrfs /dev/volume/root
	mkfs.btrfs /dev/volume/home

	_print 'Mount the filesystems'
	mount -o defaults,relatime,space_cache,ssd,compress=zstd /dev/volume/root /mnt
	mkdir -p /mnt/{boot,home}
	mount -o defaults,relatime,space_cache,ssd,compress=zstd /dev/volume/home /mnt/home
	mount "/dev/${partitions[0]}" /mnt/boot
}

_configure_secure_boot() {
	_print 'Configure secure boot'
	arch-chroot /mnt sbctl status
	arch-chroot /mnt sbctl create-keys
	arch-chroot /mnt sbctl enroll-keys
	arch-chroot /mnt sbctl status
	arch-chroot /mnt sbctl sign -s /boot/EFI/BOOT/BOOTX64.EFI
	# arch-chroot /mnt sbctl sign -s /boot/EFI/arch/fwupdx64.efi
	arch-chroot /mnt sbctl sign -s /boot/EFI/systemd/systemd-bootx64.efi
	# arch-chroot /mnt sbctl sign -s /usr/lib/fwupd/efi/fwupdx64.efi -o /usr/lib/fwupd/efi/fwupdx64.efi.signed
	arch-chroot /mnt sbctl verify
	arch-chroot /mnt sbctl list-files
	arch-chroot /mnt sbctl bundle \
		-s \
		-i /boot/intel-ucode.img \
		-l /usr/share/systemd/bootctl/splash-arch.bmp \
		-k /boot/vmlinuz-linux-zen \
		-f /boot/initramfs-linux-zen.img \
		/boot/EFI/Linux/linux-zen.efi
	arch-chroot /mnt sbctl sign /boot/EFI/Linux/linux-zen.efi
	arch-chroot /mnt sbctl list-bundles
}

main "${@}"
