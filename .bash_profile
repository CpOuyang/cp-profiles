# Homebrew related paths
eval "$(/opt/homebrew/bin/brew shellenv)"

# check formulas
must_have () {
    for item in $*
    do
        which -s $item
        if [[ $? != 0 ]]; then
            brew install $item
        fi
    done
    unset item
}
must_have git tree starship

alias ba="brew autoremove"
alias bc="brew cleanup"
alias bd="brew doctor"
alias bl="brew list -l"
alias bu="brew update && brew upgrade && brew upgrade --cask \$(brew list --cask)"
alias gl="git log --graph --pretty=oneline --abbrev-commit"
alias gl="git log --pretty=format:'%h %ad | %s %d [%an]' --date=short"
# Refer to https://www.edureka.co/blog/git-format-commit-history/
alias gl="git log --pretty=format:'%C(yellow)%h%Creset %ad | %Cgreen%s%Creset %Cred%d%Creset %Cblue[%an]' --date=short"
alias ll="ls -Gl"
alias la="ls -GAl"
alias tc="tree -C"

# # Notable legacy
# git_branch () {
# 	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
# }
# export CLICOLOR=1
# export LSCOLORS=gxfxcxdxbxegedabagacad
# export PS1="\[\e[1;35m\][\t]\[\e[1;32m\]\u\[\e[0;1m\]@\[\e[33m\]\h\[\e[0;1m\]:\[\e[0m\] \[\e[1;36m\]\w\[\e[34m\]$(git_branch)\[\e[0m\] \$ "

# DO NOT USE: eval "$(/opt/homebrew/bin/starship init bash)"
# For the scripts are errored in bash
eval "$(/opt/homebrew/bin/starship init bash --print-full-init)"

# Custom
export BASH_SILENCE_DEPRECATION_WARNING=1   # suppress macos warning
export BAT_THEME=ansi
export GITHUB_ACCESS_TOKEN=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
