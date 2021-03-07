function simple_align#logger#debug(...) abort
  echomsg "[simple-align] DEBUG - " .. a:000->copy()->map("string(v:val)")->join(" ")
endfunction

function simple_align#logger#info(...) abort
  echomsg "[simple-align] INFO - " .. a:000->join(" ")
endfunction

function simple_align#logger#error(...) abort
  echohl ErrorMsg
  echomsg "[simple-align] ERROR - " .. a:000->join(" ")
  echohl None
endfunction
