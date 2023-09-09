set fish_greeting

set -l file (
  string replace $XDG_CONFIG_HOME '$XDG_CONFIG_HOME' (status filename)
)

set -l cmd fzf
if command -q "$cmd"
    set fzf_fd_opts --hidden --exclude=.git
    set fzf_preview_dir_cmd eza -aF1 --icons
else
    printf '%s: Not found %s command\n' "$file" "$cmd" >&2
end
