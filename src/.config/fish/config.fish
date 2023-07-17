begin
    set -l file (
      string replace $XDG_CONFIG_HOME '$XDG_CONFIG_HOME' (status filename)
    )

    set -l dir "$XDG_CONFIG_HOME/fish"
    for type in conf.d functions
        set -l count 0

        for path in "$dir/usr/$type"/*
            set -l name (string split -rm 1 / "$path")[2]
            if not test -e "$dir/$type/$name"
                set count (math "$count" + 1)
                if test "$count" -eq 1
                    printf '%s: Deploy file in %s directory\n' "$file" "$type"
                end

                ln -sv {../usr,"$dir"}"/$type/$name"
            end
        end
    end
end

if status --is-interactive
    set -l file (
      string replace $XDG_CONFIG_HOME '$XDG_CONFIG_HOME' (status filename)
    )

    if not type -q fisher
        printf '%s: Install fisher\n' "$file"

        if and type -q curl
            curl -L https://git.io/fisher |
                source &&
                fisher update
        else
            printf '%s: Not found curl\n' "$file" >&2
        end
    end
end

begin
    set -l file (
      string replace $XDG_CONFIG_HOME '$XDG_CONFIG_HOME' (status filename)
    )

    set -l hash 6983c90dc311805a744a8bc67da8846c373d1b59
    set -l fqdn raw.githubusercontent.com
    set -l repo folke/tokyonight.nvim
    set -l path "extras/fish/tokyonight_night.fish"
    set -l url "https://$fqdn/$repo/$hash/$path"

    set -l path "$XDG_CONFIG_HOME/fish/conf.d/tokyonight.fish"

    if not test -e "$path"
        printf '%s: Install tokyonight\n' "$file"

        if type -q curl
            curl -o "$path" "$url"
        else
            printf '%s: Not found curl\n' "$file" >&2
        end
    end
end

begin
    set -l file (
      string replace $XDG_CONFIG_HOME '$XDG_CONFIG_HOME' (status filename)
    )

    set -l src /usr/share/nnn/quitcd/quitcd.fish
    set -l dest "$XDG_CONFIG_HOME/fish/functions/n.fish"

    if not test -e "$src"
        printf '%s: Not found %s\n' "$file" "$src" >&2
    else if not test -f "$src"
        printf '%s: Not regular file %s\n' "$file" "$src" >&2
    else if not test -r "$src"
        printf '%s: Not readable %s\n' "$file" "$src" >&2
    else if not test -f "$dest"; and not test -r "$dest"
        printf '%s: Install n.fish\n' "$file"

        string replace 'set -x NNN_TMPFILE' 'set NNN_TMPFILE' <"$src" >"$dest"
    end
end

if status --is-interactive
    __fish_abbr_add_extend - cd -
    __fish_abbr_add_extend . cd '~/.local/share/dotfiles/'

    __fish_abbr_add_extend b bat
    __fish_abbr_add_extend bs bash
    __fish_abbr_add_extend bt btm
    __fish_abbr_add_extend btt bluetuith
    __fish_abbr_add_extend bw sudo bandwhich
    __fish_abbr_add_extend cm chmod
    __fish_abbr_add_extend co chown
    __fish_abbr_add_extend cp cp -iv
    __fish_abbr_add_extend d docker
    __fish_abbr_add_extend dc docker compose
    __fish_abbr_add_extend dn deno
    __fish_abbr_add_extend ds dust -r
    __fish_abbr_add_extend do dog
    __fish_abbr_add_extend e exa -gF --icons --git --time-style long-iso -l
    __fish_abbr_add_extend ea exa -gF --icons --git --time-style long-iso -al
    __fish_abbr_add_extend ev eva
    __fish_abbr_add_extend f fd -L
    __fish_abbr_add_extend g go
    __fish_abbr_add_extend gb gobuster
    __fish_abbr_add_extend gi git
    __fish_abbr_add_extend gp gping
    __fish_abbr_add_extend gr grex
    __fish_abbr_add_extend gt gpg-tui --style colored
    __fish_abbr_add_extend h helm
    __fish_abbr_add_extend hc hashcat
    __fish_abbr_add_extend hd helm-docs
    __fish_abbr_add_extend hf helmfile
    __fish_abbr_add_extend hi hash-identifier
    __fish_abbr_add_extend ifm informant
    __fish_abbr_add_extend info info --vi-keys
    __fish_abbr_add_extend ip ip -c
    __fish_abbr_add_extend j just
    __fish_abbr_add_extend jh john
    __fish_abbr_add_extend jnc journalctl
    __fish_abbr_add_extend k kubie
    __fish_abbr_add_extend kc kubectl
    __fish_abbr_add_extend kl kube-linter
    __fish_abbr_add_extend kv kubeval
    __fish_abbr_add_extend l last
    __fish_abbr_add_extend lg lazygit
    __fish_abbr_add_extend ld lazydocker
    __fish_abbr_add_extend mc msfconsole -q
    __fish_abbr_add_extend mv mv -iv
    __fish_abbr_add_extend N sudo -E nnn
    __fish_abbr_add_extend ne nerdctl
    __fish_abbr_add_extend nkt nikto
    __fish_abbr_add_extend nm nmap -vv
    __fish_abbr_add_extend nmap nmap -vv
    __fish_abbr_add_extend nv nvim
    __fish_abbr_add_extend ns ncspot
    __fish_abbr_add_extend p procs
    __fish_abbr_add_extend pr paru
    __fish_abbr_add_extend prs paru -S
    __fish_abbr_add_extend prsi paru -Si
    __fish_abbr_add_extend prss paru -Ss
    __fish_abbr_add_extend prsc paru -Sc
    __fish_abbr_add_extend prsyu paru -Syu
    __fish_abbr_add_extend prql paru -Ql
    __fish_abbr_add_extend prqo paru -Qo
    __fish_abbr_add_extend prr paru -R
    __fish_abbr_add_extend pd sudo -E pacdiff
    __fish_abbr_add_extend pl plocate
    __fish_abbr_add_extend r rg
    __fish_abbr_add_extend rm rm -iv
    __fish_abbr_add_extend sc systemctl
    __fish_abbr_add_extend se sudoedit
    __fish_abbr_add_extend st stern
    __fish_abbr_add_extend t rlwrap -a trans -b
    __fish_abbr_add_extend td tldr
    __fish_abbr_add_extend tf terraform
    __fish_abbr_add_extend tfa terraform apply
    __fish_abbr_add_extend tfc terraform console
    __fish_abbr_add_extend tfi terraform import
    __fish_abbr_add_extend tfp terraform plan
    __fish_abbr_add_extend tfst terraform state
    __fish_abbr_add_extend tfsh terraform show
    __fish_abbr_add_extend tfo terraform output
    __fish_abbr_add_extend tfl tflint
    __fish_abbr_add_extend tfd terraform-docs
    __fish_abbr_add_extend tg terragrunt
    __fish_abbr_add_extend tga terragrunt apply
    __fish_abbr_add_extend tgc terragrunt console
    __fish_abbr_add_extend tgi terragrunt import
    __fish_abbr_add_extend tgp terragrunt plan
    __fish_abbr_add_extend tgst terragrunt state
    __fish_abbr_add_extend tgsh terragrunt show
    __fish_abbr_add_extend tgo terragrunt output
    __fish_abbr_add_extend ti tokei --hidden
    __fish_abbr_add_extend tm tmux
    __fish_abbr_add_extend tmp tmuxp
    __fish_abbr_add_extend u unbuffer
    __fish_abbr_add_extend wh which
    __fish_abbr_add_extend wlp wl-paste
    __fish_abbr_add_extend wlc wl-copy
    __fish_abbr_add_extend ws wiki-search
    __fish_abbr_add_extend x xh
    __fish_abbr_add_extend xs xsv
end
