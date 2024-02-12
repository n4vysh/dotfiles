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
    __fish_abbr_add_extend cp cp -irv
    __fish_abbr_add_extend d grc docker
    __fish_abbr_add_extend docker grc docker
    __fish_abbr_add_extend db devbox
    __fish_abbr_add_extend dc docker compose
    __fish_abbr_add_extend dcb docker compose build
    __fish_abbr_add_extend dcd docker compose down
    __fish_abbr_add_extend dcl docker compose logs
    __fish_abbr_add_extend dclf docker compose logs -f
    __fish_abbr_add_extend dcr docker compose restart
    __fish_abbr_add_extend dcu docker compose up
    __fish_abbr_add_extend dcw docker compose watch
    __fish_abbr_add_extend de direnv
    __fish_abbr_add_extend dea direnv allow
    __fish_abbr_add_extend dee direnv edit
    __fish_abbr_add_extend df grc df
    __fish_abbr_add_extend dig grc dig
    __fish_abbr_add_extend ds dust -r
    __fish_abbr_add_extend do dog
    __fish_abbr_add_extend du grc du
    __fish_abbr_add_extend e eza -gF --icons --git --time-style long-iso -s Name -l
    __fish_abbr_add_extend ea eza -gF --icons --git --time-style long-iso -s Name -al
    __fish_abbr_add_extend env grc env
    __fish_abbr_add_extend ev eva
    __fish_abbr_add_extend f fd -L
    __fish_abbr_add_extend free grc free
    __fish_abbr_add_extend gb gobuster
    __fish_abbr_add_extend ghd gh dash
    __fish_abbr_add_extend gi git
    __fish_abbr_add_extend gib gibo
    __fish_abbr_add_extend goi go install
    __fish_abbr_add_extend gomd go mod download
    __fish_abbr_add_extend gomi go mod init
    __fish_abbr_add_extend gor go run
    __fish_abbr_add_extend got go test
    __fish_abbr_add_extend gp gping
    __fish_abbr_add_extend gr grex
    __fish_abbr_add_extend gt gpg-tui --style colored
    __fish_abbr_add_extend hc hashcat
    __fish_abbr_add_extend hd helm-docs
    __fish_abbr_add_extend hl helm
    __fish_abbr_add_extend hlh helm history
    __fish_abbr_add_extend hll helm list
    __fish_abbr_add_extend hls helm status
    __fish_abbr_add_extend hlr helm rollback
    __fish_abbr_add_extend hlf helmfile
    __fish_abbr_add_extend hlfa helmfile apply
    __fish_abbr_add_extend hlfd helmfile diff
    __fish_abbr_add_extend hlfl helmfile lint
    __fish_abbr_add_extend hlfs helmfile status
    __fish_abbr_add_extend hlft helmfile test
    __fish_abbr_add_extend hi hash-identifier
    __fish_abbr_add_extend id grc id
    __fish_abbr_add_extend ifm informant
    __fish_abbr_add_extend info info --vi-keys
    __fish_abbr_add_extend ip ip -c
    __fish_abbr_add_extend js just
    __fish_abbr_add_extend jsde just dev
    __fish_abbr_add_extend jsdo just docs
    __fish_abbr_add_extend jsf just fmt
    __fish_abbr_add_extend jsgc just get-creds
    __fish_abbr_add_extend jsl just lint
    __fish_abbr_add_extend jss just switch
    __fish_abbr_add_extend jssd just switch dev
    __fish_abbr_add_extend jsss just switch stg
    __fish_abbr_add_extend jssp just switch prd
    __fish_abbr_add_extend jst just test
    __fish_abbr_add_extend jh john
    __fish_abbr_add_extend jnc journalctl
    __fish_abbr_add_extend k kubie
    __fish_abbr_add_extend kc kubectl
    __fish_abbr_add_extend kcar kubectl api-resources
    __fish_abbr_add_extend kcg kubectl get
    __fish_abbr_add_extend kcgcj kubectl get cronjobs
    __fish_abbr_add_extend kcgcm kubectl get configmaps
    __fish_abbr_add_extend kcgd kubectl get deployments
    __fish_abbr_add_extend kcge kubectl get events --sort-by=.metadata.creationTimestamp
    __fish_abbr_add_extend kcgj kubectl get jobs
    __fish_abbr_add_extend kcgn kubectl get nodes
    __fish_abbr_add_extend kcgns kubectl get namespaces
    __fish_abbr_add_extend kcgp kubectl get pods
    __fish_abbr_add_extend kcgs kubectl get secrets
    __fish_abbr_add_extend kcgsts kubectl get statefulsets
    __fish_abbr_add_extend kcgsa kubectl get serviceaccounts
    __fish_abbr_add_extend kcgsvc kubectl get services
    __fish_abbr_add_extend kcl kubectl logs
    __fish_abbr_add_extend kl kube-linter
    __fish_abbr_add_extend kn kubens
    __fish_abbr_add_extend kv kubeval
    __fish_abbr_add_extend l grc last
    __fish_abbr_add_extend last grc last
    __fish_abbr_add_extend lg lazygit
    __fish_abbr_add_extend ld lazydocker
    __fish_abbr_add_extend lsblk grc lsblk
    __fish_abbr_add_extend lsof grc lsof
    __fish_abbr_add_extend mc msfconsole -q
    __fish_abbr_add_extend md mkdir -p
    __fish_abbr_add_extend mv mv -iv
    __fish_abbr_add_extend N sudo -E nnn
    __fish_abbr_add_extend nkt nikto
    __fish_abbr_add_extend nm grc nmap -vv
    __fish_abbr_add_extend nmap grc nmap -vv
    __fish_abbr_add_extend nv nvim
    __fish_abbr_add_extend ns ncspot
    __fish_abbr_add_extend p procs
    __fish_abbr_add_extend pe pet
    __fish_abbr_add_extend pee pet edit
    __fish_abbr_add_extend pen pet new
    __fish_abbr_add_extend ping grc ping
    __fish_abbr_add_extend pr paru
    __fish_abbr_add_extend prs paru -S
    __fish_abbr_add_extend prsi paru -Si
    __fish_abbr_add_extend prss paru -Ss
    __fish_abbr_add_extend prsc paru -Sc
    __fish_abbr_add_extend prscc paru -Scc
    __fish_abbr_add_extend prsyu paru -Syu
    __fish_abbr_add_extend prql paru -Ql
    __fish_abbr_add_extend prqo paru -Qo
    __fish_abbr_add_extend prr paru -R
    __fish_abbr_add_extend prrs paru -Rs
    __fish_abbr_add_extend ps grc ps
    __fish_abbr_add_extend pd sudo -E pacdiff
    __fish_abbr_add_extend pl plocate
    __fish_abbr_add_extend pp pnpm
    __fish_abbr_add_extend ppa pnpm add
    __fish_abbr_add_extend ppd pnpm dlx
    __fish_abbr_add_extend ppi pnpm install
    __fish_abbr_add_extend ppif pnpm install --frozen-lockfile
    __fish_abbr_add_extend pps pnpm start
    __fish_abbr_add_extend ppt pnpm test
    __fish_abbr_add_extend pprb pnpm run build
    __fish_abbr_add_extend pprd pnpm run dev
    __fish_abbr_add_extend pprl pnpm run lint
    __fish_abbr_add_extend r rg
    __fish_abbr_add_extend rm rm -iv
    __fish_abbr_add_extend rs rustscan
    __fish_abbr_add_extend rt rtx
    __fish_abbr_add_extend rtg rtx global
    __fish_abbr_add_extend rti rtx install
    __fish_abbr_add_extend rtl rtx local
    __fish_abbr_add_extend rtlr rtx ls-remote
    __fish_abbr_add_extend rtplr rtx plugins ls-remote
    __fish_abbr_add_extend sc systemctl
    __fish_abbr_add_extend se sudoedit
    __fish_abbr_add_extend so sops
    __fish_abbr_add_extend st stern
    __fish_abbr_add_extend t rlwrap -a trans -b
    __fish_abbr_add_extend ta trash
    __fish_abbr_add_extend td tldr
    __fish_abbr_add_extend tf terraform
    __fish_abbr_add_extend tfa terraform apply
    __fish_abbr_add_extend tfar terraform apply -replace
    __fish_abbr_add_extend tfat terraform apply -target
    __fish_abbr_add_extend tfc terraform console
    __fish_abbr_add_extend tfin terraform init
    __fish_abbr_add_extend tfim terraform import
    __fish_abbr_add_extend tfp terraform plan
    __fish_abbr_add_extend tfpr terraform plan -replace
    __fish_abbr_add_extend tfpt terraform plan -target
    __fish_abbr_add_extend tfst terraform state
    __fish_abbr_add_extend tfstp terraform state pull
    __fish_abbr_add_extend tfsh terraform show
    __fish_abbr_add_extend tfo terraform output
    __fish_abbr_add_extend tfoj terraform output -json
    __fish_abbr_add_extend tfl tflint
    __fish_abbr_add_extend tfd terraform-docs
    __fish_abbr_add_extend tg terragrunt
    __fish_abbr_add_extend tga terragrunt apply
    __fish_abbr_add_extend tgar terragrunt apply -replace
    __fish_abbr_add_extend tgat terragrunt apply -target
    __fish_abbr_add_extend tgc terragrunt console
    __fish_abbr_add_extend tgim terragrunt import
    __fish_abbr_add_extend tgp terragrunt plan
    __fish_abbr_add_extend tgpr terragrunt plan -replace
    __fish_abbr_add_extend tgpt terragrunt plan -target
    __fish_abbr_add_extend tgr terragrunt run-all
    __fish_abbr_add_extend tgra terragrunt run-all apply
    __fish_abbr_add_extend tgrar terragrunt run-all apply -replace
    __fish_abbr_add_extend tgrat terragrunt run-all apply -target
    __fish_abbr_add_extend tgri terragrunt run-all init
    __fish_abbr_add_extend tgrp terragrunt run-all plan
    __fish_abbr_add_extend tgrpr terragrunt run-all plan -replace
    __fish_abbr_add_extend tgrpt terragrunt run-all plan -target
    __fish_abbr_add_extend tgst terragrunt state
    __fish_abbr_add_extend tgstp terragrunt state pull
    __fish_abbr_add_extend tgsh terragrunt show
    __fish_abbr_add_extend tgo terragrunt output
    __fish_abbr_add_extend tgoj terragrunt output -json
    __fish_abbr_add_extend ti tokei --hidden
    __fish_abbr_add_extend tm tmux
    __fish_abbr_add_extend tmp tmuxp
    __fish_abbr_add_extend u unbuffer
    __fish_abbr_add_extend wh which
    __fish_abbr_add_extend wlp wl-paste
    __fish_abbr_add_extend wlc wl-copy
    __fish_abbr_add_extend ws wiki-search
    __fish_abbr_add_extend x xh -F
    __fish_abbr_add_extend xs xsv
end
