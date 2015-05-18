" Don't use three-piece comments
setlocal comments=f:(*

" ocp-indent
let g:ocp_indent_vimfile = system("opam config var share")
let g:ocp_indent_vimfile = substitute(g:ocp_indent_vimfile, '[\r\n]*$', '', '')
let g:ocp_indent_vimfile = g:ocp_indent_vimfile . "/vim/syntax/ocp-indent.vim"
autocmd FileType ocaml exec ":source " . g:ocp_indent_vimfile
