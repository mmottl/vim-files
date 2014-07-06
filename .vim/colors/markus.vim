" Favorite font
"set guifont=MiscFixed\ 8
"set guifont=Andale\ Mono:h9
set guifont=Monaco:h10

" My colour preferences - NOTE: I use a black background!
set background=dark

set noantialias

hi Normal     ctermbg=Black guifg=Lightyellow guibg=Black
hi Comment    term=bold ctermfg=DarkCyan guifg=Cyan
hi Constant   term=underline ctermfg=DarkRed guifg=Red
hi String     term=underline ctermfg=DarkRed guifg=Red
hi Boolean    term=underline ctermfg=DarkRed guifg=Red
hi Special    term=bold ctermfg=DarkMagenta guifg=Magenta
hi Identifier term=bold ctermfg=White guifg=White
hi Statement  term=bold ctermfg=Brown gui=NONE guifg=Yellow
hi PreProc    term=underline ctermfg=DarkMagenta guifg=Magenta
hi Type       term=underline ctermfg=DarkGreen gui=NONE guifg=Green
hi Ignore     ctermfg=white guifg=bg
hi Error      term=reverse ctermbg=Red ctermfg=White guibg=Red guifg=White
hi Todo       term=standout ctermbg=Yellow ctermfg=Black guibg=Yellow guifg=Black
hi Search     term=reverse ctermbg=3 ctermfg=0 guibg=Yellow guifg=black
hi Pmenusel   guifg=DarkBlue guibg=DarkRed gui=NONE ctermfg=White ctermbg=DarkRed
