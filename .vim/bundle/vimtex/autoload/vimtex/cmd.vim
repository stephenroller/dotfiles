" vimtex - LaTeX plugin for Vim
"
" Maintainer: Karl Yngve Lervåg
" Email:      karl.yngve@gmail.com
"

function! vimtex#cmd#init_options() " {{{1
endfunction

" }}}1
function! vimtex#cmd#init_script() " {{{1
endfunction

" }}}1
function! vimtex#cmd#init_buffer() " {{{1
  nnoremap <silent><buffer> <plug>(vimtex-cmd-delete)
        \ :call vimtex#cmd#delete()<cr>

  nnoremap <silent><buffer> <plug>(vimtex-cmd-change)
        \ :call vimtex#cmd#change()<cr>

  nnoremap <silent><buffer> <plug>(vimtex-cmd-create)
        \ :call vimtex#cmd#create()<cr>

  inoremap <silent><buffer> <plug>(vimtex-cmd-create)
        \ <c-r>=vimtex#cmd#create()<cr>
endfunction

" }}}1

function! vimtex#cmd#change() " {{{1
  let l:cmd = vimtex#cmd#get_current()
  if empty(l:cmd) | return | endif

  let l:old_name = l:cmd.name
  let l:lnum = l:cmd.pos_start.lnum
  let l:cnum = l:cmd.pos_start.cnum

  " Get new command name
  call vimtex#echo#status(['Change command: ', ['VimtexWarning', l:old_name]])
  echohl VimtexMsg
  let l:new_name = input('> ')
  echohl None
  let l:new_name = substitute(l:new_name, '^\\', '', '')
  if empty(l:new_name) | return | endif

  " Update current position
  let l:save_pos = getpos('.')
  let l:save_pos[2] += strlen(l:new_name) - strlen(l:old_name) + 1

  " Perform the change
  let l:line = getline(l:lnum)
  call setline(l:lnum,
        \   strpart(l:line, 0, l:cnum)
        \ . l:new_name
        \ . strpart(l:line, l:cnum + strlen(l:old_name) - 1))

  " Restore cursor position and create repeat hook
  cal setpos('.', l:save_pos)
  silent! call repeat#set("\<plug>(vimtex-cmd-change)" . l:new_name . '', v:count)
endfunction

function! vimtex#cmd#delete() " {{{1
  let l:cmd = vimtex#cmd#get_current()
  if empty(l:cmd) | return | endif

  " Save current position
  let l:save_pos = getpos('.')
  let l:lnum_cur = l:save_pos[1]
  let l:cnum_cur = l:save_pos[2]

  " Remove closing bracket (if exactly one argument)
  if len(l:cmd.args) == 1
    let l:lnum = l:cmd.args[0].close.lnum
    let l:cnum = l:cmd.args[0].close.cnum
    let l:line = getline(l:lnum)
    call setline(l:lnum,
          \   strpart(l:line, 0, l:cnum - 1)
          \ . strpart(l:line, l:cnum))

    let l:cnum2 = l:cmd.args[0].open.cnum
  endif

  " Remove command (and possibly the opening bracket)
  let l:lnum = l:cmd.pos_start.lnum
  let l:cnum = l:cmd.pos_start.cnum
  let l:cnum2 = get(l:, 'cnum2', l:cnum + strlen(l:cmd.name) - 1)
  let l:line = getline(l:lnum)
  call setline(l:lnum,
        \   strpart(l:line, 0, l:cnum - 1)
        \ . strpart(l:line, l:cnum2))

  " Restore appropriate cursor position
  if l:lnum_cur == l:lnum
    if l:cnum_cur > l:cnum2
      let l:save_pos[2] -= l:cnum2 - l:cnum + 1
    else
      let l:save_pos[2] -= l:cnum_cur - l:cnum
    endif
  endif
  cal setpos('.', l:save_pos)

  " Create repeat hook
  silent! call repeat#set("\<plug>(vimtex-cmd-delete)", v:count)
endfunction

