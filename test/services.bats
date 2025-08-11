# bats file_tags=services

bats_load_library bats-support
bats_load_library bats-assert

get_enabled_services() {
  type="$1"
  [ "$type" = user ] && opts=--user
  yq e \
    ".services.systemd.$type.enabled[]" \
    "$(chezmoi source-path)/.chezmoidata/services.yaml" |
    xargs -I {} sh -c "printf '{}: '; systemctl $opts is-enabled {}"
}

get_running_services() {
  type="$1"
  [ "$type" = user ] && opts=--user
  yq e \
    ".services.systemd.$type.running[]" \
    "$(chezmoi source-path)/.chezmoidata/services.yaml" |
    xargs -I {} sh -c "printf '{}: '; systemctl $opts is-active {}"
}

@test "system services are enabled" {
  run get_enabled_services system

  refute_line --regexp '^.*: disabled$'
}

@test "system services are running" {
  run get_running_services system

  refute_line --regexp '^.*: inactive$'
}

@test "user services are enabled" {
  run get_enabled_services user

  refute_line --regexp '^.*: disabled$'
}

@test "user services are running" {
  run get_running_services user

  refute_line --regexp '^.*: inactive$'
}
