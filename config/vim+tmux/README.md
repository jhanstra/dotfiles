# vim, neovim, and tmux

- `nvim.lua` is the active Neovim configuration. Setup links it to
  `~/.config/nvim/init.lua`, the filename Neovim requires.
- `neovim-plugins.json` pins Neovim plugin versions. Setup links it to
  `~/.config/nvim/lazy-lock.json`, the filename Lazy.nvim requires.
- `.tmux.conf` is the active tmux configuration. Setup links it to
  `~/.config/tmux/tmux.conf`: tmux config path
  `~/.local/share/tmux/plugins/`: tmux package manager and plugins config
- `vimrc.vim` and `plugins.vim` preserve the old Vim setup for reference. They
  are not loaded or installed.
