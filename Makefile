cwd=$(shell pwd)
relative=`echo $(cwd) | sed 's:^$(HOME)/::'`
bin_files=$(wildcard bin/*)
not_dot=bin
dot_files=$(filter-out $(not_dot), $(wildcard *))

install-dot-files:
	if test -f $(HOME)/.zshrc ; then \
	  rm -f $(HOME)/.zshrc ; \
	fi
	if test -f $(HOME)/.bashrc ; then \
	  rm -f $(HOME)/.bashrc ; \
	fi
	mkdir -p $(HOME)/tmp
	for file in $(dot_files) ; do \
	  if test ! -h $(HOME)/.$${file} ; then \
	    ln -s $(relative)/$${file} $(HOME)/.$${file} ; \
	  fi ; \
	done ; \
	mkdir -p $(HOME)/.vim/bundle && \
	cd $(HOME)/.vim/bundle && \
	if test ! -d vimerl ; then \
	  git clone git://github.com/jimenezrick/vimerl.git ; \
	fi

uninstall-dot-files:
	rm -rf $(HOME)/.vim/bundle ; \
	for file in $(dot_files) ; do \
	  rm -f $(HOME)/.$${file} ; \
	done ; \

install-bin-files:
	if test ! -d $(HOME)/bin; then \
	  mkdir $(HOME)/bin ; \
	fi ; \
	for file in $(bin_files) ; do \
	  if test ! -h $(HOME)/$${file} ; then \
	    ln -s $(cwd)/$${file} $(HOME)/$${file} ; \
	  fi ; \
	done

uninstall-bin-files:
	for file in $(bin_files) ; do \
	  rm -f $(HOME)/$${file} ; \
	done

install: install-dot-files install-bin-files

uninstall: uninstall-dot-files uninstall-bin-files
