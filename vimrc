unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

"pressing '\s' to update.
noremap <Leader>s :update<CR>

"Better copy methods
noremap <Leader>y "+y
noremap <Leader>p "+p


set tabstop=4
set shiftwidth=4
set expandtab

if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

"set number
"set relativenumber
colorscheme desert
