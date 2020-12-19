function! s:OnTermExit(job_id, code, event)
    :q
endfunction

function! s:OpenTerm(...)
    botright new
    resize 12
    startinsert
    if a:0 == 0
        call termopen(&shell, {'on_exit': function('s:OnTermExit')})
    else
        call termopen(a:000)
    end
endfunction

command! -nargs=* T call s:OpenTerm(<f-args>)
