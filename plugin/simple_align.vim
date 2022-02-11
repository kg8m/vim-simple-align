if exists("g:loaded_simple_align")
  finish
endif
let g:loaded_simple_align = 1

command! -range -nargs=+ -complete=customlist,simple_align#options#CompletionCandidates SimpleAlign call simple_align#Align(<line1>, <line2>, [<f-args>])
