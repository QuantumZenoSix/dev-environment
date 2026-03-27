set nocompatible    " Set compatibility to Vim-Only (not vi)
set number
set relativenumber  " Set relative numbering with absolute line number for cursor line
set autoindent
set shiftwidth=4    " Set shift width to 4 spaces.
set tabstop=4       " Set tab width to 4 columns.
set expandtab       " Use space characters instead of tabs.
set smarttab
set showmode        " Show the mode you are on the last line.
set showmatch       " Show matching words during a search.
set hlsearch        " Use highlighting when doing a search.
set history=1000    " Set the commands to save in history default number is 20.
set incsearch
set laststatus=2    " Status Bar
set mouse=a
set wrap            " Text-Wrap
set ignorecase
set wildignorecase  " Ignore case when search using wildcards
set encoding=utf-8
set splitright
set splitbelow
set clipboard=unnamedplus " Yank to system clipboard
" set softtabstop
syntax on           " Turn syntax highlighting on.

" Next 3 lines set proper colors
set termguicolors
set t_Co=256
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" Use ':Diff' to see a diff between your current unsaved version and what's on the hard disk.
" command Diff execute 'w !git diff --no-index % -'

" Set grep program details
set grepprg=grep\ -nH\ -r\ -i\ --include='*.pl'\ --include='*.pm'\ --include='*.py'\ --include='*.js'\ --include='*.c'\ --include='*.cpp'\ --include='*.sh'\ --include='*.ps1'\ --include='*.css'\ --include='*.lua'\ --exclude='*.min.js'



" ============ Key-bindings ================
"
" Set leader key
let mapleader = " "

" Integrated Terminal
noremap <silent> <C-_> :terminal <CR>

" Clear search highlights with Esc
" noremap <silent> <Esc> :nohlsearch<CR><Esc>
nnoremap <silent> <Leader>h :nohlsearch<CR>

" Line numbering
nnoremap <silent> <Leader>le :set number relativenumber<CR>
nnoremap <silent> <Leader>ld :set nonumber norelativenumber<CR>
nnoremap <silent> <Leader>ll :set nonumber norelativenumber<CR>

" Enter visual-block mode with Ctrl+b
noremap <silent> <C-b> <C-v>

" Yanking yanks to unamed register (default) as well as system clipboard
nnoremap <leader>y ""y"+y
vnoremap <leader>y ""y"+y</leader></leader>

" Remove all markers with <Leader>rm
" noremap <silent> <Leader>rm :delm a-zA-Z0-9<CR>

" Move down/up 20 lines with <Leader>j/k
noremap <silent> <leader>j 20<C-e>
noremap <silent> <Leader>k 20<C-y>

" Quickfix navigation with F12/F11
noremap <silent> <F12> :cn<CR>
noremap <silent> <F11> :cp<CR>

" Indent/unindent in visual mode and keep selection
vnoremap <silent> > >gv
vnoremap <silent> < <gv

" Force close window
noremap <silent> <C-w>q :q!<CR>



" ============ vim-plug plugins =================

" Auto-Install Vim-Plug and run :PlugInstall (if not installed)
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
"
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Viet nonumber norelativenumber (Windows): '~/vimfiles/plugged'
"   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
" You can specify a custom plugin directory by passing it as1I the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
"   - Avoid using standard Vim directory names like 'plugin'

" Make sure you use single quotes
" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align

" Initialize plugin system
" - Automatically executes `filetype plugin indent on` and `syntax enable`.

" ============================================================================="
" ============================================================================="

" BEGIN PLUGINS
call plug#begin()


" _______________________ COLORSCHEME __________________________
Plug 'catppuccin/vim', { 'as': 'catppuccin' }       " Catppuccin syntax highlighting [https://github.com/catppuccin/vim/tree/main]
Plug 'thedenisnikulin/vim-cyberpunk'
Plug 'metalelf0/base16-black-metal-scheme'
" Plug 'vimcolorschemes/vimcolorschemes'
" Plug 'artanikin/vim-synthwave84'
" Plug 'ronwoch/hotline-vim'
" Plug 'eihigh/vim-aomi-grayscale'
"Plug 'hardselius/warlock'
"Plug 'ntk148v/komau.vim'
"Plug 'smallwat3r/vim-simplicity'

