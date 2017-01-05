" vimtex - LaTeX plugin for Vim
"
" Maintainer: Karl Yngve Lervåg
" Email:      karl.yngve@gmail.com
"

function! vimtex#delim#init_options() " {{{1
  call vimtex#util#set_default('g:vimtex_delim_toggle_mod_list',
        \ [['\left', '\right']])
  call vimtex#util#set_default('g:vimtex_delim_stopline', 500)
endfunction

" }}}1
function! vimtex#delim#init_script() " {{{1
  let s:stopline = g:vimtex_delim_stopline

  let s:delims = {}
  let s:re = {}

  let s:delims.env = {
        \ 'list' : [
        \   ['begin', 'end'],
        \  ],
        \ 're' : [
        \   ['\\begin\s*{[^}]*}', '\\end\s*{[^}]*}'],
        \  ],
        \}

  let s:delims.env_math = {
        \ 'list' : [
        \   ['\(', '\)'],
        \   ['\[', '\]'],
        \   ['$$', '$$'],
        \   ['$', '$'],
        \  ],
        \ 're' : [
        \   ['\\(', '\\)'],
        \   ['\\\[', '\\\]'],
        \   ['\$\$', '\$\$'],
        \   ['\$', '\$'],
        \  ],
        \}

  let s:delims.delim_tex = {
        \ 'list' : [
        \   ['[', ']'],
        \   ['{', '}'],
        \  ],
        \ 're' : [
        \   ['\[', '\]'],
        \   ['{', '}'],
        \ ],
        \}

  let s:delims.delim_mods = {
        \ 'list' : [
        \   ['\left', '\right'],
        \   ['\bigl', '\bigr'],
        \   ['\Bigl', '\Bigr'],
        \   ['\biggl', '\biggr'],
        \   ['\Biggl', '\Biggr'],
        \   ['\big', '\big'],
        \   ['\Big', '\Big'],
        \   ['\bigg', '\bigg'],
        \   ['\Bigg', '\Bigg'],
        \ ],
        \ 're' : [
        \   ['\\left', '\\right'],
        \   ['\\bigl', '\\bigr'],
        \   ['\\Bigl', '\\Bigr'],
        \   ['\\biggl', '\\biggr'],
        \   ['\\Biggl', '\\Biggr'],
        \   ['\\big', '\\big'],
        \   ['\\Big', '\\Big'],
        \   ['\\bigg', '\\bigg'],
        \   ['\\Bigg', '\\Bigg'],
        \ ],
        \}

  let s:delims.delim_math = {
        \ 'list' : [
        \   ['(', ')'],
        \   ['[', ']'],
        \   ['\{', '\}'],
        \   ['\langle', '\rangle'],
        \   ['\lvert', '\rvert'],
        \   ['\lfloor', '\rfloor'],
        \   ['\lceil', '\rceil'],
        \   ['\ulcorner', '\urcorner'],
        \  ],
        \ 're' : [
        \   ['(', ')'],
        \   ['\[', '\]'],
        \   ['\\{', '\\}'],
        \   ['\\langle', '\\rangle'],
        \   ['\\lvert', '\\rvert'],
        \   ['\\lfloor', '\\rfloor'],
        \   ['\\lceil', '\\rceil'],
        \   ['\\ulcorner', '\\urcorner'],
        \  ],
        \}

  let s:re.env = {
        \ 'open' : '\%('
        \   . join(map(copy(s:delims.env.re), 'v:val[0]'), '\|')
        \   . '\)',
        \ 'close' : '\%('
        \   . join(map(copy(s:delims.env.re), 'v:val[1]'), '\|')
        \   . '\)',
        \ 'both' : '\%('
        \   . join(map(copy(s:delims.env.re), 'v:val[0]'), '\|') . '\|'
        \   . join(map(copy(s:delims.env.re), 'v:val[1]'), '\|')
        \   . '\)'
        \}

  let s:re.env_math = {
        \ 'open' : '\%('
        \   . join(map(copy(s:delims.env_math.re), 'v:val[0]'), '\|')
        \   . '\)',
        \ 'close' : '\%('
        \   . join(map(copy(s:delims.env_math.re), 'v:val[1]'), '\|')
        \   . '\)',
        \ 'both' : '\%('
        \   . join(map(copy(s:delims.env_math.re), 'v:val[0]'), '\|') . '\|'
        \   . join(map(copy(s:delims.env_math.re), 'v:val[1]'), '\|')
        \   . '\)'
        \}

  let s:re.delim_tex = {
        \ 'open' : '\%('
        \   . join(map(copy(s:delims.delim_tex.re), 'v:val[0]'), '\|')
        \   . '\)',
        \ 'close' : '\%('
        \   . join(map(copy(s:delims.delim_tex.re), 'v:val[1]'), '\|')
        \   . '\)',
        \ 'both' : '\%('
        \   . join(map(copy(s:delims.delim_tex.re), 'v:val[0]'), '\|') . '\|'
        \   . join(map(copy(s:delims.delim_tex.re), 'v:val[1]'), '\|')
        \   . '\)'
        \}

  let s:re.delim_mods = {
        \ 'open' : '\\left\|\\[bB]igg\?l\?',
        \ 'close' : '\\right\|\\[bB]igg\?r\?',
        \ 'both' : '\\left\|\\right\|\\[bB]igg\?[lr]\?',
        \}

  let s:re.delim_math = {
        \ 'open' : '\%(\%(' . s:re.delim_mods.open . '\)\s*\)\?\%('
        \   . join(map(copy(s:delims.delim_math.re), 'v:val[0]'), '\|')
        \   . '\)\|\\left\s*\.',
        \ 'close' : '\%(\%(' . s:re.delim_mods.close . '\)\s*\)\?\%('
        \   . join(map(copy(s:delims.delim_math.re), 'v:val[1]'), '\|')
        \   . '\)\|\\right\s*\.',
        \ 'both' : '\%(\%(' . s:re.delim_mods.both . '\)\s*\)\?\%('
        \   . join(map(copy(s:delims.delim_math.re), 'v:val[0]'), '\|') . '\|'
        \   . join(map(copy(s:delims.delim_math.re), 'v:val[1]'), '\|')
        \   . '\)\|\\\%(left\|right\)\s*\.',
        \}

  let s:delims.env_all = {}
  let s:delims.delim_all = {}
  let s:delims.all = {}
  let s:re.env_all = {}
  let s:re.delim_all = {}
  let s:re.all = {}
  for k in ['list', 're']
    let s:delims.env_all[k] = s:delims.env[k] + s:delims.env_math[k]
    let s:delims.delim_all[k] = s:delims.delim_math[k] + s:delims.delim_tex[k]
    let s:delims.all[k] = s:delims.env_all[k] + s:delims.delim_all[k]
  endfor
  for k in ['open', 'close', 'both']
    let s:re.env_all[k] = s:re.env[k] . '\|' . s:re.env_math[k]
    let s:re.delim_all[k] = s:re.delim_math[k] . '\|' . s:re.delim_tex[k]
    let s:re.all[k] = s:re.env_all[k] . '\|' . s:re.delim_all[k]
  endfor

  let s:types = [
        \ {
        \   're' : '\\\%(begin\|end\)\>',
        \   'parser' : function('s:parser_env'),
        \ },
        \ {
        \   're' : '\$\$\?',
        \   'parser' : function('s:parser_tex'),
        \ },
        \ {
        \   're' : '\\\%((\|)\|\[\|\]\)',
        \   'parser' : function('s:parser_latex'),
        \ },
        \ {
        \   're' : '\\\%(left\|right\)\s*\.',
        \   'parser' : function('s:parser_delim_unmatched'),
        \ },
        \ {
        \   're' : s:re.delim_all.both,
        \   'parser' : function('s:parser_delim'),
        \ },
        \]
