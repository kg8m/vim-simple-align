function simple_align#parser#parse(args) abort
  let delimiter = ""
  let options   = copy(simple_align#options#default_values())

  let option_waiting_for_value = ""

  for item in a:args
    if empty(option_waiting_for_value)
      if simple_align#options#is_option(item)
        let option_name = simple_align#options#argument_to_name(item)
        let option_waiting_for_value = option_name
      elseif simple_align#options#is_short_option_with_value(item)
        let extracted = simple_align#options#extract_name_and_value(item)

        if has_key(options, extracted.name)
          call s:notify_option_value_overwritten(extracted.name, options[extracted.name], extracted.value)
        endif

        let options[extracted.name] = extracted.value
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
        if has_key(options, option_name)
          call s:notify_option_value_overwritten(option_name, options[option_name], item)
        endif

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

function s:notify_option_value_overwritten(option_name, old_value, new_value) abort
  call simple_align#logger#info(
  \   printf("Value of option `%s` has been overwritten from `%s` to `%s`.", a:option_name, a:old_value, a:new_value)
  \ )
endfunction
