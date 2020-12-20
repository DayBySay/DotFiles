alias ll="ls -la"
alias diff="diff -u"
alias vi=vim
alias ta="tmux attach"
alias gopath="cd $GOPATH"
alias ghcd="cd \$(ghq root)/\$(ghq list | peco)"
alias -g B='`git branch -a |peco --prompt "GIT BRANCH>" | head -n 1 | sed -e "s/^\*\s*//g" |sed -e "s/remotes\/origin\///g"`' 
export GREP_OPTIONS='--color=auto'

# User specific aliases and functions
stty -ixon -ixoff

# Path to your oh-my-zsh installation.
export ZSH=/Users/takayuki.sei/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

export PATH=${HOME}/.rbenv/bin:${PATH} && \

plugins=(git)

source $ZSH/oh-my-zsh.sh

[[ -d ~/.rbenv  ]] && \
    export PATH=${HOME}/.rbenv/bin:${PATH} && \
    eval "$(rbenv init -)"

function peco-select-history() {
    typeset tac
    if which tac > /dev/null; then
        tac=tac
    else
        tac='tail -r'
    fi
    BUFFER=$(fc -l -n 1 | eval $tac | peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle redisplay
}
zle -N peco-select-history
bindkey '^r' peco-select-history

function peco-src () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-src
bindkey '^g' peco-src

export GOPATH=$HOME/go
export PATH="$GOPATH/bin:$PATH"
export PATH="$GOENV_ROOT/bin:$PATH"

shellname=$(basename $SHELL)

export PATH="$HOME/google-cloud-sdk/platform/google_appengine:$PATH"
export PATH=$HOME/.nodebrew/current/bin:$PATH
export PATH=$HOME/Library/Android/sdk/platform-tools:$PATH

[ -f $HOME/.zshrc.local ] && . $HOME/.zshrc.local

