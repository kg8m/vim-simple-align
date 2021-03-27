let s:assert = themis#helper("assert")

let s:MARKDOWN_TABLE =<< MARKDOWN
aaa | b | ccccc
--- | --- | ---
d | ee | fff
あ | い | う
0 | 1
MARKDOWN

let s:MARKDOWN_TABLE_WITH_EDGE_BORDERS =<< MARKDOWN
| aaa | b | ccccc |
| --- | --- | --- |
| d | ee | fff |
| あ | い | う |
MARKDOWN

let s:VIM_SCRIPT =<< VIM
function Foo() abort
  let a = 1
  let bbb = 2
  let ccccc = 3

  return [a, bbb, ccccc]
endfunction
VIM

let s:GO =<< GO
func main() {
	a := 1
	bbb := 2
	ccccc := 3

	return a, bbb, ccccc
}
GO

let s:format = themis#suite("simple_align#formatter#format")
function s:format.aligns_tokens_with_1_space_around_each_delimiter_and_justifying_to_left_if_default_options_given() abort
  call setline(1, s:MARKDOWN_TABLE)

  let firstlnum    = 1
  let lastlnum     = firstlnum + 3
  let lines        = simple_align#lines#get(firstlnum, lastlnum)
  let options      = simple_align#options#default_values()
  let tokens_list  = simple_align#tokenizer#lines_to_tokens_list(lines, "|", options)
  let token_widths = simple_align#calculator#calculate_token_widths(tokens_list)

  let formatted_lines = [
  \   "aaa | b   | ccccc",
  \   "--- | --- | ---",
  \   "d   | ee  | fff",
  \   "あ  | い  | う",
  \ ]

  call simple_align#formatter#format(firstlnum, tokens_list, token_widths, options)
  call s:assert.equal(getline(firstlnum, lastlnum), formatted_lines)
endfunction

