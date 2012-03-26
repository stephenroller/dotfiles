""" FocusMode
function! ToggleFocusMode()
  if (&foldcolumn != 12)
    set laststatus=0
    set numberwidth=10
    set foldcolumn=12
    set noruler
    hi FoldColumn ctermbg=none
    hi LineNr ctermfg=0 ctermbg=none
    hi NonText ctermfg=0
    set nonu
    set cc=
    set wrap
    set nolist
  else
    set laststatus=2
    set numberwidth=4
    set foldcolumn=0
    set ruler
    set nu
    set nowrap
    set list
    colorscheme stephen "re-call your colorscheme
  endif
endfunc
nnoremap <Leader>F :call ToggleFocusMode()<cr>
