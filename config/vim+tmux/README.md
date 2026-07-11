# vim, neovim, and tmux

- `nvim.lua` is the active Neovim configuration. Setup links it to
  `~/.config/nvim/init.lua`, the filename Neovim requires.
- `neovim-plugins.json` pins Neovim plugin versions. Setup links it to
  `~/.config/nvim/lazy-lock.json`, the filename Lazy.nvim requires.
- `.tmux.conf` is the active tmux configuration, linked to `~/.tmux.conf`.
  It loads TPM and the sensible, resurrect, and continuum plugins from
  `~/.tmux/plugins/`.
- `vimrc.vim` and `plugins.vim` preserve the old Vim setup for reference. They
  are not loaded or installed.
