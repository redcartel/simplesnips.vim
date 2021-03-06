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
    let g:simplesnipsDir="$HOME/.vim/simplesnips"
endif

" list contents of g:simplesnipsDir for the -complete arg of command
" TODO: windows compatibility (lol)
function! LsSnips(A, L, P)
    let l:result = ''
    let l:regex = g:simplesnipsDir . '/\?\(.*\)'
    for path in globpath(g:simplesnipsDir, '*', 0, 1)
        let l:matches = matchlist(path, l:regex)
        if len(l:matches) > 1 && strwidth(l:matches[1]) > 0
            if len(l:result) > 0
                let l:result = l:result . "\n"
            endif
            let l:result = l:result . l:matches[1]
        endif
    endfor
    return l:result
endfun

" do the magic
function! s:InsertSnip(snipname)
    " get current line number
    let l:currentLineNum = line(".")

    " paste the file contents below the current line
    try
        execute(":r " . globpath(g:simplesnipsDir, a:snipname))
    catch
        if strwidth(LsSnips(0,0,0)) == 0
            echo "Snippit directory " . g:simplesnipsDir . " does not exist or is empty. Be sure to set g:simplesnipsDir"
        else
            echo "Snippit " . a:snipname . " not found"
        endif
        return
    endtry

    " replace <<FileSlug>> with the filename minus the extension
    " replace <<FileSlugLower>> with the slug in lowercase
    let l:fileSlug = expand("%:t:r")
    let l:fileSlugLower = tolower(l:fileSlug)
    let l:fileSlugRegex = ":silent! %s/__FileSlug__/" . l:fileSlug . "/g"
    let l:fileSlugRegexLower = ":silent! %s/__FileSlugLower__/" . l:fileSlugLower . "/g"

    execute(l:fileSlugRegex)
    execute(l:fileSlugRegexLower)

    " jump back to starting line, delete it if it is empty
    execute("normal " . l:currentLineNum . "G")
    if (strwidth(getline(".")) == 0)
        execute("normal dd")
    endif
endfun

" the command:
command! -nargs=1 -complete=custom,LsSnips Sn call s:InsertSnip(<q-args>)
