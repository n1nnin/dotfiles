if &compatible
  set nocompatible
endif
set runtimepath+=/Users/kazuki.hattori/.cache/dein/repos/github.com/Shougo/dein.vim
if dein#load_state('/Users/kazuki.hattori/.cache/dein')
  call dein#begin('/Users/kazuki.hattori/.cache/dein')

  call dein#add('/Users/kazuki.hattori/.cache/dein/repos/github.com/Shougo/dein.vim')

  call dein#add('scrooloose/nerdtree')
  call dein#add('nathanaelkane/vim-indent-guides')
  call dein#add('Yggdroot/indentLine')
  call dein#add('ngmy/vim-rubocop')
  call dein#add('scrooloose/syntastic')
  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax on 

if dein#check_install()
  call dein#install()
endif

set number

colorscheme molokai
set t_Co=256
let g:rehash256 = 1

set tabstop=2 shiftwidth=2 expandtab
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_auto_colors = 0
let g:indentLine_char = '¦'
let g:syntastic_ruby_checkers=['rubocop']
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=odd   ctermbg=133
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=even ctermbg=141

nnoremap <silent><C-e> :NERDTreeToggle<CR>

