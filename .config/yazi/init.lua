require("yaziline"):setup({
	color = "#65D1FF",
	separator_style = "angly",
	separator_open = "",
	separator_close = "",
	separator_open_thin = "",
	separator_close_thin = "",
	separator_head = "",
	separator_tail = "",
	select_symbol = "",
	yank_symbol = "󰆐",
	filename_max_length = 24,
	filename_truncate_length = 6,
	filename_truncate_separator = "...",
})

require("custom-shell"):setup({
	history_path = "default",
	save_history = true,
})
