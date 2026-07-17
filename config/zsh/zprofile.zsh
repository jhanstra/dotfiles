# zprofile.zsh - zprofile runs once per login shell, before zshrc

# Add homebrew to path
if [[ -x /opt/homebrew/bin/brew ]]; then # apple silicon
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then # intel
  export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
  eval "$(/usr/local/bin/brew shellenv)"
fi