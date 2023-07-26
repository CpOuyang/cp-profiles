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

eval "$(/opt/homebrew/bin/starship init zsh)"
# zsh-autocomplete (has bug along with ripgrep)
# if [ ! -d "$HOME/Projects/worship/zsh-autocomplete" ]; then
#     echo Lack of repo ...
#     mkdir -p $HOME/Projects/worship/ && cd $HOME/Projects/worship/
#     git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git
#     echo
#     echo Restart session to apply ...
# fi
# source $HOME/Projects/worship/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# Custom
export BAT_THEME=ansi
export GITHUB_ACCESS_TOKEN=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
