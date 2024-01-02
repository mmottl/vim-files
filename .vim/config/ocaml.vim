function! s:FT_ocaml()
  let no_ocaml_comments = 1
  let ocaml_highlight_operators = 1
  set makeprg=dune\ build

  " Merlin
  call SuperTabSetDefaultCompletionType("<c-x><c-o>")
  nmap <LocalLeader>* <Plug>(MerlinSearchOccurrencesForward)
  nmap <LocalLeader># <Plug>(MerlinSearchOccurrencesBackward)
  nmap <LocalLeader>d :MerlinDocument<CR>
  nmap <LocalLeader>m :MerlinDestruct<CR>
  nmap <LocalLeader>r <Plug>(MerlinRename)
  nmap <LocalLeader>R <Plug>(MerlinRenameAppend)
  nmap <LocalLeader>T :MerlinYankLatestType<CR>
endfunction

au FileType ocaml call s:FT_ocaml()
