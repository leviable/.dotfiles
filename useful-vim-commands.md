# Useful VIM commands

<!--toc:start-->
- [Useful VIM commands](#useful-vim-commands)
  - [LazyVIM config](#lazyvim-config)
  - [Buffers](#buffers)
  - [Inserting](#inserting)
  - [Go To (`g`)](#go-to-g)
  - [Yank](#yank)
  - [Visual (highlighting)](#visual-highlighting)
  - [Seek](#seek)
  - [Moving around](#moving-around)
  - [UI and formatting](#ui-and-formatting)
  - [`z` mode](#z-mode)
  - [Code specific](#code-specific)
    - [Surround](#surround)
  - [Misc](#misc)
<!--toc:end-->

## LazyVIM config

- `<space>fc`: Easily navigate to VIM config files
- Change number scheme on the left:
  - Edit `~/.config/nvim/lua/config/options.lua`: `vim.opt.relativenumber = false`

## Buffers

- New buffer: `space+f+n`

## Inserting

-
- `A`: Like `I`, but will enter into insert mode at end of line

## Go To (`g`)

- `gi`: "Go to the last place I inserted and enter insert mode"
- `ge`: "end of previous word", similar to but slightly different from `be`
- `g*` `g#`: Like `*` and `#`, but will match other words too
         (e.g. `g*` on `wil` will match `will`, whereas `*` wont)
- `gd` : Go to local declaration
- `gD` : Go to global declaration
- `gv` : Go to last visual selection
- `gsh(` : Highlight the parenthesis that encapsulate your position
         Can be useful as a dry run before a bigger task, like `d`

## Yank

- `yig` : Yank the entire buffer (page)
  - `cig` : Scrap everything and start over

## Visual (highlighting)

- `vic` `vif`: Highlight all text WITHIN class/function
- `vac` `vaf`: Highlight all text OF class/function
- `vap`: Highlight all text OF paragraph, will also include the whitespace above
       or below (but not both?)
- `vip`: Highlight all text OF paragraph, will NOT include the whitespace above
       or below
- `va?` : brings up a prompt for the user to select left and right tags to match
- `<alt>+j` `<alt>+k` : You can select lines and use these to move the selection
                    up and down. In Warp terminal you need to go to
                    settings -> features -> keys and select use left alt as
                    meta. Need to enable mini.move by adding this to init.lua
                    `require("mini.move").setup()`
- `viW` : Use for selecting bash variable, `$MY_VAR`
  - `viWgsa"` : "Visual surround Word, including `$`, and insert double quotes
              around it"
  - TODO: Add this as a fast command in LazyVIM?

## Seek

- `flash` mode (aka `seek` mode): navigate to anything you can currently see
  - Type `s`, followed by the first text of what you see. The
   text will by highlighted, followed by a red letter. Type
   that letter to jump there
- `cS` : This is really neat. Do a verb followed by `S`. You will be presented
       with selections of text objects, and you select the one you want the
       verb to act on
- `R` : `R`emote mode. This is awesome but tough to explain. Like `S`eek mode,
      but you don't need to be within the object for it to work. Example
      use: Type `vR`, the screen grays out. You type a letter within the
      object you want to highlight, then you cat a seek-like display of
      options to chose from. You select that option, and then the verb,
      `v` is applied to that text object
- `r` : similar to `R`, but jumps you do the seek obj and leaves you in
      operator pending mode. You co another verb and action

## Moving around

- `find` mode: navigate to next instance of `<char>`
  - Type `f`, followed by the first text of what you see. Can prefix
   with a number to jump multiples
- `til` mode (aka `to` mode): like `find`, but jumps to just before
- `w`: beginning of next word
  - `W`: like `w`, but based on whitespace (`w` will take punctuation into consideration)

    ``` txt
        myObj.methodName('foo', 'bar', 'baz')
        -----ww---------w-w--w--ww--w--ww--w---->
        ------------------------W------W-------->


- `e` : end of current word

  - `ge`: end of previous word
- `b`: beginning of current word
  - `B`: like `b`, but based on whitespace (`b` will take punctuation into consideration)
- `ctrl+i`: like `ctrl+o`, but jumps you forward in history
- `(` `)` : Move to the next "sentence"; first whitespace after `.` `?` or `!`,
        or first blank line
- `{` `}` : Move to the next blank line
- `[` `]` : "Go to next thing-under-cursor" :
  - `]f` : go to the start of the next function
  - `]F` : go to end of current function
  - `]c` : go to the start of the next class
  - `]C` : go to the end of the current class
  - A bunch more, hit `[` or `]` for menu
  - `]]` : Jump to next reference of thing under cursor
    - This works fine in python but not rust, whats up with that?
  - `]}` : is neat, jump to the next `}` for the block you are in. It will bypass
         any other `}` that exists within or under your scope
  - `]%` : the same as the above, but bracket agnostic, "jump to whatever is
         bracketing me"
- Diagnostics
  - `]d` : jump to next diagnostic (info, error, or warning)
  - `]e` : jump to next error
  - `]w` : jump to next warning
  - `]s` : jump to next spelling issue
  - `]t` : jump to next TODO
  - `]h` : jump to next git hunk (unstaged change in file)

## UI and formatting

- `<space>u` : UI and formatting menu
- `<space>uf` : Turn formatting on/off

## `z` mode

"an eclectic mix of cursor positioning, code folding, and random commands"
`:help scrolling`
`:help folding`

- `zt` `zb` `zz`
  - `zt`: Scroll current line to top
    - `z<CR>`: Same as `zt`, but also moves cursor to first non-blank char
- `zb`: Scroll current line to bottom
- `zz`: Scroll current line to middle

## Code specific

- `gd` : Go to local declaration
- `gD` : Go to global declaration
- `gK` : show signature for call under cursor
- `gcO` `gco` : add comment above/below
- `vaa` : visually select everything in function call
      `vaa` on `def myfunc(foo=123, bar=456)` will highlight `foo=123, bar=456`
- `vab` : same as `vaa`, but visually select everything in function call
        including parenthesis
- `vaB` : same as `vab`, but visually select everything in between {}
- `vad` : visually select digits: `vad` on `thing.foo(1234)` will highlight `1234`
- `vic` `vif`: Highlight all text WITHIN class/function
- `vac` `vaf`: Highlight all text OF class/function
- `vai` : Select everything at current indent level? Basically takes the place
        of `vac` and `vaf`, but location dependent
- `vao` `vio` : for selecting conditionals, blocks, etc
- `va"` `vi"` : select everything in quotes
- `vaq` : select everything in quotes, but quote symbol agnostic. Works on both
        `"my test"` and `'my test'`
- `vat` : select everything around tag (`<a> <b> testing </b> </a>`)
- `vit` : select everything within tag (`<a> <b> testing </b> </a>`)
- `vau` `vaU` : select entire call
- `vanc` `vanf` : select all of next class/function

### Surround

- `vacgsa{` : highlight entire class and surround with {}
- `gsr"'` : replace current surrounding ' with "
  - Can use "." to then rerun previous replace
- `gsrn"(` : Replace the next " surrounding with ()
- `gsdn"` : Delete the next "" surrounding
- `;` `;` keymapped to `gs` for surround actions
  - `;;` : Add surrounding
  - `;d` : Delete surrounding
  - `;r` : Replace surrounding
  - I did this to make the above happen: He added the keybinding of `;` for `gs`
    and `;;` for `gsa`. `;` is normally used with flash find or til(`f` or `t`)
    as a `next` operation, but you can simply type `f` or `t` again in that
    state to do the next thing

## Misc

- `:help` -> For example, `:help gi` or `:help insert`
- `%!jq .`: pretty print current JSON document
- `<space><tab><tab>` : open a new, unnamed buffer and switch to it
- `80i*<Escape>` : create a row of 80 `*`
- `J` : Join two lines together, removing white space. Works on selected text too
