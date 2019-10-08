" simplesnips.vim
" 2019 Carter Adams
"
" Usage 'Sn filename'
"
" Pastes the contents of a file in g:simplesnipsDir below the current cursor
" location. The pattern <<FileSlug>> is replaced by the name of the file minus
" its extension and the pattern <<FileSlugLower>> is replace by the name of
" the file in lowercase.
"
" If executed on a blank line, the blank line is deleted after pasting.
"
" Autocomplete works now.
"
" TODO: If the need comes up, insert at current / correct indentation level.

if !exists("g:simplesnipsDir")
    let g:simplesnipsDir="$HOME/.vim/snips"
endif

" list contents of g:simplesnipsDir for the -complete arg of command
" TODO: windows compatibility
fun s:LsSnips(A, L, P)
    return system("ls 2> /dev/null" . g:simplesnipsDir)
endfun

" do the magic
fun s:InsertSnip(snipname)
    " get current line number
    let l:currentLineNum = line(".")

    " paste the file contents below the current line
    execute(":r " . g:simplesnipsDir . a:snipname)

    " replace <<FileSlug>> with the filename minus the extension
    " replace <<FileSlugLower>> with the slug in lowercase
    let l:fileSlug = expand("%:t:r")
    let l:fileSlugLower = tolower(l:fileSlug)
    let l:fileSlugRegex = ":silent! %s/<<FileSlug>>/" . l:fileSlug . "/g"
    let l:fileSlugRegexLower = ":silent! %s/<<FileSlugLower>>/" . 
                \l:fileSlugLower . "/g"
    execute(l:fileSlugRegex)
    execute(l:fileSlugRegexLower)

    " jump back to starting line, delete it if it is empty
    execute("normal " . l:currentLineNum . "G")
    if (strwidth(getline(".")) == 0)
        execute("normal dd")
    endif
endfun

" the command:
command -nargs=1 -complete=custom,s:LsSnips Sn call s:InsertSnip(<q-args>)
