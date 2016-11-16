# Load ~/.extra, ~/.bash_prompt, ~/.exports, ~/.aliases and ~/.functions
# ~/.extra can be used for settings you don’t want to commit
for file in ~/.{extra,bash_prompt,exports,aliases,functions}; do
	[ -r "$file" ] && source "$file"
done
unset file

export PATH=$PATH:bin
export PATH=$PATH:usr/local/bin

# configure what is shown on each line
export PS1="\W \$ "
