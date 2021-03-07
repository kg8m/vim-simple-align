let s:assert = themis#helper("assert")

let s:DEFAULT_OPTIONS = #{
\   count:    -1,
\   lpadding: 1,
\   rpadding: 1,
\   justify:  "left",
\ }

let s:parse = themis#suite("simple_align#parser#parse")
function s:parse.returns_given_delimiter_and_default_options_if_only_delimiter_given() abort
  let args_list = [
  \   ["|"],
  \   ["="],
  \   ["\\s"],
  \   ["[^: ]\\+:\\s"],
  \ ]

  for args in args_list
    call s:assert.equal(
    \   simple_align#parser#parse(args),
    \   #{ delimiter: args[0], options: s:DEFAULT_OPTIONS },
    \   "args: " .. string(args),
    \ )
  endfor
endfunction

function s:parse.returns_given_delimiter_and_options_if_delimiter_and_valid_options_given() abort
  let testcases = [
  \   #{ args: ["|", "-lpadding", "0"], expected: #{ delimiter: "|", options: #{ lpadding: 0 } } },
  \   #{ args: ["=", "-count", "1"],    expected: #{ delimiter: "=", options: #{ count: 1 } } },
  \   #{
  \     args:     ["\\s", "-lpadding", "0", "-rpadding", "0"],
  \     expected: #{ delimiter: "\\s", options: #{ lpadding: 0, rpadding: 0 } },
  \   },
  \   #{
  \     args:     ["[^: ]\\+:", "-count", "2", "-lpadding", "0", "-rpadding", "1"],
  \     expected: #{ delimiter: "[^: ]\\+:", options: #{ count: 2, lpadding: 0, rpadding: 1 } },
  \   },
  \ ]

  for testcase in testcases
    let expected_options = extend(copy(s:DEFAULT_OPTIONS), testcase.expected.options)
    let expected         = extend(copy(testcase.expected), #{ options: expected_options })

    call s:assert.equal(
    \   simple_align#parser#parse(testcase.args),
    \   expected,
    \   "testcase: " .. string(testcase),
    \ )
  endfor
endfunction

function s:parse.returns_given_delimiter_and_options_if_delimiter_and_valid_options_given_and_reversed() abort
  let testcases = [
  \   #{ args: ["-lpadding", "0", "|"], expected: #{ delimiter: "|", options: #{ lpadding: 0 } } },
  \   #{ args: ["-count", "1", "="],    expected: #{ delimiter: "=", options: #{ count: 1 } } },
  \   #{
  \     args:     ["-lpadding", "0", "-rpadding", "0", "\\s"],
  \     expected: #{ delimiter: "\\s", options: #{ lpadding: 0, rpadding: 0 } },
  \   },
  \   #{
  \     args:     ["-count", "2", "-lpadding", "0", "-rpadding", "1", "[^: ]\\+:"],
  \     expected: #{ delimiter: "[^: ]\\+:", options: #{ count: 2, lpadding: 0, rpadding: 1 } },
  \   },
  \ ]

  for testcase in testcases
    let expected_options = extend(copy(s:DEFAULT_OPTIONS), testcase.expected.options)
    let expected         = extend(copy(testcase.expected), #{ options: expected_options })

    call s:assert.equal(
    \   simple_align#parser#parse(testcase.args),
    \   expected,
    \   "testcase: " .. string(testcase),
    \ )
  endfor
endfunction

function s:parse.ignores_invalid_options_and_echo_error_message_if_invalid_value() abort
  let testcases = [
  \   #{ args: ["|", "-count", "-2"],             expected: #{ delimiter: "|", options: {} },     echo: v:true },
  \   #{ args: ["|", "-lpadding", "-rpadding"],   expected: #{ delimiter: "|", options: {} },     echo: v:true },
  \   #{ args: ["|", "-lpadding", "-count", "1"], expected: #{ delimiter: "1", options: {} },     echo: v:true },
  \   #{ args: ["|", "-lpaddin", "0"],            expected: #{ delimiter: "0", options: {} },     echo: v:false },
  \   #{ args: ["=", "-coun"],                    expected: #{ delimiter: "-coun", options: {} }, echo: v:false },
  \ ]

  for testcase in testcases
    messages clear

    let expected_options = extend(copy(s:DEFAULT_OPTIONS), testcase.expected.options)
    let expected         = extend(copy(testcase.expected), #{ options: expected_options })

    call s:assert.equal(
    \   simple_align#parser#parse(testcase.args),
    \   expected,
    \   "testcase: " .. string(testcase),
    \ )

    call get(s:assert, testcase.echo ? "match" : "not_match")(
    \   execute("messages"),
    \   'Invalid value',
    \   "testcase: " .. string(testcase),
    \ )
  endfor
endfunction

function s:parse.overwrites_delimiter_with_latter_non_option_args_and_echo_info() abort
  let testcases = [
  \   #{ args: ["|", "="],                expected: #{ delimiter: "=", options: {} } },
  \   #{ args: ["|", "-count", "1", "="], expected: #{ delimiter: "=", options: #{ count: 1 } } },
  \ ]

  for testcase in testcases
    let expected_options = extend(copy(s:DEFAULT_OPTIONS), testcase.expected.options)
    let expected         = extend(copy(testcase.expected), #{ options: expected_options })

    call s:assert.equal(
    \   simple_align#parser#parse(testcase.args),
    \   expected,
    \   "testcase: " .. string(testcase),
    \ )

    call s:assert.match(
    \   execute("messages"),
    \   'Delimiter .* has been overwritten by',
    \   "testcase: " .. string(testcase),
    \ )
  endfor
endfunction

function s:parse.overwrites_options_with_latter_options() abort
  let testcases = [
  \   #{
  \     args:     ["|", "-count", "1", "-count", "2"],
  \     expected: #{ delimiter: "|", options: #{ count: 2 } },
  \   },
  \   #{
  \     args:     ["|", "-lpadding", "0", "-lpadding", "1"],
  \     expected: #{ delimiter: "|", options: #{ lpadding: 1 } },
  \   },
  \   #{
  \     args:     ["|", "-lpadding", "0", "-count", "1", "-lpadding", "1"],
  \     expected: #{ delimiter: "|", options: #{ count: 1, lpadding: 1 } },
  \   },
  \ ]

  for testcase in testcases
    let expected_options = extend(copy(s:DEFAULT_OPTIONS), testcase.expected.options)
    let expected         = extend(copy(testcase.expected), #{ options: expected_options })

    call s:assert.equal(
    \   simple_align#parser#parse(testcase.args),
    \   expected,
    \   "testcase: " .. string(testcase),
    \ )
  endfor
endfunction

function s:parse.returns_empty_delimiter_and_default_options_if_empty_args_given() abort
  call s:assert.equal(
  \   simple_align#parser#parse([]),
  \   #{ delimiter: "", options: s:DEFAULT_OPTIONS },
  \ )
endfunction
