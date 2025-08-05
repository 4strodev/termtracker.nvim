local core = require('termtracker.core')
local picker = require('termtracker.picker')
local termtracker = {}

---Setup termtracker
---@param opts table
function termtracker.setup(opts)
    opts = opts or {}

    termtracker.opts = opts

    core:setup()

    termtracker:listen_terminal_events()
    termtracker:create_commands()
end

function termtracker:listen_terminal_events()
    vim.api.nvim_create_autocmd('TermOpen', {
        callback = function(args)
            local bufnr = args.buf

            core:addTerminalBufferNumber(bufnr)
        end,
    })

    vim.api.nvim_create_autocmd('BufDelete', {
        callback = function(args)
            local bufnr = args.buf
            core:removeTerminalBufferNumber(bufnr)
        end,
    })
end

function termtracker:create_commands()
    vim.api.nvim_create_user_command("ListTerminals", function()
        local terminals = core:getTerminals()

        if vim.tbl_isempty(terminals) then
            print("No terminal buffers tracked.")
            return
        end

        if termtracker.opts.use_telescope then
            picker.list_terminals(terminals)
            return
        end


        print("== Tracked terminal buffers ==")
        for bufnr, info in pairs(terminals) do
            local status = info.opened_at
            print(string.format("  #%d - %s (%s)", bufnr, info.name, status))
        end
    end, {})
end

return termtracker
