" Don't use three-piece comments
setlocal comments=f:(*

" ocp-indent
vnoremap <LocalLeader>i <ESC>:'<,'>!ocp-indent -c match_clause=4<CR>
nnoremap <LocalLeader>i :%!ocp-indent -c match_clause=4<CR>
command! -range=% OCPIndent :<line1>,<line2>!ocp-indent -c match_clause=4
setlocal equalprg=ocp-indent

let g:ocp_indent_vimfile = system("opam config var share")
let g:ocp_indent_vimfile = substitute(g:ocp_indent_vimfile, '[\r\n]*$', '', '')
let g:ocp_indent_vimfile = g:ocp_indent_vimfile . "/vim/syntax/ocp-indent.vim"

" autocmd FileType ocaml exec ":source " . g:ocp_indent_vimfile
