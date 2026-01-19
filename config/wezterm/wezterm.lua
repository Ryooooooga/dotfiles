local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.font = wezterm.font_with_fallback {
  'SauceCodePro Nerd Font',
  'JetBrainsMono Nerd Font',
}

config.colors = {
  foreground = '#d8dee9',
  background = '#1c2022',
  cursor_bg = '#d8dee9',
  cursor_fg = '#1c2022',
  cursor_border = '#d8dee9',
  selection_bg = '#4c566a',
  selection_fg = '#d8dee9',
  ansi = {
    '#3b4252', -- black
    '#eb6149', -- red
    '#73ee65', -- green
    '#f0d448', -- yellow
    '#81b0ff', -- blue
    '#b48ead', -- magenta
    '#6cd6cf', -- cyan
    '#e5e9f0', -- white
  },
  brights = {
    '#4c566a', -- bright black
    '#eb6149', -- bright red
    '#73ee65', -- bright green
    '#f0d448', -- bright yellow
    '#81b0ff', -- bright blue
    '#b48ead', -- bright magenta
    '#6cd6cf', -- bright cyan
    '#eceff4', -- bright white
  },
}

return config
