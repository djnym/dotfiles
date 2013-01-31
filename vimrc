version 5.0

set autowrite
set background=dark
set backupdir=$HOME/tmp
set backspace=2
set cinkeys-=0#
set cinoptions=(0,g0,{s,>2s,n-s,^-s,t0
set cindent
set directory=$HOME/tmp
set errorfile=./errors 
set expandtab
set history=50
set ignorecase
set incsearch
set laststatus=2
set list
set listchars=tab:>>,trail:.
set pastetoggle=<F11>
set report=1
set ruler
set shiftwidth=2
set showcmd
set showmatch
set showmode
set smartcase
set splitbelow
set tabstop=4
set title
set titlestring=%{$USER}@%{hostname()}:\ VIM\ %t
set ttyfast
set nowrapscan
set viminfo='0,f0,\"0,h
set visualbell t_vb=
set wildignore+=*.class,*.o,*.so
set wildmenu
set wildmode=longest,full
set winheight=8

if has("terminfo")
  set t_Co=8
  set t_Sf=[3%p1%dm
  set t_Sb=[4%p1%dm
"else
"  set t_Co=8
"  set t_Sf=[3%dm
"  set t_Sb=[4%dm
endif

" fix backspace for xterm
"map  
map!  

"""" Set up two space indention
map <F1> :set ts=2 sw=2 ai si sm<CR>1GvG=

"""" Set up four space indention
map <F2> :set ts=4 sw=4 ai si sm<CR>GvG=

"""" Turn off all Code options
map <F3> :set ts=2 sw=2 noai nosi nosm<CR>

"""" Turn off all Code options
map <F4> :set ts=4 sw=4 noai nosi nosm<CR>

"""" Turn on and off Number Mode
map <F5> :set nu<CR>
map <F6> :set nonu<CR>

if (has("syntax"))
  map <F9> :if exists("syntax_on") <Bar> syntax off <Bar> else <Bar> syntax on <Bar> endif <CR>
  let java_highlight_java_lang_ids=1
  let java_highlight_functions="style"
  let java_allow_cpp_keywords=1

  "let perl_fold=1
endif

map <F10> :nohlsearch<CR>

if (has("autocmd"))
  autocmd!

  " Clear out group created by RedHat VIM install
  augroup cprog
    au!
  augroup END

  " Use a template for java files
"  au BufNewFile         *.java  0r!makeJavaTemplate.pl %:~:h %:t:r
"  au BufNewFile         *.java  execute "/class ".expand("%:t:r")."/"
"
"  au BufNewFile,BufRead *.jad   set ft=java
"  au BufNewFile,BufRead *.jhtml set ft=html
"  au BufNewFile,BufRead *.jhtml set fileencodings=utf-8,japan,latin1
"  au BufNewFile,BufRead *.jhtml set encoding=utf-8

  au BufEnter * call BufOptions("BufEnter")
  au BufLeave * call BufOptions("BufLeave")
endif

colorscheme anthonym
syntax on

filetype on
filetype plugin on
filetype indent on

function BufOptions(state)
  let ft=&filetype

"  if ft=="java"
"    if a:state == "BufEnter"
      "set expandtab
"      set errorformat=%f:%l:%v:%*\\d:%*\\d:%*\\s%m
"      set makeprg=jikes\ +E\ -depend\ %
      "set errorformat=%A%f:%l:%m,
      "               \%Csymbol%*\\s:\ %m,
      "               \%-Glocation:%.%#,
      "               \%-G%*\\d\ errors%\\=
      "set makeprg=javac\ %
"      set tags+=$GOTO_HOME/src/java/.tags
"    else
"      set errorformat&
      "set expandtab&
"      set makeprg&
"      set tags-=$GOTO_HOME/src/java/.tags
"    endif
"  elseif ft=="perl"
   if ft=="perl"
    if a:state=="BufEnter"
      "set expandtab
      set makeprg=perl\ -cw\ %
      set errorformat=%+Gsyntax\ error\ at\ %f\ line\ %l\\\,\ %m,
                     \%A%m\ at\ %f\ line\ %l%.%#,
                     \%C%*\\s%m,
                     \%-G%.%#\ had\ compilation\ errors.,
                     \%-G%.%#\ syntax\ OK
"      set tags+=$GOTO_HOME/src/perlsrc/.tags
    else
      "set expandtab&
      set makeprg&
      set errorformat&
"      set tags-=$GOTO_HOME/src/perlsrc/.tags
    endif
  elseif ft=="c"
    if a:state=="BufEnter"
      set cinkeys+=0#
      "set expandtab
"      set tags+=$GOTO_HOME/src/c_code/.tags
    else
      set cinkeys-=0#
      "set expandtab&
"      set tags-=$GOTO_HOME/src/c_code/.tags
    endif
  elseif ft=="make"
    if a:state=="BufEnter"
      set noexpandtab
    else
      set expandtab&
    endif
  elseif ft=="mail"
    if a:state=="BufEnter"
      set textwidth=80
    else
      set textwidth&
    endif
  endif
endfunction
