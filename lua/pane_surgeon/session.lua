local M = {}

local session_stack = {}
local max_sessions = 5

function M.save_session()
  local session_file = vim.fn.tempname()
  vim.cmd("mksession! " .. session_file)
  table.insert(session_stack, session_file)

  if #session_stack > max_sessions then
    local oldest = table.remove(session_stack, 1)
    os.remove(oldest)
  end
end

function M.restore_session()
  if #session_stack == 0 then
    vim.notify("No sessions to restore.", vim.log.levels.WARN)
    return
  end

  local session_file = table.remove(session_stack)

  if vim.fn.filereadable(session_file) == 1 then
    vim.cmd("source " .. session_file)
    os.remove(session_file)
    vim.notify "Session restored successfully."
  else
    vim.notify("Session file not found: " .. session_file, vim.log.levels.ERROR)
  end
end

function M.setup_autocmds()
  vim.api.nvim_create_autocmd("QuitPre", {
    callback = M.save_session,
    desc = "Save session before closing a window",
  })
end

return M
