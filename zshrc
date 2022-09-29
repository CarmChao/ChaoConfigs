# Created by newuser for 5.8

source /home/chao/.config/.antigen.zsh

antigen use oh-my-zsh

# 加载原版oh-my-zsh中的功能(robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle heroku
antigen bundle pip
antigen bundle lein
antigen bundle command-not-found
#same use ase fzf
antigen bundle z
antigen bundle paulirish/git-open 

# 语法高亮功能
antigen bundle zsh-users/zsh-syntax-highlighting

# 代码提示功能
antigen bundle zsh-users/zsh-autosuggestions

# 自动补全功能
antigen bundle zsh-users/zsh-completions

#antigen bundle unixorn/fzf-zsh-plugin@main

# 加载主题
antigen theme robbyrussell

# 保存更改
antigen apply

setopt no_nomatch

source /opt/ros/noetic/setup.zsh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/chao/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/chao/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/chao/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/chao/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export GOPATH=$HOME/3rd_libs/work
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

. /usr/share/autojump/autojump.sh

alias s="start_app"
