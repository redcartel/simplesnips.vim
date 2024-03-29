# simplesnips.vim

by Carter Adams (https://github.com/redcartel/simplesnips.vim)

*building a vim plugin was a bucket list item, I'm probably never going to update this again, 
but maybe it will be useful for someone learning how to do this.*

Simple snippits. Add the following line to your config file:

    `let g:simplesnipsDir = $HOME . "/path/to/your/snips/folder/"`

Then the command:

    `:Sn snippitname`

Will insert the text of the file `/path/to/your/snips/folder/snippitname` 
into your code at the current line, or below your current line if the
current line is not blank.

Autocompletion of snippit names should be enabled.

The only processing of snippit text is that the pattern `__FileSlug__` is
replaced by the current file's filename without the extension. So for instance
`class __FileSlug__` would become `class MyClass` when inserted into a file 
called `MyClass.js`

Similarly `__FileSlugLower__` is replaced by the name of the file in lowercase,
minus the extension. So `myclass` in the above example.


TODO: Insert at current indentation level

TODO: Allow snippits organized in sub-folders

TODO: Test on different platforms

TODO: Other improvements?

I don't want anything complicated like supporting the formats of other snippits
plugins. This is for people who want a straightforward solution to writing a
personal collection of templates in a simple format & use a plugin that doesn't
pollute their omnicomplete.
