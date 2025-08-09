local ok, _ = pcall(require, 'termtracker')

if ok then
    require('termtracker').setup({
        use_telescope = true
    })
end
