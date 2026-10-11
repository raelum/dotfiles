-- =============================================================================
-- Jujutsu (jj) Tools: Interactive Modified Files Menu & Diff Adapter
-- =============================================================================

local M = {}

-- Diff mode: false = working copy only (@-), true = include staged commit (@--)
M.include_staged = false

-- =============================================================================
-- Shared Helpers
-- =============================================================================

-- Execute a jj command and return stdout lines, or nil on failure
local function run_jj(args, notify_err)
  local cmd = { "jj", "--no-pager", "--color=never" }
  vim.list_extend(cmd, args)
  local res = vim.system(cmd, { text = true }):wait()
  if res.code ~= 0 then
    if notify_err and res.stderr and vim.trim(res.stderr) ~= "" then
      vim.notify("JJ error: " .. vim.trim(res.stderr), vim.log.levels.ERROR)
    end
    return nil
  end
  return vim.split(res.stdout or "", "\n", { trimempty = true })
end

-- Check if a mutable staged commit (@-) exists
function M.has_staged_commit()
  local res = run_jj({ "log", "-r", "@- & mutable()", "-T", "change_id", "--no-graph" })
  return res and res[1] and vim.trim(res[1]) ~= ""
end

-- Prompt user for single-key (y/n) confirmation on the command line
local function confirm_yn(prompt)
  vim.cmd("redraw")
  vim.api.nvim_echo({ { prompt .. " (y/n) ", "Question" } }, false, {})
  local char = vim.fn.getcharstr()
  vim.cmd("redraw")
  return char == "y" or char == "Y"
end

-- =============================================================================
-- Jujutsu Diff Reference Adapter (for mini.diff)
-- =============================================================================