" My custom theme
Plug 'QuantumZenoSix/gothic-cyberpunk.vim'


" _______________________ AIRLINE __________________________
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Get themes:https://github.com/vim-airline/vim-airline-themes/tree/master/autoload/airline/themesI


" _______________________ FILE EXPLORER __________________________
Plug 'scrooloose/nerdtree'
nnoremap <Leader><Space> :NERDTreeToggle<CR>
" Configure file exlplorer
" set netrw_browse_split=3
" let g:netrw_winsize = 20
" let g:netrw_banner = 0


" _______________________ Indentline __________________________
Plug 'Yggdroot/indentLine'
let g:indentLine_defaultGroup = 'SpecialKey'
let g:indentLine_char = '|'
noremap <silent> <Leader>ie :IndentLinesEnable<CR>
noremap <silent> <Leader>id :IndentLinesDisable<CR>

" _______________________ Git Gutter (signs) __________________________
Plug 'airblade/vim-gitgutter'  
let g:gitgutter_enabled = 1         " Enable vim-gitgutter by default
let g:gitgutter_realtime = 1        " Update signs in real-time
set updatetime=100                  " Set updatetime to 100ms for faster updates
let g:gitgutter_max_signs = 100000  " default value 500 (Vim < 8.1.0614, Neovim < 0.4.0)
" vim-gitgutter icons
let g:gitgutter_sign_added = "▎"
let g:gitgutter_sign_modified = "▎"
let g:gitgutter_sign_removed = "▎"
let g:gitgutter_sign_removed_first_line = "▎"
let g:gitgutter_sign_removed_above_and_below = "▎"
let g:gitgutter_sign_modified_removed = "▎"

noremap <silent> <Leader>gt :GitGutterToggle<CR>        " Git signs toggle (requires vim-gitgutter plugin)
noremap <silent> <Leader>gs :Git<CR>
" noremap <silent> <Leader>gd :GitGutterDiffOrig<CR>


" _______________________ Vim-fugitive __________________________
Plug 'tpope/vim-fugitive'
noremap <silent> <Leader>gu :!git reset --hard HEAD~1<CR>
noremap <silent> <Leader>ga :!git stash save<CR>
noremap <silent> <Leader>gg :Git<CR>
noremap <silent> <Leader>gd :Gdiffsplit<CR>
noremap <silent> <Leader>gb :Git blame<CR>
noremap <silent> <Leader>go :GBrowse<CR>
noremap <silent> <Leader>gl :Gclog<CR>
"noremap <silent> <Leader>gc :Git commit<CR>


" _______________________ Indentline __________________________
Plug 'Yggdroot/indentLine'
let g:indentLine_defaultGroup = 'SpecialKey'
let g:indentLine_char = '|'
noremap <silent> <Leader>ie :IndentLinesEnable<CR>
noremap <silent> <Leader>id :IndentLinesDisable<CR>
noremap <silent> <Leader>ii :IndentLinesToggle<CR>
let g:indentLine_enabled = 0                " Disable by default

" _______________________ Vim-Sneak __________________________
" Vim-sneak (like flash in nvim)
Plug 'justinmk/vim-sneak'

" _______________________ Bufferline __________________________
Plug 'nvim-tree/nvim-web-devicons' " Recommended (for coloured icons)
Plug 'bling/vim-bufferline'
" Plug 'ryanoasis/vim-devicons' Icons without colours
" Plug 'akinsho/bufferline.nvim', { 'tag': '*' }pEºJ


