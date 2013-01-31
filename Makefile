cwd=`pwd`

install:
	for file in bashagent bashrc inputrc screenrc tmux.conf vim vimrc zlogout zsh-title zshenv zshrc zsh ; do \
	  ln -s $(cwd)/$${file} $(HOME)/.$${file} ; \
	done ; \
	if test ! -d $(HOME)/bin; then \
	  mkdir $(HOME)/bin ; \
	fi ; \
	for file in histogram sumValues; do \
	  ln -s $(cwd)/bin/$${file} $(HOME)/bin/$${file} ; \
	done

uninstall:
	for file in bashagent bashrc inputrc screenrc tmux.conf vim vimrc zlogout zsh-title zshenv zshrc zsh ; do \
	  rm $(HOME)/.$${file} ; \
	done ; \
	for file in histogram sumValues; do \
	  rm $(HOME)/bin/$${file} ; \
	done
