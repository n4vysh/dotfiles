@echo (status filename)

set temp (mktemp -d)
set origin_path $PATH

cd $temp

@test 'It should be able to add key binding with existing command' (
  fish_user_execute_key_bindings seq fish >/dev/null 2>&1
) $status -eq 0

@test 'It should not add key binding with non-existent command' (
  # prevent to run all external command
  set -x PATH

  fish_user_execute_key_bindings seq dummy-command >/dev/null 2>&1
) $status -eq 1

@test 'It should not add key binding with no sequence and commands' (
  fish_user_execute_key_bindings >/dev/null 2>&1
) $status -eq 1

@test 'It should not add key binding with no commands' (
  fish_user_execute_key_bindings seq >/dev/null 2>&1
) $status -eq 1

set -x PATH $origin_path
rm -rf $temp
