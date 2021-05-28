if exists("g:loaded_simple_align")
  finish
endif
let g:loaded_simple_align = 1

command! -range -nargs=+ -complete=customlist,simple_align#options#completion_candidates SimpleAlign call simple_align#align(<line1>, <line2>, [<f-args>])