" _______________________ Syntastic [Deprecated in favir of ALE] __________________________
" "Plug 'vim-syntastic/syntastic'
" "set statusline+=%#warningmsg#
" "set statusline+=%{SyntasticStatuslineFlag()}
" "set statusline+=%*
" "
" "let g:syntastic_always_populate_loc_list = 1
" "let g:syntastic_auto_loc_list = 1
" "let g:syntastic_check_on_open = 1
" "let g:syntastic_check_on_wq = 0
" "let g:syntastic_error_symbol = "✗"
" "let g:syntastic_warning_symbol = "⚠"
" "
"  Toggle Syntastic mode (active/passive)
" "nnoremap <C-w>E :SyntasticToggleMode<CR>
"  Manually check syntax
" "nnoremap <C-w>C :SyntasticCheck<CR>
"  Open location list (show errors)
" "nnoremap <C-w>L :Errors<CR>
"  Navigate errors
" "nnoremap <C-w>N :lnext<CR>
" "nnoremap <C-w>P :lprev<CR>
"  Reset Syntastic
" "nnoremap <C-w>R :SyntasticReset<CR>


" _______________________ COC __________________________
" Use release branch (recommended)
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Install coc extensions
let g:coc_global_extensions = [
      \ 'coc-perl',
      \ 'coc-jedi',
      \ 'coc-clangd',
      \ 'coc-sh',
      \ 'coc-tsserver',
\ ]

" Manual install => CocInstall coc-perl coc-prettier@1.1.17
" Extension list => https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions

" Note: language servers still need to be installed (npm)

" --- Autocompletion ---
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>" " Confirm completion with Enter
inoremap <silent><expr> <C-Space> coc#refresh() " Trigger completion with Ctrl+Space
inoremap <silent><expr> <Tab> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>" " Navigate completion menu forward
inoremap <silent><expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>" " Navigate completion menu backward

" --- Code Navigation ---
nmap <silent> <leader>cd <Plug>(coc-definition) " Go to definition
nmap <silent> <leader>ct <Plug>(coc-type-definition) " Go to type definition
nmap <silent> <leader>ci <Plug>(coc-implementation) " Go to implementation
nmap <silent> <leader>cr <Plug>(coc-references) " Go to references

" --- Diagnostics ---
nmap <silent> <leader>cs :CocList diagnostics<CR> " Show diagnostics list
nmap <silent> <leader>cn <Plug>(coc-diagnostic-next) " Next diagnostic
nmap <silent> <leader>cp <Plug>(coc-diagnostic-prev) " Previous diagnostic

" " --- Code Actions ---
" nmap <silent> <leader>ca <Plug>(coc-codeaction-cursor) " Apply code action at cursor
" nmap <silent> <leader>cb <Plug>(coc-codeaction) " Apply code action for buffer
"
" " --- Rename Symbol ---
" nmap <silent> <leader>rn <Plug>(coc-rename) " Rename symbol under cursor
"
" " --- Hover and Documentation ---
" nnoremap <silent> <leader>h :call CocActionAsync('doHover')<CR> " Show hover documentation
"
" " --- Format Code ---
" nmap <silent> <leader>f <Plug>(coc-format) " Format buffer
" xmap <silent> <leader>f <Plug>(coc-format-selected) " Format selected code
"
" " --- Outline and Symbols ---
" nnoremap <silent> <leader>o :CocList outline<CR> " Show file outline
" nnoremap <silent> <leader>s :CocList -I symbols<CR> " Search workspace symbols
"
" " --- Extensions and Commands ---
" nnoremap <silent> <leader>cc :CocCommand<CR> " Open Coc command list
" nnoremap <silent> <leader>cr :CocRestart<CR> " Restart Coc server



" _______________________ ALE LSP __________________________
" Plug 'prabirshrestha/vim-lsp'
" Plug 'mattn/vim-lsp-settings'
" List of servers: https://github.com/mattn/vim-lsp-settings
" :LspInstallServer server-name
" :LspUninstallServer server-name

" Lsp + stuc ---
Plug 'dense-analysis/ale'

" Enable ALE
let g:ale_enabled = 1

