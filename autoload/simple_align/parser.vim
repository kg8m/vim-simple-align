vim9script

def simple_align#parser#parse(args: list<string>): dict<any>
  var delimiter = ""
  final options = extend({}, simple_align#options#default_values())

  var option_waiting_for_value = ""

  for item in args
    if empty(option_waiting_for_value)
      if simple_align#options#is_option(item)
        const option_name = simple_align#options#argument_to_name(item)
        option_waiting_for_value = option_name
      elseif simple_align#options#is_short_option_with_value(item)
        const extracted = simple_align#options#extract_name_and_value(item)

        if has_key(options, extracted.name)
          s:notify_option_value_overwritten(extracted.name, options[extracted.name], extracted.value)
        endif

        options[extracted.name] = extracted.value
      else
        if !empty(delimiter)
          simple_align#logger#info(
            printf("Delimiter `%s` has been overwritten by `%s`.", delimiter, item)
          )
        endif

        delimiter = item
      endif
    else
      const option_name = option_waiting_for_value
      option_waiting_for_value = ""

      if simple_align#options#is_valid_value(option_name, item)
        if has_key(options, option_name)
          s:notify_option_value_overwritten(option_name, options[option_name], item)
        endif

        options[option_name] = item
      else
        simple_align#logger#error(
          printf("Invalid value `%s` for the option `%s`.", item, option_name)
        )
      endif
    endif
  endfor

  for option_name in keys(options)
    options[option_name] = simple_align#options#normalize_value(option_name, options[option_name])
  endfor

  return { delimiter: delimiter, options: options }
enddef

def s:notify_option_value_overwritten(option_name: string, old_value: any, new_value: any): void
  simple_align#logger#info(
    printf("Value of option `%s` has been overwritten from `%s` to `%s`.", option_name, old_value, new_value)
  )
enddef
