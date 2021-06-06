# -*- mode: sh; -*-
zmodload zsh/zprof

if [[ "$TERM" == "dumb" ]]; then
   unset zle_bracketed_paste
else
    #load agnoster prompt
    fpath=("$HOME/.zprompts" "$fpath[@]")
    autoload -Uz promptinit
    promptinit
    prompt agnoster
    autoload -Uz add-zsh-hook
fi

if [[ "$TERM" == "st-256color" ]]; then
    function precmd () {
        print -Pn -- '\e]2;%n:%~\a'
    }

    function preexec () {
        print -Pn -- '\e]2;%n:%~' && print -n -- "${(q)1}\a"
    }

    add-zsh-hook -Uz precmd precmd
    add-zsh-hook -Uz preexec preexec
fi

#source keybinds
. ~/.zkeybinds

#export EDITOR=nvim
export EDITOR="emacsclient -c --frame-parameters='(quote (title . \"speedmacs\"))'"
export XDG_CONFIG_HOME=~/.config

#Load aliases
. ~/dotfiles/aliases
#Reload this file
alias r=". ~/.zshrc"

#Add qmk tools to path
export PATH="$PATH:$HOME/qmk_firmware/bin"
export PATH="$PATH:$HOME/.dmacs.d/bin"
export PATH="$PATH:$HOME/.local/bin"
#Add rustup to path
export PATH="$PATH:$HOME/.cargo/bin"

alias cc="gcc"
export CC="gcc"

#Loads ssh-agent
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
if [[ ! "$SSH_AUTH_SOCK" ]]; then
    eval "$(<"$XDG_RUNTIME_DIR/ssh-agent.env")" > /dev/null
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd extendedglob correct
unsetopt beep
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/clone/.zshrc'

autoload -Uz compinit
compinit

# Only recheck the cache once a day
# TODO Stopped working
# for dump in ~/.zcompdump(N.mh+24); do
#     compinit
# done

# Local guix ruby gems
#ruby_hash=$(readlink -f $(which ruby) | cut -d '/' -f 4)
#ruby_ver="$(echo $ruby_hash | cut -d '-' -f 3 | cut -d '.' -f 1-2).0"
#export GEM_HOME=$HOME/.gem/$ruby_hash/$ruby_ver
#export GEM_PATH="$GEM_PATH:$GEM_HOME:$HOME/.guix-extra-profiles/langs/langs/lib/ruby/gems/$ruby_ver/"
#export GEM_PATH="$GEM_HOME"
#export GEM_SPEC_CACHE=$HOME/.gem/$ruby_hash/specs
#export PATH="$PATH:$GEM_HOME/bin"
#export PATH="$GEM_HOME/bin:$PATH"
#
export PATH="$PATH:$HOME/node_modules/.bin"


#NPM
export PATH="$HOME/.npm/bin:$PATH"

#if [ -e /home/clone/.nix-profile/etc/profile.d/nix.sh ]; then . /home/clone/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
export PATH="$HOME/bin:$PATH"

export RT_HOME="$HOME/rtorrent"

# Special snowflake rvm needs to be last
# Very slow, so disable for now
if [[ $LOAD_RVM ]]; then
    # Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
    export PATH="$PATH:$HOME/.rvm/bin"
    #Loads rvm as a function
    [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
fi
