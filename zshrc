# wigwam path tools, make it easier to setup paths further down
ww_has_componant_usage="ww_has_componant DELIM VALUE COMPONANT"
ww_has_componant () {
  test "$#" -ne 3 && ww_usage "$ww_has_componant_usage"

  # delim="$1";
  # value="$2";
  # componant="$3";

  eval 'case "$2" in
    # matches middle
    *'"'$1$3$1'"'*)
      return 0
      ;;
    # begins with
    '"'$3$1'"'*)
      return 0
      ;;
    # ends with
    *'"'$1$3'"')
      return 0
      ;;
    # exact match
    '"'$3'"')
      return 0
      ;;
    *)
      # do nothing
      return 1
      ;;
  esac'
}

ww_env_api_reset () {
  # unset's the function and the usage var of the same name.
  # unset the vars
  for ww_env_api_reset_var_or_func in    \
    ww_has_componant    \
    ww_pre_delim        \
    ww_app_delim        \
    ww_int              \
    ww_int_clear        \
    ww_app_colon        \
    ww_int_app_colon    \
    ww_int_pre_colon    \
    ww_int_set          \
    ww_pre_colon        \
    ww_set              \
    ww_int_load_exports \
  ; do
    # once for the var
    unset ${ww_env_api_reset_var_or_func}_usage;
    # once for the func
    unset $ww_env_api_reset_var_or_func;
  done

  unset ww_usage
  unset ww_env_api_reset
  unset ww_env_api_reset_var_or_func

  unset ww_env_api_reset
}

ww_usage () {
  echo "[in $0] Usage: $*"
  exit 1;
}

#############
## ww-env-api:

# prepend to var PATH using delimiter " "
# ww_pre_delim PATH "/foo" " "
ww_pre_delim_usage="ww_pre_delim VARNAME VALUE DELIMITER"
ww_pre_delim ()  {

  test "$#" -ne 3 && ww_usage "$ww_pre_delim_usage";

  # check if the new value has the delimiter in it
  # if we're calling ourselves it shouldn't.
  if ww_has_componant "" "$2" "$3"; then
    # if it does, split it up, and loop 
    # through and recall ourselves with the 
    # componants.

    # NOTE: not safe for spaced values yet.

    # Have to reverse it first
    ww_pre_delim_tmp=""
    ww_pre_delim_val=""
    for ww_pre_delim_val in `echo $2 | sed -e "s/$3/ /g"`; do
      ww_pre_delim "ww_pre_delim_tmp" "$ww_pre_delim_val" "$3"
    done
    for ww_pre_delim_val in `echo $ww_pre_delim_tmp | sed -e "s/$3/ /g"`; do
      ww_pre_delim "$1" "$ww_pre_delim_val" "$3"
    done
    unset ww_pre_delim_tmp
    unset ww_pre_delim_val

  else

    eval "ww_pre_delim_old_value=\$$1"

    # check if the old value already has the new value.
    if ww_has_componant "$3" "$ww_pre_delim_old_value" "$2"; then
      :  # NoOp, ':' is builtin for true?  
    else
      eval 'test "x$'$1'" = "x" && '$1'="$2" || '$1'="$2$3$'$1'"'
    fi

    unset ww_pre_delim_old_value
  fi
}

# append to var PATH using delimiter " "
# ww_app_delim PATH "/foo" " "

ww_app_delim_usage="ww_app_delim VARNAME VALUE DELIMITER"
ww_app_delim ()  {

  test "$#" -ne 3 && ww_usage "$ww_app_delim_usage";

  # var="$1"
  # val="$2"
  # delim="$3" 

  # check if the new value has the delimiter in it
  if ww_has_componant "" "$2" "$3"; then
    # if it does, split it up and add each 
    # portion individually, to do the has_componant check properly

    # NOTE: not safe for spaced values yet.
    ww_app_delim_val=""
    for ww_app_delim_val in `echo $2 | sed -e "s/$3/ /g"`; do
      ww_app_delim "$1" "$ww_app_delim_val" "$3"
    done
    unset ww_app_delim_val

  else

    eval "ww_app_delim_old_value=\$$1"
    if ww_has_componant "$3" "$ww_app_delim_old_value" "$2"; then
      :  # NoOp, ':' is builtin for true?  
    else
      eval 'test "x$'$1'" = "x" && '$1'="$2" || '$1'="$'$1'$3$2"'
    fi

    unset ww_app_delim_old_value

  fi
}

# Mark a variable for the interactive enviroment
# equiv to: ww_app_delim interactive_variables "PATH" " "
# ww_int PATH

