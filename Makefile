cwd=`pwd`
bin_files=$(wildcard bin/*)
not_dot=bin
dot_files=$(filter-out $(not_dot), $(wildcard *))

install-dot-files:
	mkdir -p $(HOME)/tmp
	for file in $(dot_files) ; do \
	  if test ! -h $(HOME)/.$${file} ; then \
	    ln -s $(cwd)/$${file} $(HOME)/.$${file} ; \
	  fi ; \
	done ; \
	mkdir -p $(HOME)/.vim/bundle && \
	cd $(HOME)/.vim/bundle && \
	git clone git://github.com/jimenezrick/vimerl.git

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
	  ln -s $(cwd)/$${file} $(HOME)/$${file} ; \
	done

uninstall-bin-files:
	for file in $(bin_files) ; do \
	  rm -f $(HOME)/$${file} ; \
	done

install: install-dot-files install-bin-files

uninstall: uninstall-dot-files uninstall-bin-files
