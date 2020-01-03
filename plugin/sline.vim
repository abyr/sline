" ============================================================
" File: sline.vim
" Maintainer: Oleksandr Denysenko
" Description: A status line plugin
" Last Updated: January 03, 2020
" ============================================================

if exists("g:loaded_sline")
    finish
endif
let g:loaded_sline = 1

let s:save_cpo = &cpo
set cpo&vim

" status_line format
" http://tdaly.co.uk/projects/vim-statusline-generator/
set laststatus=2

set statusline=                          " left align
set statusline+=%2*\                     " blank char
set statusline+=%2*\%{StatuslineMode()}
set statusline+=%2*\                     " blank char
set statusline+=%1*\ <<
set statusline+=%1*\ %f                  " short filename
set statusline+=%1*\ >>

set statusline+=%1#warningmsg#
set statusline+=%1*

set statusline+=%=                       " right align
set statusline+=%*
set statusline+=%3*\%h%m%r               " file flags (help, read-only, modified)
set statusline+=%4*\%{b:gitbranch}       " include git branch
set statusline+=%3*\%.25F                " long filename (trimmed to 25 chars)
set statusline+=%3*\::
set statusline+=%3*\%l/%L\\|             " line count
set statusline+=%3*\%y                   " file type
set statusline+=%333*\                     " blank char
set statusline+=%P                       " percent of file

hi User1 ctermbg=black ctermfg=grey guibg=black guifg=grey
hi User2 ctermbg=green ctermfg=black guibg=green guifg=black
hi User3 ctermbg=black ctermfg=lightgreen guibg=black guifg=lightgreen

function! StatuslineMode()
  let l:mode=mode()
  if l:mode==#"n"
    return "NORMAL"
  elseif l:mode==?"v"
    return "VISUAL"
  elseif l:mode==#"i"
    return "INSERT"
  elseif l:mode==#"R"
    return "REPLACE"
  endif
endfunction

function! StatuslineGitBranch()
  let b:gitbranch=""
  if &modifiable
    lcd %:p:h
    let l:gitrevparse=system("git rev-parse --abbrev-ref HEAD")
    lcd -
    if l:gitrevparse!~"fatal: not a git repository"
      let b:gitbranch="(".substitute(l:gitrevparse, '\n', '', 'g').") "
    endif
  endif
endfunction

augroup GetGitBranch
  autocmd!
  autocmd VimEnter,WinEnter,BufEnter * call StatuslineGitBranch()
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo

