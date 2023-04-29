@echo (status filename)

set temp (mktemp -d)
set origin_path $PATH

cd $temp

@test 'It should be able to paginate with unbuffer command' (
  # allow to run only unbuffer command in external command
  mkdir bin/
  touch bin/unbuffer
  chmod +x bin/unbuffer
  set -x PATH $PWD/bin

  mock fish_commandline_prepend \* 0
  mock __fish_paginate \* 0

  __fish_paginate_extend >/dev/null 2>&1
) $status -eq 0

@test 'It should not paginate with no unbuffer command' (
  # prevent to run all external command including unbuffer command
  set -x PATH

  __fish_paginate_extend >/dev/null 2>&1
) $status -eq 1

set -x PATH $origin_path
rm -rf $temp
