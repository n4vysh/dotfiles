# bats file_tags=packages

bats_load_library bats-support
bats_load_library bats-assert

get_package_info() {
  yq e \
    '.packages.linux.pacman[]' \
    src/.chezmoidata/packages.yaml |
    sed 's|^.*/||g' |
    xargs pacman -Q
}

@test "packages are installed" {
  run get_package_info

  refute_line --regexp "^error: package '.*' was not found$"
}
