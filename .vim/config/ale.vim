" On save settings
let g:ale_fix_on_save = 1
let g:ale_lint_on_save = 1

" Floating window
let g:ale_floating_preview = 1
let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰']

" Sign column
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'

" Highlighting 
highlight ALEErrorSign cterm=bold ctermfg=1 ctermbg=234
highlight ALEWarningSign cterm=bold ctermfg=11 ctermbg=234
highlight ALEError cterm=NONE ctermfg=0 ctermbg=1
highlight ALEWarning cterm=NONE ctermfg=0 ctermbg=13

" ALE shortcuts
" imap <C-Space> <plug>(ale_complete)
nmap <leader>ad <plug>(ale_documentation)
nmap <leader>af <plug>(ale_fix)
nmap <leader>ag <plug>(ale_go_to_definition)
nmap <leader>ah <plug>(ale_hover)
nmap <leader>al <plug>(ale_lint)
nmap <leader>ap <plug>(ale_detail)
nmap <leader>ar <plug>(ale_find_references)
nmap <leader>at <plug>(ale_go_to_type_definition)

" Move between errors
nmap [a <plug>(ale_previous_wrap)
nmap ]a <plug>(ale_next_wrap)
nmap ]A <plug>(ale_last)
nmap [A <plug>(ale_first)
nmap <C-k> <plug>(ale_previous_wrap)
nmap <C-j> <plug>(ale_next_wrap)

" Common include path
let c_include_path = getenv('C_INCLUDE_PATH')
let base_includes = '-I' . c_include_path . ' '

" Common C/C++ options
let common_opts = '-Wall -Wextra -pedantic -Wno-keyword-macro '

" C linter options
let c_opts = base_includes . common_opts . '-std=c11'
let g:ale_c_cc_options    = c_opts
let g:ale_c_clang_options = c_opts
let g:ale_c_gcc_options   = c_opts

" C++ linter options
let cpp_opts = base_includes . common_opts . '-std=c++20'
let g:ale_cpp_cc_options    = cpp_opts
let g:ale_cpp_gcc_options   = cpp_opts
let g:ale_cpp_clang_options = cpp_opts

" Java linter options
let g:ale_java_checkstyle_config = "$HOME/.checkstyle/google_checks.xml"

" Shell linters
" Ignore level 4 indent, set maximum line length
let g:ale_sh_bashate_options = '-i E003 --max-line-length 80'

" TODO: add Ansible
" TODO: test clang-tidy / clangtidy, clangd
" Linter registration
let g:ale_linters = {
\   'c': ['cc', 'gcc', 'clang', 'clang-tidy'],
\   'cpp': ['cc', 'gcc', 'clang', 'clang-tidy'],
\   'java': ['checkstyle'],
\   'ocaml': ['merlin'],
\   'rust': ['analyzer', 'clippy'],
\   'yaml': ['actionlint', 'circleci', 'yamlls', 'yamllint'],
\}

" TODO: test clippy
let g:ale_rust_cargo_use_clippy = executable('cargo-clippy')

" Implicitly enabled
" \   'sh': ['bashate', 'cspell', 'language_server', 'shell', 'shellcheck']

" ALE Fixers

" sh/bash fixer options (consistent with Google Shell Style Guide)
let g:ale_sh_shfmt_options = "-s -i 2 -ci -bn"

" TODO: add Ansible
" TODO: test clang-format, clang-tidy / clangtidy, clangd
" Fixers
let g:ale_fixers = {
\   'bash': ['shfmt', 'trim_whitespace', 'remove_trailing_lines'],
\   'c': ['clang-format', 'trim_whitespace', 'remove_trailing_lines'],
\   'cpp': ['clang-format', 'trim_whitespace', 'remove_trailing_lines'],
\   'java': ['google_java_format', 'trim_whitespace', 'remove_trailing_lines'],
\   'ocaml': ['ocamlformat', 'trim_whitespace', 'remove_trailing_lines'],
\   'rust': ['rustfmt', 'trim_whitespace', 'remove_trailing_lines'],
\   'sh': ['shfmt', 'trim_whitespace', 'remove_trailing_lines'],
\   'yaml': ['prettier', 'trim_whitespace', 'remove_trailing_lines'],
\   'zsh': ['shfmt', 'trim_whitespace', 'remove_trailing_lines'],
\}