ww_int_usage="ww_int VARNAME ... "
ww_int () {
  test "$#" -lt 1 && ww_usage "$ww_int_usage"

  for ww_int_var in "$@"; do
    ww_app_delim interactive_variables "$ww_int_var" " "
    export "$ww_int_var"
  done
  unset ww_int_var
}

# clear the interactive variables list
# ww_int_clear
ww_int_clear () { 
  unset interactive_variables
}

# equiv to: ww_pre_delim PATH "/foo" ":"
# ww_pre_colon PATH "/foo"

ww_pre_colon_usage="ww_pre_colon VAR COMPONANT"
ww_pre_colon () {
  test "$#" -ne 2 && ww_usage "$ww_pre_colon_usage"
  ww_pre_delim "$1" "$2" ":"
}


# equiv to: ww_app_delim PATH "/foo" ":"
# ww_app_colon PATH "/foo"
ww_app_colon_usage="ww_app_colon VAR COMPONANT"
ww_app_colon () {
  test "$#" -ne 2 && ww_usage "$ww_app_colon_usage"
  ww_app_delim "$1" "$2" ":"
}

# equiv to: GOTO_HOME=$PLAYPEN_ROOT; ww_int PLAYPEN_ROOT
# ww_int_set GOTO_HOME $PLAYPEN_ROOT

ww_int_set_usage="ww_int_set VAR VALUE"
ww_int_set () { 
  test "$#" -ne 2 && ww_usage "$ww_int_set_usage"
  ww_set "$1" "$2"
  ww_int "$1"
}

# equiv to: ww_app_colon PATH "/home/anthonym/bin/solaris"; ww_int PATH
# ww_int_app_colon PATH "/home/anthonym/bin/solaris"

ww_int_app_colon_usage="ww_int_app_colon VAR COMPONANT"
ww_int_app_colon () {
  test "$#" -ne 2 && ww_usage "$ww_int_app_colon_usage"
  ww_app_colon "$1" "$2"
  ww_int "$1"
}

# equiv to: ww_pre_colon PATH "/home/anthonym/bin/solaris"; ww_int PATH
# ww_int_pre_colon PATH "/home/anthonym/bin/solaris"

ww_int_pre_colon_usage="ww_int_pre_colon VAR COMPONANT"
ww_int_pre_colon () {
  test "$#" -ne 2 && ww_usage "$ww_int_pre_colon_usage"
  ww_pre_colon "$1" "$2"; ww_int "$1"
}

# equiv to: PATH=/foo
# ww_set PATH "/foo"

ww_set_usage="ww_set VAR VALUE"
ww_set () {
  test "$#" -ne 2 && ww_usage "$ww_set_usage"
  eval "$1=\"$2\"" 
}


##
## Extended API Section.
##

##
# sources file and makes entire sourced environment interactive
# ww_int_load $PLAYPEN_ROOT/etc/environment/workrc
## 
# this one is not possible, because basic sh on solaris
# cannot output it's set vars in a safely parseable form

##
# load and ww_int any exports from sh file
# ww_int_load_exports $PLAYPEN_ROOT/etc/environment/workrc
##
ww_int_load_exports_usage="ww_int_load_exports FILENAME"
ww_int_load_exports () { 
  test "$#" -ne 1 && ww_usage "$ww_int_load_exports_usage"
  ww_int_load_exports_do="$PLAYPEN_ROOT/ext/tmp/env_interactives_loadtmp.$$"
  modified_and_new_vars="`$PLAYPEN_ROOT/ext/bin/ww-env-diffs \
    --source \"$1\" \
    --save-do \"$ww_int_load_exports_do\" \
    --list-modified --list-new`"

  # ok, now load the changes
  . "$ww_int_load_exports_do"

  rm -f "$ww_int_load_exports_do"

  for var in $modified_and_new_vars
  do
    ww_int "$var"
  done
}

# equiv to: ww_app_delim PATH "/foo" ":"
# ww_app_path PATH "/foo"
ww_app_path_usage="ww_app_path VAR COMPONANT"
ww_app_path () {
  test "$#" -ne 2 && ww_usage "$ww_app_path_usage"
  if test -d $2 ; then
    ww_app_delim "$1" "$2" ":"
  fi
}

# equiv to: ww_pre_delim PATH "/foo" ":"
# ww_pre_path PATH "/foo"
ww_pre_path_usage="ww_pre_path VAR COMPONANT"
ww_pre_path () {
  test "$#" -ne 2 && ww_usage "$ww_pre_path_usage"
  if test -d $2 ; then
    ww_pre_delim "$1" "$2" ":"
  fi
}

ww_app_include_usage="ww_app_include VAR COMPONANT"
ww_app_include () {
  test "$#" -ne 2 && ww_usage "$ww_app_include_usage"
  if test -d $2 ; then
    ww_app_delim "$1" "-I$2" " "
  fi
}

