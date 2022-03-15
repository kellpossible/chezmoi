local get_hex = require('cokeline/utils').get_hex

local yellow = vim.g.terminal_color_3

require('cokeline').setup({
  default_hl = {
    fg = get_hex('Comment', 'fg'),
    bg = get_hex('ColorColumn', 'bg'),
  },

  components = {
    {
      text = function(buffer) return (buffer.index ~= 1) and '▏' or '' end,
    },
    {
      text = ' ',
    },
    {
      text = function(buffer)
        return buffer.devicon.icon
      end,
      fg = function(buffer)
        return buffer.devicon.color
      end,
    },
    {
      text = function(buffer) return buffer.filename .. '  ' end,
      style = function(buffer)
        return buffer.is_focused and 'bold' or nil
      end,
    },
  },


  -- Left sidebar to integrate nicely with file explorer plugins.
  -- This is a table containing a `filetype` key and a list of `components` to
  -- be rendered in the sidebar.
  -- The last component will be automatically space padded if necessary
  -- to ensure the sidebar and the window below it have the same width.
  sidebar = {
    filetype = 'NvimTree',
    components = {
      {
        text = '  NvimTree',
        hl = {
          fg = yellow,
          bg = get_hex('NvimTreeNormal', 'bg'),
          style = 'bold'
        }
      },
    }
  },
})