endfunction

" }}}1
function! vimtex#delim#init_buffer() " {{{1
  nnoremap <silent><buffer> <plug>(vimtex-delim-toggle-modifier)
        \ :call vimtex#delim#toggle_modifier()<cr>

  xnoremap <silent><buffer> <plug>(vimtex-delim-toggle-modifier)
        \ :<c-u>call vimtex#delim#toggle_modifier_visual()<cr>

  inoremap <silent><buffer> <plug>(vimtex-delim-close)
        \ <c-r>=vimtex#delim#close()<cr>
endfunction

" }}}1

function! vimtex#delim#get_delim_regexes(...) " {{{1
  return exists('s:re')
        \ ? [s:re.delim_math.open, s:re.delim_math.close,
        \    s:re.delim_tex.open,  s:re.delim_tex.close]
        \ : []
endfunction

" }}}1
function! vimtex#delim#close() " {{{1
  let l:save_pos = getpos('.')
  let l:pos_val_cursor = 10000*l:save_pos[1] + l:save_pos[2]

  let l:lnum = l:save_pos[1] + 1
  while l:lnum > 1
    let l:open  = vimtex#delim#get_prev('all', 'open',
          \ { 'syn_exclude' : 'texComment' })
    if empty(l:open) || get(l:open, 'name', '') ==# 'document'
      break
    endif

    let l:close = vimtex#delim#get_matching(l:open)
    if empty(l:close.match)
      call setpos('.', l:save_pos)
      return l:open.corr
    endif

    let l:pos_val_try = 10000*l:close.lnum
          \ + l:close.cnum + strlen(l:close.match)
    if l:pos_val_try > l:pos_val_cursor
      call setpos('.', l:save_pos)
      return l:open.corr
    else
      let l:lnum = l:open.lnum
      call setpos('.', s:pos_prev(l:open.lnum, l:open.cnum))
    endif
  endwhile

  call setpos('.', l:save_pos)
  return ''
