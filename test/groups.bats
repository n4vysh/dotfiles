# bats file_tags=groups

bats_load_library bats-support
bats_load_library bats-assert

get_groups() {
  yq e \
    '.groups[]' \
    home/.chezmoidata/groups.yaml |
    xargs -I {} sh -c 'printf "{}: "; getent group {} >/dev/null && echo ok || echo ng'
}

@test "groups are correct" {
  run get_groups

  refute_line --regexp '^.*: ng$'
}
