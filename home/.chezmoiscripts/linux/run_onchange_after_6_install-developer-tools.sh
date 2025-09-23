#!/bin/sh

set -eu

gum log --level info 'Install packages with mise'
mise install

gum log --level info 'Install git hooks'
if ! [ -f ~/.local/share/chezmoi/.git/hooks/pre-commit ]; then
	cd ~/.local/share/chezmoi/ || exit
	pre-commit install --install-hooks
	cd - || exit
else
	gum log --level warn 'git hooks already exists -- skipping'
fi

gum log --level info 'Download wpscan database'
if ! [ -d .wpscan ]; then
	wpscan --update
else
	gum log --level warn 'wpscan database already exists -- skipping'
fi

gum log --level info 'Download wordlists'
sudo wordlistctl fetch best110
sudo wordlistctl fetch rockyou
sudo wordlistctl fetch fasttrack
sudo wordlistctl fetch subdomains-top1million-5000

gum log --level info 'Set java version for burp'
sudo archlinux-java set "$(
	archlinux-java status |
		grep 'java-.*-openjdk' |
		awk '{print $1}' |
		sort |
		tail -1
)"

# NOTE: run a script when mise file changes
# https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/#run-a-script-when-the-contents-of-another-file-changes
# https://github.com/twpayne/chezmoi/issues/4364
# https://github.com/alker0/chezmoi.vim/issues/76
cat <<-EOF >/dev/null
	{{ include (joinPath .chezmoi.sourceDir "dot_config/mise/config.toml") | sha256sum }}
EOF
