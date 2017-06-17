export LANG=ja_JP.UTF-8

autoload -Uz colors
colors

bindkey -e

HISTFILE=~/.sh_history
HISTSIZE=1000000
SAVEHIST=1000000

PROMPT="%{${fg[green]}%}[%n@%m]%{${reset_color}%} %~
%# "

autoload -Uz select-word-style
select-word-style default

zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified 

autoload -Uz compinit
compinit

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

zstyle ':completion:*' ignore-parents parent pwd ..

zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                       /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

autoload -Uz vcs_info
autoload -Uz add-zsh-hook

zstyle ':vcs_info:*' formats '%F{green}(%s)-[%b]%f'
zstyle ':vcs_info:*' actionformats '%F{red}(%s)-[%b|%a]%f'

function _update_vcs_info_msg() {
    LANG=en_US.UTF-8 vcs_info
    RPROMPT="${vcs_info_msg_0_}"
}
add-zsh-hook precmd _update_vcs_info_msg

setopt print_eight_bit

setopt no_beep

setopt interactive_comments

setopt auto_cd

setopt auto_pushd

setopt pushd_ignore_dups

setopt share_history

setopt hist_ignore_all_dups

setopt hist_ignore_space

setopt hist_reduce_blanks

setopt extended_glob

bindkey '^R' history-incremental-pattern-search-backward


alias la='ls -a'
alias ll='ls -la'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias sudo='sudo '

# alias -g L='| less'
# alias -g G='| grep'

#f which pbcopy >/dev/null 2>&1 ; then
#    # Mac
#    alias -g C='| pbcopy'
#elif which xsel >/dev/null 2>&1 ; then
#    # Linux
#    alias -g C='| xsel --input --clipboard'
#elif which putclip >/dev/null 2>&1 ; then
#    # Cygwin
#    alias -g C='| putclip'
#fi

case ${OSTYPE} in
    darwin*)
        #Mac用の設定
        export CLICOLOR=1
        alias ls='ls -G -F'
        ;;
    linux*)
        #Linux用の設定
        alias ls='ls -F --color=auto'
        ;;
esac

# peco
alias -g B='`git branch -a |peco --prompt "GIT BRANCH>" | head -n 1 | sed -e "s/^\*\s*//g" |sed -e "s/remotes\/origin\///g"`' 

# history search
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
