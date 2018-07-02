" colors
let s:colorscheme = 'darkburn'
"let s:colorscheme = 'base16-default-dark'
if !exists('g:colors_name') || g:colors_name != s:colorscheme
  execute 'colorscheme ' . s:colorscheme
endif

""""""""
" Vundle
""""""""
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'bling/vim-airline'
Plugin 'pearofducks/ansible-vim'
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/syntastic'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'flazz/vim-colorschemes'
Plugin 'chriskempson/base16-vim'
Plugin 'fatih/vim-go'
"Bundle 'chase/vim-ansible-yaml'
Bundle 'scrooloose/nerdtree'

call vundle#end()            " required
filetype plugin indent on    " required


" basics
set number
set completeopt=menuone
set shiftwidth=2
set softtabstop=2
set expandtab
set tabstop=2
set linebreak
set wildmode=longest:full,full
set cursorline

" searching
set ignorecase smartcase

" netrw
let g:netrw_liststyle = 3 " tree view

" ripgrep
if executable("rg")
  set grepprg=rg\ --vimgrep\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" yank and paste to system clipboard
set clipboard=unnamed

" mappings
let mapleader=' '
nnoremap <Leader>e :Explore<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>l :botright copen<CR>
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>
nnoremap g<C-e> <C-e>
nnoremap g<C-y> <C-y>
nnoremap <C-n> 3<C-n>
nnoremap <C-p> 3<C-p>
" window navigation
nnoremap <C-h> <C-w><C-h>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>
nnoremap g<C-l> <C-l>

" snippets
let g:UltiSnipsExpandTrigger="<c-e>"
let g:UltiSnipsEditSplit="context"
let g:UltiSnipsSnippetsDir="~/.config/nvim/UltiSnips"

" go
let g:go_fmt_command = "goimports"
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_types = 1
let g:go_highlight_variable_declarations = 1

" status line
let g:airline_theme='onedark'
let g:airline#extensions#tmuxline#enabled = 0

" terminal
"tnoremap <C-l> <Nop>
set scrollback=10000
augroup InitVimTerminalSettings
  autocmd!
  autocmd TermOpen * setlocal nonumber
augroup END

" extra filetypes
augroup InitVimFiletypes
  autocmd!
  autocmd BufNewFile,BufRead .envrc set filetype=sh
  autocmd BufNewFile,BufRead Vagrantfile,Berksfile set filetype=ruby
  autocmd BufNewFile,BufRead *.tfvars set filetype=conf
  autocmd BufNewFile,BufRead tmux.conf set filetype=tmux.conf
  autocmd BufNewFile,BufRead *.tfstate setlocal filetype=json shiftwidth=4 softtabstop=4
augroup END

" vim-commentary extensions
augroup InitVimComentary
  autocmd!
  autocmd FileType tf setlocal commentstring=#\ %s
  autocmd FileType sql setlocal commentstring=--\ %s
augroup END

" fzf
let $FZF_DEFAULT_OPTS .= ' --no-height'
if "," . &rtp . "," !~ ",/usr/local/opt/fzf,"
  set rtp+=/usr/local/opt/fzf
endif
command! Z call fzf#run(fzf#wrap('Z', {'source': '. ~/.oh-my-zsh/plugins/z/z.sh; _z 2>&1 | sed "s/^[0-9.]* *//"', 'sink': 'lcd', 'options': '--tac'}, <bang>0))
nnoremap <Leader>f :FZF<CR>
nnoremap <Leader>z :Z<CR>
nnoremap <Leader>b :Buffers<CR>

command! -nargs=0 Delete call s:delete()
function! s:delete()
  let file = expand("%:p")
  execute 'bdelete '.bufnr('%')
  call delete(file)
endfunction

" ale
let g:ale_lint_on_text_changed = 'never'
let g:ale_linters = {
  \ 'go': ['gofmt', 'go build', 'go vet', 'golint'],
  \ 'ruby': ['ruby']
  \ }

" direnv
augroup InitVimDirenv
  autocmd!
  autocmd BufWritePost .envrc silent !direnv allow %
  autocmd BufWritePost .envrc.local silent !direnv allow %
augroup END

" terraform
let g:terraform_fmt_on_save = 1
autocmd BufEnter *.tfvars autocmd! terraform BufWritePre *.tfvars

" rust
let g:rustfmt_autosave = 1
let g:rustfmt_fail_silently= 1
