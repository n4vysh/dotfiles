#!/bin/sh

gum log --level info 'Link etc files'
# https://learn.microsoft.com/en-us/windows/wsl/wsl-config#configuration-setting-for-wslconfig
sudo cp -iv \
	~/.local/share/chezmoi/etc/wsl.conf \
	/etc/wsl.conf

# NOTE: fix wslg bug of WSL
# https://github.com/microsoft/wslg/issues/1032#issuecomment-2310369848
sudo mkdir -p /etc/tmpfiles.d/
sudo cp -iv \
	~/.local/share/chezmoi/etc/tmpfiles.d/wslg.conf \
	/etc/tmpfiles.d/wslg.conf

# NOTE: fix clock sync bug of WSL
# https://github.com/microsoft/WSL/issues/8204#issuecomment-1339506778
sudo mkdir -p /etc/systemd/system/systemd-timesyncd.service.d/
sudo cp -iv \
	~/.local/share/chezmoi/etc/systemd/system/systemd-timesyncd.service.d/override.conf \
	/etc/systemd/system/systemd-timesyncd.service.d/override.conf

gum log --level info 'Link commands'
ln -s /mnt/c/Program\ Files/draw.io/draw.io.exe ~/.local/bin/draw.io.exe
ln -s \
	/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe \
	~/.local/bin/powershell.exe
ln -s /mnt/c/Windows/System32/wsl.exe ~/.local/bin/wsl.exe

# shellcheck disable=SC2016
dir=$(wslpath "$(powershell.exe '$env:USERPROFILE')")
ln -s \
	"$dir/AppData/Local/Microsoft/WindowsApps/winget.exe" \
	~/.local/bin/winget.exe
ln -s "$dir/scoop/shims/scoop.ps1" ~/.local/bin/scoop.ps1

# for markdown-preview.nvim
ln -s /mnt/c/Windows/System32/cmd.exe ~/.local/bin/cmd.exe

gum log --level info 'Override binaries with exe files'
ln -s \
	/mnt/c/Program\ Files/Mozilla\ Firefox/firefox.exe \
	~/.local/bin/firefox

cat <'EOF' >~/.local/bin/wl-paste
#!/bin/sh

/usr/sbin/wl-paste "$@" | tr -d '\r'
EOF

cat <'EOF' >~/.local/bin/xdg-open
#!/bin/sh

powershell.exe start "$@"
EOF

# shellcheck disable=SC2016
dir=$(wslpath "$(powershell.exe '$env:USERPROFILE')")
ln -s \
	"$dir/AppData/Local/Microsoft/WinGet/Packages/hrkfdn.ncspot_Microsoft.Winget.Source_8wekyb3d8bbwe/ncspot.exe" \
	~/.local/bin/ncspot

# https://github.com/nmap/nmap/issues/1864
# https://libreddit.garudalinux.org/r/bashonubuntuonwindows/comments/tikwt1/how_do_i_make_my_wsl_to_make_network_scans_for_my/
# https://superuser.com/questions/1700040/alexa-device-not-found-via-nmap-in-wsl2

ln -s /mnt/c/Program\ Files\ \(x86\)/Nmap/nmap.exe ~/.local/bin/nmap

gum log --level info 'Enable systemd services'
systemctl --user daemon-reload
# NOTE: fix wslg bug of WSL
# https://github.com/microsoft/wslg/issues/1032#issuecomment-2310369848
systemctl --user enable --now wsl-wayland-symlink.service
