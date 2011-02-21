let g:bufname = "*shell*"

command! -complete=shellcmd -nargs=+ Shell call s:RunShellCommand(<q-args>)
function! s:RunShellCommand(cmdline)
  let isfirst = 1
  let words = ['bash', '-c', '"']
  
  for word in split(a:cmdline)
    if isfirst
      let isfirst = 0  " don't change first word (shell command)
    else
      if word[0] =~ '\v[%#<]'
        let word = expand(word)
      endif
      " let word = shellescape(word, 1)
    endif
    call add(words, word)
  endfor
  call add(words, '"')
  let expanded_cmdline = join(words)

  if bufnr(g:bufname) == -1
    botright new
    file `=g:bufname`
    " hide buffer bufnr(g:bufname)
    setlocal buftype=nofile bufhidden=wipe noswapfile nowrap
    1
  else
    " shell buffer already exists
    execute bufnr(g:bufname) 'wincmd w'
    normal gg
    normal dG
  endif

  " call append(line("$"), a:cmdline. ': ')
  call append(line("$"), expanded_cmdline. ': ')
  " call append(line("$"), "")
  " call append(line("$"), "============================")
  silent execute '$read !'. expanded_cmdline
  " call append(line("$"), "")
  normal gg
  normal dd
  normal G
endfunction
