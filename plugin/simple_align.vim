command! -range -nargs=+ -complete=customlist,simple_align#options#completion_candidates SimpleAlign call simple_align#align(<line1>, <line2>, [<f-args>])
