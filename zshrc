#
# $Id: .zshrc,v 1.41 2007/02/15 20:50:59 molinaro Exp $
#
# comment out for no debugging info
#DEBUG=1

ARCH=`uname`

[ ! -z "${DEBUG}" ] && echo "zshrc : starting"

# set umask
umask 022

# grab functions and completions
if [ -f ${HOME}/.zsh/setup ] ; then
  . ${HOME}/.zsh/setup
fi

[ ! -z "${DEBUG}" ] && echo "zshrc : setting up zsh options"

# set options
setopt append_history 
#setopt automenu
setopt csh_null_glob
setopt globdots
setopt hist_ignore_dups
setopt hist_verify
setopt interactive_comments
setopt nohup
setopt pushd_ignore_dups

bindkey -v
bindkey "^R" history-incremental-search-backward

[ ! -z "${DEBUG}" ] && echo "zshrc : setting up history"
HISTSIZE=300           # Set up a sufficiently long history record.
SAVEHIST=0             # Kill any saved history.

[ ! -z "${DEBUG}" ] && echo "zshrc : setting up login watching"
watch=(all)                                                 # Watch for logins
who=" %B%n%b has %B%a%b %l from %B%m%b at %S%t on %w %D%s." # How to report them

# some aliases
[ ! -z "${DEBUG}" ] && echo "zshrc : setting up aliases"
if [ "${ARCH}" = "Linux" ]; then
  alias ls='\ls --color=auto -Fb'
else
  alias ls='\ls -Fb'
fi
alias rm='\rm -i'
alias cr='a2ps -2 -E -A virtual -j --line-numbers=1'
#alias perldoc='LANG=en_US perldoc'

# set some environment variables
PAGER='less'
export PAGER

# --------------------------------------------------------------------------
# Path Variables
# --------------------------------------------------------------------------
# reset the path so we can make sure it is in the order we want it in

ARCH=`uname`
[ ! -z "${DEBUG}" ] && echo "zshrc : PATH BEFORE : $PATH"
PATH=""

# fink is gobbling my path, so is here first
if [ ${ARCH} = "Darwin" ] ; then

  [ ! -z "${DEBUG}" ] && echo "zshrc : PATH BEFORE FINK : '$PATH'"
  # These are all Fink related
  if test -f /sw/bin/init.sh ; then
    source /sw/bin/init.sh
    ww_app_path MANPATH "/sw/man"
    ww_app_path PATH "/sw/bin"
    ww_app_path LD_LIBRARY_PATH "/sw/lib"
    ww_app_path PERL5LIB "/sw/lib/perl5"
    ww_app_path PKG_CONFIG_PATH "/sw/lib/pkgconfig"
    ww_app_include CPPFLAGS "/sw/include"
    ww_app_include CFLAGS "/sw/include"
    ww_app_include CXXLAGS "/sw/include"
    ww_app_lib LIBS "/sw/lib"
    ww_app_lib LDFLAGS "/sw/lib"
  fi

  [ ! -z "${DEBUG}" ] && echo "zshrc : PATH BEFORE MACPORTS '$PATH'"
  # These are all Darwin Ports related
  if test -d /opt/local ; then
    ww_app_path MANPATH "/opt/local/man"
    ww_app_path PATH "/opt/local/bin"
    ww_app_path LD_LIBRARY_PATH "/opt/local/lib"
    ww_app_path PERL5LIB "/opt/local/lib/perl5"
    ww_app_path PKG_CONFIG_PATH "/opt/local/lib/pkgconfig"
    ww_app_path CPPFLAGS "/opt/local/include"
    ww_app_include CFLAGS "/opt/local/include"
    ww_app_include CXXLAGS "/opt/local/include"
    ww_app_lib LIBS "/opt/local/lib"
    ww_app_lib LDFLAGS "/opt/local/lib"
  fi

  # default to 64-bit for building
  LDFLAGS="-arch x86_64 $LDFLAGS"
fi


[ ! -z "${DEBUG}" ] && echo "zshrc : PATH SETTING '$PATH'"

# Set PATH
ww_app_path PATH "$HOME/bin"
ww_app_path PATH "$HOME/sbin"

if test -d "$HOME/perl5/perlbrew/" ; then
  ww_app_path PATH "$HOME/perl5/perlbrew/bin"
fi

ww_app_path PATH "/usr/local/bin"
ww_app_path PATH "/opt/bin"
ww_app_path PATH "/usr/bin"
ww_app_path PATH "/bin"

ww_app_path PATH "/usr/games/bin"
ww_app_path PATH "/usr/X11R6/bin"
ww_app_path PATH "/usr/local/sbin"
ww_app_path PATH "/usr/sbin"
ww_app_path PATH "/sbin"

if [ "${ARCH}" = "SunOS" ] ; then
  ww_app_path PATH "/usr/ccs/bin"
  ww_app_path PATH "/usr/openwin/bin"
fi


[ ! -z "${DEBUG}" ] && echo "zshrc : PATH AFTER '$PATH'"

# Set LD_LIBRARY_PATH
ww_app_path LD_LIBRARY_PATH "$HOME/lib"
ww_app_path LD_LIBRARY_PATH "/opt/lib"
ww_app_path LD_LIBRARY_PATH "/usr/local/lib"

# Set PERL5LIB
#ww_app_path PERL5LIB "$HOME/lib/perl5"
#ww_app_path PERL5LIB "/opt/lib/perl5"
#ww_app_path PERL5LIB "/usr/local/lib/perl5"

# Set MANPATH
ww_app_path MANPATH "$HOME/man"
ww_app_path MANPATH "/opt/man"
ww_app_path MANPATH "/usr/local/man"
ww_app_path MANPATH "/usr/man"
ww_app_path MANPATH "/usr/share/man"
ww_app_path MANPATH "/man"


# --------------------------------------------------------------------------
# Development Variables
# --------------------------------------------------------------------------

# Set PKG_CONFIG_PATH
ww_app_delim PKG_CONFIG_PATH "$HOME/lib/pkgconfig" ":"
ww_app_delim PKG_CONFIG_PATH "/opt/lib/pkgconfig" ":"
ww_app_delim PKG_CONFIG_PATH "/usr/lib/pkgconfig" ":"
ww_app_delim PKG_CONFIG_PATH "/usr/local/lib/pkgconfig" ":"


# Set CPPFLAGS
ww_app_include CPPFLAGS "$HOME/include"
ww_app_include CPPFLAGS "/opt/include"
ww_app_include CPPFLAGS "/usr/local/include"


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

setPrompt

# platform specific environment variables
if [ "${ARCH}" = "Linux" ] ; then
  # nothing here at the moment
fi
if [ "${ARCH}" = "SunOS" ] ; then
  export TERMINFO=${HOME}/lib/solaris/terminfo
fi
if [ "${ARCH}" = "FreeBSD" ] ; then
  # FreeBSD doesn't seem to like LANG=en_US
  export LANG=C
fi

if test -f .zshrc.local ; then
  source .zshrc.local
fi

# export vars
export PATH LD_LIBRARY_PATH PERL5LIB MANPATH
export PKG_CONFIG_PATH CPPFLAGS CFLAGS CXXFLAGS LIBS LDFLAGS

findagent

[ ! -z "${DEBUG}" ] && echo "zshrc : PATH END '$PATH'"
[ ! -z "${DEBUG}" ] && echo "zshrc : done"
