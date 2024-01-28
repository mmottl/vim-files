augroup AIChatSpecific
  autocmd!
  autocmd BufWinEnter,WinEnter * if &filetype == 'aichat' | setlocal colorcolumn=80 | endif
  autocmd BufWinLeave,WinLeave * if &filetype == 'aichat' | setlocal colorcolumn=0 | endif
  autocmd FileType aichat setlocal textwidth=80
augroup END
