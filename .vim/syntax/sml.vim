" Vim syntax file
" Language:     SML
" Filenames:    *.sml *.sig
" Maintainers:  Markus Mottl            <markus.mottl@gmail.com>
"               Fabrizio Zeno Cornelli  <zeno@filibusta.crema.unimi.it>
" Last Change:  2021 Nov 20 - Improve number and string highlighting (Doug Kearns)
"                           - Add support for Successor ML lexical extensions
"               2021 Oct 04 - Fixed spell checking bug (Chuan Wei Foo)
"               2019 Oct 01 - Only spell check strings & comments (Chuan Wei Foo)

" quit when a syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

" Disable spell checking of syntax.
syn spell notoplevel

" SML is case sensitive.
syn case match

" lowercase identifier - the standard way to match
syn match    smlLCIdentifier /\<\(\l\|_\)\(\w\|'\)*\>/

syn match    smlKeyChar    "|"

" Errors
syn match    smlBraceErr   "}"
syn match    smlBrackErr   "\]"
syn match    smlParenErr   ")"
syn match    smlCommentErr "\*)"
syn match    smlThenErr    "\<then\>"

" Error-highlighting of "end" without synchronization:
" as keyword or as error (default)
if exists("sml_noend_error")
  syn match    smlKeyword    "\<end\>"
else
  syn match    smlEndErr     "\<end\>"
endif

" Some convenient clusters
syn cluster  smlAllErrs contains=smlBraceErr,smlBrackErr,smlParenErr,smlCommentErr,smlEndErr,smlThenErr

syn cluster  smlAENoParen contains=smlBraceErr,smlBrackErr,smlCommentErr,smlEndErr,smlThenErr

syn cluster  smlContained contains=smlTodo,smlPreDef,smlModParam,smlModParam1,smlPreMPRestr,smlMPRestr,smlMPRestr1,smlMPRestr2,smlMPRestr3,smlModRHS,smlFuncWith,smlFuncStruct,smlModTypeRestr,smlModTRWith,smlWith,smlWithRest,smlModType,smlFullMod


" Enclosing delimiters
syn region   smlEncl transparent matchgroup=smlKeyword start="(" matchgroup=smlKeyword end=")" contains=ALLBUT,@smlContained,smlParenErr
syn region   smlEncl transparent matchgroup=smlKeyword start="{" matchgroup=smlKeyword end="}"  contains=ALLBUT,@smlContained,smlBraceErr
syn region   smlEncl transparent matchgroup=smlKeyword start="\[" matchgroup=smlKeyword end="\]" contains=ALLBUT,@smlContained,smlBrackErr
syn region   smlEncl transparent matchgroup=smlKeyword start="#\[" matchgroup=smlKeyword end="\]" contains=ALLBUT,@smlContained,smlBrackErr


" Comments
if exists("sml_no_comment_fold")
  syn region   smlComment start="(\*" end="\*)" contains=smlComment,smlTodo,@Spell
else
  syn region   smlComment start="(\*" end="\*)" contains=smlComment,smlTodo,@Spell fold
endif
if get(g:, "sml_successor_ml", 0)
  syn match      smlComment "(\*).*"
endif
syn keyword  smlTodo contained TODO FIXME XXX


" let
syn region   smlEnd matchgroup=smlKeyword start="\<let\>" matchgroup=smlKeyword end="\<end\>" contains=ALLBUT,@smlContained,smlEndErr

" local
syn region   smlEnd matchgroup=smlKeyword start="\<local\>" matchgroup=smlKeyword end="\<end\>" contains=ALLBUT,@smlContained,smlEndErr

" abstype
syn region   smlNone matchgroup=smlKeyword start="\<abstype\>" matchgroup=smlKeyword end="\<end\>" contains=ALLBUT,@smlContained,smlEndErr

" if
syn region   smlNone matchgroup=smlKeyword start="\<if\>" matchgroup=smlKeyword end="\<then\>" contains=ALLBUT,@smlContained,smlThenErr


"" Modules

" "struct"
syn region   smlStruct matchgroup=smlModule start="\<struct\>" matchgroup=smlModule end="\<end\>" contains=ALLBUT,@smlContained,smlEndErr

" "sig"
syn region   smlSig matchgroup=smlModule start="\<sig\>" matchgroup=smlModule end="\<end\>" contains=ALLBUT,@smlContained,smlEndErr,smlModule
syn region   smlModSpec matchgroup=smlKeyword start="\<structure\>" matchgroup=smlModule end="\<\u\(\w\|'\)*\>" contained contains=@smlAllErrs,smlComment skipwhite skipempty nextgroup=smlModTRWith,smlMPRestr

" "open"
syn region   smlNone matchgroup=smlKeyword start="\<open\>" matchgroup=smlModule end="\<\w\(\w\|'\)*\(\.\w\(\w\|'\)*\)*\>" contains=@smlAllErrs,smlComment

" "structure" - somewhat complicated stuff ;-)
syn region   smlModule matchgroup=smlKeyword start="\<\(structure\|functor\)\>" matchgroup=smlModule end="\<\u\(\w\|'\)*\>" contains=@smlAllErrs,smlComment skipwhite skipempty nextgroup=smlPreDef
syn region   smlPreDef start="."me=e-1 matchgroup=smlKeyword end="\l\|="me=e-1 contained contains=@smlAllErrs,smlComment,smlModParam,smlModTypeRestr,smlModTRWith nextgroup=smlModPreRHS
syn region   smlModParam start="([^*]" end=")" contained contains=@smlAENoParen,smlModParam1
syn match    smlModParam1 "\<\u\(\w\|'\)*\>" contained skipwhite skipempty nextgroup=smlPreMPRestr

syn region   smlPreMPRestr start="."me=e-1 end=")"me=e-1 contained contains=@smlAllErrs,smlComment,smlMPRestr,smlModTypeRestr

syn region   smlMPRestr start=":" end="."me=e-1 contained contains=@smlComment skipwhite skipempty nextgroup=smlMPRestr1,smlMPRestr2,smlMPRestr3
syn region   smlMPRestr1 matchgroup=smlModule start="\ssig\s\=" matchgroup=smlModule end="\<end\>" contained contains=ALLBUT,@smlContained,smlEndErr,smlModule
syn region   smlMPRestr2 start="\sfunctor\(\s\|(\)\="me=e-1 matchgroup=smlKeyword end="->" contained contains=@smlAllErrs,smlComment,smlModParam skipwhite skipempty nextgroup=smlFuncWith
syn match    smlMPRestr3 "\w\(\w\|'\)*\(\.\w\(\w\|'\)*\)*" contained
syn match    smlModPreRHS "=" contained skipwhite skipempty nextgroup=smlModParam,smlFullMod
syn region   smlModRHS start="." end=".\w\|([^*]"me=e-2 contained contains=smlComment skipwhite skipempty nextgroup=smlModParam,smlFullMod
syn match    smlFullMod "\<\u\(\w\|'\)*\(\.\u\(\w\|'\)*\)*" contained skipwhite skipempty nextgroup=smlFuncWith

syn region   smlFuncWith start="([^*]"me=e-1 end=")" contained contains=smlComment,smlWith,smlFuncStruct
syn region   smlFuncStruct matchgroup=smlModule start="[^a-zA-Z]struct\>"hs=s+1 matchgroup=smlModule end="\<end\>" contains=ALLBUT,@smlContained,smlEndErr

syn match    smlModTypeRestr "\<\w\(\w\|'\)*\(\.\w\(\w\|'\)*\)*\>" contained
syn region   smlModTRWith start=":\s*("hs=s+1 end=")" contained contains=@smlAENoParen,smlWith
syn match    smlWith "\<\(\u\(\w\|'\)*\.\)*\w\(\w\|'\)*\>" contained skipwhite skipempty nextgroup=smlWithRest
syn region   smlWithRest start="[^)]" end=")"me=e-1 contained contains=ALLBUT,@smlContained

" "signature"
syn region   smlKeyword start="\<signature\>" matchgroup=smlModule end="\<\w\(\w\|'\)*\>" contains=smlComment skipwhite skipempty nextgroup=smlMTDef
syn match    smlMTDef "=\s*\w\(\w\|'\)*\>"hs=s+1,me=s

syn keyword  smlKeyword  and andalso as case
syn keyword  smlKeyword  datatype else eqtype
syn keyword  smlKeyword  exception fn fun handle
syn keyword  smlKeyword  in infix infixl infixr
syn keyword  smlKeyword  match nonfix of orelse
syn keyword  smlKeyword  raise handle type
syn keyword  smlKeyword  val where while with withtype

syn keyword  smlType     bool char exn int list option
syn keyword  smlType     real string unit

syn keyword  smlOperator div mod not or quot rem

syn keyword  smlBoolean      true false
syn match    smlConstructor  "(\s*)"
syn match    smlConstructor  "\[\s*\]"
syn match    smlConstructor  "#\[\s*\]"
syn match    smlConstructor  "\u\(\w\|'\)*\>"

" Module prefix
syn match    smlModPath      "\u\(\w\|'\)*\."he=e-1

" Strings and Characters
syn match    smlEscapeErr    "\\."              contained
syn match    smlEscape       "\\[abtnvfr"\\]"   contained
syn match    smlEscapeErr    "\\^."             contained
syn match    smlEscape       "\\^[@A-Z[\\\]^_]" contained
syn match    smlEscapeErr    "\\\d\{1,2}"       contained
syn match    smlEscape       "\\\d\{3}"         contained
syn match    smlEscapeErr    "\\u\x\{0,3}"      contained
syn match    smlEscape       "\\u\x\{4}"        contained
syn match    smlEscape       "\\\_s\+\\"        contained
syn cluster  smlEscape       contains=smlEscape,smlEscapeErr

