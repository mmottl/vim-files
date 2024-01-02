let g:rustfmt_autosave = 1

augroup RustSpecific
  autocmd!
  autocmd BufWinEnter,WinEnter * if &filetype == 'rust' | setlocal colorcolumn=100 | endif
  autocmd BufWinLeave,WinLeave * if &filetype == 'rust' | setlocal colorcolumn=0 | endif
augroup END
