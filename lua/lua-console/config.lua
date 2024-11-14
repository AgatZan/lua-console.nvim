local M = {}

M.default_config = {
  buffer = {
    prepend_result_with = '=> ',
    save_path = vim.fn.stdpath('state') .. '/lua-console.lua',
    load_on_start = true, -- load saved session on first entry
  },
  window = {
    relative = 'editor',
    anchor = 'SW',
    style = 'minimal',
    border = 'double', -- single|double|rounded
    title = ' Lua console ',
    title_pos = 'left',
    height = 0.6, -- percentage of main window
    zindex = 1,
  },
  mappings = {
    toggle = '`',
    quit = 'q',
    eval = '<CR>',
    clear = 'C',
    messages = 'M',
    save = 'S',
    load = 'L',
    resize_up = '<C-Up>',
    resize_down = '<C-Down>',
    help = 'g?',
  },
}

M.setup = function(opts)
  M.default_config = vim.tbl_deep_extend('force', M.default_config, opts or {})

  return M
end

return M
