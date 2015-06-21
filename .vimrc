set nocompatible
set linebreak ts=4 sw=4 expandtab
set softtabstop=4 expandtab
filetype off

set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 10

if has('unnamedplus')
    set clipboard=unnamedplus
else
    set clipboard=unnamed
endif

set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

Plugin 'scrooloose/nerdtree'
Plugin 'nanotech/jellybeans.vim'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'Shougo/unite.vim'
Plugin 'Shougo/neomru.vim'
Plugin 'Shougo/vimproc.vim'
Plugin 'Shougo/neocomplete.vim'
Plugin 'honza/vim-snippets'
Plugin 'SirVer/ultisnips'
Plugin 'itchyny/lightline.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'ap/vim-buftabline'
Plugin 'jmcantrell/vim-virtualenv'
Plugin 'jiangmiao/auto-pairs'
Plugin 'davidhalter/jedi-vim'

call vundle#end()
filetype plugin indent on
syntax on

function! NumberOfWindows()
  let i = 1
  while winbufnr(i) != -1
  let i = i+1
  endwhile
  return i - 1
endfunction


function! DonotQuitLastWindow()
  if NumberOfWindows() != 1
    let v:errmsg = ""
    silent! quit
    if v:errmsg != ""
        echohl ErrorMsg | echo v:errmsg | echohl NONE
    endif
  else
     echohl Error | echo "Can't quit the last window..." | echohl None
  endif
endfunction

if has('gui_running')
    set guioptions-=T
    set guioptions-=m
    set guioptions-=r
    set guioptions-=L
    cnoreabbrev <expr> q getcmdtype() == ":" && getcmdline() == 'q' ? 'call DonotQuitLastWindow()' : 'q'
endif

colorscheme jellybeans

syntax enable

highlight Pmenu      guifg=fg       guibg=#1c1c1c
highlight PmenuSel   guifg=#000000  guibg=#af87df
highlight PmenuSbar  guibg=#1c1c1c
highlight PmenuThumb guibg=#af87df

set relativenumber
set number
set splitbelow
set completeopt-=preview
set hidden

command! W w !sudo tee % >/dev/null

noremap <F3> :NERDTreeToggle<CR>
inoremap <F3> <C-o>:NERDTreeToggle<CR>
let g:NERDTreeChDirMode=2
let g:NERDTreeShowLineNumbers=1
let g:NERDTreeMapChdir='c'
let g:NERDTreeMapCWD='d'

let g:AutoPairs={'(':')', '[':']', '{':'}',"'":"'",'"':'"'}
let g:AutoPairsMultilineClose=0

inoremap <C-c> <Esc>
nnoremap <C-p> :Unite -start-insert file_rec/async<CR>
nnoremap <space>/ :Unite grep:.<cr>
nnoremap <space>s :Unite -quick-match buffer<cr>
inoremap jk <Esc>
nnoremap : ,
nnoremap , ;
nnoremap ; :
nnoremap <C-s> :w<CR>
nnoremap <silent> <A-k> :wincmd k<CR>
nnoremap <silent> <A-j> :wincmd j<CR>
nnoremap <silent> <A-h> :wincmd h<CR>
nnoremap <silent> <A-l> :wincmd l<CR>
nnoremap <A-o> :bnext<CR>
nnoremap <A-i> :bprev<CR>


" Neocomplete and ultisnips config
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#max_list = 20
let g:UltiSnipsExpandTrigger = "<C-CR>"
let g:UltiSnipsJumpForwardTrigger="<Tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-Tab>"
set pumheight=20

inoremap <expr><C-g>  neocomplete#undo_completion()
inoremap <expr><C-l>  neocomplete#complete_common_string()
inoremap <expr><C-h>  neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS>   neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()

let g:ulti_expand_or_jump_res = 0 "default value, just set once
let g:ulti_jump_forwards_res = 0
let g:ulti_jump_backwards_res = 0

function! Tab_Function()
  if pumvisible()
    return "\<C-n>"
  else
    call UltiSnips#JumpForwards()
    if g:ulti_jump_forwards_res == 0
      return "\<Tab>"
    endif
  endif
  return ""
endfunction

function! STab_Function()
  if pumvisible()
    return "\<C-p>"
  else
    call UltiSnips#JumpBackwards()
    if g:ulti_jump_backwards_res == 0
      return "\<BS>"
    endif
  endif
  return ""
endfunction

function! CR_Function()
    call UltiSnips#ExpandSnippetOrJump()
    if g:ulti_expand_or_jump_res > 0
        return ""
    endif
    return neocomplete#close_popup() . "\<CR>"
endfunction

inoremap <silent> <Tab> <C-R>=Tab_Function()<CR>
inoremap <silent> <S-Tab> <C-R>=STab_Function()<CR>
inoremap <silent> <CR> <C-R>=CR_Function()<CR>

autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=jedi#completions
let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0

if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns={}
endif

let g:neocomplete#force_omni_input_patterns.python = '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'

let g:unite_source_rec_async_command = 'ag --follow --nocolor --nogroup --hidden -g ""'
let g:unite_source_grep_command = 'ag'
let g:unite_source_grep_default_opts =
  \ '-i --line-numbers --nocolor --nogroup --hidden --ignore ' .
  \  '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
let g:unite_source_grep_recursive_opt = ''

" Multiple cursosr config

" Called once right before you start selecting multiple cursors
function! Multiple_cursors_before()
  if exists(':NeoCompleteLock')==2
    exe 'NeoCompleteLock'
  endif
endfunction

" Called once only when the multiple selection is canceled (default <Esc>)
function! Multiple_cursors_after()
  if exists(':NeoCompleteUnlock')==2
    exe 'NeoCompleteUnlock'
  endif
endfunction

let g:multi_cursor_insert_maps={'j':1}
let g:multi_cursor_exit_from_insert_mode=0

" Buffers tab line
let g:buftabline_indicators=1
let g:buftabline_numbers=1

hi! BufTabLineHidden guifg=#888888 guibg=#151515
hi! link BufTabLineActive Normal
hi! BufTabLineFill guibg=#242424
hi! link BufTabLineCurrent Function

" Status line
set laststatus=2
set noshowmode

let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'virtualenv', 'fugitive', 'filename' ] ]
      \ },
      \ 'component_function': {
      \   'fugitive': 'MyFugitive',
      \   'readonly': 'MyReadonly',
      \   'modified': 'MyModified',
      \   'filename': 'MyFilename'
      \ },
      \ 'component_expand': {
      \   'virtualenv': 'MyVirtualenv',
      \ },
      \ 'component_type': {
      \   'virtualenv': 'warning2'
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
      \ }

function! MyModified()
  if &filetype == "help"
    return ""
  elseif &modified
    return "+"
  elseif &modifiable
    return ""
  else
    return ""
  endif
endfunction

function! MyReadonly()
  if &filetype == "help"
    return ""
  elseif &readonly
    return ""
  else
    return ""
  endif
endfunction

function! MyFugitive()
  if exists("*fugitive#head")
    let _ = fugitive#head()
    return strlen(_) ? ' '._ : ''
  endif
  return ''
endfunction

function! MyFilename()
  return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
       \ ('' != expand('%:t') ? expand('%:t') : '[No Name]') .
       \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyVirtualenv()
  if &filetype == "python"
    let _ = virtualenv#statusline()
    return strlen(_) ? 'ⓔ '._ : ''
  endif
  return ''
endfunction