function s:format.aligns_tokens_with_spaces_around_each_delimiter_depending_on_padding_options() abort
  call setline(1, s:MARKDOWN_TABLE)

  let firstlnum    = 1
  let lastlnum     = firstlnum + 3
  let lines        = simple_align#lines#get(firstlnum, lastlnum)
  let options      = extend(copy(simple_align#options#default_values()), #{ lpadding: 0, rpadding: 0 })
  let tokens_list  = simple_align#tokenizer#lines_to_tokens_list(lines, "|", options)
  let token_widths = simple_align#calculator#calculate_token_widths(tokens_list)

  let formatted_lines = [
  \   "aaa|b  |ccccc",
  \   "---|---|---",
  \   "d  |ee |fff",
  \   "あ |い |う",
  \ ]

  call simple_align#formatter#format(firstlnum, tokens_list, token_widths, options)
  call s:assert.equal(getline(firstlnum, lastlnum), formatted_lines)
endfunction

function s:format.aligns_tokens_with_justifying_to_right_if_right_justify_option_given() abort
  call setline(1, s:MARKDOWN_TABLE)

  let firstlnum    = 1
  let lastlnum     = firstlnum + 3
  let lines        = simple_align#lines#get(firstlnum, lastlnum)
  let options = extend(copy(simple_align#options#default_values()), #{ justify: "right" })
  let tokens_list  = simple_align#tokenizer#lines_to_tokens_list(lines, "|", options)
  let token_widths = simple_align#calculator#calculate_token_widths(tokens_list)

  let formatted_lines = [
  \   "aaa |   b | ccccc",
  \   "--- | --- |   ---",
  \   "  d |  ee |   fff",
  \   " あ |  い |    う",
  \ ]

  call simple_align#formatter#format(firstlnum, tokens_list, token_widths, options)
  call s:assert.equal(getline(firstlnum, lastlnum), formatted_lines)
endfunction

function s:format.ignores_lacked_columns() abort
  call setline(1, s:MARKDOWN_TABLE)

  let firstlnum    = 1
  let lastlnum     = firstlnum + 4
  let lines        = simple_align#lines#get(firstlnum, lastlnum)
  let options      = simple_align#options#default_values()
  let tokens_list  = simple_align#tokenizer#lines_to_tokens_list(lines, "|", options)
  let token_widths = simple_align#calculator#calculate_token_widths(tokens_list)

  let formatted_lines = [
  \   "aaa | b   | ccccc",
  \   "--- | --- | ---",
  \   "d   | ee  | fff",
  \   "あ  | い  | う",
  \   "0   | 1",
  \ ]

  call simple_align#formatter#format(firstlnum, tokens_list, token_widths, options)
  call s:assert.equal(getline(firstlnum, lastlnum), formatted_lines)
endfunction

function s:format.no_problem_even_if_each_line_starts_and_ends_with_delimiter() abort
  call setline(1, s:MARKDOWN_TABLE_WITH_EDGE_BORDERS)

  let firstlnum    = 1
  let lastlnum     = firstlnum + 3
  let lines        = simple_align#lines#get(firstlnum, lastlnum)
  let options      = simple_align#options#default_values()
  let tokens_list  = simple_align#tokenizer#lines_to_tokens_list(lines, "|", options)
  let token_widths = simple_align#calculator#calculate_token_widths(tokens_list)

  let formatted_lines = [
  \   "| aaa | b   | ccccc |",
  \   "| --- | --- | ---   |",
  \   "| d   | ee  | fff   |",
  \   "| あ  | い  | う    |",
  \ ]

  call simple_align#formatter#format(firstlnum, tokens_list, token_widths, options)
  call s:assert.equal(getline(firstlnum, lastlnum), formatted_lines)
endfunction

function s:format.aligns_tokens_with_with_keeping_each_line_indentation() abort
  call setline(1, s:VIM_SCRIPT)

  let firstlnum    = 2
  let lastlnum     = firstlnum + 2
  let lines        = simple_align#lines#get(firstlnum, lastlnum)
  let options      = simple_align#options#default_values()
  let tokens_list  = simple_align#tokenizer#lines_to_tokens_list(lines, "=", options)
  let token_widths = simple_align#calculator#calculate_token_widths(tokens_list)

  let formatted_lines = [
  \   "  let a     = 1",
  \   "  let bbb   = 2",
  \   "  let ccccc = 3",
  \ ]

  call simple_align#formatter#format(firstlnum, tokens_list, token_widths, options)
  call s:assert.equal(getline(firstlnum, lastlnum), formatted_lines)
endfunction

function s:format.aligns_tokens_with_with_keeping_each_line_indentation_even_if_it_is_hard_tab() abort
  call setline(1, s:GO)

  let firstlnum    = 2
  let lastlnum     = firstlnum + 2
  let lines        = simple_align#lines#get(firstlnum, lastlnum)
  let options      = simple_align#options#default_values()
  let tokens_list  = simple_align#tokenizer#lines_to_tokens_list(lines, ":=", options)
  let token_widths = simple_align#calculator#calculate_token_widths(tokens_list)

  let formatted_lines = [
  \   "\ta     := 1",
  \   "\tbbb   := 2",
  \   "\tccccc := 3",
  \ ]

  call simple_align#formatter#format(firstlnum, tokens_list, token_widths, options)
  call s:assert.equal(getline(firstlnum, lastlnum), formatted_lines)
endfunction

function s:format.restores_lazyredraw_configuration() abort
  call setline(1, s:MARKDOWN_TABLE)

  let firstlnum    = 1  " aaa | b | ccccc
  let lastlnum     = firstlnum
  let lines        = simple_align#lines#get(firstlnum, lastlnum)
  let options      = simple_align#options#default_values()
  let tokens_list  = simple_align#tokenizer#lines_to_tokens_list(lines, "|", options)
  let token_widths = simple_align#calculator#calculate_token_widths(tokens_list)

  let original_lazyredraw = &lazyredraw
  call simple_align#formatter#format(firstlnum, tokens_list, token_widths, options)
  call s:assert.equal(&lazyredraw, original_lazyredraw)
endfunction

function s:format.restores_cursor_position() abort
  call setline(1, s:MARKDOWN_TABLE)

  let firstlnum    = 1  " aaa | b | ccccc
  let lastlnum     = firstlnum
  let lines        = simple_align#lines#get(firstlnum, lastlnum)
  let options      = simple_align#options#default_values()
  let tokens_list  = simple_align#tokenizer#lines_to_tokens_list(lines, "|", options)
  let token_widths = simple_align#calculator#calculate_token_widths(tokens_list)

  call cursor(1, 5)
  call simple_align#formatter#format(firstlnum, tokens_list, token_widths, options)
  call s:assert.equal(line("."), 1)
  call s:assert.equal(col("."), 5)
endfunction
