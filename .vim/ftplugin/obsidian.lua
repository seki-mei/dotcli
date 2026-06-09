require("obsidian").setup{
  legacy_commands = false,
  workspaces = { { name = "obsidian", path = "~/obsidian" } },
  picker = { name = "telescope.nvim" },
}

require("telescope").setup{
  defaults = {
    mappings = { i = { ["<C-u>"] = false } },
  }
}

require("aerial").setup()

vim.api.nvim_set_hl(0, "ObsidianTagDim", { fg = "#928374" })

vim.api.nvim_create_user_command("Unifiedswitch", function()
  local search = require("obsidian.search")
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local entry_display = require("telescope.pickers.entry_display")

  local displayer = entry_display.create{
    separator = " ",
    items = {
      { remaining = true },
      { remaining = true },
    },
  }

  search.find_notes_async("", function(notes)
    local entries = {}
    for _, note in ipairs(notes) do
      local tag_str = ""
      if note.tags and #note.tags > 0 then
        tag_str = table.concat(vim.tbl_map(function(t) return "#" .. t end, note.tags), " ")
      end
      local alias_str = ""
      if note.aliases and #note.aliases > 0 then
        alias_str = " (" .. table.concat(note.aliases, ", ") .. ")"
      end
      table.insert(entries, {
        id = tostring(note.id) .. alias_str,
        tags = tag_str,
        ordinal = tostring(note.id) .. " " .. alias_str .. " " .. tag_str,
        path = tostring(note.path),
      })
    end
    pickers.new({}, {
      prompt_title = "Notes & Tags",
      finder = finders.new_table{
        results = entries,
        entry_maker = function(e)
          return {
            value = e,
            ordinal = e.ordinal,
            display = function()
              return displayer{
                { e.id },
                { e.tags, "ObsidianTagDim" },
              }
            end,
          }
        end,
      },
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local e = action_state.get_selected_entry().value
          actions.close(prompt_bufnr)
          vim.cmd("edit " .. vim.fn.fnameescape(e.path))
        end)
        return true
      end,
    }):find()
  end)
end, {})

vim.api.nvim_create_user_command("Tagswitcher", function()
  local api = require("obsidian.api")
  local note = api.current_note()
  if not note then
    vim.notify("Not an obsidian note", vim.log.levels.WARN)
    return
  end
  local tags = note.tags
  if not tags or #tags == 0 then
    vim.notify("No tags in current note", vim.log.levels.WARN)
    return
  end
  if #tags == 1 then
    vim.cmd("Obsidian tags " .. tags[1])
    return
  end
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  pickers.new({}, {
    prompt_title = "Tags in this note",
    finder = finders.new_table{ results = tags },
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local tag = action_state.get_selected_entry()[1]
        actions.close(prompt_bufnr)
        vim.cmd("Obsidian tags " .. tag)
      end)
      return true
    end,
  }):find()
end, {})
