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
    end
end, {
    range = true,
    nargs='?'
})
