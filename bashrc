# .bashrc

PATH=$PATH:$HOME/bin

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

if [ -f $HOME/.bashrc.local ]; then
  source $HOME/.bashrc.local
fi
