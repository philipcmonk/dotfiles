with import <nixpkgs> {};

neovim.override {
  configure = {
    packages.myVimPackage = with pkgs.vimPlugins;
    let
      new-hoon-vim = hoon-vim.overrideAttrs (oldAttrs: {
        src = fetchFromGitHub {
          owner = "urbit";
          repo = "hoon.vim";
          rev = "f287adb9ce5f99a2a8b806833ab1582ba162aab0";
          sha256 = "0nlmcz79qcmrkfji5mdc66p1pxrz5i68m50013fr66zqcccnynjk";
        };
      });
    in
      {
        # see examples below how to use custom packages
        start = [ new-hoon-vim vim-elixir solidity nvim-lspconfig completion-nvim
                  vim-tmux-navigator ];
        # If a Vim plugin has a dependency that is not explicitly listed in
        # opt that dependency will always be added to start to avoid confusion.
        opt = [ ];
      };

    customRC = ''
      set nocompatible
      filetype off
  
      set t_Co=256
      set bg=dark
      set number
      set hlsearch
      set ruler
      set nowrap
      set shiftwidth=2
      set softtabstop=0
      set tabstop=2
      set expandtab
      set incsearch
      set tabpagemax=200
      set sessionoptions-=options
      set sessionoptions-=curdir
      set sessionoptions+=sesdir
  
      nmap <C-h> <C-w>h
      nmap <C-j> <C-w>j
      nmap <C-k> <C-w>k
      nmap <C-l> <C-w>l
      nmap gc :hi! link Comment Ignore<CR>
      nmap gC :hi! link Comment Comment<CR>
  
      hi CursorLine cterm=NONE ctermbg=19  " check ~/.config/alacritty/alacritty.yml
      hi CursorColumn cterm=NONE ctermbg=19
      au WinEnter * set cursorline
      au WinEnter * set cursorcolumn
      au WinLeave * set nocursorline
      au WinLeave * set nocursorcolumn
      au InsertEnter * hi CursorLine cterm=underline
      au InsertLeave * hi CursorLine cterm=NONE
  
      inoremap 1 !
      inoremap 2 @
      inoremap 3 #
      inoremap 4 $
      inoremap 5 %
      inoremap 6 ^
      inoremap 7 &
      inoremap 8 *
      inoremap 9 (
      inoremap 0 )
      " and then the opposite
      inoremap ! 1
      inoremap @ 2
      inoremap # 3
      inoremap $ 4
      inoremap % 5
      inoremap ^ 6
      inoremap & 7
      inoremap * 8
      inoremap ( 9
      inoremap ) 0
  
      autocmd BufRead scp://* :set bt=acwrite
      autocmd BufWritePost scp://* :set bt=acwrite

      " imap <tab> <Plug>(completion_smart_tab)
      " imap <s-tab> <Plug>(completion_smart_s_tab)
      set completeopt=menuone,noinsert,noselect


      lua << LUA
        -- Use an on_attach function to only map the following keys
        -- after the language server attaches to the current buffer
        local on_attach = function(client, bufnr)
          local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
          local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
        
          -- require 'completion'.on_attach()
          -- Enable completion triggered by <c-x><c-o>
          buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
        
          -- Mappings.
          local opts = { noremap=true, silent=true }
        
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
          buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
          buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
          buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
          buf_set_keymap('n', '<space>k', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
          buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
          buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
          buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
          buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
          buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
          buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
          buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
          buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
          buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
          buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
          buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
          buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
        
        end
        
        -- require 'lspconfig'.ccls.setup {
        --    cmd = {"${pkgs.ccls}/bin/ccls"},
        --    on_attach = on_attach,
        --    flags = {
        --      debounce_text_changes = 150,
        --    }
        -- }
      LUA
    '';

  };
}
