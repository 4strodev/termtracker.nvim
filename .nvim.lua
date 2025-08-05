local ok, _ = pcall(require, 'termtracker')

if ok then
    print('require termtracker')
    require('termtracker').setup({
        use_telescope = true
    })
end
