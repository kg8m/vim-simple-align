function simple_align#parser#parse(args) abort
  let delimiter = ""
  let options   = copy(simple_align#options#default_values())

  let option_waiting_for_value = ""

  for item in a:args
    if empty(option_waiting_for_value)
      if simple_align#options#is_option(item)
        let option_name = simple_align#options#argument_to_name(item)
        let option_waiting_for_value = option_name
      else
        if !empty(delimiter)
          call simple_align#logger#info(
          \   printf("Delimiter `%s` has been overwritten by `%s`.", delimiter, item)
          \ )
        endif

        let delimiter = item
      endif
    else
      let option_name = option_waiting_for_value
      let option_waiting_for_value = ""

      if simple_align#options#is_valid_value(option_name, item)
        let options[option_name] = item
      else
        call simple_align#logger#error(
        \   printf("Invalid value `%s` for the option `%s`.", item, option_name)
        \ )
      endif
    endif
  endfor

  for option_name in keys(options)
    let options[option_name] = simple_align#options#normalize_value(option_name, options[option_name])
  endfor

  return #{ delimiter: delimiter, options: options }
endfunction
