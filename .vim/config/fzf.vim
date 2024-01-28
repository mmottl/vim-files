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
nnoremap <silent> <leader>fF :FZFFiles!<CR>
nnoremap <silent> <leader>fh :FZFHistory<CR>
nnoremap <silent> <leader>f: :FZFHistory:<CR>
cnoremap <silent> <C-p>      :FZFHistory:<CR>
nnoremap <silent> <leader>f/ :FZFHistory/<CR>

nnoremap <silent> <leader>fg :FZFGFiles<CR>
nnoremap <silent> <leader>fG :FZFGFiles?<CR>
nnoremap <silent> <leader>fr :FZFRg<CR>
nnoremap <silent> <leader>fR :FZFRG<CR>
nnoremap <silent> <leader>fb :FZFBuffers<CR>
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

" Function to open selected file with root prefix while stripping lsd icon
function! s:open_selected_lsd_file(root, selected_file_with_icon)
  " Split the input by space and take the last part, which is the file name
  let file_parts = split(a:selected_file_with_icon)
  let selected_file = file_parts[-1]

  " Open the file in Vim
  execute 'edit ' . a:root . '/' . selected_file
endfunction

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
  \   'source':
  \      'cd '.root.' && git ls-files -z --deduplicate
  \      | xargs -0 lsd -d --color=always --icon=always',
  \   'sink': function('s:open_selected_lsd_file', [root]),
  \   'options': '-m --preview "bat -n --color=always --line-range :10000 '.root.'/{2}" --preview-window right:66%',
  \ }
  call fzf#run(fzf#wrap(opts))
endfunction
nnoremap <silent> <leader>fg :call <SID>setup_fzf_all_git_files()<CR>

" Set up FZF for git files in current subdirectory
function! s:setup_fzf_git_files()
  let opts = {
  \ 'source': 'ls --color $(git ls-files)',
  \ 'options': '--preview "bat -n --color=always --line-range :10000 {}" --preview-window right:66%',
  \ }
  call fzf#run(fzf#wrap(opts))
endfunction
nnoremap <silent> <leader>fx :call <SID>setup_fzf_git_files()<CR>

" Set up spell checking via FZF
function! FzfSpellSink(word)
  exe 'normal! "_ciw'.a:word
endfunction
function! FzfSpell()
  let suggestions = spellsuggest(expand("<cword>"))
  return fzf#run({'source': suggestions, 'sink': function("FzfSpellSink"), 'down': 10 })
endfunction
nnoremap z= :call FzfSpell()<CR>

" Use tree tool for directory previews
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>,
  \ {'options': [
  \ '--layout=reverse', '--info=inline',
  \ '--preview-window', 'right:66%', '--preview',
  \ '[[ -d {} ]] && tree -C {} | head -200 ||
  \ ~/.vim/pack/mmottl/start/fzf.vim/bin/preview.sh {}']}, <bang>0)

" FZFMru
command! -bang -nargs=? FZFMru call fzf_mru#actions#mru(<q-args>, {
  \ 'window': {
  \   'width': 0.9,
  \   'height': 0.9
  \ },
  \ 'options': [
  \   '--preview', 'bat -n --color=always --line-range :10000 {}',
  \   '--preview-window', 'right:66%',
  \   '--bind', 'ctrl-_:toggle-preview'
  \ ]
\ })

let g:fzf_mru_max = 10000
nnoremap <leader>fm :FZFMru<CR>
