dofile("plugin/thor.lua")
vim.opt.runtimepath:prepend("~/.local/share/nvim/lazy/nvim-treesitter")
vim.opt.runtimepath:prepend("~/.local/share/nvim/plugged/nvim-treesitter")
local helper = require("tests.helper")

local eq = assert.are.equal
local same = assert.are.same
local current_dir = vim.fn.expand("%:p:h")
local file_path = current_dir .. "/tests/mocks/Test.swift"
local extract_path = current_dir .. "/tests/mocks/Extract.swift"

describe("thor", function()
    before_each(function()
        require("thor").setup({
            company = "ha100",
            templates = {},
        })
    end)

    after_each(function()
        os.remove(file_path)
        os.remove(extract_path)
    end)

    it("extract to file works for simple struct", function()
        local from_path = current_dir .. "/tests/mocks/mockStruct.swift"
        os.execute(('cp "%s" "%s"'):format(from_path, file_path))

        vim.cmd("edit " .. file_path)
        local bufnameOrigo = vim.fn.bufname("%")
        local bufOrigo = vim.fn.bufnr(bufnameOrigo)
        helper.set_visual_selection(28, 0, 44, 0, bufOrigo)
        vim.cmd("Thor extract2file")
        local bufnameNew = vim.fn.bufname("%")
        local bufNew = vim.fn.bufnr(bufnameNew)
        helper.save_close_buffers({ bufNew, bufOrigo })

        local content = helper.read_file(file_path)
        eq(helper.structTemplate, content)
        local econtent = helper.read_file(extract_path)
        local template = helper.update_dates(helper.structExtractTemplate)
        eq(template, econtent)
    end)

    it("extract to file works for extended struct", function()
        local from_path = current_dir .. "/tests/mocks/mockStructExt.swift"
        os.execute(('cp "%s" "%s"'):format(from_path, file_path))

        vim.cmd("edit " .. file_path)
        local bufnameOrigo = vim.fn.bufname("%")
        local bufOrigo = vim.fn.bufnr(bufnameOrigo)
        helper.set_visual_selection(28, 0, 49, 0, bufOrigo)
        vim.cmd("Thor extract2file")
        local bufnameNew = vim.fn.bufname("%")
        local bufNew = vim.fn.bufnr(bufnameNew)
        helper.save_close_buffers({ bufNew, bufOrigo })

        local content = helper.read_file(file_path)
        eq(helper.structTemplate, content)
        local econtent = helper.read_file(extract_path)
        local template = helper.update_dates(helper.structExtExtractTemplate)
        eq(template, econtent)
    end)

    it("extract to file works for simple enum", function()
        local from_path = current_dir .. "/tests/mocks/mockEnum.swift"
        os.execute(('cp "%s" "%s"'):format(from_path, file_path))

        vim.cmd("edit " .. file_path)
        local bufnameOrigo = vim.fn.bufname("%")
        local bufOrigo = vim.fn.bufnr(bufnameOrigo)
        helper.set_visual_selection(28, 0, 32, 0, bufOrigo)
        vim.cmd("Thor extract2file")
        local bufnameNew = vim.fn.bufname("%")
        local bufNew = vim.fn.bufnr(bufnameNew)
        helper.save_close_buffers({ bufNew, bufOrigo })

        local content = helper.read_file(file_path)
        eq(helper.structTemplate, content)
        local econtent = helper.read_file(extract_path)
        local template = helper.update_dates(helper.enumExtractTemplate)
        eq(template, econtent)
    end)

    it("extract to file works for extended enum", function()
        local from_path = current_dir .. "/tests/mocks/mockEnumExt.swift"
        os.execute(('cp "%s" "%s"'):format(from_path, file_path))

        vim.cmd("edit " .. file_path)
        local bufnameOrigo = vim.fn.bufname("%")
        local bufOrigo = vim.fn.bufnr(bufnameOrigo)
        helper.set_visual_selection(28, 0, 37, 0, bufOrigo)
        vim.cmd("Thor extract2file")
        local bufnameNew = vim.fn.bufname("%")
        local bufNew = vim.fn.bufnr(bufnameNew)
        helper.save_close_buffers({ bufNew, bufOrigo })

        local content = helper.read_file(file_path)
        eq(helper.structTemplate, content)
        local econtent = helper.read_file(extract_path)
        local template = helper.update_dates(helper.enumExtExtractTemplate)
        eq(template, econtent)
    end)

    it("extract to file works for simple class", function()
        local from_path = current_dir .. "/tests/mocks/mockClass.swift"
        os.execute(('cp "%s" "%s"'):format(from_path, file_path))

        vim.cmd("edit " .. file_path)
        local bufnameOrigo = vim.fn.bufname("%")
        local bufOrigo = vim.fn.bufnr(bufnameOrigo)
        helper.set_visual_selection(28, 0, 44, 0, bufOrigo)
        vim.cmd("Thor extract2file")
        local bufnameNew = vim.fn.bufname("%")
        local bufNew = vim.fn.bufnr(bufnameNew)
        helper.save_close_buffers({ bufNew, bufOrigo })

        local content = helper.read_file(file_path)
        eq(helper.structTemplate, content)
        local econtent = helper.read_file(extract_path)
        local template = helper.update_dates(helper.classExtractTemplate)
        eq(template, econtent)
    end)

    it("extract to file works for extended class", function()
        local from_path = current_dir .. "/tests/mocks/mockClassExt.swift"
        os.execute(('cp "%s" "%s"'):format(from_path, file_path))

        vim.cmd("edit " .. file_path)
        local bufnameOrigo = vim.fn.bufname("%")
        local bufOrigo = vim.fn.bufnr(bufnameOrigo)
        helper.set_visual_selection(28, 0, 49, 0, bufOrigo)
        vim.cmd("Thor extract2file")
        local bufnameNew = vim.fn.bufname("%")
        local bufNew = vim.fn.bufnr(bufnameNew)
        helper.save_close_buffers({ bufNew, bufOrigo })

        local content = helper.read_file(file_path)
        eq(helper.structTemplate, content)
        local econtent = helper.read_file(extract_path)
        local template = helper.update_dates(helper.classExtExtractTemplate)
        eq(template, econtent)
    end)

    it("extract to file works for protocol", function()
        local from_path = current_dir .. "/tests/mocks/mockProtocol.swift"
        os.execute(('cp "%s" "%s"'):format(from_path, file_path))

        vim.cmd("edit " .. file_path)
        local bufnameOrigo = vim.fn.bufname("%")
        local bufOrigo = vim.fn.bufnr(bufnameOrigo)
        helper.set_visual_selection(28, 0, 31, 0, bufOrigo)
        vim.cmd("Thor extract2file")
        local bufnameNew = vim.fn.bufname("%")
        local bufNew = vim.fn.bufnr(bufnameNew)
        helper.save_close_buffers({ bufNew, bufOrigo })

        local content = helper.read_file(file_path)
        eq(helper.structTemplate, content)
        local econtent = helper.read_file(extract_path)
        local template = helper.update_dates(helper.protocolExtractTemplate)
        eq(template, econtent)
    end)

    it("extract to variable works for specified template", function()
        local opts = {
            templates = {
                {
                    file = "Test.swift",
                    from = "targets",
                    to = "targets",
                    type = "[Target]",
                },
            },
        }
        local module = require("thor")
        module.setup(opts)
        local from_path = current_dir .. "/tests/mocks/mockPackage.swift"
        os.execute(('cp "%s" "%s"'):format(from_path, file_path))

        vim.cmd("edit " .. file_path)
        local bufnameOrigo = vim.fn.bufname("%")
        local bufOrigo = vim.fn.bufnr(bufnameOrigo)
        helper.set_visual_selection(13, 0, 25, 5, bufOrigo)
        vim.cmd("Thor extract2variable")
        vim.api.nvim_buf_call(bufOrigo, function()
            vim.cmd("write!")
            vim.cmd("bdelete")
        end)

        local content = helper.read_file(file_path)
        eq(helper.packageTemplate, content)
    end)

    it("toggle public/private visibility", function()
        local from_path = current_dir .. "/tests/mocks/mockClassExt.swift"
        os.execute(('cp "%s" "%s"'):format(from_path, file_path))

        vim.cmd("edit " .. file_path)
        local bufnameOrigo = vim.fn.bufname("%")
        local bufOrigo = vim.fn.bufnr(bufnameOrigo)
        vim.api.nvim_win_set_cursor(0, { 29, 0 })
        vim.cmd("Thor toggle_visibility")
        vim.api.nvim_buf_call(bufOrigo, function()
            vim.cmd("write!")
            vim.cmd("bdelete")
        end)

        local content = helper.read_file(file_path)
        eq(helper.visibilityTemplate, content)
    end)

    it("anotates struct with no props, no init, no lifecycle", function()
        local from_path = current_dir .. "/tests/mocks/mockEmptyStruct.swift"
        os.execute(('cp "%s" "%s"'):format(from_path, file_path))

        vim.cmd("edit " .. file_path)
        local bufnameOrigo = vim.fn.bufname("%")
        local bufOrigo = vim.fn.bufnr(bufnameOrigo)
        helper.set_visual_selection(1, 0, 3, 0, bufOrigo)
        vim.cmd("Thor extract2file")
        local bufnameNew = vim.fn.bufname("%")
        local bufNew = vim.fn.bufnr(bufnameNew)
        helper.save_close_buffers({ bufNew, bufOrigo })

        local econtent = helper.read_file(extract_path)
        local template = helper.update_dates(helper.emptyStructTemplate)
        eq(template, econtent)
    end)

    it("anotates struct with no props, no init", function()
        local from_path = current_dir .. "/tests/mocks/mockLifecycleStruct.swift"
        os.execute(('cp "%s" "%s"'):format(from_path, file_path))

        vim.cmd("edit " .. file_path)
        local bufnameOrigo = vim.fn.bufname("%")
        local bufOrigo = vim.fn.bufnr(bufnameOrigo)
        helper.set_visual_selection(1, 0, 8, 0, bufOrigo)
        vim.cmd("Thor extract2file")
        local bufnameNew = vim.fn.bufname("%")
        local bufNew = vim.fn.bufnr(bufnameNew)
        helper.save_close_buffers({ bufNew, bufOrigo })

        local econtent = helper.read_file(extract_path)
        eq(helper.lifecycleStructTemplate, econtent)
    end)

    it("anotates struct with no props, no init, but lifecycle mark present", function()
        local from_path = current_dir .. "/tests/mocks/mockLifecycleMarkStruct.swift"
        os.execute(('cp "%s" "%s"'):format(from_path, file_path))

        vim.cmd("edit " .. file_path)
        local bufnameOrigo = vim.fn.bufname("%")
        local bufOrigo = vim.fn.bufnr(bufnameOrigo)
        helper.set_visual_selection(1, 0, 10, 0, bufOrigo)
        vim.cmd("Thor extract2file")
        local bufnameNew = vim.fn.bufname("%")
        local bufNew = vim.fn.bufnr(bufnameNew)
        helper.save_close_buffers({ bufNew, bufOrigo })

        local econtent = helper.read_file(extract_path)
        local template = helper.update_dates(helper.lifecycleStructTemplate)
        eq(template, econtent)
    end)

    it("anotates struct with props and marks present", function()
        local from_path = current_dir .. "/tests/mocks/mockNoInitStruct.swift"
        os.execute(('cp "%s" "%s"'):format(from_path, file_path))

        vim.cmd("edit " .. file_path)
        local bufnameOrigo = vim.fn.bufname("%")
        local bufOrigo = vim.fn.bufnr(bufnameOrigo)
        helper.set_visual_selection(1, 0, 15, 0, bufOrigo)
        vim.cmd("Thor extract2file")
        local bufnameNew = vim.fn.bufname("%")
        local bufNew = vim.fn.bufnr(bufnameNew)
        helper.save_close_buffers({ bufNew, bufOrigo })

        local econtent = helper.read_file(extract_path)
        local template = helper.update_dates(helper.noInitStructTemplate)
        eq(template, econtent)
    end)

    it("anotates init when it is present", function()
        local from_path = current_dir .. "/tests/mocks/mockInitStruct.swift"
        os.execute(('cp "%s" "%s"'):format(from_path, file_path))

        vim.cmd("edit " .. file_path)
        local bufnameOrigo = vim.fn.bufname("%")
        local bufOrigo = vim.fn.bufnr(bufnameOrigo)
        helper.set_visual_selection(1, 0, 23, 0, bufOrigo)
        vim.cmd("Thor extract2file")
        local bufnameNew = vim.fn.bufname("%")
        local bufNew = vim.fn.bufnr(bufnameNew)
        helper.save_close_buffers({ bufNew, bufOrigo })

        local econtent = helper.read_file(extract_path)
        eq(helper.initStructTemplate, econtent)
    end)

    it("anotates init with mark when it is present", function()
        local from_path = current_dir .. "/tests/mocks/mockInitMarkStruct.swift"
        os.execute(('cp "%s" "%s"'):format(from_path, file_path))

        vim.cmd("edit " .. file_path)
        local bufnameOrigo = vim.fn.bufname("%")
        local bufOrigo = vim.fn.bufnr(bufnameOrigo)
        helper.set_visual_selection(1, 0, 25, 0, bufOrigo)
        vim.cmd("Thor extract2file")
        local bufnameNew = vim.fn.bufname("%")
        local bufNew = vim.fn.bufnr(bufnameNew)
        helper.save_close_buffers({ bufNew, bufOrigo })

        local econtent = helper.read_file(extract_path)
        local template = helper.update_dates(helper.initStructTemplate)
        eq(template, econtent)
    end)

    it("updates init values", function()
        local from_path = current_dir .. "/tests/mocks/mockInitUpdate.swift"
        os.execute(('cp "%s" "%s"'):format(from_path, file_path))
        vim.cmd("edit " .. file_path)
        vim.cmd("Thor update_init")
        vim.cmd("bdelete!")

        local content = helper.read_file(file_path)
        eq(helper.initUpdateTemplate, content)
    end)

    it("injects header into newly created Swift file automatically", function()
        vim.cmd("edit " .. file_path)
        local bufnameOrigo = vim.fn.bufname("%")
        local bufOrigo = vim.fn.bufnr(bufnameOrigo)
        vim.api.nvim_buf_call(bufOrigo, function()
            vim.cmd("write!")
            vim.cmd("bdelete")
        end)

        local content = helper.read_file(file_path)
        local template = helper.update_dates(helper.templateNew)
        eq(template, content)
    end)

    it("injects header via command", function()
        local from_path = current_dir .. "/tests/mocks/mockExisting.swift"
        os.execute(('cp "%s" "%s"'):format(from_path, file_path))

        vim.cmd("edit " .. file_path)
        local bufnameOrigo = vim.fn.bufname("%")
        local bufOrigo = vim.fn.bufnr(bufnameOrigo)
        vim.cmd("Thor header")
        vim.api.nvim_buf_call(bufOrigo, function()
            vim.cmd("write!")
            vim.cmd("bdelete")
        end)

        local content = helper.read_file(file_path)
        local template = helper.update_dates(helper.template)
        eq(template, content)
    end)

    it("updates header for invalid header data", function()
        local from_path = current_dir .. "/tests/mocks/mockInvalid.swift"
        os.execute(('cp "%s" "%s"'):format(from_path, file_path))

        vim.cmd("edit " .. file_path)
        local bufnameOrigo = vim.fn.bufname("%")
        local bufOrigo = vim.fn.bufnr(bufnameOrigo)
        vim.cmd("Thor header")
        vim.api.nvim_buf_call(bufOrigo, function()
            vim.cmd("write!")
            vim.cmd("bdelete")
        end)

        local content = helper.read_file(file_path)
        local contentFixDate = helper.update_dates(content)
        local template = helper.update_dates(helper.templateValid)
        eq(template, contentFixDate)
    end)
end)

describe("setup", function()
    it("will handle default options", function()
        local opts = {
            templates = {},
        }
        local module = require("thor")

        module.setup(opts)
        same({}, module.templates)
    end)

    it("will pass through user options", function()
        local template = {
            file = "Package.swift",
            from = "dependencies",
            to = "deps",
            type = "[Package.Dependency]",
        }

        local opts = {
            company = "ou",
            templates = { template },
        }

        local module = require("thor")
        module.setup(opts)
        eq(template, module.templates[1])
        eq("ou", module.company)
    end)
end)
