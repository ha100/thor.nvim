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
        assert.are.same(helper.structTemplate, content)
        local econtent = helper.read_file(extract_path)
        assert.are.same(helper.structExtractTemplate, econtent)
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
        assert.are.same(helper.structTemplate, content)
        local econtent = helper.read_file(extract_path)
        assert.are.same(helper.structExtExtractTemplate, econtent)
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
        assert.are.same(helper.structTemplate, content)
        local econtent = helper.read_file(extract_path)
        assert.are.same(helper.enumExtractTemplate, econtent)
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
        assert.are.same(helper.structTemplate, content)
        local econtent = helper.read_file(extract_path)
        assert.are.same(helper.enumExtExtractTemplate, econtent)
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
        assert.are.same(helper.structTemplate, content)
        local econtent = helper.read_file(extract_path)
        assert.are.same(helper.classExtractTemplate, econtent)
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
        assert.are.same(helper.structTemplate, content)
        local econtent = helper.read_file(extract_path)
        assert.are.same(helper.classExtExtractTemplate, econtent)
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
        assert.are.same(helper.structTemplate, content)
        local econtent = helper.read_file(extract_path)
        assert.are.same(helper.protocolExtractTemplate, econtent)
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
        assert.are.same(helper.packageTemplate, content)
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
        assert.are.same(helper.visibilityTemplate, content)
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
            templates = { template },
        }

        local module = require("thor")
        module.setup(opts)
        eq(template, module.templates[1])
    end)
end)