function! vimtex#cmd#create() " {{{1
  let l:re = '\v%(^|\A)\zs\w+\ze%(\A|$)'
  let l:c0 = col('.') - (mode() ==# 'i')

  let [l:l1, l:c1] = searchpos(l:re, 'bcn', line('.'))
  let l:c1 -= 1
  let l:line = getline(l:l1)
  let l:match = matchstr(l:line, l:re, l:c1)
  let l:c2 = l:c1 + strlen(l:match)

  if l:c0 > l:c2
    call vimtex#echo#status(['vimtex: ',
          \ ['VimtexWarning', 'Could not create command']])
    return ''
  endif

  let l:strpart1 = strpart(l:line, 0, l:c1)
  let l:strpart2 = '\' . l:match . '{'
  let l:strpart3 = strpart(l:line, l:c2)
  call setline(l:l1, l:strpart1 . l:strpart2 . l:strpart3)
  call setpos('.', [0, l:l1, l:c2+3, 0])

  if mode() ==# 'n'
    execute 'startinsert' . (empty(l:strpart3) ? '!' : '')
  endif
  return ''
endfunction

" }}}1

function! vimtex#cmd#get_next() " {{{1
  return s:get_cmd('next')
endfunction

" }}}1
function! vimtex#cmd#get_prev() " {{{1
  return s:get_cmd('prev')
endfunction

" }}}1
function! vimtex#cmd#get_current() " {{{1
  let pos = getpos('.')

  let depth = 3
  while depth > 0
    let depth -= 1
    let cmd = s:get_cmd('prev')
    if empty(cmd) | break | endif

    if 10000*pos[1] + pos[2] <= 10000*cmd.pos_end.lnum + cmd.pos_end.cnum
      return cmd
    endif
  endwhile

  return {}
endfunction

" }}}1
function! vimtex#cmd#get_at(lnum, cnum) " {{{1
  let l:pos_saved = getpos('.')
  call setpos('.', [0, a:lnum, a:cnum, 0])
  let l:cmd = vimtex#cmd#get_current()
  call setpos('.', l:pos_saved)
  return l:cmd
endfunction

" }}}1

function! s:get_cmd(direction) " {{{1
  let [lnum, cnum, match] = s:get_cmd_name(a:direction ==# 'next')
  if lnum == 0 | return {} | endif

  let res = {
        \ 'name' : match,
        \ 'pos_start' : { 'lnum' : lnum, 'cnum' : cnum },
        \ 'pos_end' : { 'lnum' : lnum, 'cnum' : cnum + strlen(match) - 1 },
        \ 'args' : [],
        \}

  " Environments always start with environment name and allows option
  " afterwords
  if res.name ==# '\begin'
    let arg = s:get_cmd_part('{', res.pos_end)
    call add(res.args, arg)
    let res.pos_end.lnum = arg.close.lnum
    let res.pos_end.cnum = arg.close.cnum
  endif

  " Get options
  let res.opt = s:get_cmd_part('[', res.pos_end)
  if !empty(res.opt)
    let res.pos_end.lnum = res.opt.close.lnum
    let res.pos_end.cnum = res.opt.close.cnum
  endif

  " Get arguments
  let arg = s:get_cmd_part('{', res.pos_end)
  while !empty(arg)
    call add(res.args, arg)
    let res.pos_end.lnum = arg.close.lnum
    let res.pos_end.cnum = arg.close.cnum
    let arg = s:get_cmd_part('{', res.pos_end)
  endwhile

  " Include entire cmd text
  let res.text = s:text_between(res.pos_start, res.pos_end, 1)

  return res
endfunction

" }}}1
function! s:get_cmd_name(next) " {{{1
  let [l:lnum, l:cnum] = searchpos('\\\a\+', a:next ? 'nW' : 'cbnW')
  let l:match = matchstr(getline(l:lnum), '^\\\a*', l:cnum-1)
  return [l:lnum, l:cnum, l:match]
endfunction

" }}}1
function! s:get_cmd_part(part, start_pos) " {{{1
  let l:save_pos = getpos('.')
  call setpos('.', [0, a:start_pos.lnum, a:start_pos.cnum, 0])
  let l:open = vimtex#delim#get_next('delim_tex', 'open')
  call setpos('.', l:save_pos)

  "
  " Ensure that the delimiter
  " 1) exists,
  " 2) is of the right type,
  " 3) and is the next non-whitespace character.
  "
  if empty(l:open)
        \ || l:open.match !=# a:part
        \ || strlen(substitute(
        \             s:text_between(a:start_pos, l:open), ' ', '', 'g')) != 0
    return {}
  endif

  let l:close = vimtex#delim#get_matching(l:open)
  if empty(l:close)
    return {}
  endif

  return {
        \ 'open' : l:open,
        \ 'close' : l:close,
        \ 'text' : s:text_between(l:open, l:close),
        \}
endfunction

" }}}1

function! s:text_between(p1, p2, ...) " {{{1
  let [l1, c1] = [a:p1.lnum, a:p1.cnum - (a:0 > 0)]
  let [l2, c2] = [a:p2.lnum, a:p2.cnum - (a:0 <= 0)]

  let lines = getline(l1, l2)
  if !empty(lines)
    let lines[0] = strpart(lines[0], c1)
    let lines[-1] = strpart(lines[-1], 0,
          \ l1 == l2 ? c2 - c1 : c2)
  endif
  return join(lines, '')
endfunction

" }}}1

" vim: fdm=marker sw=2
