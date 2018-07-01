" Myst's vimrc
" Based on eevee's vimrc a lot, still. From 'scratch', but heavily borrowing
" <3

if &compatible
  set nocompatible               " Be iMproved
endif

set titlestring=vim\ %{expand(\"%t\")}
if &term =~ "^screen"
  " pretend this is xterm, instead, so vim understands ctrl-arrow
  if &term == "screen-256color"
    set term=xterm-256color
  else
    set term=xterm
  endif

  " eevee set things here but I can't manage to copy the characters, so
endif
set title

" lets you backspace over everything in insert mode
set backspace=indent,eol,start

" backups and similar files
set backupdir=~/.vim/backup          " get backups outta here
set directory=~/.vim/swap            " get swapfiles outta here
set writebackup                      " temp backup during write
set undodir=~/.vim/undo              " persistent undo storage
set undofile                         " and persistent undo on

" ui settings
set history=1000                     " remember command mode hist
set laststatus=2                     " always show status line(?)
set lazyredraw                       " don't update screen in macros etc
set matchtime=2                      " ms to show matchparen for showmatch
set number                           " line numbers
set ruler                            " show the cursor pos all the time
set showcmd                          " display incomplete commands
set showmatch                        " show matching brackets while typing
set relativenumber                   " line numbers are relative to current
set cursorline                       " highlights current line
set display=lastline,uhex            " show lastline evenif too long, use <xx>

" regex options
set incsearch                        " do incremental searching
set ignorecase                       " useful more often than not
set smartcase                        " makes it caps-sens with caps
set gdefault                         " default for :s is /g

" whitespace
set autoindent                       " keep indenting on <CR>
set shiftwidth=4                     " one tab = 4 spaces (autoindent)
set softtabstop=4                    " one tab = 4 spaces (tab key)
set expandtab                        " never use hard/literal tabs
set shiftround                       " only indent to multiples of shiftwidth
set smarttab                         " DTRT when swidth/stabstop diverge (???)
set fileformats=unix,dos             " unix linebreaks in new files, please
set listchars=tab:↹·,extends:⇉,precedes:⇇,nbsp:␠,trail:␠,nbsp:␣
                                     " appearance of invisible characters

set formatoptions=crqlj              " wrap comments, never autowrap long lines
set tabstop=4                        " eevee had a big block of text about this
                                     " i do not care, to be honest about their
				     " concerns about this. sorry

" wrapping
set colorcolumn=81                   " highlight column 81
set linebreak                        " break on what looks like boundaries
set showbreak=↳\                     " shown at the start of a wrapped line
"set textwidth=80                     " this would wrap after 80 columns
set virtualedit=block                " allow moving visual block into the VOID

" gui stuffs
if !has('nvim')			    " This was removed in neovim
  set ttymouse=xterm2                " overrides autodetection so works w/ screen
endif
set mouse=a                          " always terminal mouse when possible
set guifont=Fura\ Code\ Nerd\ Font\ 12
                                     " font i am currently using

" unicode
set encoding=utf-8                   " best default
setglobal fileencoding=utf-8         " because i guess this is needed too? *shrug*
set nobomb                           " do not write BOMs with utf8 files
set fileencodings=ucs-bom,utf-8,iso8859-1
                                     " order to detect encoding i guess?

" tab completion
" TODO: tweak this
set wildmenu                         " show a menu of completions
set wildmode=full                    " longest common prefix first
set wildignore+=.*.sw*,__pycache__,*.pyc
                                     " ignore some (mostly py) junk files
set complete-=i                      " don't try to tab complete #included files
set completeopt-=preview             " no preview window (eevee says super annoying)

" misc settings
set scrolloff=2                      " always have 2 lines of ctx around curr on screen
set foldmethod=indent                " autofold based on indent (good for python especially?)
set foldlevel=99                     " (???) uncommented, i guess probably max fold levels?
set timeoutlen=1000                  " wait 1s for mappings to finish
set ttimeoutlen=100                  " but only .1s for keycodes to finish
set nrformats-=octal                 " no autoincr 'octal' (??????)

set autoread                         " reload changed files
" NOTE: 'autoread' seems to not check for changes very often; mostly after
" doing a shell command and when focus is /lost/.  (My reading of the source
" code suggests it ought to happen during a buffer switch, but vim in practice
" disagrees?)  Even the 'focus lost' check — a strange choice — doesn't
" actually work in a terminal!
" So I use tmux's focus-events setting, the tmux-focus-events plugin, AND the
" following autocommands to check for changes when gaining focus (from tmux's
" point of view), when entering a buffer, and when idling.
autocmd FocusGained * if mode() != 'c' | checktime | endif
autocmd BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | execute 'checktime' expand("<abuf>") | endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins

" add dein to rtp
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

" Begin block of dein plugins
if dein#load_state('~/.cache/dein')
    call dein#begin('~/.cache/dein')

    " dein.vim - dark powered plugin manager
    call dein#add('Shougo/dein.vim')

    " my colorscheme - solarized
    call dein#add('altercation/vim-colors-solarized')

    " more colorschemes
    call dein#add('tomasr/molokai')

    call dein#add('chriskempson/base16-vim')

    " airline and related (mainly the themes)
    " vim-airline: status/tabline for vim 'as light as air'
    " replaces powerline
    call dein#add('vim-airline/vim-airline')
    call dein#add('vim-airline/vim-airline-themes')

    " vim-repeat, enhances the . command to repeat more
    " can be used by many other tpope plugins to make them nicer
    call dein#add('tpope/vim-repeat')

    " other tpope plugins
    "
    " abolish: easily work with multiple variants of a word
    call dein#add('tpope/vim-abolish')
    " unimpaired: pairs of handy bracket mappings
    call dein#add('tpope/vim-unimpaired')
    " surround: quoting/parenthesizing made easy
    call dein#add('tpope/vim-surround')

    call dein#add('tpope/vim-commentary')

    call dein#add('tpope/vim-characterize')
    " fugitive: best git wrapper for vim hands-down
    call dein#add('tpope/vim-fugitive')
    " sleuth: heuristically set buffer options
    call dein#add('tpope/vim-sleuth')
    " markdown - markdown support, simple as that
    call dein#add('tpope/vim-markdown')

    " vim-dispatch - async build/test dispatcher, used by salve/fireplace below
    call dein#add('tpope/vim-dispatch')
    " vim-projectionist - granular project configuration - mostly just set up by
    " salve for me
    call dein#add('tpope/vim-projectionist')

    " vim-tmux-focus-events - ...makes focus events work in tmux? :v
    call dein#add('tmux-plugins/vim-tmux-focus-events')

    " vim-gitgutter - see a git diff in the 'gutter'
    call dein#add('airblade/vim-gitgutter')

    " denite.nvim - dark powered async unite.vim
    call dein#add('Shougo/denite.nvim')
    " unite.vim - unite and create user interfaces
    "call dein#add('Shougo/unite.vim')
    " ctrlp.vim - fuzzy anything-finder
    " obsoleted by unite, and then denite, above
    "call dein#add('ctrlpvim/ctrlp.vim')

    " gundo.vim - visualize your undo tree
    call dein#add('sjl/gundo.vim')

    " supertab - perform all your insert mode completions with tab
    " YCM is enough
    "call dein#add('ervandew/supertab')

    " rust.vim - official rust support for vim
    call dein#add('rust-lang/rust.vim')

    " vim-javascript - syntax highlighting for js
    call dein#add('pangloss/vim-javascript')

    " vim-polyglot - hundreds of languages packaged together.
    call dein#add('sheerun/vim-polyglot')

    " rainbow - maybe I won't be as clueless now. Probably
    " not, but I can wish. <Something like paredit, that I also know how to
    " use, would be reeeeeeal nice.>
    " Side note: the things above were parens but that broke things badly?
    " Bad parsing code in dein or something it looked like from the glimpse of
    " the error? :shrug:
    " I originally tried to use something that didn't work and followed a
    " chain of updates to find this one.
    call dein#add('luochen1990/rainbow')

    " webapi-vim - an interface to various types of web apis
    " used by an optional feature of rust.vim
    call dein#add('mattn/webapi-vim')

    " syntastic.vim - the best syntax checking framework for vim
    " (it's fantastic! it's syntastic!)
    "call dein#add('vim-syntastic/syntastic')

    " ale - Asynchronous Lint Engine
    " replaces syntastic
    call dein#add('w0rp/ale')

    " YouCompleteMe - a code completion engine for vim
    " It turns out building this is bad on a VPS :P
    "call dein#add('Valloric/YouCompleteMe', {'build': 'python install.py --rust-completer --js-completer'})
    call dein#add('Valloric/YouCompleteMe', {'merged': 0})

    """"" Python Plugins
    " python-mode - pylint, rope, pydoc, more
    " broke something else, and YCM is enough nowadays <said eevee iirc?>
    "call dein#add('klen/python-mode')
    " jedi-vim - use the jedi autocompletion library in vim
    " YCM is enough nowadays
    "call dein#add('davidhalter/jedi-vim')

    """" Lisp
    " fireplace.vim - Clojure repl support
    call dein#add('tpope/vim-fireplace')
    " salve.vim - static support for Leiningen/Boot
    call dein#add('tpope/vim-salve')

    """" Misc
    " vim-wakatime - track coding time with wakatime
    call dein#add('wakatime/vim-wakatime')

    " Add or remove your plugins here:
    "call dein#add('Shougo/neosnippet.vim')
    "call dein#add('Shougo/neosnippet-snippets')

    " You can specify revision/branch/tag.
    "call dein#add('Shougo/vimshell', { 'rev': '3787e5' })

    " end of dein block, plugins are NOW SOURCED.
    " consider this to be pathogen#infect.
    call dein#end()
    call dein#save_state()
endif

" ALE (linter)
" Only use flake8 for python, because pylint is huge and impossible to appease
" Can use mypy too
" Limit to eslint and flow for js by default because of xo
" I don't care *which* linter was being so frustrating and useless w/ html I
" just want it gone
let g:ale_linters = {
\   'python': ['flake8', 'mypy'],
\   'javascript': ['eslint', 'flow'],
\   'html': ['htmlhint', 'tidy'],
\}
" No fixers are setup by default, so everything is manual
" For css: just run through prettier
" json: same with jq
" javascript: prettier, again
" python: heavy handed, reformat, sort imports, and misc generic cleanup in
" case yapf doesn't get them.
let g:ale_fixers = {
\   'css': [
\       'prettier',
\   ],
\   'json': [
\       'jq',
\   ],
\   'javascript': [
\       'prettier',
\   ],
\   'python': [
\       'yapf',
\       'isort',
\       'remove_trailing_lines',
\       'trim_whitespace',
\   ],
\}
" Stupid Unicode tricks
let g:ale_sign_info = "🚩"
let g:ale_sign_warning = "🚨"
let g:ale_sign_error = "💥"
let g:ale_sign_style_warning = "💈"  " get it?  /style/ issues?  wow tough crowd
let g:ale_sign_style_error = "🚨"

" YCM?
let g:ycm_server_python_interpreter = '/usr/bin/python'

" Airline; use powerline-style glyphs and colors
let g:airline_powerline_fonts = 1
let g:airline#extensions#ale#error_symbol = "🚨"
let g:airline#extensions#ale#warning_symbol = "🚩"
"let g:airline_left_sep = "\uE0C6"
"let g:airline_right_sep = "\uE0C7"
let g:airline_theme='base16_oceanicnext'

" Denite (searcher for files in the current dir, but also ag, buffers, ...)
" Most of this comes straight from the documentation.
" Use up/down to browse the suggestions
" TODO i wish there were a "post-search" mode?  is that what normal mode is?
call denite#custom#map('insert', '<Down>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<Up>', '<denite:move_to_previous_line>', 'noremap')
" TODO: cpsm?  ctrlp-based very fast file matching
"call denite#custom#source( 'file_mru', 'matchers', ['matcher_fuzzy', 'matcher_project_files'])
call denite#custom#option('default', 'prompt', '» ')
call denite#custom#option('default', 'auto_resize', v:true)
if executable('rg')
	call denite#custom#var('file_rec', 'command', ['rg', '--files', '--glob', '!.git'])

	call denite#custom#var('grep', 'command', ['rg'])
	call denite#custom#var('grep', 'default_opts', ['--vimgrep', '--no-heading'])
	call denite#custom#var('grep', 'recursive_opts', [])
	call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
	call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'final_opts', [])
elseif executable('ag')
	call denite#custom#var('file_rec', 'command', ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])

	call denite#custom#var('grep', 'command', ['ag'])
	call denite#custom#var('grep', 'default_opts', ['-i', '--vimgrep'])
	call denite#custom#var('grep', 'recursive_opts', [])
	call denite#custom#var('grep', 'pattern_opt', [])
	call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'final_opts', [])
endif
" TODO mappings for file_mru?  buffers?
nnoremap <silent> <c-p> :Denite file_rec<cr>
nnoremap <silent> g/ :Denite grep<cr>

" Polyglot; disable the language packs I have installed already
let g:polyglot_disabled = ['javascript', 'rust']

" rainbow
let g:rainbow_active = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Bindings

" Stuff that clobbers default bindings
" Force ^U and ^W in insert mode to start a new undo group
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>

" Bind Dispatch to F9 for easy builds
nnoremap <F9> :Dispatch<CR>

" Easy running of ALEFix
nmap <F8> <Plug>(ale_fix)

" Leader
"let mapleader = ","
"let g:mapleader = ","

" Swaps selection with buffer
vnoremap <C-X> <Esc>`.``gvP``P

" ctrl-arrow in normal mode to switch windows; overrides ctrl-left/right for
" moving by words, but i tend to use those only in insert mode
noremap <C-Left> <C-W><Left>
noremap <C-Right> <C-W><Right>
noremap <C-Up> <C-W><Up>
noremap <C-Down> <C-W><Down>

" -/= to navigate tabs
nnoremap - :tabprevious<CR>
nnoremap = :tabnext<CR>

" Bind gb to toggle between the last two tabs
map gb :exe "tabn ".g:ltv<CR>
function! Setlasttabpagevisited()
    let g:ltv = tabpagenr()
endfunction

augroup localtl
    autocmd!
    autocmd TabLeave * call Setlasttabpagevisited()
augroup END
autocmd VimEnter * let g:ltv = 1

" Abbreviation to make `:e %%/...` edit in same directory
cabbr <expr> %% expand('%:.:h')

""" For plugins
" gundo
noremap <Leader>u :GundoToggle<CR>

" Autocmds to make dispatch even more useful
" autocmd FileType java let b:dispatch = 'javac %' " example for plain java
" ...Why do I have this, again?


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Miscellaneous autocmds

" Automatically delete swapfiles older than the actual file.
" Look at this travesty.  vim already has this information but doesn't expose
" it, so I have to reparse the swap file.  Ugh.
function! s:SwapDecide()
python << endpython
import os
import struct

import vim

# Format borrowed from:
# https://github.com/nyarly/Vimrc/blob/master/swapfile_parse.rb
SWAPFILE_HEADER = "=BB10sLLLL40s40s898scc"
size = struct.calcsize(SWAPFILE_HEADER)
with open(vim.eval('v:swapname'), 'rb') as f:
    buf = f.read(size)
(
    id0, id1, vim_version, pagesize, writetime,
    inode, pid, uid, host, filename, flags, dirty
) = struct.unpack(SWAPFILE_HEADER, buf)

try:
    # Test whether the pid still exists.  Could get fancy and check its name
    # or owning uid but :effort:
    os.kill(pid, 0)
except OSError:
    # NUL means clean, \x55 (U) means dirty.  Yeah I don't know either.
    if dirty == b'\x00':
        # Appears to be from a crash, so just nuke it
        vim.command('let v:swapchoice = "d"')

endpython
endfunction

if has("python")
    augroup eevee_swapfile
        autocmd!
        autocmd SwapExists * call s:SwapDecide()
    augroup END
endif

" Where did this come from
autocmd Filetype pug setlocal ts=2 sw=2
autocmd Filetype scss setlocal ts=2 sw=2

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colors and syntax
" in GUI or color console, enable coloring and search highlighting
if &t_Co > 2 || has("gui_running")
  syntax enable
  set background=dark
  set hlsearch
endif

" This is an absolute mess
"set t_Co=256  " force 256 colors
"colorscheme solarized

" Current colorscheme setup.
" This works with neovim by always looking at the file in ~/.vim, and always
" keeping a symlink at the neovim location.
" Currently there should always be a scheme because it's being kept in git I
" guess, but I'm not sure I really want that so this will always work.
if filereadable(expand("~/.vim/colors/base16.vim"))
  colorscheme base16 " Scheme from my setup exists, load it.
else
  colorscheme base16-atelier-forest " Fallback scheme, otherwise it errors.
endif
"AirlineTheme molokai
let g:airline_theme='base16_oceanicnext'

"if filereadable(expand("~/.vimrc_background"))
  "let base16colorspace=256
  "source ~/.vimrc_background
"endif
set termguicolors
" Not sure if I like this. Berfect colors in terminals with 24bit color
" support always, but it also makes scrolling significantly slower?
set guifont=Fira\ Code\ Medium\ 12

if has("autocmd")
  " Filetypes and indenting settings
  filetype plugin indent on

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
endif " has("autocmd")

filetype plugin indent on
syntax enable
