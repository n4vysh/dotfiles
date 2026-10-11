# bats file_tags=services

bats_load_library bats-support
bats_load_library bats-assert

get_services() {
  local type="$1" state="$2"
  local platform=linux opts='' command

  [ -f /usr/bin/wslinfo ] && platform=wsl

  [[ "$type" == user ]] && opts=--user

  case "$state" in
  enabled) command=is-enabled ;;
  running) command=is-active ;;
  *) return 1 ;;
  esac

  set -o pipefail
  platform="$platform" type="$type" state="$state" yq '
    explode(.)
    | .services[strenv(platform)].systemd[strenv(type)][strenv(state)]
    | flatten
    | unique
    | .[]
  ' "$(chezmoi source-path)/.chezmoidata/services.yaml" |
    xargs -I {} sh -c "printf '{}: '; systemctl $opts $command {}"
}

@test "system services are enabled" {
  run get_services system enabled

  assert_success
  refute_line --regexp '^.*: disabled$'
}

@test "system services are running" {
  run get_services system running

  assert_success
  refute_line --regexp '^.*: inactive$'
}

@test "user services are enabled" {
  run get_services user enabled

  assert_success
  refute_line --regexp '^.*: disabled$'
}

@test "user services are running" {
  run get_services user running

  assert_success
  refute_line --regexp '^.*: inactive$'
}
