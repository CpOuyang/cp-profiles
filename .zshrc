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
}
must_have git tree starship

alias ll="ls -Gl"
alias la="ls -GAl"

alias tc="tree -C"
alias gl="git log --graph --pretty=oneline --abbrev-commit"
alias gl="git log --pretty=format:'%h %ad | %s %d [%an]' --date=short"
# Refer to https://www.edureka.co/blog/git-format-commit-history/
alias gl="git log --pretty=format:'%C(yellow)%h%Creset %ad | %Cgreen%s%Creset %Cred%d%Creset %Cblue[%an]' --date=short"

eval "$(/opt/homebrew/bin/starship init zsh)"

export GITHUB_ACCESS_TOKEN=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

# Custom
export BAT_THEME=ansi
