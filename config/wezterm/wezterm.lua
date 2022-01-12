local wezterm = require('wezterm');

return {
  font = wezterm.font("JetBrainsMono Nerd Font"),
  font_size = 11.0,
  initial_cols = 300,
  initial_rows = 100,
  use_ime = true,

  window_padding = {
    left = '0.5cell',
    right = '0.5cell',
    top = 0,
    bottom = 0,
  },

  colors = {
    background = '#1c2022',
    foreground = '#d8dee9',
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
      '#4c566a', -- black
      '#eb6149', -- red
      '#73ee65', -- green
      '#f0d448', -- yellow
      '#81b0ff', -- blue
      '#b48ead', -- magent
      '#6cd6cf', -- cyan
      '#eceff4', -- white
    },
    tab_bar = {
      active_tab = {
        bg_color = "#1c2022",
        fg_color = "#c0c0c0",
      },
      inactive_tab = {
        bg_color = "#3c465a",
        fg_color = "#808080",
      },
      inactive_tab_hover = {
        bg_color = "#202426",
        fg_color = "#909090",
      },
      new_tab = {
        bg_color = "#3c465a",
        fg_color = "#808080",
      },
      new_tab_hover = {
        bg_color = "#1c2022",
        fg_color = "#909090",
      },
    },
  },
}
