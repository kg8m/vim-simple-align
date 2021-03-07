command! -range -nargs=+ -complete=customlist,simple_align#options#completion_candidates SimpleAlign <line1>,<line2>call simple_align#align([<f-args>])
