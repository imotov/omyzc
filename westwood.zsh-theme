source "$ZSH/themes/eastwood.zsh-theme"

if [[ $OS == "Linux" ]]; then
    PROMPT='%{$fg[cyan]%}%n@%m%{$reset_color%}:'"$PROMPT"
fi