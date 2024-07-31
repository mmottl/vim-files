let g:slime_no_mappings = 1
let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": "default", "target_pane": "{last}"}
xmap <C-c><C-s> <Plug>SlimeRegionSend
nmap <C-c><C-s> <Plug>SlimeParagraphSend
nmap <C-c>v     <Plug>SlimeConfig