-- Retrieve baseline file content from `jj file show -r <base>` for mini.diff
function M.get_ref_text(buf_id)
  local path = vim.api.nvim_buf_get_name(buf_id)
  if path == "" or vim.bo[buf_id].buftype ~= "" then return nil end
  local repo_root = vim.fs.root(path, ".jj")
  if not repo_root then return nil end
  local norm_path = vim.fs.normalize(path)
  if not vim.startswith(norm_path, repo_root .. "/") then return nil end
  local rel_path = norm_path:sub(#repo_root + 2)

  local base = (M.include_staged and M.has_staged_commit()) and "@--" or "@-"
  local res = vim.system({ "jj", "--no-pager", "--color=never", "file", "show", "-r", base, rel_path }, { text = true }):wait()
  return res.code == 0 and (res.stdout or "") or ""
end

-- Refresh gutter diff signs across all active buffers
function M.refresh_all_diffs()
  local has_diff, diff = pcall(require, "mini.diff")
  if not has_diff then return end
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(b) and vim.api.nvim_buf_get_name(b) ~= "" then
      local text = M.get_ref_text(b)
      if text ~= nil then
        pcall(diff.set_ref_text, b, text)
      end
    end
  end
end
_G.refresh_all_jj_diffs = M.refresh_all_diffs

-- Toggle diff mode between working copy only and including staged commit
function M.toggle_diff_base()
  M.include_staged = not M.include_staged

  local msg
  if M.include_staged then
    if M.has_staged_commit() then
      msg = "Diff mode: includes staged changes"
    else
      msg = "Diff mode: includes staged changes (none currently staged)"
    end
  else
    msg = "Diff mode: working copy only"
  end

  M.refresh_all_diffs()
  vim.cmd("redraw")
  vim.api.nvim_echo({ { msg, "Directory" } }, false, {})
end

-- Custom provider passed into mini.diff setup
M.source = {
  name = "jj",
  attach = function(buf_id)
    local text = M.get_ref_text(buf_id)
    if text ~= nil then
      local has_diff, diff = pcall(require, "mini.diff")
      if has_diff then diff.set_ref_text(buf_id, text) end
      return true
    end
    return false
  end,
}

-- =============================================================================
-- Jujutsu Modified Files Menu (Browse, Stage & Unstage, Fig-style)
-- =============================================================================

-- Interactive dashboard to review working copy and stage into commit (@-)
local function open_jj_files_menu()
  local win, buf = nil, nil

  -- Ensure current buffer is within a Jujutsu repository
  local repo_root = vim.fs.root(0, ".jj") or vim.fs.root(vim.fn.getcwd(), ".jj")
  if not repo_root then return vim.notify("Not inside a Jujutsu repository", vim.log.levels.WARN) end

  -- Get first-line description of staged commit (@-)
  local function get_staged_desc()
    local res = run_jj({ "log", "-r", "@-", "-T", "description.first_line()", "--no-graph" })
    return (res and res[1] and vim.trim(res[1]) ~= "") and vim.trim(res[1]) or nil
  end

  local line_to_entry = {}

  -- Parse `jj diff --summary` output into structured file entries with status
  local function parse_entries(raw_lines, section)
    local entries = {}
    for _, line in ipairs(raw_lines or {}) do
      local status = line:sub(1, 1)
      local path_part = vim.trim(line:sub(3))
      local file_path = status == "R" and (path_part:match("%->%s*(.+)$") or path_part) or path_part
      table.insert(entries, {
        section = section,
        status = status,
        path = file_path,
        full_path = repo_root .. "/" .. file_path,
      })
    end
    return entries
  end

  -- Build buffer lines, apply syntax highlights, and position floating window
  local function render(target_row)
    local working_entries = parse_entries(run_jj({ "diff", "-r", "@-..@", "--summary" }), "working")
    local staged_entries = {}
    local has_staged = M.has_staged_commit()
    if has_staged then
      staged_entries = parse_entries(run_jj({ "diff", "-r", "@--..@-", "--summary" }), "staged")
    end

    local buf_lines = {}
    line_to_entry = {}
    local highlights = {}
    local first_file_line = nil

    -- Format a section header and file list with sign highlights
    local function add_section(title, entries, empty_msg)
      table.insert(buf_lines, " " .. title)
      table.insert(highlights, { #buf_lines - 1, 0, -1, "Title" })
      if #entries == 0 then
        table.insert(buf_lines, "   " .. empty_msg)
        table.insert(highlights, { #buf_lines - 1, 0, -1, "Comment" })
      else
        for _, item in ipairs(entries) do
          table.insert(buf_lines, string.format("   %s  %s", item.status, item.path))
          line_to_entry[#buf_lines] = item
          if not first_file_line then first_file_line = #buf_lines end
          local hl = (item.status == "A" and "MiniDiffSignAdd")
            or (item.status == "M" and "MiniDiffSignChange")
            or (item.status == "D" and "MiniDiffSignDelete") or "DiagnosticWarn"
          table.insert(highlights, { #buf_lines - 1, 3, 4, hl })
        end
      end
    end

    add_section("Working Copy (@) - Uncommitted:", working_entries, "(no uncommitted changes)")
    table.insert(buf_lines, "")

    if has_staged then
      local desc = get_staged_desc()
      local header = "Staged Commit (@-)" .. (desc and (' ["' .. desc .. '"]:') or ":")
      add_section(header, staged_entries, "(no files in staged commit)")
    else
      add_section("Staged Commit: none", {}, "(stage uncommitted files with [a] to create)")
    end

    if not buf or not vim.api.nvim_buf_is_valid(buf) then
      buf = vim.api.nvim_create_buf(false, true)
      vim.bo[buf].buftype = "nofile"
    end

    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, buf_lines)
    vim.bo[buf].modifiable = false

    local ns = vim.api.nvim_create_namespace("jj_files_menu")
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    for _, h in ipairs(highlights) do
      vim.api.nvim_buf_add_highlight(buf, ns, h[4], h[1], h[2], h[3])
    end

    -- Window configuration: centered with fixed maximum width
    local width = math.min(80, vim.o.columns - 4)
    local height = math.min(math.floor(vim.o.lines * 0.8), #buf_lines)
    local win_opts = {
      relative = "editor",
      width = width,
      height = height,
      row = math.max(1, math.floor((vim.o.lines - height) / 2)),
      col = math.max(0, math.floor((vim.o.columns - width) / 2)),
      style = "minimal",
      border = "rounded",
      title = " JJ Modified Files ",
      title_pos = "center",
      footer = " [a] Stage  [u] Unstage  [x] Discard  [d] Desc  [p] Push ",
      footer_pos = "center",
    }

    if not win or not vim.api.nvim_win_is_valid(win) then
      win = vim.api.nvim_open_win(buf, true, win_opts)
    else
      vim.api.nvim_win_set_config(win, win_opts)
    end

    local cursor_row = math.max(1, math.min(target_row or first_file_line or 2, #buf_lines))
    pcall(vim.api.nvim_win_set_cursor, win, { cursor_row, 5 })
  end

  -- Safely close the floating menu window
  local function close_win()
    if win and vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end

  -- Open currently selected file in standard editor buffer
  local function open_entry()
    local cur_row = vim.api.nvim_win_get_cursor(win)[1]
    local entry = line_to_entry[cur_row]
    if not entry or (entry.status == "D" and vim.fn.filereadable(entry.full_path) == 0) then return end
    close_win()
    vim.cmd.edit(entry.full_path)
  end

  -- Squash working copy file into staged commit (@-), prompting if initial commit
  local function stage_entry()
    local cur_row = vim.api.nvim_win_get_cursor(win)[1]
    local entry = line_to_entry[cur_row]
    if not entry or entry.section == "staged" then return end

    if M.has_staged_commit() then
      if run_jj({ "squash", entry.path }, true) then
        vim.notify("✓ Staged '" .. entry.path .. "'")
        M.refresh_all_diffs()
        render(cur_row)
      end
    else
      vim.ui.input({ prompt = "Initial commit message for staged commit: " }, function(input)
        if not input or vim.trim(input) == "" then return end
        if run_jj({ "commit", "-m", vim.trim(input), entry.path }, true) then
          vim.notify("✓ Created staged commit \"" .. vim.trim(input) .. "\"")
          M.refresh_all_diffs()
          render(cur_row)
        end
      end)
    end
  end

  -- Move file from staged commit (@-) back into working copy (@)
  local function unstage_entry()
    local cur_row = vim.api.nvim_win_get_cursor(win)[1]
    local entry = line_to_entry[cur_row]
    if not entry or entry.section ~= "staged" then return end
    if not M.has_staged_commit() then
      return vim.notify("No staged commit to unstage from", vim.log.levels.WARN)
    end

    if run_jj({ "squash", "--from", "@-", "--into", "@", "--keep-emptied", entry.path }, true) then
      vim.notify("✓ Unstaged '" .. entry.path .. "' back to Working Copy (@)")
      M.refresh_all_diffs()
      render(cur_row)
    end
  end

  -- Discard uncommitted changes to file via `jj restore` after confirmation
  local function discard_entry()
    local cur_row = vim.api.nvim_win_get_cursor(win)[1]
    local entry = line_to_entry[cur_row]
    if not entry or entry.section ~= "working" then return end

    if confirm_yn("Discard changes to '" .. entry.path .. "'?") then
      if run_jj({ "restore", entry.path }, true) then
        vim.notify("✓ Discarded " .. entry.path)
        vim.cmd.checktime()
        M.refresh_all_diffs()
        render(cur_row)
      end
    end
  end

  -- Edit commit description for staged commit (@-)
  local function describe_staged()
    if not M.has_staged_commit() then
      return vim.notify("No staged commit to describe", vim.log.levels.WARN)
    end
    vim.ui.input({ prompt = "Edit description for staged commit: ", default = get_staged_desc() or "" }, function(input)
      if input and vim.trim(input) ~= "" and run_jj({ "describe", "-r", "@-", "-m", vim.trim(input) }, true) then
        vim.notify("✓ Updated staged commit description: " .. vim.trim(input))
        render()
      end
    end)
  end

  -- Push staged commit (@-) to remote Git repository
  local function push_staged()
    if not M.has_staged_commit() then
      return vim.notify("No staged commit to push", vim.log.levels.WARN)
    end

    local is_empty = run_jj({ "log", "-r", "@- & empty()", "-T", "change_id", "--no-graph" })
    if is_empty and is_empty[1] and vim.trim(is_empty[1]) ~= "" then
      return vim.notify("Staged commit has no file changes to push", vim.log.levels.WARN)
    end

    if not confirm_yn("Push staged commit to remote?") then
      return
    end

    -- Advance closest tracking bookmark (defaulting to main) to @-
    local bm_res = run_jj({ "log", "-r", "heads(::@- & bookmarks())", "-T", "bookmarks", "--no-graph" })
    local bm_raw = (bm_res and bm_res[1] and vim.trim(bm_res[1]) ~= "") and vim.trim(bm_res[1]) or "main"
    local bookmark_name = vim.split(bm_raw, "%s+")[1]
    run_jj({ "bookmark", "set", bookmark_name, "-r", "@-" }, true)

    vim.notify("Pushing staged commit to remote...", vim.log.levels.INFO)
    local res = run_jj({ "git", "push" }, true)
    if res then
      vim.notify("✓ Successfully pushed staged commit to remote!", vim.log.levels.INFO)
      M.refresh_all_diffs()
      render()
    end
  end

  render()
  if not buf or not vim.api.nvim_buf_is_valid(buf) then return end

  -- Keybindings for the menu
  vim.keymap.set("n", "<CR>",  open_entry,       { buffer = buf, nowait = true, silent = true })
  vim.keymap.set("n", "a",     stage_entry,      { buffer = buf, nowait = true, silent = true })
  vim.keymap.set("n", "u",     unstage_entry,    { buffer = buf, nowait = true, silent = true })
  vim.keymap.set("n", "x",     discard_entry,    { buffer = buf, nowait = true, silent = true })
  vim.keymap.set("n", "d",     describe_staged,  { buffer = buf, nowait = true, silent = true })
  vim.keymap.set("n", "p",     push_staged,      { buffer = buf, nowait = true, silent = true })
  vim.keymap.set("n", "q",     close_win,        { buffer = buf, nowait = true, silent = true })
  vim.keymap.set("n", "<Esc>", close_win,        { buffer = buf, nowait = true, silent = true })
end

M.open_files_menu = open_jj_files_menu

-- =============================================================================
-- Setup & Keybindings
-- =============================================================================
function M.setup()
  vim.api.nvim_create_user_command("JJFiles", function()
    M.open_files_menu()
  end, { desc = "Open Jujutsu modified files menu (working copy & staged commit)" })

  vim.keymap.set("n", "<leader>jf", M.open_files_menu, { desc = "JJ Modified Files" })
  vim.keymap.set("n", "<leader>jt", M.toggle_diff_base, { desc = "Toggle diff mode (working vs staged)" })
end

return M
