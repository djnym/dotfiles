# .bashrc

PATH=$PATH:$HOME/bin

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

### User specific aliases and functions
source .preexec.bash
source .screen.bash

preexec_install
