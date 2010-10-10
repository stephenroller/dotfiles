function! MakeScratch()
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal buflisted
endfunction

function! NewScratchBuffer()
    :botright new
    call MakeScratch()
endfunction

