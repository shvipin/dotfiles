" Generic Vim Configuration

filetype plugin on

" Plugins (using Vim-Plug)
call plug#begin('~/.vim/plugged')
Plug 'junegunn/goyo.vim'
Plug 'majutsushi/tagbar'
Plug 'mhinz/vim-signify'
Plug 'morhetz/gruvbox'
Plug 'preservim/nerdtree'
Plug 'sainnhe/gruvbox-material'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()

syntax on
set background=dark
colorscheme gruvbox

" General Settings
set list listchars=tab:»\ ,trail:·
set backspace=indent,eol,start
set clipboard=unnamed
set colorcolumn=81,101
set cursorline
set cursorlineopt=number
set history=1000
set hlsearch
set nu
set rnu
set scrolloff=3
set splitbelow
set splitright
highlight Pmenu ctermbg=White
let mapleader = ","
highlight ColorColumn ctermbg=0
set fillchars+=vert:│

" Tabs for Linux kernel development
set tabstop=8
set softtabstop=8
set shiftwidth=8
set noexpandtab
set foldmethod=syntax
set nofoldenable

" Plugin specific settings
let g:airline_theme='wombat'
let g:NERDTreeDirArrowExpandable='+'
let g:NERDTreeDirArrowCollapsible='-'

autocmd FileType gitcommit set textwidth=72
autocmd FileType gitcommit set colorcolumn=73

" CSCOPE mappings
nnoremap <Leader>A :cs add cscope.out<CR>
nnoremap <Leader>a :cs find a <cword><CR>
nnoremap <Leader>c :cs find c <cword><CR>
nnoremap <Leader>d :cs find d <cword><CR>
nnoremap <Leader>f :cs find f <cfile><CR>
nnoremap <Leader>g :cs find g <cword><CR>
nnoremap <Leader>i :cs find i <cfile><CR>
nnoremap <Leader>s :cs find s <cword><CR>
nnoremap <Leader>t :cs find t <cword><CR>

" Keybindings
noremap <F2> :NERDTreeToggle<CR>
noremap <F3> :TagbarToggle<CR>
noremap <C-j> <C-w>j
noremap <C-h> <C-w>h
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <F4> :py3f /usr/lib/clang-format/clang-format.py<cr>
noremap <F5> :G blame<cr>
noremap <Leader>z :Goyo<CR>

" Terminal mode navigation
tnoremap <C-j> <C-w>j
tnoremap <C-h> <C-w>h
tnoremap <C-k> <C-w>k
tnoremap <C-l> <C-w>l

set mouse=
