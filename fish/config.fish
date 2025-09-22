# cp-profiles Fish configuration (macOS)
# Mirrors the Bash profile behaviour with Fish-friendly syntax.

if not status is-interactive
    return
end

umask 022

function _cp_path_prepend --argument dir
    if test -d "$dir"
        fish_add_path --path "$dir"
    end
end

function _cp_path_append --argument dir
    if test -d "$dir"
        set --local existing $PATH
        if not contains -- "$dir" $existing
            set -gx PATH $PATH "$dir"
        end
    end
end

_cp_path_prepend "$HOME/.local/bin"
_cp_path_prepend "/usr/local/sbin"

if test -x /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
end

if type -q starship
    set -gx STARSHIP_CONFIG "$HOME/.config/starship.toml"
    starship init fish | source
end

set -q EDITOR; or set -gx EDITOR nvim
set -gx VISUAL $EDITOR
set -q PAGER; or set -gx PAGER "less -FR"
set -q BAT_THEME; or set -gx BAT_THEME ansi
set -gx GPG_TTY (tty)

_cp_path_append "/Applications/Docker.app/Contents/Resources/bin"

if test -f /opt/homebrew/Caskroom/miniconda/base/etc/fish/conf.d/conda.fish
    source /opt/homebrew/Caskroom/miniconda/base/etc/fish/conf.d/conda.fish
end

alias ll='ls -alhG'
alias la='ls -A'
alias lt='ls -ltG'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'

alias ba='brew autoremove'
alias bc='brew cleanup'
alias bd='brew doctor'
alias bl='brew list -l'
alias bu='brew update && brew upgrade && brew upgrade --cask (brew list --cask)'

alias dc='docker compose'

alias gco='git checkout'
alias gst='git status -sb'
alias gl="git log --pretty=format:'%C(yellow)%h%Creset %ad | %Cgreen%s%Creset %Cred%d%Creset %Cblue[%an]' --date=short"
alias gp='git push'

if test -f $HOME/.config/fish/local.fish
    source $HOME/.config/fish/local.fish
end

functions -e _cp_path_prepend _cp_path_append