endfunction

" }}}1
function! vimtex#delim#toggle_modifier(...) " {{{1
  let [l:open, l:close] = a:0 == 2
        \ ? [a:1, a:2]
        \ : vimtex#delim#get_surrounding('delim_math')
  if empty(l:open) | return | endif

  let newmods = ['', '']
  let modlist = [['', '']] + g:vimtex_delim_toggle_mod_list
  let n = len(modlist)
  for i in range(n)
    let j = (i + 1) % n
    if l:open.mod ==# modlist[i][0]
      let newmods = modlist[j]
      break
    endif
  endfor

  let line = getline(l:open.lnum)
  let line = strpart(line, 0, l:open.cnum - 1)
        \ . newmods[0]
        \ . strpart(line, l:open.cnum + len(l:open.mod) - 1)
  call setline(l:open.lnum, line)

  let l:cnum = l:close.cnum
  if l:open.lnum == l:close.lnum
    let n = len(newmods[0]) - len(l:open.mod)
    let l:cnum += n
    let pos = getpos('.')
    if pos[2] > l:open.cnum + len(l:open.mod)
      let pos[2] += n
      call setpos('.', pos)
    endif
  endif

  let line = getline(l:close.lnum)
  let line = strpart(line, 0, l:cnum - 1)
        \ . newmods[1]
        \ . strpart(line, l:cnum + len(l:close.mod) - 1)
  call setline(l:close.lnum, line)

  silent! call repeat#set("\<plug>(vimtex-delim-toggle-modifier)", v:count)

  return newmods
endfunction

