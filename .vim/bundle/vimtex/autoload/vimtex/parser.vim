" vimtex - LaTeX plugin for Vim
"
" Maintainer: Karl Yngve Lervåg
" Email:      karl.yngve@gmail.com
"

function! vimtex#parser#init_options() " {{{1
endfunction

" }}}1
function! vimtex#parser#init_script() " {{{1
  let s:input_line_tex = '\v^\s*\\%(' . join([
        \ 'input',
        \ 'include',
        \ '%(sub)?import',
        \ '%(sub)?%(input|include)from',
        \ 'subfile',
        \ ], '|') . ')\s*\{'
  let s:input_line_aux = '\\@input{'
endfunction

" }}}1
function! vimtex#parser#init_buffer() " {{{1
endfunction

" }}}1

"
" Define tex and aux parsers
"
function! vimtex#parser#tex(file, ...) " {{{1
  let s:prev_parsed = ''
  return s:parser(a:file, extend({
        \   'detailed' : 1,
        \   'input_re' : s:input_line_tex,
        \   'input_parser' : 's:input_line_parser_tex',
        \ },
        \ a:0 > 0 ? a:1 : {}))
endfunction

" }}}1
function! vimtex#parser#aux(file, ...) " {{{1
  let s:prev_parsed = ''
  return s:parser(a:file, extend({
        \   'detailed' : 0,
        \   'input_re' : s:input_line_aux,
        \   'input_parser' : 's:input_line_parser_aux',
        \ },
        \ a:0 > 0 ? a:1 : {}))
endfunction

" }}}1

"
" Get list of externalfile entries
"
function! vimtex#parser#get_externalfiles() " {{{1
  let l:preamble = s:parser(b:vimtex.tex, {
        \ 're_stop' : '\\begin{document}',
        \ 'input_re' : s:input_line_tex,
        \ 'input_parser' : 's:input_line_parser_tex',
        \ })

  let l:result = []
  for l:line in filter(l:preamble, 'v:val =~# ''\\externaldocument''')
    let l:name = matchstr(l:line, '{\zs[^}]*\ze}')
    call add(l:result, {
          \ 'tex' : l:name . '.tex',
          \ 'aux' : l:name . '.aux',
          \ 'opt' : matchstr(l:line, '\[\zs[^]]*\ze\]'),
          \ })
  endfor

  return l:result
endfunction

" }}}1

"
" Define the main parser function
"
function! s:parser(file, opts) " {{{1
  if !filereadable(a:file) || s:prev_parsed ==# a:file
    return []
  endif
  let s:prev_parsed = a:file

  let l:parsed = []
  let l:lnum = 0
  for l:line in readfile(a:file)
    let l:lnum += 1

    if get(a:opts, 'finished', 0)
      break
    endif

    if has_key(a:opts, 're_stop') && l:line =~# a:opts.re_stop
      let a:opts.finished = 1
      break
    endif

    if l:line =~# a:opts.input_re
      let l:file = call(a:opts.input_parser, [l:line, a:file, a:opts.input_re])
      call extend(l:parsed, s:parser(l:file, a:opts))
      continue
    endif

    if get(a:opts, 'detailed', 0)
      call add(l:parsed, [a:file, l:lnum, l:line])
    else
      call add(l:parsed, l:line)
    endif
  endfor

  return l:parsed
endfunction

" }}}1

"
" Input line parsers
"
function! s:input_line_parser_tex(line, file, re) " {{{1
  " Handle \space commands
  let l:file = substitute(a:line, '\\space\s*', ' ', 'g')

  " Handle import package commands
  let l:subimport = 0
  if l:file =~# '\v\\%(sub)?%(import|%(input|include)from)'
    let l:candidate = s:input_line_parser_tex(
          \ substitute(l:file, '\\\w*\s*{[^{}]*}\s*', '', ''),
          \ a:file,
          \ '\v^\s*\{')
    if !empty(l:candidate) | return l:candidate | endif

    " Handle relative paths
    let l:subimport = l:file =~# '\v\\sub%(import|%(input|include)from)'

    let l:file = substitute(l:file, '}\s*{', '', 'g')
  endif

  " Parse file name
  let l:file = matchstr(l:file, a:re . '\zs[^\}]+\ze}')

  " Trim whitespaces and quotes from beginning/end of string
  let l:file = substitute(l:file, '^\(\s\|"\)*', '', '')
  let l:file = substitute(l:file, '\(\s\|"\)*$', '', '')

  " Ensure that the file name has extension
  if l:file !~# '\.tex$'
    let l:file .= '.tex'
  endif

  " Use absolute paths
  if l:file !~# '\v^(\/|[A-Z]:)'
    let l:file = (l:subimport ? fnamemodify(a:file, ':h') : b:vimtex.root) . '/' . l:file
  endif

  " Only return filename if it is readable
  return filereadable(l:file) ? l:file : ''
endfunction

" }}}1
function! s:input_line_parser_aux(line, file, re) " {{{1
  let l:file = matchstr(a:line, a:re . '\zs[^}]\+\ze}')

  " Remove extension to simplify the parsing (e.g. for "my file name".aux)
  let l:file = substitute(l:file, '\.aux', '', '')

  " Trim whitespaces and quotes from beginning/end of string, append extension
  let l:file = substitute(l:file, '^\(\s\|"\)*', '', '')
  let l:file = substitute(l:file, '\(\s\|"\)*$', '', '')
  let l:file .= '.aux'

  " Use absolute paths
  if l:file !~# '\v^(\/|[A-Z]:)'
    let l:file = fnamemodify(a:file, ':p:h') . '/' . l:file
  endif

  " Only return filename if it is readable
  return filereadable(l:file) ? l:file : ''
endfunction

" }}}1

" vim: fdm=marker sw=2
