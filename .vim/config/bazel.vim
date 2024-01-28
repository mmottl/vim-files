augroup BazelSpecific
  autocmd!
  autocmd BufWinEnter,WinEnter * if &filetype == 'bzl' | setlocal colorcolumn=80 | endif
  autocmd BufWinLeave,WinLeave * if &filetype == 'bzl' | setlocal colorcolumn=0 | endif
  autocmd FileType bzl setlocal textwidth=80 shiftwidth=4 tabstop=4
augroup END
