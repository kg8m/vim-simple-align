function simple_align#logger#debug(...) abort
  echomsg "[simple-align] DEBUG - " .. join(map(copy(a:000), "string(v:val)"), " ")
endfunction

function simple_align#logger#info(...) abort
  echomsg "[simple-align] INFO - " .. join(a:000, " ")
endfunction

function simple_align#logger#error(...) abort
  echohl ErrorMsg
  echomsg "[simple-align] ERROR - " .. join(a:000, " ")
  echohl None
endfunction
