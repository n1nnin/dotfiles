set nocompatible
filetype off

if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim
    call neobundle#begin(expand('~/.vim/bundle/'))
    NeoBundleFetch 'Shougo/neobundle.vim'
    NeoBundle 'scrooloose/nerdtree'
    NeoBundle 'nathanaelkane/vim-indent-guides'
    call neobundle#end()
endif

set number

syntax on
colorscheme molokai
set t_Co=256
let g:rehash256 = 1

set tabstop=2 shiftwidth=2 expandtab
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=odd   ctermbg=133
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=even ctermbg=141


filetype plugin indent on
nnoremap <silent><C-e> :NERDTreeToggle<CR>

