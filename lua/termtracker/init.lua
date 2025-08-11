local core = require('termtracker.core')
local picker = require('termtracker.picker')
local termtracker = {}

---Setup termtracker
---@param opts table
function termtracker.setup(opts)
    core:setup(opts)

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
    vim.api.nvim_create_user_command("TermList", function()
        local terminals = core:getTerminals()

        if vim.tbl_isempty(terminals) then
            vim.notify("No terminal buffers tracked.", vim.log.levels.WARN)
            return
        end

        local ok, _ = pcall(require, "telescope")
        if not ok then
            vim.notify("Cannot use telescope. Check if it's installed correctly", vim.log.levels.ERROR)
        end

        picker.list_terminals(terminals)
    end, {})

    vim.api.nvim_create_user_command("TermOpen", function()
        core:openTerminal({ orientation = 'horizontal' })
    end, {})

    vim.api.nvim_create_user_command("TermToggle", function()
        local latestTerminal = core:getLatestTerminal()

        local terminalToOpen = nil
        if latestTerminal ~= nil then
            terminalToOpen = latestTerminal.bufnr
        else
            vim.notify("Creating new terminal")
        end
        core:openTerminal({ orientation = 'horizontal' }, terminalToOpen)
    end, {})
end

return termtracker
