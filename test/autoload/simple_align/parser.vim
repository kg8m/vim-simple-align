let s:assert = themis#helper("assert")

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
    \   #{ delimiter: args[0], options: #{ count: -1, lpadding: 1, rpadding: 1, justify: "left" } },
    \   "args: " .. string(args),
    \ )
  endfor
endfunction

function s:parse.returns_given_delimiter_and_options_if_delimiter_and_valid_options_given() abort
  let testcases = [
  \   #{
  \     args:     ["|", "-lpadding", "0"],
  \     expected: #{ delimiter: "|", options: #{ count: -1, lpadding: 0, rpadding: 1, justify: "left" } },
  \   },
  \   #{
  \     args:     ["=", "-count", "1"],
  \     expected: #{ delimiter: "=", options: #{ count: 1, lpadding: 1, rpadding: 1, justify: "left" } },
  \   },
  \   #{
  \     args:     ["\\s", "-lpadding", "0", "-rpadding", "0"],
  \     expected: #{ delimiter: "\\s", options: #{ count: -1, lpadding: 0, rpadding: 0, justify: "left" } },
  \   },
  \   #{
  \     args:     ["[^: ]\\+:", "-count", "2", "-lpadding", "0", "-rpadding", "1"],
  \     expected: #{ delimiter: "[^: ]\\+:", options: #{ count: 2, lpadding: 0, rpadding: 1, justify: "left" } },
  \   },
  \ ]

  for testcase in testcases
    call s:assert.equal(
    \   simple_align#parser#parse(testcase.args),
    \   testcase.expected,
    \   "testcase: " .. string(testcase),
    \ )
  endfor
endfunction

function s:parse.returns_given_delimiter_and_options_if_delimiter_and_valid_options_given_and_reversed() abort
  let testcases = [
  \   #{
  \     args:     ["-lpadding", "0", "|"],
  \     expected: #{ delimiter: "|", options: #{ count: -1, lpadding: 0, rpadding: 1, justify: "left" } },
  \   },
  \   #{
  \     args:     ["-count", "1", "="],
  \     expected: #{ delimiter: "=", options: #{ count: 1, lpadding: 1, rpadding: 1, justify: "left" } },
  \   },
  \   #{
  \     args:     ["-lpadding", "0", "-rpadding", "0", "\\s"],
  \     expected: #{ delimiter: "\\s", options: #{ count: -1, lpadding: 0, rpadding: 0, justify: "left" } },
  \   },
  \   #{
  \     args:     ["-count", "2", "-lpadding", "0", "-rpadding", "1", "[^: ]\\+:"],
  \     expected: #{ delimiter: "[^: ]\\+:", options: #{ count: 2, lpadding: 0, rpadding: 1, justify: "left" } },
  \   },
  \ ]

  for testcase in testcases
    call s:assert.equal(
    \   simple_align#parser#parse(testcase.args),
    \   testcase.expected,
    \   "testcase: " .. string(testcase),
    \ )
  endfor
endfunction

function s:parse.ignores_invalid_options_and_echo_error_message_if_invalid_value() abort
  let expected_options = #{
  \   count:    -1,
  \   lpadding: 1,
  \   rpadding: 1,
  \   justify:  "left",
  \ }
  let testcases = [
  \   #{ args: ["|", "-count", "-2"],             expected: #{ delimiter: "|", options: expected_options },     echo: v:true },
  \   #{ args: ["|", "-lpadding", "-rpadding"],   expected: #{ delimiter: "|", options: expected_options },     echo: v:true },
  \   #{ args: ["|", "-lpadding", "-count", "1"], expected: #{ delimiter: "1", options: expected_options },     echo: v:true },
  \   #{ args: ["|", "-lpaddin", "0"],            expected: #{ delimiter: "0", options: expected_options },     echo: v:false },
  \   #{ args: ["=", "-coun"],                    expected: #{ delimiter: "-coun", options: expected_options }, echo: v:false },
  \ ]

  for testcase in testcases
    messages clear

    call s:assert.equal(
    \   simple_align#parser#parse(testcase.args),
    \   testcase.expected,
    \   "testcase: " .. string(testcase),
    \ )

    call get(s:assert, testcase.echo ? "match" : "not_match")(
    \   execute("messages"),
    \   '\[simple-align\] ERROR - Invalid value .* for the option',
    \   "testcase: " .. string(testcase),
    \ )
  endfor
endfunction

function s:parse.overwrites_delimiter_with_latter_non_option_args_and_echo_info() abort
  let testcases = [
  \   #{
  \     args:     ["|", "="],
  \     expected: #{ delimiter: "=", options: #{ count: -1, lpadding: 1, rpadding: 1, justify: "left" } },
  \   },
  \   #{
  \     args:     ["|", "-count", "1", "="],
  \     expected: #{ delimiter: "=", options: #{ count: 1, lpadding: 1, rpadding: 1, justify: "left" } },
  \   },
  \ ]

  for testcase in testcases
    messages clear

    call s:assert.equal(
    \   simple_align#parser#parse(testcase.args),
    \   testcase.expected,
    \   "testcase: " .. string(testcase),
    \ )

    call s:assert.match(
    \   execute("messages"),
    \   '\[simple-align\] INFO - Delimiter .* has been overwritten by',
    \   "testcase: " .. string(testcase),
    \ )
  endfor
endfunction

function s:parse.overwrites_options_with_latter_options() abort
  let testcases = [
  \   #{
  \     args:     ["|", "-count", "1", "-count", "2"],
  \     expected: #{ delimiter: "|", options: #{ count: 2, lpadding: 1, rpadding: 1, justify: "left" } },
  \   },
  \   #{
  \     args:     ["|", "-lpadding", "0", "-lpadding", "1"],
  \     expected: #{ delimiter: "|", options: #{ count: -1, lpadding: 1, rpadding: 1, justify: "left" } },
  \   },
  \   #{
  \     args:     ["|", "-lpadding", "0", "-count", "1", "-lpadding", "1"],
  \     expected: #{ delimiter: "|", options: #{ count: 1, lpadding: 1, rpadding: 1, justify: "left" } },
  \   },
  \ ]

  for testcase in testcases
    call s:assert.equal(
    \   simple_align#parser#parse(testcase.args),
    \   testcase.expected,
    \   "testcase: " .. string(testcase),
    \ )
  endfor
endfunction

function s:parse.returns_empty_delimiter_and_default_options_if_empty_args_given() abort
  call s:assert.equal(
  \   simple_align#parser#parse([]),
  \   #{ delimiter: "", options: #{ count: -1, lpadding: 1, rpadding: 1, justify: "left" } },
  \ )
endfunction
