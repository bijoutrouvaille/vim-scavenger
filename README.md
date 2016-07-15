## scavenger.vim

This plugin will eat your dead options and convert them into digestable resources...

The biology of the process is really quite simple: instead of having all of your options set in the same tumid and mutated, poor .vimrc file, you would create a resource file in: your project folder, in a folder that holds all of your code, in a folder that holds other stuff that you edit with vim, or in subfolders of that, if you'd like.

It traverses up the tree, starting from the current file's directory and sources each file that matches a pattern. It does so in the order of outer to inner, so as to shadow more general files with the more immediate ones.

### Questions

Wouldn't you get confused as to where you keep all your options?

-- Unlikely. There is a handy window that will popup on command to let you quickly view and edit any resource files that apply to the currently edited one.

Isn't there another project that does the same thing?

-- I don't know, which is why I made this one, but please send me its name so I can post it here.

Can you add a feature I would like to see?

-- It's possible. Please create an issue, and we can discuss it.

### Installation

Pathogen and most vim package managers should work.

### Usage

Just place files that match your defined pattern somewhere within or up the path from any file you wish them to apply to.

Will do the thing. It is by default set up to run on `BufEnter` autocmd. Of course, it will not apply a resource file to itself:

    :Scavenge 

Will show a quick popup window with all the matched resource files currently in and up the path:

    :ScaFiles 

### Options

Below are the options that you can put in your .vimrc to overwrite the *defaults* shown here, after the equals sign.

A list of glob file patterns which will be searched for:

    let g:scavenger_patterns = ['project.vim', 'rc.vim']

The list above will then be filtered through the below list of regular expressions:

    let g:scavenger_exclude = []

The `g:scavenger_map` is a hash of which the key is a comma-separated list of patterns to match the file to be edited, and the value an array of glob patterns to be used in addition to the `g:scavenger_patterns`. The latter having been described above, here is the syntax for the keys:

- Files can be included by either an extension or the filetype
- Files can be excluded the same way by prefixing a bang (`!`) to one of the above
- If there is no extension, as in a shell script, the parser will understand an empty pattern
- `\*` Matches all types, and is compatible with `!`.
- Items to the right shadow those stated previously.

Example:

    let g:scavenger_map = {
        \'sh,pl,!' : '*shell.vim' " example: would include files "test.sh", "test.pl", but not "test"
        \'vim,!vim,vim' : 'vim.vim' " example: would apply any vim.vim found in tree to test.vim
        \'*' : 'myrc.vim' " would apply any myrc.vim to any file edited
        \}

If set to 1 the autocmd for :Scavenge will not be defined, leaving you to customize this behavior at your own discretion:

    g:scavenger_manual_only = 0

Scavenger will by default pick up filetype files in your $HOME/.vim/ftplugin folder, but you can disable this behaviour by specifying

    let g:scavenger_ft = 0

### Key Mappings

There are none. Feel free to assign what works best for you--that's the scavenger way.

### To Do

- Create a help file

### License

The MIT License (MIT)

Copyright (c) 2013 github.com/bijoutrouvaille

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
