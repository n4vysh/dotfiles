#!/bin/bash

dir=$(
	cd "$(dirname "$0")" || exit
	git rev-parse --show-toplevel
)

cd "$dir/" || exit

echo "# This file is auto-generated"
echo "# script path: test/scripts/output-vars.bash"
cat <(
	# extract packages except group packages
	cat misc/pkglist/* <(
		# extract group packages
		cat misc/pkglist/* <(pacman -Sg) |
			sort |
			uniq -d
	) |
		sort |
		uniq -u
) <(
	# extract a single package from group packages
	cat misc/pkglist/* <(pacman -Sg) |
		sort |
		uniq -d |
		pacman -Sg - |
		awk '{print $2}'
) |
	sed 's|.*/||g' |
	sort |
	yq '{"packages":split(" ")}'
