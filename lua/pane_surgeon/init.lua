local M = {}

-- Helper function to recursively traverse the layout tree and collect windows in a direction
local function collect_windows_to_close(layout, current_win, direction, current_pos)
	local windows_to_close = {}

	if layout[1] == "leaf" then
		-- Base case: It's a window; check its position
		local win_id = layout[2]
		if win_id ~= current_win then
			local win_pos = vim.api.nvim_win_get_position(win_id)

			if direction == "left" and win_pos[2] < current_pos[2] then
				table.insert(windows_to_close, win_id)
			elseif direction == "right" and win_pos[2] > current_pos[2] then
				table.insert(windows_to_close, win_id)
			elseif direction == "top" and win_pos[1] < current_pos[1] then
				table.insert(windows_to_close, win_id)
			elseif direction == "bottom" and win_pos[1] > current_pos[1] then
				table.insert(windows_to_close, win_id)
			end
		end
	else
		-- Recursive case: Traverse the children of the split
		for _, child in ipairs(layout[2]) do
			vim.list_extend(windows_to_close, collect_windows_to_close(child, current_win, direction, current_pos))
		end
	end

	return windows_to_close
end

-- Main function to close windows in the given direction
function M.close_windows(direction)
	local current_win = vim.api.nvim_get_current_win()
	local layout = vim.api.nvim_eval("winlayout()")
	local current_pos = vim.api.nvim_win_get_position(current_win)

	-- Collect all windows to close
	local windows_to_close = collect_windows_to_close(layout, current_win, direction, current_pos)

	if #windows_to_close == 0 then
		vim.notify("No windows to close in the " .. direction .. " direction.", vim.log.levels.INFO)
		return
	end

	-- Close each collected window
	for _, win_id in ipairs(windows_to_close) do
		vim.api.nvim_win_close(win_id, true)
	end
end

-- Store the selected windows
local selected_windows = {}
local highlight_ns = vim.api.nvim_create_namespace("SelectedWindow") -- Create a unique namespace for highlights

-- Function to toggle a window as selected or deselected
local function toggle_window_selection(win_id)
	if selected_windows[win_id] then
		-- Deselect the window
		selected_windows[win_id] = nil
		vim.api.nvim_win_set_hl_ns(win_id, 0) -- Clear the custom highlight
		vim.notify("Window " .. win_id .. " deselected.")
	else
		-- Select the window
		selected_windows[win_id] = true
		vim.api.nvim_win_set_hl_ns(win_id, highlight_ns) -- Apply the custom highlight namespace
		vim.notify("Window " .. win_id .. " selected.")
	end
end

-- Function to enter selection mode
function M.select_windows()
	local current_win = vim.api.nvim_get_current_win()
	toggle_window_selection(current_win)
end

-- Function to close all windows except the selected ones
function M.close_unselected_windows()
	local all_windows = vim.api.nvim_tabpage_list_wins(0) -- Get all windows in the current tab

	if vim.tbl_isempty(selected_windows) then
		vim.notify("No windows selected to keep open.", vim.log.levels.WARN)
		return
	end

	for _, win_id in ipairs(all_windows) do
		if not selected_windows[win_id] then
			vim.api.nvim_win_close(win_id, true) -- Close unselected windows
		else
			vim.api.nvim_win_set_hl_ns(win_id, 0) -- Reset highlight after close
		end
	end

	-- Clear the selection
	selected_windows = {}
end

-- Setup the custom highlight group
local function setup_highlight()
	vim.api.nvim_set_hl(0, "SelectedWindow", { bg = "#FFD700", fg = "#000000", bold = true }) -- Golden background
end

-- Setup user commands for the plugin
function M.setup()
	setup_highlight() -- Initialize the highlight group

	vim.api.nvim_create_user_command("PaneSurgeonCloseLeft", function()
		M.close_windows("left")
	end, {})
	vim.api.nvim_create_user_command("PaneSurgeonCloseRight", function()
		M.close_windows("right")
	end, {})
	vim.api.nvim_create_user_command("PaneSurgeonCloseTop", function()
		M.close_windows("top")
	end, {})
	vim.api.nvim_create_user_command("PaneSurgeonCloseBottom", function()
		M.close_windows("bottom")
	end, {})

	vim.api.nvim_create_user_command("PaneSurgeonSelect", function()
		M.select_windows()
	end, {})
	vim.api.nvim_create_user_command("PaneSurgeonCloseUnselected", function()
		M.close_unselected_windows()
	end, {})
end

return M
