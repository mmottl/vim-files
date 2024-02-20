let s:ai_model = "gpt-4-turbo-preview"

" This prompt instructs model to work with syntax highlighting
let s:initial_chat_prompt =<< trim END
>>> system

You are a general assistant. When attaching code blocks, add their syntax type
after ``` to enable highlighting. Keep your responses concise and to the point.
Try to keep all text within 80 characters.
END

" Temperature 0.2 is fairly conservative for coding
let g:vim_ai_chat = {
\  "options": {
\    "model": s:ai_model,
\    "temperature": 0.2,
\    "initial_prompt": s:initial_chat_prompt,
\  },
\}

let g:vim_ai_complete = {
\  "options": {
\    "model": s:ai_model,
\    "endpoint_url": "https://api.openai.com/v1/chat/completions",
\    "temperature": 0.2,
\  },
\}

let g:vim_ai_edit = {
\  "options": {
\    "model": s:ai_model,
\    "endpoint_url": "https://api.openai.com/v1/chat/completions",
\    "temperature": 0.2,
\  },
\}

" Jump to AI chat sections
function! s:AIChatSetupJump2Section()
  " See also https://github.com/tpope/vim-markdown/commit/191438f3582a532b72c9f8a1d6c0477050ccddef
  nnoremap <buffer><silent> ]] :<c-u>call <SID>AIChatJump2Section( v:count1, '' , 0)<CR>
  nnoremap <buffer><silent> [[ :<c-u>call <SID>AIChatJump2Section( v:count1, 'b', 0)<CR>
  xnoremap <buffer><silent> ]] :<c-u>call <SID>AIChatJump2Section( v:count1, '' , 1)<CR>
  xnoremap <buffer><silent> [[ :<c-u>call <SID>AIChatJump2Section( v:count1, 'b', 1)<CR>
  onoremap <buffer><silent> ]] :<c-u>normal ]]<CR>
  onoremap <buffer><silent> [[ :<c-u>normal [[<CR>
  let b:undo_ftplugin .= '|sil! nunmap <buffer> [[|sil! nunmap <buffer> ]]|sil! xunmap <buffer> [[|sil! xunmap <buffer> ]]'
  " From https://github.com/plasticboy/vim-markdown/issues/282#issuecomment-725909968
  xnoremap <buffer><silent> ic :<C-U>call <SID>AIChatBlockTextObj('i')<CR>
  onoremap <buffer><silent> ic :<C-U>call <SID>AIChatBlockTextObj('i')<CR>

  xnoremap <buffer><silent> ac :<C-U>call <SID>AIChatBlockTextObj('a')<CR>
  onoremap <buffer><silent> ac :<C-U>call <SID>AIChatBlockTextObj('a')<CR>
  let b:undo_ftplugin .= '|sil! ounmap <buffer> ic|sil! ounmap <buffer> ac|sil! xunmap <buffer> ic|sil! xunmap <buffer> ac'
endfunction

function s:AIChatJump2Section( cnt, dir, vis ) abort
  if a:vis
    normal! gv
  endif

  let i = 0
  let pattern = '\v^\>{3,3} user$|^\<{3,3} assistant$'
  let flags = 'W' . a:dir
  while i < a:cnt && search( pattern, flags ) > 0
    let i = i+1
  endwhile
endfunction

function s:AIChatBlockTextObj(type) abort
  " the parameter type specify whether it is inner text objects or arround
  " text objects.
  let start_row = searchpos('\v^\>{3,3} user$|^\<{3,3} assistant$', 'bn')[0]
  let end_row = searchpos('\v^\>{3,3} user$|^\<{3,3} assistant$', 'n')[0]

  let buf_num = bufnr('%')
  if a:type ==# 'i'
    let start_row += 1
    let end_row -= 1
  endif
  " echo a:type start_row end_row

  call setpos("'<", [buf_num, start_row, 1, 0])
  call setpos("'>", [buf_num, end_row, 1, 0])
  execute 'normal! `<V`>'
endfunction

augroup VimAI
  autocmd!
  autocmd FileType aichat call s:AIChatSetupJump2Section()
augroup end

" Note the space at the end of some commands for user instructions!

" Redo last AI command
nnoremap <leader>dr :AIRedo

" Complete text on current line or in visual selection with optional instruction
nnoremap <leader>da :AI
xnoremap <leader>da :AI

" Edit text on current line or in visual selection with optional instruction
nnoremap <leader>de :AIEdit
xnoremap <leader>de :AIEdit

" New chat (below), in tab, or on the side (right)
nnoremap <leader>dn :AINewChat below<CR>
nnoremap <leader>dt :AINewChat tab<CR>
nnoremap <leader>ds :AINewChat right<CR>

" Start or continue chat with optional selection and optional instruction
nnoremap <leader>dc :AIChat
xnoremap <leader>dc :AIChat
nnoremap <leader>dd :AIChat<CR>

" Fix line or selection for both general text and code with filetype context
function! AIFixFn()
  " Get the current filetype
  let curr_ft = &filetype
  " Design the fix command to include filetype information for context
  let fix_cmd  = 'AIEdit You are improving a text that may contain '
  let fix_cmd .= 'both general text and ' . curr_ft . ' code. '

  " Check if there's a visual selection
  if mode() =~# '\v\v|V|\^V'
    " Process visual selection
    execute ":'<,'>" . fix_cmd
  else
    " Process current line
    execute fix_cmd
  endif
endfunction

" Normal mode mapping to fix current line
nnoremap <leader>df :call AIFixFn()<CR>

" Visual mode mapping to fix selected text
xnoremap <leader>df :call AIFixFn()<CR>

" Explain or summarize the selected text or code
function! AIExplainSelection()
  " Store the filetype for context
  let curr_ft = &filetype

  " Start constructing the AI command with the filetype for context
  let ai_command  = 'AIChat You are explaining a ' . curr_ft . ' snippet. '
  let ai_command .= 'Explain or summarize clearly and concisely the '
  let ai_command .= 'following text or code'

  " Check for visual mode and replace it with the proper command
  if mode() =~# '\v\v|V|\^V'
    " Prepend the visual range to the command
    let ai_command = "'<,'>" . ai_command
  endif

  " Execute the command
  execute ai_command
endfunction
" Visual mode mapping to explain the selected text or code
xnoremap <leader>dx :call AIExplainSelection()<CR>

" Custom command suggesting git commit message, takes no arguments
function! AIPromptCommitMessageFn()
  let l:diff = system('git diff --staged')
  let l:prompt = "Generate a short commit message from this diff:\n" . l:diff
  let l:range = 0
  let l:config = {
  \  "options": {
  \    "model": s:instruct_ai_model,
  \    "initial_prompt": ">>> system\nYou are a code assistant",
  \    "temperature": 0.2,
  \  },
  \}
  call vim_ai#AIRun(l:range, l:config, l:prompt)
endfunction
command! AIPromptCommitMessage call AIPromptCommitMessageFn()
nnoremap <leader>dk :<C-u>call AIPromptCommitMessageFn()<CR>

" Custom command that provides a code review for selected code block
function! AIPromptCodeReviewFn(range) range
  let l:prompt = "Vim filetype is " . &filetype . ", review the code below"
  let l:config = {
  \  "options": {
  \    "model": s:chat_ai_model,
  \    "initial_prompt": ">>> system\nYou are a code review expert.",
  \  },
  \}
  '<,'>call vim_ai#AIChatRun(a:range, l:config, l:prompt)
endfunction
command! -range AIPromptCodeReview <line1>,<line2>call AIPromptCodeReviewFn(<range>)
xnoremap <leader>dR :call AIPromptCodeReviewFn()<CR>

" Custom command for adding filetype to the instruction
function! AISyntaxFn(range, ...) range
  let l:instruction = "Programming language is " . &filetype
  if a:0
    let l:instruction = l:instruction . " - " . a:1
  endif
  if a:range
    '<,'>call vim_ai#AIRun(a:range, {}, l:instruction)
  else
    call vim_ai#AIRun(a:range, {}, l:instruction)
  endif
endfunction
command! -range -nargs=? AISyntax <line1>,<line2> call AISyntaxFn(<range>, <f-args>)
nnoremap <leader>dS :AISyntax
