" On save settings
let g:ale_fix_on_save = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 'normal'

" Floating window
let g:ale_floating_preview = 1
let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰']

" Sign column
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
let g:ale_sign_info = 'ⓘ'

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

" Common C/C++ include path
let c_include_path = getenv('C_INCLUDE_PATH')
if c_include_path != ''
  let include_paths = split(c_include_path, ':')
  let base_includes = join(map(include_paths, '"-I" . v:val'), ' ')
endif

" Common C/C++ options
let common_opts = '-Wall -Wextra -pedantic -Wno-keyword-macro ' . base_includes
let g:ale_c_cppcheck_options="--check-level=exhaustive"

" C linter options
let c_opts = common_opts . '-std=c17'
let g:ale_c_cc_options = c_opts
let g:ale_c_clang_options = c_opts
let g:ale_c_gcc_options = c_opts
" For using compile_commands.json
" let g:ale_c_parse_compile_commands = 1

" C++ linter options
let cpp_opts = common_opts . '-std=c++20'
let g:ale_cpp_cc_options = cpp_opts
let g:ale_cpp_gcc_options = cpp_opts
let g:ale_cpp_clang_options = cpp_opts

" Java linter options
let g:ale_java_checkstyle_config = 'google_checks.xml'

" Python linter options
let g:ale_python_pyright_config = {
  \ 'pyright': {
  \   'typeCheckingMode': 'basic',
  \ },
  \}

" Shell linter options
" Ignore level 4 indent, set maximum line length
let g:ale_sh_bashate_options = '-i E003 --max-line-length 80'

" Rust linter options
let g:ale_rust_cargo_use_clippy = executable('cargo-clippy')
let g:ale_rust_cargo_use_clippy = 1
let g:ale_rust_cargo_clippy_options =
  \ '--tests --all-features --all-targets -- -D warnings'

" TODO: currently not working
" YAML linter options
let g:ale_yaml_ls_config = {
\   'yaml': {
\     'customTags': [
\       '!vault scalar'
\     ],
\   },
\ }

" Only enable specific linters
" let g:ale_linters_explicit = 1

let g:ale_linters_ignore = {
\}

let g:ale_ocaml_ocamlformat_options = '--enable-outside-detected-project'

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
\   'markdown': ['markdownlint', 'proselint', 'vale', 'writegood'],
\   'ocaml': ['merlin'],
\   'proto': ['buf_lint', 'protolint'],
\   'python': ['ruff', 'flake8', 'pylint', 'pyright', 'bandit'],
\   'rust': ['analyzer', 'cargo'],
\   'sh': ['bashate', 'language_server', 'shell', 'shellcheck'],
\   'sql': ['sqlfluff'],
\   'xml': ['xmllint'],
"\   'yaml': ['yamllint', 'yaml-language-server',
"\            'actionlint', 'circleci', 'spectral'],
\   'yaml': ['yamllint', 'yaml-language-server',
\            'circleci', 'spectral'],
\}

" ALE Fixers

" Python format options
let g:ale_python_ruff_format_options = "--line-length 79"

" sh/bash fixer options (consistent with Google Shell Style Guide)
let g:ale_sh_shfmt_options = "-s -i 2 -ci -bn"

" Rust format options
let g:ale_rust_rustfmt_options="+nightly-2024-03-28 --edition 2021"

" Fixers
" NOTES:
" - 'ansible' covered by 'yaml'
" - 'dprint' and 'biome' may eclipse 'prettier' in the future
let g:ale_fixers = {
\   'bash': ['shfmt', 'trim_whitespace', 'remove_trailing_lines'],
\   'bzl': ['buildifier', 'trim_whitespace', 'remove_trailing_lines'],
\   'c': ['clang-format', 'trim_whitespace', 'remove_trailing_lines'],
\   'cpp': ['clang-format', 'trim_whitespace', 'remove_trailing_lines'],
\   'go': ['gofmt', 'trim_whitespace', 'remove_trailing_lines'],
\   'java': ['google_java_format', 'trim_whitespace', 'remove_trailing_lines'],
\   'json': ['prettier', 'trim_whitespace', 'remove_trailing_lines'],
\   'markdown': ['prettier', 'trim_whitespace', 'remove_trailing_lines'],
\   'ocaml': ['ocamlformat', 'trim_whitespace', 'remove_trailing_lines'],
\   'proto': ['buf-format', 'protolint',
\             'trim_whitespace', 'remove_trailing_lines'],
\   'python': ['ruff_format', 'trim_whitespace', 'remove_trailing_lines'],
\   'rust': ['rustfmt', 'trim_whitespace', 'remove_trailing_lines'],
\   'sh': ['shfmt', 'trim_whitespace', 'remove_trailing_lines'],
\   'sql': ['sqlfluff', 'trim_whitespace', 'remove_trailing_lines'],
\   'toml': ['trim_whitespace', 'remove_trailing_lines'],
\   'vim': ['trim_whitespace', 'remove_trailing_lines'],
\   'yaml': ['prettier', 'trim_whitespace', 'remove_trailing_lines'],
\   'xml': ['xmllint', 'trim_whitespace', 'remove_trailing_lines'],
\   'zsh': ['shfmt', 'trim_whitespace', 'remove_trailing_lines'],
\}

" Helper functions and bindings

" Copy the ALE warning message for the current line to the clipboard
function! CopyAleWarningToClipboard()
  " Start redirecting to a variable
  redir => warning_message
  " Echo the ALE warning message for the current line
  call ale#cursor#EchoCursorWarning()
  " End the redirection
  redir END
  " Trim whitespace and newlines from the beginning and end of the message
  let warning_message = substitute(warning_message, '^\n*\s*\(.\{-}\)\n*\s*$', '\1', '')
  " Ensure the message ends with a newline character
  let warning_message .= "\n"
  " Copy the message with the newline to the clipboard register
  let @+ = warning_message
endfunction

" Key binding to call the function using <Leader>w
nnoremap <Leader>ac :call CopyAleWarningToClipboard()<CR>
