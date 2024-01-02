augroup JavaSpecific
  autocmd!
  autocmd BufWinEnter,WinEnter * if &filetype == 'java' | setlocal colorcolumn=100 | endif
  autocmd BufWinLeave,WinLeave * if &filetype == 'java' | setlocal colorcolumn=0 | endif
  autocmd FileType java setlocal shiftwidth=2 tabstop=2 expandtab
augroup END
