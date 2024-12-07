vim.api.nvim_create_augroup("NewFileGroup", { clear = true })
vim.api.nvim_create_augroup("HeaderCheckGroup", { clear = true })

vim.api.nvim_create_autocmd("BufNewFile", {
    group = "NewFileGroup",
    pattern = "*.swift",
    callback = function()
        local thor = require('thor')
        thor.insert_header()
    end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
    group = "HeaderCheckGroup",
    pattern = "*.swift",
    callback = function()
        local thor = require('thor')
        if thor.has_header() then
            thor.check_header()
        end
    end,
})

vim.api.nvim_create_user_command("Thor", function(opts)
    local thor = require('thor')
    if opts.fargs[1] == "extract2file" then
        thor.extract_to_file()
    elseif opts.fargs[1] == "extract2variable" then
        thor.extract_to_variable()
    elseif opts.fargs[1] == "toggle_visibility" then
        thor.toggle_visibility()
    elseif opts.fargs[1] == "update_init" then
        thor.update_init()
    elseif opts.fargs[1] == "dispatch" then
        if opts.fargs[2] then
            thor.dispatch(opts.fargs[2])
        else
            vim.api.nvim_err_writeln("Error: Missing parameter for 'dispatch'")
        end
    elseif opts.fargs[1] == "docstring" then
        thor.docstring()
    elseif opts.fargs[1] == "header" then
        if thor.has_header() then
            thor.update_header()
        else
            thor.insert_header()
        end
    end
end, {
    range = true,
    nargs='+'
})
