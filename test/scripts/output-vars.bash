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
find src/.local/bin/ -mindepth 1 -printf '%f\n' |
	yq '{"commands":split(" ")}'
{
	find src/ -mindepth 1 -maxdepth 1 -not -name '.local' -not -name '.config' -printf '%p\n'
} |
	sed 's|^src/||g' |
	yq '{"files":split(" ")}'
{
	find src/.config -mindepth 1 -maxdepth 1 -printf '%p\n'
} |
	sed 's|^src/||g' |
	yq '{"xdg_config_files":split(" ")}'
{
	find src/.local/{bin,src} -mindepth 1 -maxdepth 1 -printf '%p\n'
} |
	sed 's|^src/||g' |
	yq '{"xdg_local_files":split(" ")}'
