link: prelink _stow postlink

prelink:
    mise trust
    mise activate >/dev/null # HACK: load env after `mise trust`
    mkdir -p ~/.config/ ~/.local/bin/ ~/.local/src/

_stow *opt:
    stow {{ opt }} -v -d src/ -t ~/ .

postlink:
    cp src/.config/git/{scripts/pre-commit.bash,templates/hooks/pre-commit}
    systemctl --user enable tmux
    systemctl --user enable --now gcr-ssh-agent.socket

unlink: (_stow "-D")

dry-run-link: (_stow "-n")

dry-run-unlink: (_stow "-n" "-D")

install:
    cat misc/pkglist/* | yay -S --needed -

install-git-hooks:
    pre-commit install --install-hooks
    pre-commit install --hook-type commit-msg

install-tresorit:
    curl -o '/tmp/#1' 'https://installer.tresorit.com/{tresorit_installer.run}'
    chmod +x /tmp/tresorit_installer.run
    /tmp/tresorit_installer.run

configure-tresorit:
    ~/.local/share/tresorit/tresorit-cli sync --start Documents --path ~/Documents
    ~/.local/share/tresorit/tresorit-cli sync --start Music --path ~/Music
    ~/.local/share/tresorit/tresorit-cli sync --start Pictures --path ~/Pictures
    ~/.local/share/tresorit/tresorit-cli sync --start Videos --path ~/Videos

test *target:
    pre-commit run -av {{ target }}

test-in-container:
    test/scripts/dgoss.bash

build:
    docker build -t n4vysh/dotfiles --progress=plain .

capture:
    sudo fbgrab -c 2 misc/screenshots/login_screen.png

create:
    magick \
        -size 1920x1080 \
        xc:black \
        /usr/share/systemd/bootctl/splash-arch-custom.bmp \
        -gravity center \
        -composite \
        misc/screenshots/bootsplash.png
