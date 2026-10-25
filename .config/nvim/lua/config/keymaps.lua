-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Delete a char without yanking it, so `x` doesn't overwrite the system clipboard.
-- Inspired by: craftzdog/dotfiles (a common Vim idiom)
vim.keymap.set("n", "x", '"_x', { desc = "Delete Char (no yank)" })

-- Warn when h/j/k/l are mashed (see lua/user/cowboy.lua)
require("user.cowboy").setup()
