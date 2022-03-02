function simple_align#lines#get(from_lnum, to_lnum) abort
  return getline(a:from_lnum, a:to_lnum)
endfunction