" }}}1
function! vimtex#delim#toggle_modifier_visual() " {{{1
  let l:save_pos = getpos('.')
  let l:start_pos = getpos("'<")
  let l:end_pos = getpos("'>")
  let l:end_pos_val = 10000*l:end_pos[1] + min([l:end_pos[2], 1000])
  let l:cur_pos = l:start_pos
  let l:cur_pos_val = 10000*l:cur_pos[1] + l:cur_pos[2]

  "
  " Check if selection is swapped
  "
  let l:end_pos[1] += 1
  call setpos("'>", l:end_pos)
  let l:end_pos[1] -= 1
  normal! gv
  let l:swapped = l:start_pos != getpos("'<")

  "
  " First we generate a stack of all delimiters that should be toggled
  "
  let l:stack = []
  while l:cur_pos_val < l:end_pos_val
    call setpos('.', l:cur_pos)
    let l:open = vimtex#delim#get_next('delim_math', 'open')
    if empty(l:open) | break | endif

    let l:open_pos_val = 10000*l:open.lnum + l:open.cnum
    if l:open_pos_val >= l:end_pos_val
      break
    endif

    let l:close = vimtex#delim#get_matching(l:open)
    if !empty(l:close)
      if l:end_pos_val >= 10000*l:close.lnum + l:close.cnum
            \ + strlen(l:close.match) - 1
        let l:newmods = vimtex#delim#toggle_modifier(l:open, l:close)

        let l:col_diff  = (l:open.lnum == l:end_pos[1])
              \ ? strlen(newmods[0]) - strlen(l:open.mod) : 0
        let l:col_diff += (l:close.lnum == l:end_pos[1])
              \ ? strlen(newmods[1]) - strlen(l:close.mod) : 0

        if l:col_diff != 0
          let l:end_pos[2] += l:col_diff
          let l:end_pos_val += l:col_diff
        endif
      endif
    endif

    let l:cur_pos = s:pos_next(l:open.lnum, l:open.cnum)
    let l:cur_pos_val = 10000*l:cur_pos[1] + l:cur_pos[2]
  endwhile

  "
  " Finally we return to original position and reselect the region
  "
  call setpos(l:swapped? "'>" : "'<", l:start_pos)
  call setpos(l:swapped? "'<" : "'>", l:end_pos)
  call setpos('.', l:save_pos)
  normal! gv
endfunction

" }}}1

function! vimtex#delim#get_next(type, side, ...) " {{{1
  return s:get_delim(extend({
        \ 'direction' : 'next',
        \ 'type' : a:type,
        \ 'side' : a:side,
        \}, get(a:, '1', {})))
endfunction

" }}}1
function! vimtex#delim#get_prev(type, side, ...) " {{{1
  return s:get_delim(extend({
        \ 'direction' : 'prev',
        \ 'type' : a:type,
        \ 'side' : a:side,
        \}, get(a:, '1', {})))
endfunction

" }}}1
function! vimtex#delim#get_current(type, side, ...) " {{{1
  return s:get_delim(extend({
        \ 'direction' : 'current',
        \ 'type' : a:type,
        \ 'side' : a:side,
        \}, get(a:, '1', {})))
endfunction

" }}}1
function! vimtex#delim#get_matching(delim) " {{{1
  if empty(a:delim) || !has_key(a:delim, 'lnum') | return {} | endif

  "
  " Get the matching position
  "
  let l:save_pos = getpos('.')
  call setpos('.', [0, a:delim.lnum, a:delim.cnum, 0])
  let [l:match, l:lnum, l:cnum] = a:delim.get_matching()
  call setpos('.', l:save_pos)

  "
  " Create the match result
  "
  let l:matching = deepcopy(a:delim)
  let l:matching.lnum = l:lnum
  let l:matching.cnum = l:cnum
  let l:matching.match = l:match
  let l:matching.corr  = a:delim.match
  let l:matching.side = a:delim.is_open ? 'close' : 'open'
  let l:matching.is_open = !a:delim.is_open
  let l:matching.re.corr = a:delim.re.this
  let l:matching.re.this = a:delim.re.corr

  if l:matching.type ==# 'delim'
    let l:matching.corr_delim = a:delim.delim
    let l:matching.corr_mod = a:delim.mod
    let l:matching.delim = a:delim.corr_delim
    let l:matching.mod = a:delim.corr_mod
  elseif l:matching.type ==# 'env' && has_key(l:matching, 'name')
    if l:matching.is_open
      let l:matching.env_cmd = vimtex#cmd#get_at(l:lnum, l:cnum)
    else
      unlet l:matching.env_cmd
    endif
  endif

  return l:matching
