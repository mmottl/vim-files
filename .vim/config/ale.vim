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
" <C-space> already used by YouCompleteMe
imap <C-a> <plug>(ale_complete)
nmap <leader>ad <plug>(ale_documentation)
nmap <leader>af <plug>(ale_fix)
nmap <leader>ag <plug>(ale_go_to_definition)
nmap <leader>ah <plug>(ale_hover)
nmap <leader>ai <plug>(ale_info)
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

" ALE Linters

" Only enable specific linters
let g:ale_linters_explicit = 1

" Common C/C++ include path
let c_include_path = getenv('C_INCLUDE_PATH')
if c_include_path != ''
  let include_paths = split(c_include_path, ':')
  let base_includes = join(map(include_paths, '"-I" . v:val'), ' ')
endif

" Common C/C++ options
let common_opts = '-Wall -Wextra -pedantic -Wno-keyword-macro ' . base_includes

" C linter options
let c_opts = common_opts . '-std=c17'
let g:ale_c_cc_options = c_opts
let g:ale_c_clang_options = c_opts
let g:ale_c_gcc_options = c_opts

" C++ linter options
let cpp_opts = common_opts . '-std=c++20'
let g:ale_cpp_cc_options = cpp_opts
let g:ale_cpp_gcc_options = cpp_opts
let g:ale_cpp_clang_options = cpp_opts

" Java linter options
let g:ale_java_checkstyle_config = "google_checks.xml"

" Shell linter options
" Ignore level 4 indent, set maximum line length
let g:ale_sh_bashate_options = '-i E003 --max-line-length 80'

" Rust linter options
let g:ale_rust_cargo_use_clippy = executable('cargo-clippy')

" Linter registration
" NOTES:
" - 'cspell' may be too intrusive
let g:ale_linters = {
\   'ansible': ['ansible_lint', 'language_server'],
\   'c': ['cc', 'clangtidy', 'cppcheck', 'cpplint'],
\   'cpp': ['cc', 'clangtidy', 'cppcheck', 'cpplint'],
\   'go': ['gofmt', 'golangci-lint', 'revive', 'staticcheck'],
\   'java': ['javalsp', 'checkstyle', 'pmd'],
\   'json': ['jsonlint', 'spectral'],
\   'markdown': ['markdownlint', 'proselint', 'vale', 'write_good'],
\   'ocaml': ['merlin'],
\   'python': ['ruff', 'flake8', 'pylint', 'pyright', 'bandit'],
\   'rust': ['analyzer', 'cargo'],
\   'sh': ['bashate', 'language_server', 'shell', 'shellcheck'],
\   'sql': ['sqlfluff'],
\   'yaml': ['yamllint', 'yaml-language-server',
\            'actionlint', 'circleci', 'spectral'],
\}

" ALE Fixers

" sh/bash fixer options (consistent with Google Shell Style Guide)
let g:ale_sh_shfmt_options = "-s -i 2 -ci -bn"

" TODO: check linter list
" Fixers
" NOTES:
" - 'ansible' covered by 'yaml'
" - 'dprint' and 'biome' may eclipse 'prettier' in the future
let g:ale_fixers = {
\   'bash': ['shfmt', 'trim_whitespace', 'remove_trailing_lines'],
\   'c': ['clang-format', 'trim_whitespace', 'remove_trailing_lines'],
\   'cpp': ['clang-format', 'trim_whitespace', 'remove_trailing_lines'],
\   'go': ['gofmt', 'trim_whitespace', 'remove_trailing_lines'],
\   'java': ['google_java_format', 'trim_whitespace', 'remove_trailing_lines'],
\   'json': ['prettier', 'trim_whitespace', 'remove_trailing_lines'],
\   'markdown': ['prettier', 'trim_whitespace', 'remove_trailing_lines'],
\   'ocaml': ['ocamlformat', 'trim_whitespace', 'remove_trailing_lines'],
\   'python': ['ruff_format', 'trim_whitespace', 'remove_trailing_lines'],
\   'rust': ['rustfmt', 'trim_whitespace', 'remove_trailing_lines'],
\   'sh': ['shfmt', 'trim_whitespace', 'remove_trailing_lines'],
\   'sql': ['sqlfluff', 'trim_whitespace', 'remove_trailing_lines'],
\   'vim': ['trim_whitespace', 'remove_trailing_lines'],
\   'yaml': ['prettier', 'trim_whitespace', 'remove_trailing_lines'],
\   'zsh': ['shfmt', 'trim_whitespace', 'remove_trailing_lines'],
\}
