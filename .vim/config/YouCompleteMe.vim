let g:ycm_global_ycm_extra_conf = '~/.vim/config/ycm_extra_conf.py'

if executable('brew')
  " Use Homebrew's clangd
  let g:ycm_clangd_binary_path = trim(system('brew --prefix llvm')).'/bin/clangd'
endif
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:ycm_key_list_stop_completion = ['<C-y>', '<CR>']
let g:ycm_auto_hover = ''
let g:ycm_show_detailed_diag_in_popup = 1
let g:ycm_enable_semantic_highlighting = 1
let g:ycm_enable_inlay_hints = 0
let g:ycm_clear_inlay_hints_in_insert_mode = 1
let g:ycm_always_populate_location_list = 1
let g:ycm_goto_buffer_command='split-or-existing-window'
let g:ycm_clangd_args = ['--clang-tidy']
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_error_symbol = '✘'
let g:ycm_warning_symbol = '⚠'

let MY_YCM_HIGHLIGHT_GROUP = {
      \ 'attributeBracket': 'Delimiter',
      \ 'boolean': 'Boolean',
      \ 'builtinAttribute': 'PreProc',
      \ 'builtinType': 'Type',
      \ 'const': 'Constant',
      \ 'decorator': 'Function',
      \ 'formatSpecifier': 'Special',
      \ 'generic': 'Type',
      \ 'lifetime': 'Identifier',
      \ 'selfKeyword': 'Keyword',
      \ 'selfTypeKeyword': 'Type',
      \ 'typeAlias': 'Type',
      \ }

for tokenType in keys(MY_YCM_HIGHLIGHT_GROUP)
  call prop_type_add('YCM_HL_' . tokenType,
                    \ { 'highlight': MY_YCM_HIGHLIGHT_GROUP[tokenType] })
endfor

" For :YcmShowDetailedDiagnostic
let g:ycm_key_detailed_diagnostics = '<leader>yd'

nnoremap <silent> <leader>yD <plug>(YCMHover)
nnoremap <silent> <leader>yH <Plug>(YCMToggleInlayHints)
nnoremap <leader>yfd <Plug>(YCMFindSymbolInDocument)
nnoremap <leader>yfs <Plug>(YCMFindSymbol)
nnoremap <leader>yfw <Plug>(YCMFindSymbolInWorkspace)

nnoremap <leader>yc  :YcmCompleter ClearCompilationFlagCache<CR>
nnoremap <leader>yF  :YcmCompleter Format<CR>
nnoremap <leader>ygg :YcmCompleter GoTo<CR>
nnoremap <leader>ygG :YcmCompleter GoToImprecise<CR>
nnoremap <leader>ygI :YcmCompleter GoToInclude<CR>
nnoremap <leader>ygi :YcmCompleter GoToImplementation<CR>
nnoremap <leader>ygc :YcmCompleter GoToCallers<CR>
nnoremap <leader>ygC :YcmCompleter GoToCallees<CR>
nnoremap <leader>ygd :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>ygD :YcmCompleter GoToDefinition<CR>
nnoremap <leader>yga :YcmCompleter GoToAlternativeFile<CR>
nnoremap <leader>ygr :YcmCompleter GoToReferences<CR>
nnoremap <leader>ygt :YcmCompleter GoToType<CR>
nnoremap <leader>ygT :YcmCompleter GoToTypeImprecise<CR>
nnoremap <leader>ygo :YcmCompleter GoToDocumentOutline<CR>
nnoremap <leader>yh  :YcmCompleter GetDoc<CR>
nnoremap <leader>yo  :YcmCompleter OrganizeImports<CR>
nnoremap <leader>yp  :YcmCompleter GetParent<CR>
nnoremap <leader>yt  :YcmCompleter GetType<CR>
nnoremap <leader>yx  :YcmCompleter FixIt<CR>
nnoremap <leader>yy  :YcmDiags<CR>
nnoremap <leader>yY  :YcmRestartServer<CR>
