" See `man fzf-tmux` for available options
if exists('$TMUX')
  let g:fzf_layout = { 'tmux': '-p90%,90%' }
else
  let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9 } }
endif

let g:fzf_command_prefix = 'FZF'
let g:fzf_buffers_jump = 1
let g:fzf_preview_window = ['right,66%', 'ctrl-/']

" File path completion in Insert mode using FZF
imap <C-x><C-k> <plug>(fzf-complete-word)
imap <C-x><C-f> <plug>(fzf-complete-path)
imap <C-x><C-l> <plug>(fzf-complete-buffer-line)

" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

nnoremap <silent> <leader>ff :FZFFiles<CR>
nnoremap <silent> <leader>fh :FZFHistory<CR>
nnoremap <silent> <leader>f: :FZFHistory:<CR>
cnoremap <silent> <C-p>      :FZFHistory:<CR>
nnoremap <silent> <leader>f/ :FZFHistory/<CR>

nnoremap <silent> <leader>fg :FZFGFiles<CR>
nnoremap <silent> <leader>fG :FZFGFiles?<CR>
nnoremap <silent> <leader>fr :FZFRg<CR>
nnoremap <silent> <leader>fR :FZFRG<CR>
nnoremap <silent> <leader>fb :FZFBuffers<CR>
nnoremap <silent> <leader>fB :FZFBTags<CR>
nnoremap <silent> <leader>fl :FZFBLines<CR>
nnoremap <silent> <leader>fL :FZFLines<CR>
nnoremap <silent> <leader>fc :FZFChanges<CR>
nnoremap <silent> <leader>fj :FZFJumps<CR>
nnoremap <silent> <leader>fw :FZFWindows<CR>
nnoremap <silent> <leader>fs :FZFSnippets<CR>
nnoremap <silent> <leader>fk :FZFBCommits<CR>
nnoremap <silent> <leader>fK :FZFCommits<CR>
nnoremap <silent> <leader>fC :FZFCommands<CR>
nnoremap <silent> <leader>fM :FZFMaps<CR>
nnoremap <silent> <leader>fH :FZFHelptags<CR>
nnoremap <silent> <leader>ft :FZFFiletypes<CR>
nnoremap <silent> <leader>fT :FZFTags<CR>

" Function to open selected files with root prefix while stripping lsd icon
function! s:open_selected_lsd_file(root, sinklist)
  " Check if only a key was pressed without selecting a file
  if len(a:sinklist) <= 1
    return
  endif

  " The first line of 'sinklist' contains the key pressed (if any)
  let key_pressed = a:sinklist[0]

  " Determine the command to use based on the key pressed
  let cmd = 'edit'
  if key_pressed == 'ctrl-t'
    let cmd = 'tabedit'
  elseif key_pressed == 'ctrl-x'
    let cmd = 'split'
  elseif key_pressed == 'ctrl-v'
    let cmd = 'vsplit'
  endif

  let selected_file_with_icon = a:sinklist[1]
  let file_parts = split(selected_file_with_icon)
  let selected_file = file_parts[-1]

  " Check if root is provided or not (zero)
  if a:root[0] == '0'
    execute cmd . ' ' . fnameescape(selected_file)
  else
    " Open file using chosen command with the root directory prepended
    execute cmd . ' ' . fnameescape(a:root . '/' . selected_file)
  endif
endfunction

" Set up FZF for finding any file under the current directory
function! s:setup_fzf_files()
  let opts = {
  \ 'source':
  \   'fd --color=never --type f --hidden --follow --exclude .git
  \       --print0 --strip-cwd-prefix
  \    | xargs -0 lsd -v -d --color=always --icon=always',
  \ 'sinklist': function('s:open_selected_lsd_file', [getcwd()]),
  \ 'options':
  \   '--preview "bat -n --color=always --line-range :10000 {2}"
  \    --preview-window right:66% --expect=ctrl-t,ctrl-x,ctrl-v,enter',
  \ }
  call fzf#run(fzf#wrap(opts))
endfunction
nnoremap <silent> <leader>ff :call <SID>setup_fzf_files()<CR>

" Set up FZF for git files in the whole repo
function! s:setup_fzf_all_git_files()
  " Check if inside a Git repository
  if system('git rev-parse --is-inside-work-tree') != "true\n"
    echo "Not inside a Git repository"
    return
  endif

  let root = substitute(system('git rev-parse --show-toplevel'), '\n$', '', '')

  " FZF options with colorized output and file preview
  let opts = {
  \ 'source':
  \   'cd ' . root . ' && git ls-files -z --deduplicate
  \   | xargs -0 lsd -v -d --color=always --icon=always',
  \ 'sinklist': function('s:open_selected_lsd_file', [root]),
  \ 'options':
  \   '--preview "bat -n --color=always --line-range :10000 ' . root . '/{2}"
  \    --preview-window right:66% --expect=ctrl-t,ctrl-x,ctrl-v,enter',
  \ }
  call fzf#run(fzf#wrap(opts))
