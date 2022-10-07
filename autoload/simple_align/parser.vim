vim9script

export def Parse(args: list<string>): dict<any>
  var delimiter = ""
  final options = extend({}, simple_align#options#DefaultValues())

  var option_waiting_for_value = ""

  for item in args
    if empty(option_waiting_for_value)
      if simple_align#options#IsOption(item)
        const option_name = simple_align#options#ArgumentToName(item)
        option_waiting_for_value = option_name
      elseif simple_align#options#IsShortOptionWithValue(item)
        # FIXME: `:dict<string>` is a workaround for preventing an error `E1229: Expected dictionary for using key
        # "name)", but got any`, that may be Vim9 script's bug.
        const extracted: dict<string> = simple_align#options#ExtractNameAndValue(item)

        if has_key(options, extracted.name)
          NotifyOptionValueOverwritten(extracted.name, options[extracted.name], extracted.value)
        endif

        options[extracted.name] = extracted.value
      else
        if !empty(delimiter)
          simple_align#logger#Info(
            printf("Delimiter `%s` has been overwritten by `%s`.", delimiter, item)
          )
        endif

        delimiter = item
      endif
    else
      const option_name = option_waiting_for_value
      option_waiting_for_value = ""

      if simple_align#options#IsValidValue(option_name, item)
        if has_key(options, option_name)
          NotifyOptionValueOverwritten(option_name, options[option_name], item)
        endif

        options[option_name] = item
      else
        simple_align#logger#Error(
          printf("Invalid value `%s` for the option `%s`.", item, option_name)
        )
      endif
    endif
  endfor

  for option_name in keys(options)
    options[option_name] = simple_align#options#NormalizeValue(option_name, options[option_name])
  endfor

  return { delimiter: delimiter, options: options }
enddef

def NotifyOptionValueOverwritten(option_name: string, old_value: any, new_value: any): void
  simple_align#logger#Info(
    printf("Value of option `%s` has been overwritten from `%s` to `%s`.", option_name, old_value, new_value)
  )
enddef
