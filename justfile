link:
    yadm clone -b standard https://github.com/n4vysh/dotfiles

prelink:
    mise trust
    mise activate >/dev/null # HACK: load env after `mise trust`

postlink:
    cp src/.config/git/{scripts/pre-commit.bash,templates/hooks/pre-commit}
    systemctl --user enable tmux
    systemctl --user enable --now gcr-ssh-agent.socket

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
