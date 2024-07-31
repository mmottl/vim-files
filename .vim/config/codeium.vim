let g:codeium_no_map_tab = v:true
map  <C-q> <Cmd>call codeium#Clear()<CR>
imap <C-q> <Cmd>call codeium#Clear()<CR>
imap <C-b> <Cmd>call codeium#CycleCompletions(-1)<CR>
imap <C-f> <Cmd>call codeium#CycleCompletions(1)<CR>
imap <script><silent><nowait><expr> <C-h> codeium#Accept()
let g:airline#extensions#codeium#enabled = 1