syn region   smlString       start=+"+ end=+"+ contains=@smlEscape,@Spell

syn match    smlCharacter    +#"[^\\"]"+
syn match    smlCharacter    +#"\\."+       contains=@smlEscape
syn match    smlCharacter    +#"\\^."+      contains=@smlEscape
syn match    smlCharacter    +#"\\\d\{3}"+  contains=@smlEscape
syn match    smlCharacter    +#"\\u\x\{4}"+ contains=@smlEscape

syn match    smlFunDef       "=>"
syn match    smlRefAssign    ":="
syn match    smlTopStop      ";;"
syn match    smlOperator     "\^"
syn match    smlOperator     "::"
syn match    smlAnyVar       "\<_\>"
syn match    smlKeyChar      "!"
syn match    smlKeyChar      ";"
syn match    smlKeyChar      "\*"
syn match    smlKeyChar      "="

" Numbers
syn case     ignore
if get(g:, "sml_successor_ml", 0)
  syn match    smlInteger       "\~\=\<\d\+\%(_\+\d\+\)*\>"
  syn match    smlInteger       "\~\=\<0x\x\+\%(_\+\x\+\)*\>"
  syn match    smlInteger       "\~\=\<0b[01]\+\%(_\+[01]\+\)*\>"
  syn match    smlWord          "\<0w\d\+\%(_\+\d\+\)*\>"
  syn match    smlWord          "\<0wx\x\+\%(_\+\x\+\)*\>"
  syn match    smlWord          "\<0wb[01]\+\%(_\+[01]\+\)*\>"
  syn match    smlReal          "\~\=\<\d\+\%(_\+\d\+\)*\.\d\+\%(_\+\d\+\)*\>"
  syn match    smlReal          "\~\=\<\d\+\%(_\+\d\+\)*\%(\.\d\+\%(_\+\d\+\)*\)\=e\~\=\d\+\%(_\+\d\+\)*\>"
