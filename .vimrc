" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
set nohls

map [H 0
map! [H 0i
map [F $
map! [F $a

set sm

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set nobackup
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" Don't use Ex mode, use Q for formatting
map Q gq

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
au!

" For all text files set 'textwidth' to 78 characters.
autocmd FileType text setlocal textwidth=78

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

augroup END

syntax on
set ignorecase
set smartcase

set ts=4 noet sw=4

set scrolloff=1
set wildmode=longest,list

set shiftround
set nowrap

set whichwrap=h,l,~,[,]

set mouse=a
set nu

cab utf :set encoding=utf-8

cab csmake :make<CR><CR>

" aliases 
cab Wq :wq
cab WQ :wq
cab W :w
cab Q :q
cab E :e

" language specific stuff
au FileType python set et sts=4 complete+=k~/.vim/ac/python.dict isk+=.,(
au FileType php set complete+=k~/.vim/ac/php.dict isk+=.,(

set tags+=$HOME/.vim/tags/python.ctags
map <silent><C-Left> <C-T>
map <silent><C-Right> <C-]>
"
