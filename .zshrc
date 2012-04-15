# Created by pSub for 4.3.10

# Declaration of config files to
# be used, which are located in $ZSHDIR
config_files=(alias
              bindkey
              functions
              style
              prompt
              zle
             )

export ZSHDIR=$HOME/.zsh
export ZSHFUN=$ZSHDIR/functions
export EDITOR="ec"
export PAGER=less
export REPORTTIME="10"
export HISTFILE=$HOME/.zshhistory
export COLORTERM=yes
export DIRSTACKSIZE=9
export DIRSTACKFILE=~/.zdirs

# Keybindings to change pacman commands on the fly
pacman_bindings=(
    "^[i" "S"     # Meta-i → install
    "^[f" "Ss"    # Meta-f → search
    "^[r" "Rs"    # Meta-r → remove
    "^[p" "Qi"    # Meta-p → info / properties
)

# MODULES
autoload -U compinit && compinit
autoload -U keeper && keeper
autoload -U colors && colors
autoload -U zfinit && zfinit
autoload -U zmv
autoload -Uz vcs_info
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# Add directory with custom functions to FPATH
fpath=($fpath $ZSHFUN)

# Mark all functions in ZSHFUN for autoloading
for file in $ZSHFUN/*
do
    autoload -U $file:t
done

# OPTIONS

# change directory without 'cd'
setopt autocd

# Push direcotries automatically
setopt autopushd

# Ignore duplicates on dictionary stack
setopt pushd_ignoredups

# Be quiet
setopt nobeep
setopt nohistbeep
setopt nolistbeep

# Maybe needed for prompt, I'm not sure
setopt prompt_subst

# $0 is the name of the function/script
setopt function_argzero

# No duplicate entries in history
setopt histignoredups

# Cool globbing stuff, see http://zsh.sourceforge.net/Intro/intro_2.html
setopt extendedglob

# Comments are allowed in the prompt, useful when pasting a shelscript
setopt interactivecomments


# COLORS
if [[ -f ~/.dircolors ]] {
    if [[ ${TERM} == screen* ]] {
        eval $( TERM=screen dircolors ~/.dircolors )
    } else {
        eval $( dircolors ~/.dircolors )
    }
} else {
    eval $( dircolors -b )
}

# Persistent directory stack by Christian Neukirchen
# <http://chneukirchen.org/blog/archive/2012/02/10-new-zsh-tricks-you-may-not-know.html>
if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then
  dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
  [[ -d $dirstack[1] ]] && cd $dirstack[1] && cd $OLDPWD
fi
chpwd() {
  print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
}

# Auxiliary function
function load_config() {
    if [[ -f $1 ]] {
        source $1
    }
}

# Load config files
if [[ -d $ZSHDIR ]] {
    for config_file in $config_files
    do
      load_config $ZSHDIR/$config_file.zsh
    done
}

unfunction load_config
unset config_files
