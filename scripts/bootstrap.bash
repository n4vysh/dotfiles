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
		while getopts puh opt; do
			case $opt in
			p)
				_verify_arch_linux

				if _runtime::is_privileged; then
					_configure_with_privileged
				else
					_log::fatal 'try privileged user'
				fi
				;;
			u)
				_verify_arch_linux

				if ! _runtime::is_privileged; then
					_configure_without_privileged
				else
					_log::fatal 'try unprivileged user'
				fi
				;;
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
		$(_color::main "Usage:")
		  ${SCRIPT_NAME} [options]

		$(_color::main "OPTIONS:")
		  $(_color::sub "-h") show list of command-line options
		  $(_color::sub "-p") configure Arch Linux by privileged user after install
		  $(_color::sub "-u") configure Arch Linux by unprivileged user after install
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
	yes '' | bash -c "pacstrap /mnt $(tr '\n' ' ' </tmp/dotfiles/misc/pkglist/base.txt)"

	_log::info 'Copy reflector config from live environment'
	cp -fv /{,mnt/}etc/xdg/reflector/reflector.conf

	_log::info 'Deploy config files from live environment'
	dir=/tmp/dotfiles
	mkdir -p \
		/mnt/etc/iwd/ \
		/mnt/etc/systemd/resolved.conf.d/ \
		/mnt/etc/systemd/system/systemd-fsck-root.service.d/ \
		/mnt/etc/systemd/system/systemd-fsck@.service.d/ \
		/mnt/etc/systemd/system/systemd-networkd-wait-online.service.d/ \
		/mnt/etc/systemd/system/display-manager.service.d/
	xargs -I {} cp -v "$dir/misc/{}" /mnt/{} <<-EOF
		etc/iwd/main.conf
		etc/systemd/network/20-wired.network
		etc/systemd/network/25-wireless.network
		etc/systemd/resolved.conf.d/dns_servers.conf
		etc/systemd/system/systemd-fsck-root.service.d/io.conf
		etc/systemd/system/systemd-fsck@.service.d/io.conf
		etc/systemd/system/systemd-networkd-wait-online.service.d/wait-for-only-one-interface.conf
		etc/systemd/system/display-manager.service.d/color.conf
		etc/systemd/system/rkhunter.service
		etc/systemd/system/rkhunter.timer
		etc/modprobe.d/disable-overlay-redirect-dir.conf
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

	# NOTE: support for enrolling multiple FIDO2 tokens is currently limited
	# https://man.archlinux.org/man/systemd-cryptenroll.1.en
	_log::info 'Register keys in a LUKS slot'
	_log::info 'Waiting for security key device'
	_log::info 'connect device and press enter key'
	read -r
	systemd-cryptenroll --fido2-device=list
	systemd-cryptenroll --fido2-device=auto "/dev/${PARTITIONS[1]}"

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
# Configure by privileged user
# Globals:
#   None
# Arguments:
#   None
#######################################
_configure_with_privileged() {
	_log::info 'Configure user'
	systemctl enable --now systemd-homed.service

	homectl create "$USERNAME" --member-of=wheel --storage=directory

	_log::info 'Configure privilege escalation'
	cp -fv /tmp/dotfiles/misc/etc/sudoers.d/* /etc/sudoers.d/
}

#######################################
# Configure by unprivileged user
# Globals:
#   XDG_DATA_HOME
#   USER
# Arguments:
#   None
#######################################
_configure_without_privileged() {
	_verify_internet_connection

	# NOTE: stub-resolv.conf does not exist unless systemd-resolved starts
	sudo ln -rsfv /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

	_log::info 'Configure pacman'
	sudo sed \
		-i \
		-e '/^#Color$/s/#//' \
		-e '/^#VerbosePkgLists$/s/#//' \
		-e 's/^#ParallelDownloads = 5$/ParallelDownloads = 20/' \
		/etc/pacman.conf
	sudo systemctl enable --now paccache.timer

	_log::info 'Add chaotic-aur repository'
	sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
	sudo pacman-key --lsign-key 3056513887B78AEB
	sudo pacman \
		-U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' \
		--noconfirm
	sudo pacman \
		-U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' \
		--noconfirm
	if ! sudo grep -q "\[chaotic-aur\]" /etc/pacman.conf; then
		sudo tee -a /etc/pacman.conf >/dev/null <<-EOF

			[chaotic-aur]
			Include = /etc/pacman.d/chaotic-mirrorlist
		EOF
	else
		_log::warn 'chaotic-aur repository already exists -- skipping'
	fi

	_log::info 'Add blackarch repository'
	curl -o '/tmp/#1' 'https://blackarch.org/{strap.sh}'
	echo 5ea40d49ecd14c2e024deecf90605426db97ea0c /tmp/strap.sh | sha1sum -c
	chmod +x /tmp/strap.sh
	sudo /tmp/strap.sh

	sudo cp /etc/pacman.d/blackarch-mirrorlist{,.bak}
	sudo sed -i -e 's/^#Server/Server/' /etc/pacman.d/blackarch-mirrorlist.bak
	rankmirrors -n 5 -p -r blackarch /etc/pacman.d/blackarch-mirrorlist.bak |
		sudo tee /etc/pacman.d/blackarch-mirrorlist >/dev/null

	_log::info 'Install packages'
	sudo bash -c "yes '' | pacman -S --noconfirm --needed --disable-download-timeout $(
		find /tmp/dotfiles/misc/pkglist/ \
			-type f \
			-not -name base.txt \
			-print0 |
			xargs -0 cat |
			grep -v aur |
			tr '\n' ' '
	)"

	_log::info 'Configure makepkg'
	sudo sed \
		-i \
		-e 's/-march=x86-64 -mtune=generic/-march=native/' \
		-e "/^#MAKEFLAGS=\"-j2\"$/s/-j2/-j$(nproc)/" \
		-e '/^COMPRESSZST/s/zstd -c/zstd -1 --threads=0 -c/' \
		-e '/^BUILDENV/s/!ccache/ccache/' \
		/etc/makepkg.conf

	_log::info 'Configure pkgfile'
	sudo systemctl start pkgfile-update.service
	sudo systemctl enable --now pkgfile-update.timer

	_log::info 'Install AUR helper'
	curl -L -o '/tmp/#1' \
		'https://aur.archlinux.org/cgit/aur.git/snapshot/{yay-bin.tar.gz}'
	tar xzvf /tmp/yay-bin.tar.gz -C /tmp/
	cd /tmp/yay-bin/
	makepkg -si --noconfirm
	cd -

	_log::info 'Import 1Password signing key'
	curl -sS https://downloads.1password.com/linux/keys/1password.asc |
		gpg --import

	_log::info 'Install AUR packages'
	# HACK: enter password before running AUR helper to skip selection of package group with yes command
	sudo true
	# HACK: mark news item as read to avoid interruption a pacman transaction
	yay -S --noconfirm --needed --disable-download-timeout informant
	sudo informant read --all
	bash -c "yes '' | yay -S --noconfirm --needed --disable-download-timeout $(
		find /tmp/dotfiles/misc/pkglist/ \
			-type f \
			-print0 |
			xargs -0 cat |
			grep aur |
			tr '\n' ' '
	)"

	_log::info 'Lock the password of root user'
	sudo passwd -l root

	_log::info 'Configure securetty'
	sudo sed \
		-i \
		-e '/^console$/s/^/# /' \
		-e '/^tty1$/s/^/# /' \
		-e '/^tty2$/s/^/# /' \
		-e '/^tty3$/s/^/# /' \
		-e '/^tty4$/s/^/# /' \
		-e '/^tty5$/s/^/# /' \
		-e '/^tty6$/s/^/# /' \
		-e '/^ttyS0$/s/^/# /' \
		-e '/^hvc0$/s/^/# /' \
		/etc/securetty

	_log::info 'Configure firewall'
	sudo systemctl enable --now ufw
	sudo ufw enable
	sudo ufw status verbose

	_log::info 'Enable irqbalance'
	sudo systemctl enable --now irqbalance.service

	_log::info 'Clone dotfiles repository'
	if ! [[ -e "$XDG_DATA_HOME/dotfiles/" ]]; then
		git clone "https://github.com/$USERNAME/dotfiles" "$XDG_DATA_HOME/dotfiles/"
	else
		_log::warn 'dotfiles already exists -- skipping'
	fi

	_log::info 'Deploy config files'
	sudo mkdir -p /etc/keyd/ /etc/docker/
	dir="$XDG_DATA_HOME/dotfiles"
	xargs -I {} sudo cp -v "$dir/misc/{}" /{} <<-EOF
		etc/keyd/default.conf
		etc/docker/daemon.json
		etc/polkit-1/rules.d/50-udisks.rules
		etc/systemd/zram-generator.conf
		etc/udev/rules.d/99-lowbat.rules
		etc/ssh/sshd_config.d/permit_root_login.conf
	EOF

	_log::info 'Change default shell'
	sudo homectl update --shell="$(which zsh)" "$USER"

	_log::info 'Configure clock synchronization'
	sudo sed \
		-i \
		-e "s/^#NTP=/NTP=$(echo {0..3}.jp.pool.ntp.org)/" \
		-e '/^#FallbackNTP/s/#//' \
		/etc/systemd/timesyncd.conf
	sudo systemctl enable --now systemd-timesyncd
	sudo timedatectl set-ntp true
	sudo timedatectl status

	# System administration
	_log::info 'Configure service management'
	sudo sed \
		-i \
		-e '/^#DefaultTimeoutStopSec/s/90s/5s/' \
		-e '/^#DefaultTimeoutStopSec/s/#//' \
		/etc/systemd/system.conf
	sudo sed \
		-i \
		-e 's/^#SystemMaxUse=/SystemMaxUse=5M/' \
		/etc/systemd/journald.conf

	# Graphical User Interface
	_log::info 'Configure display manager'
	sudo sed \
		-i \
		-e '/^clock =/s/null/%a, %b %d %H:%M/' \
		-e '/^hide_key_hints =/s/false/true/' \
		-e '/^wayland_cmd/s|wsetup.sh$|wsetup.sh >/dev/null|' \
		/etc/ly/config.ini
	sudo systemctl enable ly.service

	_log::info 'Configure window manager'
	hyprpm update --no-shallow
	hyprpm add https://github.com/outfoxxed/hy3
	hyprpm add https://github.com/hyprwm/hyprland-plugins
	hyprpm enable hy3
	hyprpm enable hyprbars

	# OOM-killer
	_log::info 'Configure OOM-killer'
	sudo systemctl enable --now systemd-oomd

	# TRIM
	_log::info 'Configure Periodic TRIM'
	sudo systemctl enable --now fstrim.timer

	# Power management
	_log::info 'Configure ACPI events'
	sudo sed \
		-i \
		-e '/^#HandlePowerKey=/s/poweroff/suspend/' \
		-e '/^#HandlePowerKey=/s/#//' \
		-e '/^#HandleLidSwitch=/s/suspend/ignore/' \
		-e '/^#HandleLidSwitch=/s/#//' \
		/etc/systemd/logind.conf

	sudo systemctl restart systemd-logind

	_log::info 'Configure CPU frequency scaling'
	sudo sed \
		-i \
		-e '/^#governor=/s/ondemand/performance/' \
		-e '/^#governor=/s/#//' \
		-e '/^#max_freq=/s/#max_freq="[0-9]*GHz"/max_freq="2GHz"/' \
		/etc/default/cpupower
	sudo systemctl enable --now cpupower

	# Input devices
	_log::info 'Configure keyboard layouts'
	keymap=us

	sudo cp \
		"/usr/share/kbd/keymaps/i386/qwerty/$keymap.map.gz" \
		"/usr/share/kbd/keymaps/$keymap-custom.map.gz"
	sudo gunzip "/usr/share/kbd/keymaps/$keymap-custom.map.gz"
	# Disable caps lock
	sudo sed \
		-i \
		-e 's/^keycode  58 = Caps_Lock$/keycode  58 = VoidSymbol/' \
		"/usr/share/kbd/keymaps/$keymap-custom.map"
	# Change right alt to control
	if ! sudo grep -q "keycode 100 = Control" "/usr/share/kbd/keymaps/$keymap-custom.map"; then
		sudo tee -a "/usr/share/kbd/keymaps/$keymap-custom.map" <<<"keycode 100 = Control" >/dev/null
	fi
	sudo sed -i \
		-e "s|^KEYMAP=$keymap$|KEYMAP=$keymap-custom|" \
		/etc/vconsole.conf
	sudo systemctl enable --now keyd

	_log::info 'Configure wallpaper'
	mkdir -p "${XDG_DATA_HOME}/hypr/"
	# https://www.pexels.com/photo/buildings-with-blue-light-747101/
	curl \
		'https://images.pexels.com/photos/747101/pexels-photo-747101.jpeg?dl&fit=crop&crop=entropy&w=1920&h=1280' \
		>"${XDG_DATA_HOME}/hypr/wallpaper.jpeg"

	_log::info 'Configure bluetooth'
	sudo gpasswd -a "$USER" lp
	sudo sed \
		-i \
		-e '/^#AutoEnable=/s/false/true/' \
		-e '/^#AutoEnable=/s/#//' \
		/etc/bluetooth/main.conf
	sudo systemctl enable --now bluetooth

	_log::info 'Configure yubikey'
	sudo systemctl enable --now pcscd.service

	_log::info 'Configure avrdude'
	sudo gpasswd -a "$USER" uucp
	sudo gpasswd -a "$USER" lock

	_log::info 'Configure virtualization'
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

	# Utilities
	_log::info 'Configure password manager'
	sudo ln -sf /usr/bin/pinentry-curses /usr/bin/pinentry

	_log::info 'Configure mount helper'
	sudo gpasswd --add "$USER" storage

	_log::info 'Create user directories'
	mkdir "$HOME"/{Downloads,Public,Workspaces}

	_log::info 'Configure U2F PAM'
	if ! sudo grep -q "pam_u2f.so" /etc/pam.d/sudo; then
		sudo sed \
			-i \
			-e '/^#%PAM-1.0$/a auth		sufficient		pam_u2f.so		cue		origin=pam:\/\/localhost		appid=pam:\/\/localhost' \
			/etc/pam.d/sudo
	else
		_log::warn "U2F PAM already set in /etc/pam.d/sudo -- skipping"
	fi
	if ! sudo grep -q "pam_u2f.so" /etc/pam.d/polkit-1; then
		sudo sed \
			-i \
			-e '/^#%PAM-1.0$/a auth		sufficient		pam_u2f.so		cue		origin=pam:\/\/localhost		appid=pam:\/\/localhost' \
			/etc/pam.d/polkit-1
	else
		_log::warn "U2F PAM already set in /etc/pam.d/polkit-1 -- skipping"
	fi
	if ! sudo grep -q "pam_u2f.so" /etc/pam.d/hyprlock; then
		sudo sed \
			-i \
			-e '/^auth        include     login$/i auth		sufficient		pam_u2f.so		cue		origin=pam:\/\/localhost		appid=pam:\/\/localhost' \
			/etc/pam.d/hyprlock
	else
		_log::warn "U2F PAM already set in /etc/pam.d/hyprlock -- skipping"
	fi

	_log::info 'Configure GNOME keyring'
	sudo sed \
		-i \
		-e '/^auth *optional *pam_gnome_keyring.so$/! {
			/^auth *include *system-local-login$/a auth       optional     pam_gnome_keyring.so
		}' \
		-e '/^session *optional *pam_gnome_keyring.so auto_start$/! {
			/^session *include *system-local-login$/a session    optional     pam_gnome_keyring.so auto_start
		}' \
		/etc/pam.d/login

	sudo sed \
		-i \
		-e '/^password	optional	pam_gnome_keyring.so$/! {
			$ a password	optional	pam_gnome_keyring.so
		}' /etc/pam.d/passwd

	_log::info 'Setup nix'
	sudo gpasswd -a "$USER" nix-users
	sudo systemctl enable --now nix-daemon.service
	nix-channel --add https://nixos.org/channels/nixpkgs-unstable
	nix-channel --update
	# initialize home-manager
	# NOTE: do not use --switch option with init command as home.nix already exists
	nix run home-manager/master -- init
	# install home-manager binary
	nix run home-manager/master -- switch

	_log::info 'Install kubectl packages'
	bash -c "yes | kubectl krew install $(
		tr '\n' ' ' </tmp/dotfiles/misc/kubectl-plugins.txt
	)"

	_log::info 'Install gh extensions'
	gh extension install dlvhdr/gh-dash

	_log::info 'Install formatter'
	pnpm add -g sql-formatter

	_log::info 'Install TUI for LLM'
	pipx install elia-chat

	_log::info 'Install test tool'
	go install gotest.tools/gotestsum@latest

	_log::info 'Install code generator'
	go install github.com/josharian/impl@latest
	go install github.com/fatih/gomodifytags@latest

	_log::info 'Install packages for editor'
	go install github.com/rhysd/vim-startuptime@latest

	_log::info 'Configure VPN'
	sudo systemctl enable --now nordvpnd
	sudo gpasswd -a "$USER" nordvpn

	_log::info 'Configure scheduling utility'
	sudo systemctl enable --now atd

	_log::info 'Configure plocate'
	sudo systemctl start plocate-updatedb.service
	sudo systemctl enable --now plocate-updatedb.timer

	_log::info 'Configure etckeeper'
	sudo etckeeper init
	sudo git -C /etc/ config --local user.name "etckeeper"
	sudo git -C /etc/ config --local user.email "etckeeper@localhost"
	sudo etckeeper commit "Initial commit"
	sudo systemctl enable --now etckeeper.timer

	_log::info 'Configure profile-sync-daemon'
	systemctl --user enable --now psd.service

	_log::info 'Configure text expander'
	systemctl --user enable espanso

	_log::info 'Configure metasploit'
	sudo mkdir -p /var/lib/postgres/data
	sudo chattr +C /var/lib/postgres/data
	sudo -u postgres initdb -D /var/lib/postgres/data
	sudo systemctl start postgresql
	yes no | msfdb init

	_log::info 'Configure wireshark'
	sudo gpasswd -a "$USER" wireshark

	_log::info 'Downloads wordlists'
	sudo wordlistctl fetch best110
	sudo wordlistctl fetch -d rockyou
	sudo wordlistctl fetch -d fasttrack
	sudo wordlistctl fetch subdomains-top1million-5000

	_log::info 'Configure wpscan'
	wpscan --update

	_log::info 'Configure rkhunter'
	lists=(
		/usr/bin/egrep
		/usr/bin/fgrep
		/usr/bin/ldd
		/usr/sbin/s
	)
	for list in "${lists[@]}"; do
		if ! sudo grep "SCRIPTWHITELIST=$list" /etc/rkhunter.conf; then
			sudo tee -a /etc/rkhunter.conf <<<"SCRIPTWHITELIST=$list" >/dev/null
		else
			_log::warn "rkhunter SCRIPTWHITELIST=$list already set -- skipping"
		fi
	done
	sudo sed \
		-i \
		-e '/^#ALLOW_SSH_PROT_V1/s/#//' \
		-e '/^ALLOW_SSH_PROT_V1/s/0/2/' \
		-e '/^#ALLOW_SSH_ROOT_USER/s/#//' \
		-e '/^ALLOW_SSH_ROOT_USER/s/no/unset/' \
		/etc/rkhunter.conf

	if ! sudo grep "RTKT_FILE_WHITELIST=/usr/sbin/s" /etc/rkhunter.conf; then
		sudo tee -a /etc/rkhunter.conf <<<"RTKT_FILE_WHITELIST=/usr/sbin/s" >/dev/null
	else
		_log::warn "rkhunter RTKT_FILE_WHITELIST=/usr/sbin/s already set -- skipping"
	fi
	if ! sudo grep "ALLOWDEVFILE=/dev/shm/PostgreSQL.*" /etc/rkhunter.conf; then
		sudo tee -a /etc/rkhunter.conf <<<"ALLOWDEVFILE=/dev/shm/PostgreSQL.*" >/dev/null
	else
		_log::warn "rkhunter ALLOWDEVFILE=/dev/shm/PostgreSQL.* already set -- skipping"
	fi
	# For zoom
	if ! sudo grep "ALLOWDEVFILE=/dev/shm/aomshm.*" /etc/rkhunter.conf; then
		sudo tee -a /etc/rkhunter.conf <<<"ALLOWDEVFILE=/dev/shm/aomshm.*" >/dev/null
	else
		_log::warn "rkhunter ALLOWDEVFILE=/dev/shm/aomshm.* already set -- skipping"
	fi
	if ! sudo grep "ALLOWHIDDENDIR=/etc/.git" /etc/rkhunter.conf; then
		sudo tee -a /etc/rkhunter.conf <<<"ALLOWHIDDENDIR=/etc/.git" >/dev/null
	else
		_log::warn "rkhunter ALLOWHIDDENDIR=/etc/.git already set -- skipping"
	fi
	lists=(
		/etc/.etckeeper
		/etc/.gitignore
		/etc/.updated
		/usr/share/man/man5/.k5identity.5.gz
		/usr/share/man/man5/.k5login.5.gz
	)
	for list in "${lists[@]}"; do
		if ! sudo grep "ALLOWHIDDENFILE=$list" /etc/rkhunter.conf; then
			sudo tee -a /etc/rkhunter.conf <<<"ALLOWHIDDENFILE=$list" >/dev/null
		else
			_log::warn "rkhunter ALLOWHIDDENFILE=$list already set -- skipping"
		fi
	done
	# NOTE: allow IPC for ueberzug
	if ! sudo grep "ALLOWIPCUSER=$USER" /etc/rkhunter.conf; then
		sudo tee -a /etc/rkhunter.conf <<<"ALLOWIPCUSER=$USER" >/dev/null
	else
		_log::warn "rkhunter ALLOWIPCUSER=$USER already set -- skipping"
	fi
	sudo cp -fv "$dir"/misc/etc/pacman.d/hooks/rkhunter-* /etc/pacman.d/hooks/
	# NOTE: use /dev/null to ignore grep warning
	sudo rkhunter --update 2>/dev/null
	sudo rkhunter --config-check 2>/dev/null
	sudo rkhunter --propupd 2>/dev/null
	sudo rkhunter -c --sk 2>/dev/null
	sudo systemctl enable --now rkhunter.timer

	# GUI Java Application
	sudo archlinux-java set "$(
		archlinux-java status |
			grep 'java-.*-openjdk' |
			awk '{print $1}' |
			sort |
			tail -1
	)"

	# NOTE: git clone fails when forcing ssh protocol
	#       in ~/.config/git/config before creating ssh key
	_log::info 'Deploy dotfiles'
	# HACK: move default dotfiles to avoid conflict
	mv -v ~/.bashrc{,.bak}
	just --justfile "$XDG_DATA_HOME/dotfiles/justfile"
}

#######################################
# Verify boot mode
# Globals:
#   None
# Arguments:
#   None
#######################################
_verify_boot_mode() {
	_runtime::is_container && return

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
# Return true when container
# Globals:
#   CONTAINER
# Arguments:
#   None
#######################################
_runtime::is_container() {
	[[ $CONTAINER == true ]]
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
# Return true when privileged user
# Globals:
#   None
# Arguments:
#   None
#######################################
_runtime::is_privileged() {
	[[ $(id -u) == 0 ]]
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

main """${@}"