endfunction

" }}}1
function! vimtex#delim#get_surrounding(type) " {{{1
  let l:save_pos = getpos('.')
  let l:lnum = l:save_pos[1] + 1
  let l:pos_val_cursor = 10000*l:save_pos[1] + l:save_pos[2]

  while l:lnum > 1
    let l:open  = vimtex#delim#get_prev(a:type, 'open')
    if empty(l:open) | break | endif
    let l:close = vimtex#delim#get_matching(l:open)
    let l:pos_val_try = 10000*l:close.lnum
          \ + l:close.cnum + strlen(l:close.match)
    if l:pos_val_try > l:pos_val_cursor
      call setpos('.', l:save_pos)
      return [l:open, l:close]
    else
      let l:lnum = l:open.lnum
      call setpos('.', s:pos_prev(l:open.lnum, l:open.cnum))
    endif
  endwhile

  call setpos('.', l:save_pos)
  return [{}, {}]
endfunction

" }}}1

function! s:get_delim(opts) " {{{1
  "
  " Arguments:
  "   opts = {
  "     'direction'   :  next
  "                      prev
  "                      current
  "     'type'        :  env
  "                      env_math
  "                      env_all
  "                      delim_tex
  "                      delim_math
  "                      delim_all
  "                      all
  "     'side'        :  open
  "                      close
  "                      both
  "     'syn_exclude' :  Don't match in given syntax
  "  }
  "
  " Returns:
  "   delim = {
  "     type    : env | delim
  "     side    : open | close
  "     name    : name of environment [only for type env]
  "     lnum    : number
  "     cnum    : number
  "     match   : unparsed matched delimiter
  "     corr    : corresponding delimiter
  "     re : {
  "       open  : regexp for the opening part
  "       close : regexp for the closing part
  "     }
  "   }
  "
  let l:save_pos = getpos('.')
  let l:re = s:re[a:opts.type][a:opts.side]
  while 1
    let [l:lnum, l:cnum] = a:opts.direction ==# 'next'
          \ ? searchpos(l:re, 'cnW', line('.') + s:stopline)
          \ : a:opts.direction ==# 'prev'
          \   ? searchpos(l:re, 'bcnW', max([line('.') - s:stopline, 1]))
          \   : searchpos(l:re, 'bcnW', line('.'))
    if l:lnum == 0 | break | endif

    if has_key(a:opts, 'syn_exclude')
          \ && vimtex#util#in_syntax(a:opts.syn_exclude, l:lnum, l:cnum)
      call setpos('.', s:pos_prev(l:lnum, l:cnum))
      continue
    endif

    break
  endwhile
  call setpos('.', l:save_pos)

  let l:match = matchstr(getline(l:lnum), '^' . l:re, l:cnum-1)

  if a:opts.direction ==# 'current'
        \ && l:cnum + strlen(l:match) + (mode() ==# 'i' ? 1 : 0) <= col('.')
    let l:match = ''
    let l:lnum = 0
    let l:cnum = 0
  endif

  let l:result = {
        \ 'type' : '',
        \ 'lnum' : l:lnum,
        \ 'cnum' : l:cnum,
        \ 'match' : l:match,
        \}

  for l:type in s:types
    if l:match =~# '^' . l:type.re
      let l:result = extend(
            \ l:type.parser(l:match, l:lnum, l:cnum,
            \               a:opts.side, a:opts.type, a:opts.direction),
            \ l:result, 'keep')
      break
    endif
  endfor

  return empty(l:result.type) ? {} : l:result
endfunction

" }}}1

function! s:parser_env(match, lnum, cnum, ...) " {{{1
  let result = {}

  let result.type = 'env'
  let result.name = matchstr(a:match, '{\zs\k*\ze\*\?}')
  let result.starred = match(a:match, '\*}$') > 0
  let result.side = a:match =~# '\\begin' ? 'open' : 'close'
  let result.is_open = result.side ==# 'open'
  let result.get_matching = function('s:get_matching_env')

  if result.is_open
    let result.env_cmd = vimtex#cmd#get_at(a:lnum, a:cnum)
  endif

  let result.corr = result.is_open
        \ ? substitute(a:match, 'begin', 'end', '')
        \ : substitute(a:match, 'end', 'begin', '')

  let result.re = {
        \ 'open' : '\\begin\s*{' . result.name . '\*\?}',
        \ 'close' : '\\end\s*{' . result.name . '\*\?}',
        \}

  let result.re.this = result.is_open ? result.re.open  : result.re.close
  let result.re.corr = result.is_open ? result.re.close : result.re.open

  return result
endfunction

" }}}1
function! s:parser_tex(match, lnum, cnum, side, type, direction) " {{{1
  "
  " TeX shorthand are these
  "
  "   $ ... $   (inline math)
  "   $$ ... $$ (displayed equations)
  "
  " The notation does not provide the delimiter side directly, which provides
  " a slight problem. However, we can utilize the syntax information to parse
  " the side.
  "
  let result = {}
  let result.type = 'env'
  let result.corr = a:match
  let result.get_matching = function('s:get_matching_tex')
  let result.re = {
        \ 'this'  : escape(a:match, '$'),
        \ 'corr'  : escape(a:match, '$'),
        \ 'open'  : escape(a:match, '$'),
        \ 'close' : escape(a:match, '$'),
        \}
  let result.side = vimtex#util#in_syntax(
        \   (a:match ==# '$' ? 'texMathZoneX' : 'texMathZoneY'),
        \   a:lnum, a:cnum+1)
        \ ? 'open' : 'close'
  let result.is_open = result.side ==# 'open'

  if (a:side !=# 'both') && (a:side !=# result.side)
    "
    " The current match ($ or $$) is not the correct side, so we must
    " continue the search recursively. We do this by changing the cursor
    " position, since the function searchpos relies on the current cursor
    " position.
    "
    let l:save_pos = getpos('.')

    " Move the cursor
    call setpos('.', a:direction ==# 'next'
          \ ? s:pos_next(a:lnum, a:cnum)
          \ : s:pos_prev(a:lnum, a:cnum))

    " Get new result
    let result = s:get_delim({
          \ 'direction' : a:direction,
          \ 'type' : a:type,
          \ 'side' : a:side,
          \})

    " Restore the cursor
    call setpos('.', l:save_pos)
  endif

  return result
endfunction

" }}}1
function! s:parser_latex(match, lnum, cnum, ...) " {{{1
  let result = {}

  let result.type = 'env'
  let result.side = a:match =~# '\\(\|\\\[' ? 'open' : 'close'
  let result.is_open = result.side ==# 'open'
  let result.get_matching = function('s:get_matching_latex')

  let result.corr = result.is_open
        \ ? substitute(substitute(a:match, '\[', ']', ''), '(', ')', '')
        \ : substitute(substitute(a:match, '\]', '[', ''), ')', '(', '')

  let result.re = {
        \ 'open'  : a:match =~# '\\(\|\\)' ? '\\(' : '\\\[',
        \ 'close' : a:match =~# '\\(\|\\)' ? '\\)' : '\\\]',
        \}

  let result.re.this = result.is_open ? result.re.open  : result.re.close
  let result.re.corr = result.is_open ? result.re.close : result.re.open

  return result
endfunction

" }}}1
function! s:parser_delim(match, lnum, cnum, ...) " {{{1
  let result = {}
  let result.type = 'delim'
  let result.side = a:match =~# s:re.delim_all.open ? 'open' : 'close'
  let result.is_open = result.side ==# 'open'
  let result.get_matching = function('s:get_matching_delim')

  "
  " Find corresponding delimiter and the regexps
  "
  if a:match =~# '^' . s:re.delim_mods.both
    let m1 = matchstr(a:match, '^' . s:re.delim_mods.both)
    let d1 = substitute(strpart(a:match, len(m1)), '^\s*', '', '')
    let s1 = !result.is_open
    let re1 = s:parser_delim_get_regexp(m1, s1, 'delim_mods')
          \  . '\s*' . s:parser_delim_get_regexp(d1, s1, 'delim_math')

    let m2 = s:parser_delim_get_corr(m1, 'delim_mods')
    let d2 = s:parser_delim_get_corr(d1, 'delim_math')
    let s2 = result.is_open
    let re2 = s:parser_delim_get_regexp(m2, s2, 'delim_mods') . '\s*'
          \ . (m1 =~# '\\\%(left\|right\)'
          \   ? '\%(' . s:parser_delim_get_regexp(d2, s2, 'delim_math') . '\|\.\)'
          \   : s:parser_delim_get_regexp(d2, s2, 'delim_math'))
  else
    let d1 = a:match
    let m1 = ''
    let re1 = s:parser_delim_get_regexp(a:match, !result.is_open)

    let d2 = s:parser_delim_get_corr(a:match)
    let m2 = ''
    let re2 = s:parser_delim_get_regexp(d2, result.is_open)
  endif

  let result.delim = d1
  let result.mod = m1
  let result.corr = m2 . d2
  let result.corr_delim = d2
  let result.corr_mod = m2
  let result.re = {
        \ 'this'  : re1,
        \ 'corr'  : re2,
        \ 'open'  : result.is_open ? re1 : re2,
        \ 'close' : result.is_open ? re2 : re1,
        \}

  return result
endfunction

" }}}1
function! s:parser_delim_unmatched(match, lnum, cnum, ...) " {{{1
  let result = {}
  let result.type = 'delim'
  let result.side = a:match =~# s:re.delim_all.open ? 'open' : 'close'
  let result.is_open = result.side ==# 'open'
  let result.get_matching = function('s:get_matching_delim_unmatched')
  let result.delim = '.'
  let result.corr_delim = '.'

  "
  " Find corresponding delimiter and the regexps
  "
  if result.is_open
    let result.mod = '\left'
    let result.corr_mod = '\right'
    let result.corr = '\right.'
    let re1 = '\\left\s*\.'
    let re2 = s:parser_delim_get_regexp('\right', 1, 'delim_mods')
          \  . '\s*' . s:parser_delim_get_regexp('.', 1)
  else
    let result.mod = '\right'
    let result.corr_mod = '\left'
    let result.corr = '\left.'
    let re1 = '\\right\s*\.'
    let re2 = s:parser_delim_get_regexp('\left', 0, 'delim_mods')
          \  . '\s*' . s:parser_delim_get_regexp('.', 0)
  endif

  let result.re = {
        \ 'this'  : re1,
        \ 'corr'  : re2,
        \ 'open'  : result.is_open ? re1 : re2,
        \ 'close' : result.is_open ? re2 : re1,
        \}

  return result
endfunction

" }}}1
function! s:parser_delim_get_regexp(delim, side, ...) " {{{1
  let l:type = a:0 > 0 ? a:1 : 'delim_all'

  " First check unmatched
  if a:delim ==# '.'
    return '\%(' . join(map(copy(s:delims.delim_math.re),
          \ 'v:val[' . a:side . ']'), '\|') . '\)'
  endif

  " Next check normal delimiters
  let index = index(map(copy(s:delims[l:type].list),
        \ 'v:val[' . a:side . ']'), a:delim)
  return (index >= 0)
        \ ? s:delims[l:type].re[index][a:side]
        \ : ''
endfunction

" }}}1
function! s:parser_delim_get_corr(delim, ...) " {{{1
  let l:type = a:0 > 0 ? a:1 : 'delim_all'

  for l:pair in s:delims[l:type].list
    if a:delim ==# l:pair[0]
      return l:pair[1]
    elseif a:delim ==# l:pair[1]
      return l:pair[0]
    endif
  endfor
endfunction

" }}}1

function! s:get_matching_env() dict " {{{1
  let [re, flags, stopline] = self.is_open
        \ ? [self.re.close,  'nW', line('.') + s:stopline]
        \ : [self.re.open,  'bnW', max([line('.') - s:stopline, 1])]

  let [lnum, cnum] = searchpairpos(self.re.open, '', self.re.close,
        \ flags, '', stopline)
  let match = matchstr(getline(lnum), '^' . re, cnum-1)

  return [match, lnum, cnum]
endfunction

" }}}1
function! s:get_matching_tex() dict " {{{1
  let [re, flags, stopline] = self.is_open
        \ ? [self.re.open,  'nW', line('.') + s:stopline]
        \ : [self.re.open, 'bnW', max([line('.') - s:stopline, 1])]

  let [lnum, cnum] = searchpos(re, flags, stopline)
  let match = matchstr(getline(lnum), '^' . re, cnum-1)

  return [match, lnum, cnum]
endfunction

" }}}1
function! s:get_matching_latex() dict " {{{1
  let [re, flags, stopline] = self.is_open
        \ ? [self.re.close, 'nW', line('.') + s:stopline]
        \ : [self.re.open, 'bnW', max([line('.') - s:stopline, 1])]

  let [lnum, cnum] = searchpos(re, flags, stopline)
  let match = matchstr(getline(lnum), '^' . re, cnum-1)

  return [match, lnum, cnum]
endfunction

" }}}1
function! s:get_matching_delim() dict " {{{1
  let [re, flags, stopline] = self.is_open
        \ ? [self.re.close,  'nW', line('.') + s:stopline]
        \ : [self.re.open,  'bnW', max([line('.') - s:stopline, 1])]

  let [lnum, cnum] = searchpairpos(self.re.open, '', self.re.close,
        \ flags, '', stopline)
  let match = matchstr(getline(lnum), '^' . re, cnum-1)

  return [match, lnum, cnum]
endfunction

" }}}1
function! s:get_matching_delim_unmatched() dict " {{{1
  let [re, flags, stopline] = self.is_open
        \ ? [self.re.close,  'nW', line('.') + s:stopline]
        \ : [self.re.open,  'bnW', max([line('.') - s:stopline, 1])]

  let tries = 0
  let misses = []
  while 1
    let [lnum, cnum] = searchpairpos(self.re.open, '', self.re.close, flags,
          \ 'index(misses, [line("."), col(".")]) >= 0', stopline)
    let match = matchstr(getline(lnum), '^' . re, cnum-1)
    if lnum == 0 | break | endif

    let cand = vimtex#delim#get_matching(extend({
          \ 'type' : '',
          \ 'lnum' : lnum,
          \ 'cnum' : cnum,
          \ 'match' : match,
          \}, s:parser_delim(match, lnum, cnum)))

    if !empty(cand) && [self.lnum, self.cnum] == [cand.lnum, cand.cnum]
      return [match, lnum, cnum]
    else
      let misses += [[lnum, cnum]]
      let tries += 1
      if tries == 10 | break | endif
    endif
  endwhile

  return ['', 0, 0]
endfunction

" }}}1

function! s:pos_next(lnum, cnum) " {{{1
    return a:cnum < strlen(getline(a:lnum))
          \ ? [0, a:lnum, a:cnum+1, 0]
          \ : [0, a:lnum+1, 1, 0]
endfunction

" }}}1
function! s:pos_prev(lnum, cnum) " {{{1
    return a:cnum > 1
          \ ? [0, a:lnum, a:cnum-1, 0]
          \ : [0, max([a:lnum-1, 1]), strlen(getline(a:lnum-1)), 0]
endfunction

" }}}1

" vim: fdm=marker sw=2
