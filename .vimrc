" General
set nocompatible
set encoding=utf-8
set history=500

" UI
set number
set relativenumber
set ruler
set showcmd
set showmode
set cursorline
set scrolloff=8
set wildmenu

" Search
set hlsearch
set incsearch
set ignorecase
set smartcase

" Indentation
set autoindent
set smartindent
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" Files
set autoread
set nobackup
set noswapfile

" Syntax
syntax enable
set background=dark

" Clipboard
set clipboard=unnamedplus

" Keymaps
let mapleader = " "
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <Esc> :nohlsearch<CR>
