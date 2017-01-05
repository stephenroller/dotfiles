" vimtex - LaTeX plugin for Vim
"
" Maintainer: Karl Yngve Lervåg
" Email:      karl.yngve@gmail.com
"

function! vimtex#labels#init_options() " {{{1
  call vimtex#util#set_default('g:vimtex_labels_enabled', 1)
endfunction

" }}}1
function! vimtex#labels#init_buffer() " {{{1
  if !g:vimtex_labels_enabled | return | endif

  " Define commands
  command! -buffer VimtexLabelsOpen   call vimtex#labels#open()
  command! -buffer VimtexLabelsToggle call vimtex#labels#toggle()

  " Define mappings
  nnoremap <buffer> <plug>(vimtex-labels-open)   :call vimtex#labels#open()<cr>
  nnoremap <buffer> <plug>(vimtex-labels-toggle) :call vimtex#labels#toggle()<cr>
endfunction

" }}}1

function! vimtex#labels#open() " {{{1
  if vimtex#index#open(s:name) | return | endif

  let index = {}
  let index.name            = s:name
  let index.entries         = vimtex#labels#get_entries()
  let index.all_entries     = deepcopy(index.entries)
  let index.hook_init_post  = function('s:index_hook_init_post')
  let index.help            = [
        \ 'c:       clear filters',
        \ 'f:       filter',
        \ ]
  let index.clear_filter    = function('s:index_clear_filter')
  let index.filter          = function('s:index_filter')
  let index.syntax          = function('s:index_syntax')

  call vimtex#index#create(index)
endfunction

" }}}1
function! vimtex#labels#toggle() " {{{1
  if vimtex#index#open(s:name)
    call vimtex#index#close(s:name)
  else
    call vimtex#labels#open()
    silent execute 'wincmd w'
  endif
endfunction

" }}}1

function! vimtex#labels#get_entries(...) " {{{1
  if a:0 > 0
    let l:file = a:1
  elseif exists('b:vimtex')
    let l:file = b:vimtex.tex
  else
    return []
  endif

  let l:tac = []
  let l:preamble = 1
  for [l:file, l:lnum, l:line] in vimtex#parser#tex(l:file)
    if l:line =~# '\v^\s*\\begin\{document\}'
      let l:preamble = 0
    endif

    if l:preamble
      continue
    endif

    if l:line =~# '\v\\label\{'
      call add(tac, {
            \ 'title' : matchstr(l:line, '\v\\label\{\zs.{-}\ze\}'),
            \ 'file'  : l:file,
            \ 'line'  : l:lnum,
            \ })
      continue
    endif
  endfor
  return l:tac
endfunction

" }}}1

function! s:index_clear_filter() dict "{{{1
  let self.entries = copy(self.all_entries)
  call self.refresh()
endfunction

" }}}1
function! s:index_filter() dict "{{{1
  let filter = input('filter by: ')
  let self.entries = filter(self.entries, 'v:val.title =~# filter') 
  call self.refresh()
endfunction

" }}}1
function! s:index_hook_init_post() dict " {{{1
  nnoremap <buffer> <silent> c :call b:index.clear_filter()<cr>
  nnoremap <buffer> <silent> f :call b:index.filter()<cr>
endfunction

" }}}1
function! s:index_syntax() dict " {{{1
  syntax match VimtexLabelsLine /^.*$/      contains=@Tex
  syntax match VimtexLabelsChap /^chap:.*$/ contains=@Tex
  syntax match VimtexLabelsEq   /^eq:.*$/   contains=@Tex
  syntax match VimtexLabelsFig  /^fig:.*$/  contains=@Tex
  syntax match VimtexLabelsSec  /^sec:.*$/  contains=@Tex
  syntax match VimtexLabelsTab  /^tab:.*$/  contains=@Tex
  syntax match VimtexLabelsHelp /^.*: .*/
endfunction

" }}}1

" {{{1 Script initialization

let s:name = 'Table of labels (vimtex)'

call vimtex#util#set_highlight('VimtexLabelsHelp', 'helpVim')
call vimtex#util#set_highlight('VimtexLabelsLine', 'Todo')
call vimtex#util#set_highlight('VimtexLabelsChap', 'PreProc')
call vimtex#util#set_highlight('VimtexLabelsEq', 'Statement')
call vimtex#util#set_highlight('VimtexLabelsFig', 'Identifier')
call vimtex#util#set_highlight('VimtexLabelsSec', 'Type')
call vimtex#util#set_highlight('VimtexLabelsTab', 'String')

" }}}1

" vim: fdm=marker sw=2