endfunction
nnoremap <silent> <leader>fg :call <SID>setup_fzf_all_git_files()<CR>

" Set up FZF for git files in current subdirectory
function! s:setup_fzf_git_files()
  let opts = {
  \ 'source':
  \   'git ls-files -z --deduplicate
  \    | xargs -0 lsd -v -d --color=always --icon=always',
  \ 'sinklist': function('s:open_selected_lsd_file', [getcwd()]),
  \ 'options':
  \   '--preview "bat -n --color=always --line-range :10000 {2}"
  \    --preview-window right:66% --expect=ctrl-t,ctrl-x,ctrl-v,enter',
  \ }
  call fzf#run(fzf#wrap(opts))
endfunction
nnoremap <silent> <leader>fx :call <SID>setup_fzf_git_files()<CR>

" Augment ripgrep FZF integration with delta

command! -bang -nargs=* FZFRg
  \ call fzf#vim#grep(
  \   expand('~/.vim/bin/rg_delta')." -- ".fzf#shellescape(<q-args>),
  \   fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=* FZFRG
  \ call fzf#vim#grep2(
  \   expand('~/.vim/bin/rg_delta')." -- ", <q-args>,
  \   fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=* FZFRq
  \ execute 'lcd' fnameescape(system('git rev-parse --show-toplevel')->trim()) |
  \ call fzf#vim#grep(
  \   expand('~/.vim/bin/rg_delta')." -- ".fzf#shellescape(<q-args>),
  \   fzf#vim#with_preview(), <bang>0)
nnoremap <silent> <leader>fq :FZFRq<CR>

command! -bang -nargs=* FZFRQ
  \ execute 'lcd' fnameescape(system('git rev-parse --show-toplevel')->trim()) |
  \ call fzf#vim#grep2(
  \   expand('~/.vim/bin/rg_delta')." -- ", <q-args>,
  \   fzf#vim#with_preview(), <bang>0)
nnoremap <silent> <leader>fQ :FZFRQ<CR>

" Improved multiline representation
"let g:fzf_vim.grep_multi_line = 1

" FZF MRU

" Helper function to replace home directory with tilde, preserving icons
function! s:replace_home_with_tilde(line, home_dir_pattern)
  " Extract the icon and the file path
  let icon_and_path = matchlist(a:line, '^\(\S\+\s\+\)\(.*\)$')
  if empty(icon_and_path)
    return a:line
  endif
  let icon = icon_and_path[1]
  let path = icon_and_path[2]

  " Replace the home directory in the path with '~'
  let modified_path = substitute(path, '^' . a:home_dir_pattern, '~', '')

  " Return the line with the icon and the modified path
  return icon . modified_path
endfunction

" Get MRU files and color and iconize them using lsd
function! s:GetMRUFiles()
  let source = copy(fzf_mru#mrufiles#list())

  " Remove current file from the list
  let source = filter(source, 'v:val != expand("%")')

  " Remove files that don't exist
  let source = filter(source, 'filereadable(v:val)')

  " Escape file paths for shell command
  let escaped_source = map(source, 'shellescape(v:val)')

  " Join the escaped file paths into a single string
  let file_list = join(escaped_source, " ")

  " Create the lsd command with the file list
  let lsd_command = 'lsd -U --color=always --icon=always ' . file_list

  " Execute the lsd command and capture the output
  let lsd_output = system(lsd_command)

  " Split the output by newline to get the list of files with lsd formatting
  let lsd_file_list = split(lsd_output, "\n")

  " Get the user's home directory path
  let home_dir = expand('$HOME')

  " Replace the home directory path with '~/', taking icons into consideration
  let home_dir_pattern = escape(home_dir, '/\')
  let source_with_icons =
    \ map(lsd_file_list, 's:replace_home_with_tilde(v:val, home_dir_pattern)')

  return source_with_icons
endfunction

command! -bang -nargs=? FZFMru call fzf_mru#actions#mru(<q-args>, {
  \ 'window': {
  \   'width': 0.9,
  \   'height': 0.9
  \ },
  \ 'source': s:GetMRUFiles(),
  \ 'sinklist': function('s:open_selected_lsd_file', [0]),
  \ 'options': [
  \   '--preview',
  \     'bat -n --color=always --line-range :10000
  \       $(echo {2} | sed -e "s!^~!$HOME!")',
  \   '--preview-window', 'right:50%',
  \   '--bind', 'ctrl-_:toggle-preview',
  \   '--expect', 'ctrl-t,ctrl-x,ctrl-v,enter'
  \ ]
\ })

let g:fzf_mru_max = 10000
nnoremap <leader>fm :FZFMru<CR>

" Set up spell checking via FZF
function! FzfSpellSink(word)
  exe 'normal! "_ciw'.a:word
endfunction
function! FzfSpell()
  let suggestions = spellsuggest(expand("<cword>"))
  return fzf#run({
    \ 'source': suggestions, 'sink': function("FzfSpellSink"), 'down': 10 })
endfunction
nnoremap z= :call FzfSpell()<CR>
