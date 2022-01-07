local wezterm = require 'wezterm';

return {
  enable_tab_bar = false,
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  color_scheme = "Monokai Remastered",
  skip_close_confirmation_for_processes_named = {
    "bash", "sh", "zsh", "fish", "tmux"
  },
  window_close_confirmation = "NeverPrompt",
  keys = {
    {key="w", mods="CTRL|SHIFT", action=wezterm.action{CloseCurrentTab={confirm=false}}},
    {key="\t", mods="CTRL|SHIFT", action=wezterm.action{ActivateTabRelative=-1}},
    {key="\t", mods="CTRL", action=wezterm.action{ActivateTabRelative=1}},
  },
  check_for_updates = false,
}
