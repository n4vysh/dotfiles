FROM archlinux:latest

# Upgrade installed packages to take advantage of rolling release
# and add some packages to simulate archiso
RUN set -eux; \
  yes '' | pacman -Syu --noconfirm --needed --disable-download-timeout \
  # https://geo.mirror.pkgbuild.com/iso/latest/arch/pkglist.x86_64.txt
  arch-install-scripts \
  gnu-netcat \
  reflector \
  zsh \
  # for su-exec
  gcc \
  make

# Mock
# HACK: set ~/.local/bin/ to $PATH for dgoss command tests
ENV USERNAME=n4vysh \
  PATH="/home/n4vysh/.local/bin/:/usr/local/bin/:$PATH"
COPY misc/mock/ /tmp/dotfiles/misc/mock/
RUN set -eux; \
  rm -fr /mnt; \
  ln -fsv / /mnt; \
  mkdir -p /usr/local/bin/ /boot/loader/; \
  install /tmp/dotfiles/misc/mock/* /usr/local/bin/; \
  # Add user
  useradd -m -G wheel -s /usr/bin/zsh "$USERNAME"; \
  # Install su-exec to switch user
  curl -L -o '/tmp/su-exec.tar.gz' \
  'https://github.com/ncopa/su-exec/archive/refs/tags/v0.2.tar.gz'; \
  tar xzvf /tmp/su-exec.tar.gz -C /tmp/; \
  make -C /tmp/su-exec-0.2/; \
  install /tmp/su-exec-0.2/su-exec /usr/local/bin/

# Disable getty to execute systemd without login
RUN set -eux; \
  systemctl mask getty@tty1.service

# Simulate bootstrap
COPY scripts/bootstrap.bash /tmp/dotfiles/scripts/
COPY misc/boot/ /tmp/dotfiles/misc/boot/
COPY misc/etc/ /tmp/dotfiles/misc/etc/
COPY misc/pkglist/base.txt /tmp/dotfiles/misc/pkglist/
RUN set -eux; \
  echo archiso >/etc/hostname; \
  yes '' | CONTAINER=true /tmp/dotfiles/scripts/bootstrap.bash; \
  /tmp/dotfiles/scripts/bootstrap.bash -p; \
  echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
COPY misc/pkglist/* /tmp/dotfiles/misc/pkglist/
COPY misc/lockscreen.svg /tmp/dotfiles/misc/
COPY misc/kubectl-plugins.txt /tmp/dotfiles/misc/
COPY src/ /tmp/dotfiles/src/
COPY justfile /tmp/dotfiles/
RUN set -eux; \
  # NOTE: su-exec does not change user directory, so change manually directory
  cd /home/$USERNAME; \
  # NOTE: su-exec does not set environment variables, so set manually
  USER=$USERNAME \
  TERM=xterm-256color \
  su-exec $USERNAME /tmp/dotfiles/scripts/bootstrap.bash -u

# Clear cache, add all files, and set systemd to entrypoint
RUN set -eux; \
  pacman -Sc --noconfirm
COPY . /tmp/dotfiles/
ENTRYPOINT [ "init" ]
