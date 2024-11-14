local M = {}

M.set_buf_keymap = function()
  local utils = require('lua-console.utils')
  local config = require('lua-console.config')
  local mappings = config.mappings

  --- @type number
  local buf = Lua_console.buf

  vim.api.nvim_buf_set_keymap(buf, 'n', mappings.resize_up, '', {
    desc = 'Resize up',
    callback = function()
      vim.cmd.resize('+5')
    end,
  })

  vim.api.nvim_buf_set_keymap(buf, 'n', mappings.resize_down, '', {
    desc = 'Resize down',
    callback = function()
      vim.cmd.resize('-5')
    end,
  })

  vim.api.nvim_buf_set_keymap(buf, 'n', mappings.clear, '', {
    desc = 'Clear console',
    callback = function()
      vim.api.nvim_buf_set_lines(0, 1, -1, false, { '' })
    end,
  })

  vim.api.nvim_buf_set_keymap(buf, 'n', mappings.messages, '', {
    desc = 'Load messages',
    callback = utils.load_messages,
  })

  vim.api.nvim_buf_set_keymap(buf, 'n', 'gf', '', {
    desc = 'Open file in vertical split',
    callback = function()
      local file = vim.fn.expand('<cfile>')
      local line = utils.get_source_lnum()

      vim.api.nvim_win_close(0, false)

      vim.cmd('vs ' .. file)
  -- stylua: ignore
      if line then vim.api.nvim_win_set_cursor(0, {line, 0}) end
    end,
  })

  vim.api.nvim_buf_set_keymap(buf, 'n', mappings.eval, '', {
    desc = 'Eval lua code in current line or visual selection',
    callback = utils.eval_lua_in_buffer,
    noremap = true,
  })
  vim.api.nvim_buf_set_keymap(buf, 'v', mappings.eval, '', {
    desc = 'Eval lua code in current line or visual selection',
    callback = utils.eval_lua_in_buffer,
    noremap = true,
  })

  vim.api.nvim_buf_set_keymap(buf, 'n', mappings.save, '', {
    desc = 'Save console',
    callback = function()
      vim.cmd('write! ' .. config.buffer.save_path)
    end,
    noremap = true,
  })

  vim.api.nvim_buf_set_keymap(buf, 'n', mappings.load, '', {
    desc = 'Load console',
    callback = utils.load_console,
  })

  vim.api.nvim_buf_set_keymap(buf, 'n', mappings.quit, '', {
    desc = 'Close console',
    callback = function()
      vim.api.nvim_win_close(0, false)
    end,
    noremap = true,
  })

  vim.api.nvim_buf_set_keymap(buf, 'n', 'g?', '', {
    desc = 'Toggle help',
    callback = function()
      utils.toggle_help()
    end,
    noremap = true,
  })
end

M.set_buf_autocommands = function()
  vim.api.nvim_create_autocmd({ 'BufLeave', 'BufWinLeave' }, {
    buffer = Lua_console.buf,
    desc = 'Close window when focus is lost',
    callback = function()
      local win = Lua_console.win
  -- stylua: ignore
      if not win then return end

      if vim.api.nvim_win_is_valid(win) then
        Lua_console.height = vim.api.nvim_win_get_height(win)
        vim.api.nvim_win_close(win, false)
      end

      Lua_console.win = false
    end,
  })
end

return M
