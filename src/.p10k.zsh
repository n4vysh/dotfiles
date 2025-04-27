# NOTE: temporarily change options until loading p10k
'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
	emulate -L zsh -o extended_glob

	# NOTE: use `source ~/.p10k.zsh` without restarting zsh
	unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

	# NOTE: zsh >= 5.1
	[[ $ZSH_VERSION == (5.<1->*|<6->.*) ]] || return

	typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
		dir         # current directory
		vcs         # git status
		newline     # \n
		prompt_char # prompt symbol
	)

	typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
		status                 # exit code of the last command
		command_execution_time # duration of the last command
		kubecontext            # current kubernetes context
		aws                    # aws profile
		newline                # \n
	)

	typeset -g POWERLEVEL9K_MODE=nerdfont-v3
	typeset -g POWERLEVEL9K_ICON_PADDING=none

	# NOTE: enable OSC 133
	typeset -g POWERLEVEL9K_TERM_SHELL_INTEGRATION=true

	# Basic style options
	# - transparent background
	# - no surrounding whitespace
	# - separate segments with a space
	# - no end-of-line symbol
	typeset -g POWERLEVEL9K_BACKGROUND=
	typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=
	typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '
	typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=

	typeset -g POWERLEVEL9K_ICON_BEFORE_CONTENT=true

	# NOTE: add an empty line before each prompt
	typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

	# Prompt frame
	# NOTE: disable prompt lines with empty string
	typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=
	typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX=
	typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=
	typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_SUFFIX=
	typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_SUFFIX=
	typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_SUFFIX=

	typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=
	typeset -g POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL=

	# Ruler
	# NOTE: disable the horizontal line before each prompt
	typeset -g POWERLEVEL9K_SHOW_RULER=false

	# Prompt connection
	# NOTE: disable filler between left and right prompt
	typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR=' '

	# prompt_char: prompt symbol
	typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND='#4289ff'
	typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND='#f7768e'
	# NOTE: use unicode characters instead of Nerd Font icons as prompt symbols
	#       unicode is widely supported without additional font installations
	typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='▶▶▶'
	typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='◀◀◀'
	typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='▼▼▼'
	typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='▲▲▲'
	typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=true
	# NOTE: no line terminator if prompt_char is the last segment
	typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
	# NOTE: no line introducer if prompt_char is the first segment
	typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=

	# dir: current directory
	typeset -g POWERLEVEL9K_DIR_FOREGROUND='#767676'
	typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND='#767676'
	typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND='#00afff'
	typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
	local anchor_files=(
		.bzr
		.citc
		.git
		.hg
		.node-version
		.python-version
		.go-version
		.ruby-version
		.lua-version
		.java-version
		.perl-version
		.php-version
		.tool-versions
		.mise.toml
		.shorten_folder_marker
		.svn
		.terraform
		CVS
		Cargo.toml
		composer.json
		go.mod
		package.json
		stack.yaml
	)
	typeset -g POWERLEVEL9K_SHORTEN_FOLDER_MARKER="(${(j:|:)anchor_files})"
	typeset -g POWERLEVEL9K_DIR_TRUNCATE_BEFORE_MARKER=false
	typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=0
	typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS=40
	typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS_PCT=50
	typeset -g POWERLEVEL9K_DIR_HYPERLINK=false
	typeset -g POWERLEVEL9K_DIR_SHOW_WRITABLE=v3
	# NOTE: disable default icons with dir classes
	typeset -g POWERLEVEL9K_DIR_CLASSES=()

	## fish-like shorten directory name
	# https://fishshell.com/docs/current/cmds/prompt_pwd.html
	# https://unix.stackexchange.com/a/715983
	typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_from_right
	typeset -g POWERLEVEL9K_SHORTEN_DELIMITER=
	typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=1

	# vcs: git status
	typeset -g POWERLEVEL9K_VCS_BRANCH_ICON='\UE0A0 '

	typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='?'

	# Formatter for Git status
	function my_git_formatter() {
		emulate -L zsh

		if [[ -n $P9K_CONTENT ]]; then
			typeset -g my_git_format=$P9K_CONTENT
			return
		fi

		if (( $1 )); then
			# up-to-date Git status
			local       meta='%f'          # default foreground
			local      clean='%F{#00afff}' # blue foreground
			local   modified='%F{#ff9e64}' # orange foreground
			local  untracked='%F{#7dcfff}' # cyan foreground
			local conflicted='%F{#f7768e}' # red foreground
		else
			# incomplete and stale Git status
			local       meta='%F{#767676}' # grey foreground
			local      clean='%F{#767676}' # grey foreground
			local   modified='%F{#767676}' # grey foreground
			local  untracked='%F{#767676}' # grey foreground
			local conflicted='%F{#767676}' # grey foreground
		fi

		local res

		if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
			local branch=${(V)VCS_STATUS_LOCAL_BRANCH}
			# shorten branch name
			(( $#branch > 32 )) && branch[13,-13]="…"
			res+="${clean}${(g::)POWERLEVEL9K_VCS_BRANCH_ICON}${branch//\%/%%}"
		fi

		if [[ -n $VCS_STATUS_TAG
					# NOTE: show tag only if not on a branch
					&& -z $VCS_STATUS_LOCAL_BRANCH
				]]; then
			local tag=${(V)VCS_STATUS_TAG}
			# shorten tag name
			(( $#tag > 32 )) && tag[13,-13]="…"
			res+="${meta}#${clean}${tag//\%/%%}"
		fi

		# NOTE: display the current Git commit if there is no branch and no tag
		[[ -z $VCS_STATUS_LOCAL_BRANCH && -z $VCS_STATUS_TAG ]] &&
			res+="${meta}@${clean}${VCS_STATUS_COMMIT[1,8]}"

		# NOTE: show tracking branch name if it differs from local branch
		if [[ -n ${VCS_STATUS_REMOTE_BRANCH:#$VCS_STATUS_LOCAL_BRANCH} ]]; then
			res+="${meta}:${clean}${(V)VCS_STATUS_REMOTE_BRANCH//\%/%%}"
		fi

		# NOTE: display "wip" if the latest commit's summary contains "wip" or "WIP"
		if [[ $VCS_STATUS_COMMIT_SUMMARY == (|*[^[:alnum:]])(wip|WIP)(|[^[:alnum:]]*) ]]; then
			res+=" ${modified}wip"
		fi

		if (( VCS_STATUS_COMMITS_AHEAD || VCS_STATUS_COMMITS_BEHIND )); then
			# behind the remote
			(( VCS_STATUS_COMMITS_BEHIND )) && res+=" ${clean}⇣${VCS_STATUS_COMMITS_BEHIND}"
			# ahead of the remote
			(( VCS_STATUS_COMMITS_AHEAD && !VCS_STATUS_COMMITS_BEHIND )) && res+=" "
			(( VCS_STATUS_COMMITS_AHEAD  )) && res+="${clean}⇡${VCS_STATUS_COMMITS_AHEAD}"
		fi

		# behind the push remote
		(( VCS_STATUS_PUSH_COMMITS_BEHIND )) && res+=" ${clean}⇠${VCS_STATUS_PUSH_COMMITS_BEHIND}"
		(( VCS_STATUS_PUSH_COMMITS_AHEAD && !VCS_STATUS_PUSH_COMMITS_BEHIND )) && res+=" "
		# ahead of the push remote
		(( VCS_STATUS_PUSH_COMMITS_AHEAD  )) && res+="${clean}⇢${VCS_STATUS_PUSH_COMMITS_AHEAD}"
		# stashes
		(( VCS_STATUS_STASHES        )) && res+=" ${clean}⚑"
		# an unusual state
		[[ -n $VCS_STATUS_ACTION     ]] && res+=" ${conflicted}${VCS_STATUS_ACTION}"
		# merge conflicts
		(( VCS_STATUS_NUM_CONFLICTED )) && res+=" ${conflicted}~"
		# staged changes
		(( VCS_STATUS_NUM_STAGED     )) && res+=" ${modified}+"
		# unstaged changes
		(( VCS_STATUS_NUM_UNSTAGED   )) && res+=" ${modified}!"
		# untracked files
		(( VCS_STATUS_NUM_UNTRACKED  )) && res+=" ${untracked}${(g::)POWERLEVEL9K_VCS_UNTRACKED_ICON}"
		# the number of unstaged files is unknown
		(( VCS_STATUS_HAS_UNSTAGED == -1 )) && res+=" ${modified}─"

		typeset -g my_git_format=$res
	}
	functions -M my_git_formatter 2>/dev/null

	typeset -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=-1

	# ignore path pattern
	typeset -g POWERLEVEL9K_VCS_DISABLED_WORKDIR_PATTERN='~'

	typeset -g POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING=true
	typeset -g POWERLEVEL9K_VCS_CONTENT_EXPANSION='${$((my_git_formatter(1)))+${my_git_format}}'
	typeset -g POWERLEVEL9K_VCS_LOADING_CONTENT_EXPANSION='${$((my_git_formatter(0)))+${my_git_format}}'
	typeset -g POWERLEVEL9K_VCS_{STAGED,UNSTAGED,UNTRACKED,CONFLICTED,COMMITS_AHEAD,COMMITS_BEHIND}_MAX_NUM=-1

	typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_COLOR='#00afff'
	typeset -g POWERLEVEL9K_VCS_LOADING_VISUAL_IDENTIFIER_COLOR='#767676'
	# NOTE: disable visual identifier icon
	typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION=''

	typeset -g POWERLEVEL9K_VCS_BACKENDS=(git)

	# fall back colors
	typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#00afff'
	typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#00afff'
	typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#ff9e64'

	# status: exit code of the last command
	typeset -g POWERLEVEL9K_STATUS_EXTENDED_STATES=true
	typeset -g POWERLEVEL9K_STATUS_OK=false
	typeset -g POWERLEVEL9K_STATUS_OK_PIPE=true
	typeset -g POWERLEVEL9K_STATUS_OK_PIPE_FOREGROUND='#5FAF00'
	typeset -g POWERLEVEL9K_STATUS_OK_PIPE_VISUAL_IDENTIFIER_EXPANSION='✔'
	typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL=true
	typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_FOREGROUND='#f7768e'
	typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_VISUAL_IDENTIFIER_EXPANSION='✘'
	typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE=true
	typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_FOREGROUND='#f7768e'
	typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_VISUAL_IDENTIFIER_EXPANSION='✘'

	# command_execution_time: duration of the last command
	typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=1
	typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
	typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#00afff'
	typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'
	# NOTE: disable icon
	typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_VISUAL_IDENTIFIER_EXPANSION=''

	# kubecontext: current kubernetes context
	typeset -g POWERLEVEL9K_KUBECONTEXT_CLASSES=(
			'*prod*'  PROD
			'*prd*'   PROD
			'*stg*'   STG
			'*'       DEFAULT)
	typeset -g POWERLEVEL9K_KUBECONTEXT_PROD_FOREGROUND='#f7768e'
	typeset -g POWERLEVEL9K_KUBECONTEXT_STG_FOREGROUND='#ff9e64'
	typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_FOREGROUND='#00afff'

	typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_CONTENT_EXPANSION=
	POWERLEVEL9K_KUBECONTEXT_DEFAULT_CONTENT_EXPANSION+='${P9K_KUBECONTEXT_NAME}'
	# NOTE: append the current context's namespace if it's not "default".
	POWERLEVEL9K_KUBECONTEXT_DEFAULT_CONTENT_EXPANSION+='${${:-/$P9K_KUBECONTEXT_NAMESPACE}:#/default}'

	# aws: aws profile
	typeset -g POWERLEVEL9K_AWS_CLASSES=(
			'*prod*'  PROD
			'*prd*'   PROD
			'*stg*'   STG
			'*'       DEFAULT)
	typeset -g POWERLEVEL9K_AWS_PROD_FOREGROUND='#f7768e'
	typeset -g POWERLEVEL9K_AWS_STG_FOREGROUND='#ff9e64'
	typeset -g POWERLEVEL9K_AWS_DEFAULT_FOREGROUND='#00afff'
	typeset -g POWERLEVEL9K_AWS_CONTENT_EXPANSION='${P9K_AWS_PROFILE//\%/%%}'

	# misc
	typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=off
	typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose

	# NOTE: hot reload is slow down prompt by 1-2 milliseconds
	typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true

	# NOTE: if p10k is already loaded, reload configuration
	(( ! $+functions[p10k] )) || p10k reload
}

# NOTE: tell `p10k configure` which file it should overwrite
typeset -g POWERLEVEL9K_CONFIG_FILE=${${(%):-%x}:a}

(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
