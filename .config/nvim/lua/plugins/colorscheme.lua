-- Colors follow the wallpaper.
-- theme.py renders ~/.cache/43pr/nvim-colors.lua from ~/.config/43pr/templates/nvim-colors.lua
-- and sends SIGUSR1 to running nvim instances, which repaint immediately.
-- Falls back to tokyonight when the generated file is missing.
-- Inspired by: mxmrn/dotfiles (matugen -> mini.base16). Written for 43pr's theme.py.
local cache = vim.fn.expand("~/.cache/43pr/nvim-colors.lua")

local function apply_wallpaper_colors()
  local ok, palette = pcall(dofile, cache)
  if not ok or type(palette) ~= "table" then
    return false
  end
  require("mini.base16").setup({ palette = palette })
  vim.g.colors_name = "wallpaper"
  return true
end

return {
  { "nvim-mini/mini.base16", lazy = true },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        if not apply_wallpaper_colors() then
          vim.cmd.colorscheme("tokyonight")
        end
        -- registered even on fallback, so the first wallpaper change still applies
        vim.api.nvim_create_autocmd("Signal", {
          group = vim.api.nvim_create_augroup("user_wallpaper_colors", { clear = true }),
          pattern = "SIGUSR1",
          callback = vim.schedule_wrap(function()
            if apply_wallpaper_colors() then
              -- let lualine, bufferline, etc. refresh their colors
              vim.api.nvim_exec_autocmds("ColorScheme", { pattern = "wallpaper" })
            end
          end),
        })
      end,
    },
  },
}
