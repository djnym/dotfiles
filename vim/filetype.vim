" my filetype file
if exists("did_load_filetypes")
  finish
endif
augroup filetypedetect
  au! BufRead,BufNewFile *.hrl		setfiletype erlang
  au! BufRead,BufNewFile *.xrl		setfiletype erlang
  au! BufRead,BufNewFile *.yrl		setfiletype erlang
augroup END
