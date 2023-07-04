# Homebrew related paths
eval "$(/opt/homebrew/bin/brew shellenv)"

# check formulas
check_formula () {
   for item in $*
   do
      which -s $item
      if [[ $? != 0 ]]; then
         brew install $item
      fi
   done
}
check_formula git tree starship

alias ls="ls -G"
alias ll="ls -l"
alias la="ll -A"

alias tree="tree -C"
alias gl="git log --graph --pretty=oneline --abbrev-commit"
alias gl="git log --pretty=format:'%h %ad | %s %d [%an]' --date=short"
# Refer to https://www.edureka.co/blog/git-format-commit-history/
alias gl="git log --pretty=format:'%C(yellow)%h%Creset %ad | %Cgreen%s%Creset %Cred%d%Creset %Cblue[%an]' --date=short"

eval "$(/opt/homebrew/bin/starship init zsh)"
