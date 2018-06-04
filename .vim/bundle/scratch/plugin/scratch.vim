function! MakeScratch()
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal buflisted
endfunction

function! NewScratchBuffer()
    botright new
    call MakeScratch()
endfunction

function! HgDiff()
    call NewScratchBuffer()
    read !hg diff
    setfiletype git-diff
    set ro
    normal gg
endfunction
