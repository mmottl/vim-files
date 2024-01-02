set grepprg=rg\ --smart-case\ --vimgrep
set grepformat=%f:%l:%c:%m,%f:%l:%m
autocmd QuickFixCmdPost *grep* cwindow
