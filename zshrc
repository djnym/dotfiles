# source path tools
. ~/.zsh/functions/ww-env-api

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

# Set LD_LIBRARY_PATH
ww_app_path LD_LIBRARY_PATH "$HOME/lib"
ww_app_path LD_LIBRARY_PATH "/opt/lib"
ww_app_path LD_LIBRARY_PATH "/usr/local/lib"

# Set MANPATH
ww_app_path MANPATH "$HOME/man"
ww_app_path MANPATH "/opt/man"
ww_app_path MANPATH "/usr/local/man"
ww_app_path MANPATH "/usr/man"
ww_app_path MANPATH "/usr/share/man"
ww_app_path MANPATH "/man"

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
