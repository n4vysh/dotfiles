@echo (status filename)

set temp (mktemp -d)
set origin_path $PATH

cd $temp

@test 'It should be able to add abbr with existing command' (
  __fish_abbr_add_extend word fish >/dev/null 2>&1
) $status -eq 0

@test 'It should not add abbr with non-existent command' (
  # prevent to run all external command
  set -x PATH

  __fish_abbr_add_extend word dummy-command >/dev/null 2>&1
) $status -eq 1

@test 'It should not add abbr with no word and expansion' (
  __fish_abbr_add_extend >/dev/null 2>&1
) $status -eq 1

@test 'It should not add abbr with no expansion' (
  __fish_abbr_add_extend word >/dev/null 2>&1
) $status -eq 1

set -x PATH $origin_path
rm -rf $temp
