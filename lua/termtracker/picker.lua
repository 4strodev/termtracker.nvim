local picker = {}

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local core = require("termtracker.core")

picker.list_terminals = function(terminals, opts)
    opts = opts or {}

    local entries = {}

    for bufnr, info in pairs(terminals) do
        local status = os.date("%Y-%m-%d %H:%M:%S", info.opened_at)
        table.insert(entries, {
            bufnr = bufnr,
            display = string.format("#%d - %s (%s)", bufnr, info.name, status),
            ordinal = info.name .. bufnr
        })
    end

    pickers.new(opts, {
        prompt_title = "Tracked Terminals",
        finder = finders.new_table {
            results = entries,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry.display,
                    ordinal = entry.ordinal,
                }
            end,
        },
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_vertical:replace(function()
                actions.close(prompt_bufnr)

                local selection = action_state.get_selected_entry()
                local bufnr = selection.value.bufnr

                core:openTerminal({ orientation = 'vertical' }, bufnr)
            end)
            actions.select_horizontal:replace(function()
                actions.close(prompt_bufnr)

                local selection = action_state.get_selected_entry()
                local bufnr = selection.value.bufnr

                core:openTerminal({ orientation = 'horizontal' }, bufnr)
            end)

            actions.select_default:replace(function()
                actions.close(prompt_bufnr)

                local selection = action_state.get_selected_entry()
                local bufnr = selection.value.bufnr


                core:openTerminal({ orientation = 'horizontal' }, bufnr)
            end)

            return true
        end,
    }):find()
end

return picker
