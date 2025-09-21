# bats file_tags=files

bats_load_library bats-support
bats_load_library bats-file

@test "etc files are correct" {
  assert_file_contains /etc/vconsole.conf '^KEYMAP=us$'

  assert_file_contains /etc/xdg/reflector/reflector.conf '^--latest 30$'
  assert_file_contains /etc/xdg/reflector/reflector.conf '^--sort rate$'
  assert_file_contains /etc/xdg/reflector/reflector.conf '^# Print extra information$'
  assert_file_contains /etc/xdg/reflector/reflector.conf '^--verbose$'

  assert_file_contains /etc/locale.gen '^en_US.UTF-8 UTF-8  $'

  assert_file_contains \
    /etc/mkinitcpio.conf \
    '^HOOKS=(systemd autodetect microcode modconf kms keyboard sd-vconsole block sd-encrypt lvm2 filesystems)$'
  assert_file_contains /etc/mkinitcpio.conf '^COMPRESSION=cat$'

  assert_file_contains /etc/mkinitcpio.d/linux-zen.preset '^#.*_image=.*$'
  assert_file_contains /etc/mkinitcpio.d/linux-zen.preset '^.*_uki=.*$'
  assert_file_contains /etc/mkinitcpio.d/linux-zen.preset 'boot/EFI'
  assert_file_contains \
    /etc/mkinitcpio.d/linux-zen.preset \
    '^default_options=.*$'
  assert_file_contains \
    /etc/mkinitcpio.d/linux-zen.preset \
    'splash-arch-custom.bmp'

  assert_file_contains /etc/kernel/cmdline '^rd.luks.name=.*=cryptlvm rd.luks.options=.*=tpm2-device=auto root=/dev/volume/root quiet loglevel=0 systemd.show_status=false rd.udev.log_level=1 vt.global_cursor_default=0 fbcon=nodefer ro nosgx mitigations=auto,nosmt modprobe.blacklist=iTCO_wdt ipv6.disable=1$'

  assert_file_contains /etc/ly/config.ini '^clock = %a, %b %d %H:%M$'
  assert_file_contains /etc/ly/config.ini '^hide_key_hints = true$'
  assert_file_contains /etc/ly/config.ini '^session_log = .ly-session.log$'

  assert_file_contains /etc/pacman.conf '^Color$'
  assert_file_contains /etc/pacman.conf '^VerbosePkgLists$'
  assert_file_contains /etc/pacman.conf '^ParallelDownloads = 20$'
}

@test "etc files are linked" {
  assert_symlink_to /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

  assert_symlink_to /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
}

@test "etc files are deployed" {
  mapfile -t files < <(
    find etc/ -type f |
      grep -v 'etc/kernel/cmdline' |
      grep -v 'etc/modprobe.d/disable-overlay-redirect-dir.conf' |
      grep -v 'etc/polkit-1/rules.d/50-udisks.rules' |
      grep -v 'etc/sudoers.d/' |
      grep -v 'etc/systemd/system/display-namager.service.d/color.conf' |
      grep -v 'etc/wsl.conf' |
      grep -v 'etc/tmpfiles.d/wslg.conf' |
      grep -v 'etc/systemd/system/systemd-timesyncd.service.d/override.conf'
  )

  for file in "${files[@]}"; do
    assert_files_equal "/$file" "$file"
  done
}
