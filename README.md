## scavenger.vim

This plugin will eat your dead options and convert them into digestable resources...

The biology of the process is really quite simple: instead of having all of your options set in the same tumid and mutated poor .vimrc file, you would create a resource file in: your project folder, in a folder that holds all of your code, in a folder that holds other stuff that you edit with vim, and in subfolders of that, if you'd like.

It traverses up the tree, starting from the current file's directory and sources each file that matches a pattern. It does so in the order of outer to inner, so as to shadow more general files with the more immediate ones.

### Questions

Wouldn't you get confused as to where you keep all your options?

-- Unlikely. There is a handy window that will popup on command to let you quickly view and edit any resource files that apply to the current one.

Isn't there another project that does the same thing?

-- I don't know, which is why I made this one, but please send me its name so I can post it here.

Can you add feature X?

-- It's possible, please create an issue and we can discuss it.

### Usage

Just place files that match your defined pattern somewhere in or up the path from any file you wish them to apply to.

    :Scavange 
Will do the thing. It is by default set up to run on BufEnter autocmd.

    :ScaFiles 
Will show a quick popup window with all the matched resource files currently in and up the path.

### Options

Below are the options that you can put in your .vimrc to overwrite the defaults shown here, after the equals sign.

A list of glob file patterns which will be searched for:

    let g:scavenger\_patterns = ['project.vim', 'rc.vim']

The list above will then be filtered through a list of regular expressions:

    let g:scavenger\_exclude = []

If set to 1 the autocmd for :Scavange will not be defined, leaving you to customize this behavior at your own discretion:

    g:scavenger\_manual\_only = 0

### Mappings

There are none. Feel free to assign what works best for you--that's the scavenger way.

### ToDo

- Add a dictionary option that would allow to specify search patterns for file types
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
