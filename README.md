vim-simple-align
==================================================

A Vim plugin to align texts by simple way.

* vim-simple-align provides only 1 command and a few its options
  * no need to remember options because they can be completed
* delimiter used to split texts is always Vim's regular expression

vim-simple-align doesn't cover all alignment cases but aims to work nice in many common cases.

![vim-simple-align-demo](https://user-images.githubusercontent.com/694547/110630529-cdcb9880-81e8-11eb-93c1-7c6fed199663.gif)


Commands/Usage
--------------------------------------------------

vim-simple-align provides only 1 command: `:SimpleAlign`.

Usage:

```vim
:{RANGE}SimpleAlign {DELIMITER}[ {OPTIONS}]
```

Delimiter is Vim's regular expression. Some characters may need to be escaped.

cf. `:h regular-expression`


### Options

#### `-count` option

`-count` option means how many times to split and align tokens. Available values are `-1` and integers greater than 0. `-1` means unlimited.

Default: `-1`


#### `-lpadding` option

`-lpadding` option means how many spaces to put left padding of each token. Available values are integers greater than or equal to 0.

Default: `1`


#### `-rpadding` option

`-rpadding` option means how many spaces to put right padding of each token. Available values are integers greater than or equal to 0.

Default: `1`


#### `-justify` option

`-justify` option means which side tokens should be on. Available values are `left` and `right`.

Default: `left`


Examples
--------------------------------------------------

### Align Markdown table

#### Not aligned

```md
a | bbb | ccccc
--- | --- | ---
012345 | 6 | 789
.. | .. | ..
```

```md
| a | bbb | ccccc |
| --- | --- | --- |
| 012345 | 6 | 789 |
| .. | .. | .. |
```


#### Command

```vim
:1,4SimpleAlign |
```


#### Aligned

```md
a      | bbb | ccccc
---    | --- | ---
012345 | 6   | 789
..     | ..  | ..
```

```md
| a      | bbb | ccccc |
| ---    | --- | ---   |
| 012345 | 6   | 789   |
| ..     | ..  | ..    |
```


### Align Markdown table with justifying to right

#### Not aligned

```md
a | bbb | ccccc
--- | --- | ---
012345 | 6 | 789
.. | .. | ..
```

```md
| a | bbb | ccccc |
| --- | --- | --- |
| 012345 | 6 | 789 |
| .. | .. | .. |
```


#### Command

```vim
:1,4SimpleAlign | -justify right
```


#### Aligned

```md
     a | bbb | ccccc
   --- | --- |   ---
012345 |   6 |   789
    .. |  .. |    ..
```

```md
|      a | bbb | ccccc |
|    --- | --- |   --- |
| 012345 |   6 |   789 |
|     .. |  .. |    .. |
```


### Align JSON, dictionary/hash items

#### Not aligned

```json
{
  "a": "a",
  "bbb": "bbb",
  "ccccc": "ccccc"
}
```

```js
{
  a: "a",
  bbb: "bbb",
  ccccc: "ccccc",
}
```

```rb
{
  "a" => "a",
  "bbb" => "bbb",
  "ccccc" => "ccccc",
}
```


#### Command

For JSON:

```vim
:2,4SimpleAlign [^:\ ]\+:
```

For JavaScript dictionary:

```vim
:2,4SimpleAlign \w\+:
```

For Ruby old Hash syntax:

```vim
:2,4SimpleAlign =>
```


#### Aligned

```json
{
  "a":     "a",
  "bbb":   "bbb",
  "ccccc": "ccccc"
}
```

```js
{
  a:     "a",
  bbb:   "bbb",
  ccccc: "ccccc",
}
```

```rb
{
  "a"     => "a",
  "bbb"   => "bbb",
  "ccccc" => "ccccc",
}
```


### Align variable assginments

#### Not aligned

```js
const a = "a";
const bbb = "bbb";
const ccccc = "ccccc";
```

```js
const a = "a";
const bbb = "bbb";
const ccccc = "ccccc";
const d = (a === bbb)
```

```rb
a = "a"
a += "a"
```


#### Command

For basic case:

```vim
:1,3SimpleAlign =
```

For the case when multiple `=`s exist:

```vim
:1,4SimpleAlign = -count 1
```

For `=` and `+=`:

```vim
:1,2SimpleAlign [+\ ]=
```


#### Aligned

```js
const a     = "a";
const bbb   = "bbb";
const ccccc = "ccccc";
```

```js
const a     = "a";
const bbb   = "bbb";
const ccccc = "ccccc";
const d     = (a === bbb)
```

```rb
a  = "a"
a += "a"
```


### Align output/result comments

#### Not aligned

```js
a() //=> "a"
bbb() //=> "bbb"
ccccc() //=> "ccccc"
```

```rb
a #=> "a"
bbb #=> "bbb"
ccccc #=> "ccccc"
```


#### Command

For JavaScript:

```vim
:1,3SimpleAlign //=> -lpadding 2
```

For Ruby:

```vim
:1,3SimpleAlign #=> -lpadding 2
```


#### Aligned

```js
a()      //=> "a"
bbb()    //=> "bbb"
ccccc()  //=> "ccccc"
```

```rb
a      #=> "a"
bbb    #=> "bbb"
ccccc  #=> "ccccc"
```


### Align non-whitespace characters

#### Not aligned

```rb
t.belongs_to :user, null: false
t.string :name, null: false
t.boolean :active, null: false, default: true
t.boolean :foo, null: true, default: false
```


#### Command

```vim
:1,4SimpleAlign \S\+ -lpadding 0
```


#### Aligned

```rb
t.belongs_to :user,   null: false
t.string     :name,   null: false
t.boolean    :active, null: false, default: true
t.boolean    :foo,    null: true,  default: false
```


Why not vim-easy-align?
--------------------------------------------------

Yes, [vim-easy-align](https://github.com/junegunn/vim-easy-align) is a great Vim plugin. However, it is complicated and difficult for me. I can't remember its mappings, options, and syntaxes. It is a so cool product, but not for me.


Installation
--------------------------------------------------

If you use [dein.vim](https://github.com/Shougo/dein.vim):

```vim
call dein#add("kg8m/vim-simple-align")
```

Note: dein.vim's lazy loading feature with `on_cmd` option is not recommended for vim-simple-align. You will see `E471: Argument required: '<,'>SimpleAlign` if so. Anyway, lazy loading of vim-simple-align doesn't make Vim's startup faster because vim-simple-align just defines 1 command when added to `runtimepath`. dein.vim's lazy loading with `on_cmd` also defines a dummy command.


Requirements
--------------------------------------------------

Vim 8.2+ or Neovim nightly
