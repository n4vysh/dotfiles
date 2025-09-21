# NOTE: ~/.zshrc.d/conf.d/*.zsh is compiled with ~/.zshrc.d/functions/source
setopt extendedglob
for file in ~/.zshenv ~/.zshrc ~/.zshrc.d/functions/*~*.zwc; do
	if [[ $file -nt $file.zwc ]] || [[ ! -e $file.zwc ]]; then
		zcompile "$file"
	fi
done
