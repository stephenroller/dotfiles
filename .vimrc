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
"map Q gq

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on
filetype plugin on

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
au!

" For all text files set 'textwidth' to 78 characters.
autocmd FileType text setlocal textwidth=78

autocmd filetype plugin indent on

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

set ts=4 sts=4 et sw=4

set scrolloff=3
set wildmode=longest,list

set shiftround
set nowrap

set whichwrap=h,l,~,[,]

"set mouse=a

" always show line numbers
set nu

" i love spaces
set et

cab utf :set encoding=utf-8

cab csmake :make<CR><CR>

" stuff I mistype all the time
cab Wq wq
cab WQ wq
cab W w
cab Q q
cab Q! q!
cab E e
cab E! e!

" remap ; to :. it's just one less keystroke, but all the time
" nnoremap ; :

" language specific stuff
set ai
au FileType python set et sts=4 "complete+=k~/.vim/ac/python.dict isk+=.,(
au FileType ruby set et sts=2 sw=4 ts=4
au FileType php set complete+=k~/.vim/ac/php.dict isk+=.,(
au FileType tex set sts=2 ts=2 sw=2 et iskeyword+=:
au FileType tex let g:line_comment='% ' 
au FileType scala set sts=2 ts=2 sw=2 et

"set tags+=$HOME/.vim/tags/python.ctags

set noswf " no swap file

" so you don't have to remember to reload your docs
helptags ~/.vim/doc

" convenient mappings for paging through text
map <Space> <PageDown>
map J 10j
map <S-Space> <PageUp>
map K 10k


nmap <silent> <Leader>p :NERDTreeToggle <CR>


" GUI stuff
set gfn=Inconsolata:h15.00
set anti
set guioptions=emgrtL
colorscheme stephen
		
" ghetto indenting
nmap <silent> <D-]> :s?^?\t? <CR>
nmap <silent> <D-[> :s?^\t?? <CR>
imap <silent> <D-]> <Esc> :s?^?\t? <CR> a
imap <silent> <D-[> <Esc> :1s?^\t?? <CR> a
vmap <silent> <D-]> :s?^?\t? <CR> gv
vmap <silent> <D-[> :s?^\t?? <CR> gv


" map command-/ to magic comment toggle like TextMate
if !exists("g:line_comment")
	let g:line_comment='# '
endif

function! Comment()
	call CommentLineToEnd(g:line_comment)
endfunction

au FileType vim let g:line_comment='" '
au FileType c let g:line_comment='// '
au FileType java let g:line_comment='// '

map <silent> <leader>c :call Comment() <CR>
" imap <silent> <leader>c <Esc> :call Comment() <CR> +

" map <Leader>f :CommandT <CR>
set wildignore+=*.o,*.obj,.git,*.pyc,*.class,*.jar

let g:fuf_file_exclude = '\v\~$|\.(o|exe|dll|bak|swp|pyc|DS_Store)$|(^|[/\\])\.(hg|git|bzr)($|[/\\])'

highlight Pmenu ctermbg=Black gui=bold ctermfg=Blue
highlight PmenuSel ctermbg=Blue gui=bold ctermfg=White

let g:SuperTabDefaultCompletionType = "<C-X><C-O>"
let g:SuperTabDefaultCompletionType = "context"

" ctrl-A and ctrl-E mapped everywhere
inoremap <C-a> <Home>
cnoremap <C-a> <Home>
"noremap <C-a> <Home>
inoremap <C-e> <End>
cnoremap <C-e> <End>
noremap <C-e> <End>

" color extra whitespace red (see extrawhitespace.vim)
highlight ExtraWhitespace ctermbg=red guibg=red

" no folds
set nofoldenable

" the default keybindings for omnicompletion are awful
inoremap <expr> <Esc>      pumvisible() ? "\<C-e>\<Esc>" : "\<Esc>"


inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"

" spell checking is a must
" set spell

au FileType git-log set nospell

map <Leader>s :call NewScratchBuffer()<CR>
map <Leader>v :so ~/.vimrc <CR> :echo "~/.vimrc loaded..." <CR>

set modeline
set ls=2

" Make it easier to run commands
map <Leader>r :ConqueTermSplit 
map !! :ConqueTermSplit <C-Up><CR>

" terminal!
" and some settings
let g:ConqueTerm_TERM = 'xterm'
let g:ConqueTerm_CloseOnEnd = 1
let g:ConqueTerm_InsertOnEnter = 1
let g:ConqueTerm_CWInsert = 1
let g:ConqueTerm_ReadUnfocused = 1
map <Leader>t :ConqueTermSplit bash<CR>

nmap Zs :w<CR>



" close a window
nmap <Leader>q :q <Cr>

" show a line at 80 characters
if version >= 703
    set cc=80
endif

" trailing whitespace
set list
if version <= 702
    set listchars=tab:>-,trail:-
else
    set listchars=tab:▸·,trail:·
endif

" test of white space: 	      	asdfasdf    

" options for latex-suite
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'

" and vim-latex
let g:Tex_MultipleCompileFormats="dvi,pdf"
let g:Tex_DefaultTargetFormat="pdf"
let g:Tex_CompileRule_pdf='pdflatex -synctex=1 --interaction=nonstopmode $*'
let g:Tex_GotoError=0

let g:Tex_IgnoreLevel=5
let g:Tex_IgnoredWarnings ='
      \"Underfull\n".
      \"Overfull\n".
      \"specifier changed to\n".
      \"You have requested\n".
      \"Missing number, treated as zero.\n".
      \"There were undefined references\n".
      \"Citation %.%# undefined\n".
      \"\oval, \circle, or \line size unavailable\n"' 