else
  syn match    smlInteger       "\~\=\<\d\+\>"
  syn match    smlInteger       "\~\=\<0x\x\+\>"
  syn match    smlWord          "\<0w\d\+\>"
  syn match    smlWord          "\<0wx\x\+\>"
  syn match    smlReal          "\~\=\<\d\+\.\d\+\>"
  syn match    smlReal          "\~\=\<\d\+\%(\.\d\+\)\=e\~\=\d\+\>"
endif
syn case     match

" Synchronization
syn sync minlines=20
syn sync maxlines=500

syn sync match smlEndSync     groupthere smlEnd     "\<end\>"
syn sync match smlStructSync  grouphere  smlStruct  "\<struct\>"
syn sync match smlStructSync  groupthere smlStruct  "\<end\>"
syn sync match smlSigSync     grouphere  smlSig     "\<sig\>"
syn sync match smlSigSync     groupthere smlSig     "\<end\>"

" Define the default highlighting.
" Only when an item doesn't have highlighting yet

hi def link smlBraceErr     Error
hi def link smlBrackErr     Error
hi def link smlParenErr     Error

hi def link smlCommentErr   Error

hi def link smlEndErr       Error
hi def link smlThenErr      Error

hi def link smlEscapeErr    Error

hi def link smlComment      Comment

hi def link smlModPath      Include
hi def link smlModule       Include
hi def link smlModParam1    Include
hi def link smlModType      Include
hi def link smlMPRestr3     Include
hi def link smlFullMod      Include
hi def link smlModTypeRestr Include
hi def link smlWith         Include
hi def link smlMTDef        Include

hi def link smlConstructor  Constant

hi def link smlModPreRHS    Keyword
hi def link smlMPRestr2     Keyword
hi def link smlKeyword      Keyword
hi def link smlFunDef       Keyword
hi def link smlRefAssign    Keyword
hi def link smlKeyChar      Keyword
hi def link smlAnyVar       Keyword
hi def link smlTopStop      Keyword
hi def link smlOperator     Keyword

hi def link smlBoolean      Boolean
hi def link smlCharacter    Character
hi def link smlInteger      Number
hi def link smlReal         Float
hi def link smlWord         Number
hi def link smlEscape       Special
hi def link smlString       String
hi def link smlType         Type
hi def link smlTodo         Todo
hi def link smlEncl         Keyword


let b:current_syntax = "sml"

" vim: ts=8
