#!/bin/bash

dir=$(
	cd "$(dirname "$0")" || exit
	git rev-parse --show-toplevel
)

cd "$dir/" || exit

[[ $(hostname) == localhost ]] && export GOSS_PATH=/usr/bin/goss
export GOSS_VARS="goss-vars.yaml"
# shellcheck disable=SC2016
mapfile -t files < <(
	yq '
		. as $item ireduce ({}; . * $item )
		| .gossfile
		| keys
		' goss.yaml goss_privileged.yaml |
		sed 's/^- //'
)
for file in "${files[@]}"; do
	# HACK: some tests fail in container, so skip its
	#         - test/mount.yaml: does not exists mount points in container
	#         - test/templates/package.yaml: some packages fail install by network problem
	if [[ $file == test/mount.yaml ]] ||
		[[ $file == test/templates/package.yaml ]]; then
		continue
	fi

	echo "file: $file"
	export GOSS_FILE="$file"

	if [[ $file == test/service.yaml ]] || [[ $file == test/interface.yaml ]]; then
		export GOSS_SLEEP=10
	else
		export GOSS_SLEEP=0.2
	fi

	dgoss run -t --rm --privileged -e USER=n4vysh n4vysh/dotfiles
done