ww_app_lib_usage="ww_app_lib VAR COMPONANT"
ww_app_lib () {
  test "$#" -ne 2 && ww_usage "$ww_app_lib_usage"
  if test -d $2 ; then
    ww_app_delim "$1" "-L$2" " "
  fi
}

# Set PATH
unset PATH
ww_app_path PATH "$HOME/bin"
ww_app_path PATH "$HOME/sbin"
#if test -d "$HOME/perl5/perlbrew/" ; then
  ww_app_path PATH "$HOME/perl5/perlbrew/bin"
#fi
ww_app_path PATH "$HOME/go/bin"
ww_app_path PATH "/usr/local/bin"
ww_app_path PATH "/usr/local/sbin"
ww_app_path PATH "/usr/bin"
ww_app_path PATH "/usr/sbin"
ww_app_path PATH "/bin"
ww_app_path PATH "/sbin"
ww_app_path PATH "/opt/bin"
ww_app_path PATH "/opt/sbin"
ww_app_path PATH "/usr/games/bin"
ww_app_path PATH "/usr/X11R6/bin"

# Set LD_LIBRARY_PATH
ww_app_path LD_LIBRARY_PATH "$HOME/lib"
ww_app_path LD_LIBRARY_PATH "/usr/local/lib"
ww_app_path LD_LIBRARY_PATH "/opt/lib"

# Set MANPATH
ww_app_path MANPATH "$HOME/man"
ww_app_path MANPATH "/usr/local/man"
ww_app_path MANPATH "/usr/man"
ww_app_path MANPATH "/usr/share/man"
ww_app_path MANPATH "/man"
ww_app_path MANPATH "/opt/man"
ww_app_path MANPATH "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/share/man/"

# Set PKG_CONFIG_PATH
ww_app_delim PKG_CONFIG_PATH "$HOME/lib/pkgconfig" ":"
ww_app_delim PKG_CONFIG_PATH "/usr/lib/pkgconfig" ":"
ww_app_delim PKG_CONFIG_PATH "/usr/local/lib/pkgconfig" ":"
ww_app_delim PKG_CONFIG_PATH "/opt/lib/pkgconfig" ":"

# Set CPPFLAGS
ww_app_include CPPFLAGS "$HOME/include"
ww_app_include CPPFLAGS "/usr/local/include"
ww_app_include CPPFLAGS "/opt/include"

# Set CFLAGS
ww_app_delim CFLAGS "-g" " "
ww_app_delim CFLAGS "-O3" " "
ww_app_delim CFLAGS "-funroll-loops" " "
ww_app_delim CFLAGS "$CPPFLAGS" " "

# Set CXXFLAGS
ww_app_delim CXXFLAGS "$CFLAGS" " "
ww_app_delim CXXFLAGS "$CPPFLAGS" " "

# Set LIBS
ww_app_lib LIBS "$HOME/lib"
ww_app_lib LIBS "/usr/local/lib"
ww_app_lib LIBS "/opt/lib"

# Set LDFLAGS
ww_app_delim LDFLAGS "$LIBS" " "

# Set PERL5LIB
ww_app_path PERL5LIB "$HOME/perl5/lib/perl5"

# Set MAKE
gmake=`which gmake 2>/dev/null`
if test "x$gmake" != "xgmake not found"; then
  MAKE=gmake
  export MAKE
  alias make=gmake
fi

# make vim our editor
if which vim >/dev/null; then
  export EDITOR=vim
  export VISUAL=vim
else
  echo 1>&2 'Argh! No vim!'
  export EDITOR=vi
  export VISUAL=vi
fi

if test -f .zshrc.local ; then
  source .zshrc.local
fi

# export vars
export PATH LD_LIBRARY_PATH PERL5LIB MANPATH
export PKG_CONFIG_PATH CPPFLAGS CFLAGS CXXFLAGS LIBS LDFLAGS

ARCH=`uname`
# Path to your oh-my-zsh installation.
if [ "`uname`" = "Darwin" ]; then
  if [ -d /Users/anthony.molinaro ] ; then
    export ZSH=/Users/anthony.molinaro/.oh-my-zsh
  else
    if [ -d /Users/molinaro ] ; then
      export ZSH=/Users/molinaro/.oh-my-zsh
    fi
  fi
else
  # probably Linux, so assume my standard naming
  export ZSH=/home/molinaro/.oh-my-zsh
fi

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="fishy"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  $plugins
)

ZSH_DISABLE_COMPFIX=true

source $ZSH/oh-my-zsh.sh

# User configuration

# enable vi command line editing
bindkey -v
# but put back incremental search backward because I like it
bindkey "^R" history-incremental-search-backward

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
