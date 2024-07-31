" Add markdown pairs and >>> / <<<
setlocal matchpairs-=<:>
let b:match_words = &l:matchpairs .
      \ ',' . '\%(^\|[ (/]\)\@<="' . ':' . '"\ze\%($\|[ )/.\,;\:?!\-]\)' .
      \ ',' . '\%(^\|[ (/]\)\@<=''' . ':' . '''\ze\%($\|[ )/.\,;\:?!\-]\)'
let b:match_words .=
      \ ',' . '\%(^\|[ (/]\)\@<=\*[^*]' . ':' . '[^*]\@<=\*\ze\%($\|[ )/.\,;\:?!\-]\)' .
      \ ',' . '\%(^\|[ (/]\)\@<=\*\*' . ':' . '\*\*\ze\%($\|[ )/.\,;\:?!\-]\)' .
      \ ',' . '\%(^\|[ (/]\)\@<=\*\*\*' . ':' . '\*\*\*\ze\%($\|[ )/.\,;\:?!\-]\)' .
      \ ',' . '\%(^\|[ (/]\)\@<=_[^_]' . ':' . '[^_]\@<=_\ze\%($\|[ )/.\,;\:?!\-]\)' .
      \ ',' . '\%(^\|[ (/]\)\@<=__' . ':' . '__\ze\%($\|[ )/.\,;\:?!\-]\)' .
      \ ',' . '\%(^\|[ (/]\)\@<=___' . ':' . '___\ze\%($\|[ )/.\,;\:?!\-]\)' .
      \ ',' . '\%(^\|[ (/]\)\@<=`[^`]' . ':' . '[^`]\@<=`\ze\%($\|[ )/.\,;\:?!\-]\)' .
      \ ',' . '\%(^\|\s\)\@<=```\%(\w\+\)$' . ':' . '\%(^\|\s\)\@<=```\ze$' .
      \ ',' . '^>>>\s' . ':' . '^<<<\ze\s'

" Add folding
if has("folding")
  setlocal foldexpr=AIChatFold()
  setlocal foldmethod=expr
  setlocal foldtext=AIChatFoldText()
  if exists('b:undo_ftplugin')
    let b:undo_ftplugin .= "|setl foldexpr< foldmethod< foldtext<"
  else
    let b:undo_ftplugin  = "|setl foldexpr< foldmethod< foldtext<"
  endif
endif

" The rest of the file needs to be :sourced only once per session.
if exists('s:loaded_functions') || &cp
  finish
endif
let s:loaded_functions = 1

function! AIChatFold() abort
  return getline(v:lnum) =~# '^>>> user$' ? '>1' : '='
endfunction

function! AIChatFoldText() abort
  let nextline = getline(v:foldstart + 2)
  let title = nextline
  let foldsize = (v:foldend - v:foldstart + 1)
  let linecount = '['.foldsize.' lines]'
  return title.' '.linecount
endfunction