" Enable LSP features
let g:ale_lsp_suggestions = 1  " Show LSP suggestions
let g:ale_completion_enabled = 1  " Enable autocompletion (optional)
let g:ale_hover_cursor = 1  " Show hover information on cursor
let g:ale_go_to_definition_in_tab = 0  " Open definitions in the same window
" set statusline+=%{ALEGetStatusLine()}   " Enable ALE statusline integration
let g:ale_statusline_format = ['⨉ %d error(s)', '⚠ %d warning(s)', '✓ OK']
" "let g:ale_echo_msg_format = '[%linter%] %s (%code%)'
" "let g:ale_echo_msg_error_str = 'Error'
" "let g:ale_echo_msg_warning_str = 'Warning'
" "let g:ale_cursor_detail = 1

" Configure linters (optional: restrict to specific LSP servers)
let g:ale_linters = {
\   'javascript': ['tsserver'],
\   'python': ['pylsp'],
\   'go': ['gopls'],
\}

" Configure fixers (optional: for automatic fixing)
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['eslint'],
\   'python': ['black', 'isort'],
\}

" Enable fixing on save (optional)
let g:ale_fix_on_save = 0

" Customize linting behavior
let g:ale_lint_on_text_changed = 'always'  " Lint while typing
let g:ale_lint_on_insert_leave = 1  " Lint when leaving insert mode
let g:ale_lint_on_save = 1  " Lint on save
let g:ale_lint_on_enter = 1  " Lint when opening a file

" Customize signs for errors and warnings
let g:ale_sign_error = '✖'
let g:ale_sign_warning = '⚠'

" Keep the sign gutter always open
let g:ale_sign_column_always = 1

" Python virtual env to use ALE
let g:ale_python_auto_pipenv = 1
let g:ale_python_auto_poetry = 1
let g:ale_python_auto_uv = 1

let g:airline#extensions#ale#enabled = 1


" Key-Bindings
nmap <silent> gd :ALEGoToDefinition<CR>
nmap <silent> ge :ALEDetail<CR>
nmap <silent> K :ALEHover<CR>
nmap <silent> <leader>gf :ALEFix<CR>





" vim-visual-multi (equiv. to Ctrl+d in vscode)
" Allows one to use Ctrl+n to highlight next identical occurences (once text is highlighted)
" Plug 'mg979/vim-visual-multi', {'branch': 'master'}


packloadall

call plug#end()
" END PLUGINS

" =================================================================================="
" =================================================================================="





" =============== COLOR SCHEMES ============== "
" Defining custome color schemes needs to be here - after all plugins have loaded

" colorscheme desert
"let g:airline_theme='luna'
" let g:airline_theme = 'catppuccin_mocha'

" # Colorscheme - monakai #
" [requires above: Plug 'vimcolorschemes/vimcolorschemes']
" Uncomment following 2 lines for this colorscheme
" set background=dark
" colorscheme monokai

" # Colorscheme - catppuccin #
" Uncomment following 1 line for this colorscheme
" colorscheme catppuccin_mocha
"colorscheme synthwave84
" colorscheme ir_dark

" # Colorscheme - cyberpunk #
set cursorline
set background=dark
" colorscheme cyberpunk
colorscheme gothic-cyberpunk
let g:cyberpunk_cursorline="black"
let g:airline_theme='monochrome'
let g:airline_theme='lucius'
" let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''


" =============== CUSTOM FUNCS ============== "
" [FindFiles] Call :args - but assume recusrive and add to Quickfix list
nnoremap <silent> <leader>ff :call SetArgsWithPattern()<CR>
function! SetArgsWithPattern()
  let pattern = input('Rargs: ')
  if pattern != ''
    " Prepend **/ and escape the pattern properly
    let escaped_pattern = escape(pattern, ' ')
    execute 'args **/' . escaped_pattern
    cexpr []
    argdo caddexpr expand('%:p') . ':1:1'
    copen
  endif
endfunction

" Add :args findings to quickfix list
nnoremap <silent> <C-q> :cexpr []<CR>:argdo caddexpr expand('%:p') . ':1:1'<CR>:copen<CR>
