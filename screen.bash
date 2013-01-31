# Got inspiration from
#   http://zshwiki.org/home/examples/hardstatus
#   http://serverfault.com/questions/3740/what-are-useful-screenrc-settings
# for zsh and
#   http://www.davidpashley.com/articles/xterm-titles-with-bash.html
#   http://www.twistedmatrix.com/users/glyph/preexec.bash.txt
# for bash.

# calculate a short hostname for use below
if [[ "$SHORT_HOST" == "" ]]
then
  SHORT_HOST=`hostname | perl -lne 'print $1 if m/^([^\.]*)/'`
fi

function xterm_title_set()
{
  echo -ne "\033]0;$1\a"
}

function screen_title_set()
{
  echo -ne "\033k$1\033\\"
}

# this is the same control sequence as xterm title, but I want to be clear
# about which does which, so it's repeated
function screen_hardstatus_set()
{
  echo -ne "\033]0;$1\a"
}

# when we are in an xterm just set the xterm title
if [[ "$TERM" == "xterm" ]] ; then
  function preexec {
    xterm_title_set "${USER}@${SHORT_HOST} - $1"
  }
  function precmd {
    xterm_title_set "${USER}@${SHORT_HOST}"
  }
fi

# if in screen, set title and hardstatus
if [[ "$TERM" == "screen" ]]; then
  function preexec()
  {
    screen_title_set "${USER}@${SHORT_HOST}"
    screen_hardstatus_set "$1"
  }
  function precmd()
  {
    screen_title_set "${USER}@${SHORT_HOST}"
    screen_hardstatus_set ""
  }
fi
