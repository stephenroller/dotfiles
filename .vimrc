try
    source $LOCAL_ADMIN_SCRIPTS/master.vimrc
catch
    " do nothing
endtry

set nocompatible
set nohls

map [H 0
map! [H 0i
map [F $
map! [F $a

" load modules early
execute pathogen#infect()

" do you want regex magic?
" set sm

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set nobackup
" keep 500 lines of command line history
set history=500
" show the cursor position all the time
set ruler
" display incomplete commands
set showcmd
" do incremental searching
set incsearch
" highlight search results
set hlsearch
" buffers can exist in background without a window
set hidden

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

" For all text files set 'textwidth' to 80 characters.
autocmd FileType text setlocal textwidth=80

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

" always use utf-8
set encoding=utf-8

" stuff I mistype all the time
function! CommandCabbr(abbreviation, expansion)
      execute 'cabbr ' . a:abbreviation . ' <c-r>=getcmdpos() == 1 && getcmdtype() == ":" ? "' . a:expansion . '" : "' . a:abbreviation . '"<CR>'
endfunction
command! -nargs=+ CommandCabbr call CommandCabbr(<f-args>)
CommandCabbr Wq wq
CommandCabbr W w
CommandCabbr WQ wq
CommandCabbr Q q
CommandCabbr Q! q!
CommandCabbr E e
CommandCabbr E! e!
" cab Wq wq
" cab WQ wq
" cab W w
" cab Q q
" cab Q! q!
" cab E e
" cab E! e!

" remap ; to :. it's just one less keystroke, but all the time
" nnoremap ; :

" language specific stuff
set ai
" au FileType python set et sts=4 sw=4 ts=4
" au FileType ruby set et sts=2 sw=2 ts=2
" au FileType tex set sts=2 ts=2 sw=2 et iskeyword+=:
" au FileType tex let g:line_comment='% ' 
" au FileType scala set sts=2 ts=2 sw=2 et
" au FileType html set sts=2 ts=2 sw=2 et
" au FileType javascript set sts=2 ts=2 sw=2 et
" au FileType css set sts=2 ts=2 sw=2 et
" au FileType c set noet sts=2 sw=2 ts=2 nolist
au FileType cpp set et sts=2 sw=2 ts=2 list
" au FileType go set ts=2 sts=2 noet nolist
" au FileType c set ts=2 sts=2 noet nolist sw=2
" au FileType sh set ts=4 noet nolist noet
au FileType xml syntax off
au FileType json syntax off

set noswf " no swap file

" convenient mappings for paging through text
map <Space> <PageDown>
map J 10j
map <S-Space> <PageUp>
map K 10k


" GUI stuff
set gfn=Inconsolata:h15.00
set anti
set guioptions=emgrtL
colorscheme stephen-xoria

" Don't show these files in project and ctrlp, etc
set wildignore+=*.o,*.obj,.git,*.pyc,*.class,*.jar,.DS_Store,*.bak,.hg
set wildignore+=*.aux,*.bbl,*.blg,*.log,*.synctex.gz
" scala stuff
set wildignore+=target
" and hadoop stuff
set wildignore+=.*.crc

" Bindings and settings for FZF
map <silent> <leader>b :Buffers <CR>
" I like my fzf
let g:fzf_layout = {'down': '~20%'}

map <silent> <leader>F :call fzf#vim#files('~/working/proj', 0)<CR>
map <silent> <leader>f :call fzf#run(fzf#wrap({'source': 'fastproj'}))<CR>
map <silent> <leader>d :GFiles?<CR>

highlight Pmenu ctermbg=Black gui=bold ctermfg=Blue
highlight PmenuSel ctermbg=Blue gui=bold ctermfg=White
" ruler when longer than 80 characters
highlight ColorColumn ctermbg=236

let g:SuperTabDefaultCompletionType = "<C-X><C-O>"
let g:SuperTabDefaultCompletionType = "context"

" ctrl-A and ctrl-E mapped everywhere
inoremap <C-a> <Home>
cnoremap <C-a> <Home>
noremap <C-a> <Home>
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
map <Leader>V :so ~/.vimrc <CR> :echo "~/.vimrc loaded..." <CR>

set modeline
set ls=2

" close a window
nmap <Leader>q :q <Cr>

" show a line at 80 characters
if version >= 703
    set cc=88
endif

" trailing whitespace
set list
set listchars=tab:».,trail:· ",eol:¬
" test of white space 	  	asdf	asdf    

" options for latex-suite
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'

" and vim-latex
let g:Tex_MultipleCompileFormats="dvi,pdf"
let g:Tex_DefaultTargetFormat="pdf"
let g:Tex_CompileRule_pdf='pdflatex -synctex=1 --interaction=nonstopmode $*'
let g:Tex_GotoError=1
" i hate those damn placeholders
let g:Imap_UsePlaceHolders = 0

let g:Tex_IgnoreLevel=4
let g:Tex_IgnoredWarnings ='
      \"Underfull\n".
      \"Overfull\n".
      \"specifier changed to\n".
      \"You have requested\n".
      \"Missing number, treated as zero.\n".
      \"There were undefined references\n".
      \"Citation %.%# undefined\n".
      \"\oval, \circle, or \line size unavailable\n"'


au FileType tex nmap <Leader>B :split<CR><C-W>W:e bib.bib<CR>G
au FileType tex nmap <Leader>/ I% <Esc>
au FileType tex vmap <Leader>/ I% <Esc>
au FileType tex let b:autoformat_autoindent=0 " no auto format for latex
nmap <Leader>v :set paste<CR>:r !pbpaste<CR>:set nopaste<CR>

"let g:Tex_MainFileExpression = 'MainFile(modifier)'
"function! MainFile(fmod)
"    if glob('main.tex') != ''
"        return fnamemodify(glob('main.tex'), a:fmod)
"    else
"        return ''
"    endif
"endfunction

set synmaxcol=300

let g:go_doc_keywordprg_enabled=0
let g:go_def_mapping_enabled=0
au filetype crontab setlocal nobackup nowritebackup

" Persistent undo
let undodir = expand('~/.vim/undo')
if !isdirectory(undodir)
  call mkdir(undodir)
endif
set undodir=~/.vim/undo
set undofile " Create FILE.un~ files for persistent undo


" python's jedi-vim autocomplete options
let g:jedi#popup_on_dot = 0
let g:jedi#documentation_command = "<leader>k" " instead of default K
let g:jedi#popup_select_first = 0
let g:jedi#rename_command = "" " instead of <leader>r
let g:jedi#goto_command = "" " instead of default <leader>d
let g:jedi#use_splits_not_buffers="bottom"
au Filetype python setlocal completeopt-=preview

" ag is better and works on more of my computers
let g:ackprg = 'ag --nogroup --nocolor --column'

let g:vimtex_latexmk_callback = 0
let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
let g:vimtex_view_general_options = '-r @line @pdf @tex'

map <silent> <leader>r :AsyncRun lastrerun<CR>
map <silent> <leader>i :AsyncRun lastrerun -i<CR>
map <silent> <leader>a :Ag 
map <silent> <leader>h :History<CR>

map <silent> <leader>l :AsyncRun! -post=cw flake8 %<CR>:copen<CR><c-w><c-p>
map <silent> <leader>t :AsyncRun! -post=cw mypy %<CR>:copen<CR><c-w><c-p>
map <silent> <leader>c :ccl<CR>
set switchbuf=useopen
map <silent> <leader><space> :b#<CR>

" signify is a little faster if you tell it what vcs you care about
let g:signify_vcs_list = [ 'git', 'hg' ]
let g:signify_realtime = 0
" update often
let updatetime = 500
" auto read in file changes
set autoread
" Drives me nuts that the gutter appears and disappears constantly. always
" turn it on
set signcolumn=yes

let g:jedi#force_py_version=3

" show the branch in my powerline
let g:Powerline_symbols="compatible"

" black everywhere
let g:black_skip_string_normalization = 1
let g:autoblack = 1
autocmd BufWritePre *.py if g:autoblack | execute ':Black' | endif
