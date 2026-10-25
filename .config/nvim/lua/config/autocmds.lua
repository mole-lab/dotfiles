-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Switch fcitx5 to English when leaving insert mode,
-- so normal-mode keys (j, k, ...) are not typed as Hangul.
vim.api.nvim_create_autocmd("InsertLeave", {
  group = vim.api.nvim_create_augroup("user_fcitx5_english", { clear = true }),
  callback = function()
    if vim.fn.executable("fcitx5-remote") == 1 then
      vim.system({ "fcitx5-remote", "-c" })
    end
  end,
})

-- Scrolloff follows window height (~1/6, at least 4 lines),
-- so it fits the laptop screen, the 4K monitor and splits alike.
local function adaptive_scrolloff()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local height = vim.api.nvim_win_get_height(win)
    vim.wo[win].scrolloff = math.max(4, math.floor(height / 6))
  end
end

vim.api.nvim_create_autocmd({ "VimResized", "WinResized", "WinEnter", "BufWinEnter" }, {
  group = vim.api.nvim_create_augroup("user_adaptive_scrolloff", { clear = true }),
  callback = adaptive_scrolloff,
})
adaptive_scrolloff()
