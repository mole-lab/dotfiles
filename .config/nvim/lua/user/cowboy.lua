-- "Hold it Cowboy!": stop mashing h/j/k/l, use bigger motions (10j, w, b, }, ...).
-- Inspired by: craftzdog/dotfiles (lua/craftzdog/discipline.lua). Idea only, code written from scratch.
local M = {}

local LIMIT = 10 -- presses allowed in a row
local RESET_MS = 2000 -- a pause this long resets the counter

function M.setup()
  for _, key in ipairs({ "h", "j", "k", "l" }) do
    local count = 0
    local timer = assert(vim.uv.new_timer())

    vim.keymap.set("n", key, function()
      -- Keep LazyVim's j/k behavior: move by screen line when no count is given.
      local motion = (key == "j" or key == "k") and vim.v.count == 0 and "g" .. key or key

      -- Counted motions (10j) and special buffers (file tree, Lazy, Mason) are always fine.
      if vim.v.count > 0 or vim.bo.buftype ~= "" then
        count = 0
        return motion
      end

      timer:stop()
      timer:start(RESET_MS, 0, function()
        count = 0
      end)
      count = count + 1

      if count > LIMIT then
        vim.notify("Hold it Cowboy! Try 10j, w, b, } ...", vim.log.levels.WARN, { id = "cowboy", title = "Cowboy" })
        return ""
      end
      return motion
    end, { expr = true, silent = true, desc = "Cowboy " .. key })
  end
end

return M
