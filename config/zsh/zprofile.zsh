# zprofile.zsh - zprofile runs once per login shell, before zshrc

# Add homebrew to path
if [[ -x /opt/homebrew/bin/brew ]]; then # apple silicon
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then # intel
  eval "$(/usr/local/bin/brew shellenv)"
fi