# NOTE: ~/.zshrc.d is compiled with ~/.zfunctions/source
setopt extendedglob
for file in ~/.zshenv ~/.zshrc ~/.zfunctions/*~*.zwc; do
	if [[ $file -nt $file.zwc ]] || [[ ! -e $file.zwc ]]; then
		zcompile "$file"
	fi
done
