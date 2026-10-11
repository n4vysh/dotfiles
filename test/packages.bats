# bats file_tags=packages

bats_load_library bats-support
bats_load_library bats-assert

get_package_info() {
  local platform=linux

  [ -f /usr/bin/wslinfo ] && platform=wsl

  set -o pipefail
  platform="$platform" yq \
    '
      explode(.)
      | .packages[strenv(platform)].pacman
      | flatten
      | unique
      | .[]
      | split("/")
      | .[-1]
    ' \
    home/.chezmoidata/packages.yaml |
    xargs -r pacman -Q
}

@test "packages are installed" {
  run get_package_info

  assert_success
  refute_line --regexp "^error: package '.*' was not found$"
}
