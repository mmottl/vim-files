function! s:cargo_check()
  let l:old_makeprg = &makeprg
  compiler cargo
  let &makeprg = 'cargo check --all-features'
  make
  let &makeprg = l:old_makeprg
endfunction

nnoremap <leader>rk :call <SID>cargo_check()<CR>
