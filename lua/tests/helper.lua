local os = require("os")

local Helper = {}

Helper.structTemplate = [[//
//  Test.swift
//  mocks
//
//  Created by ha100 on 15/11/2024.
//  Copyright © 2024 apperiodic OÜ. All rights reserved.
//

// sourcery: PublicInit
struct Test {

    // MARK: - Properties

    // sourcery:default=""test""
    var uno: String
    var duo: Int

// sourcery:inline:auto:Test.PublicInit

    // MARK: - Init

    public init(
    ) {
    }
// sourcery:end
}


]]

Helper.initUpdateTemplate = [[// sourcery: PublicInit
struct Test {

    // MARK: - Properties

    // sourcery:default=""test""
    var uno: String
    var duo: Int

// sourcery:inline:auto:Test.PublicInit

    // MARK: - Init

    public init(
        uno: String = "test",
        duo: Int
    ) {
        self.uno = uno
        self.duo = duo
    }
// sourcery:end
}
]]

Helper.initStructTemplate = [[//
//  Extract.swift
//  thor.nvim
//
//  Created by ha100 on 07/12/2024.
//  Copyright © 2024 ha100. All rights reserved.
//

// sourcery: PublicInit
struct Extract {

    // MARK: - Properties

    var marko: String
    var polo: Int

// sourcery:inline:auto:Extract.PublicInit

    // MARK: - Init

    public init(
        marko: String,
        polo: Int
    ) {
        self.marko = marko
        self.polo = polo
    }
// sourcery:end

    // MARK: - LifeCycle

    func ramen() {
    }

    func noodle() {
    }
}

]]

Helper.noInitStructTemplate = [[//
//  Extract.swift
//  thor.nvim
//
//  Created by ha100 on 07/12/2024.
//  Copyright © 2024 ha100. All rights reserved.
//

// sourcery: PublicInit
struct Extract {

    // MARK: - Properties

    var marko: String
    var polo: Int

// sourcery:inline:auto:Extract.PublicInit

    // MARK: - Init

    public init(
    ) {
    }
// sourcery:end

    // MARK: - LifeCycle

    func ramen() {
    }

    func noodle() {
    }
}

]]

Helper.emptyStructTemplate = [[//
//  Extract.swift
//  thor.nvim
//
//  Created by ha100 on 07/12/2024.
//  Copyright © 2024 ha100. All rights reserved.
//

// sourcery: PublicInit
struct Extract {

// sourcery:inline:auto:Extract.PublicInit

    // MARK: - Init

    public init(
    ) {
    }
// sourcery:end
}

]]

Helper.lifecycleStructTemplate = [[//
//  Extract.swift
//  thor.nvim
//
//  Created by ha100 on 07/12/2024.
//  Copyright © 2024 ha100. All rights reserved.
//

// sourcery: PublicInit
struct Extract {

// sourcery:inline:auto:Extract.PublicInit

    // MARK: - Init

    public init(
    ) {
    }
// sourcery:end

    // MARK: - LifeCycle

    func ramen() {
    }

    func noodle() {
    }
}

]]

Helper.structExtExtractTemplate = [[//
//  Extract.swift
//  thor.nvim
//
//  Created by ha100 on 07/12/2024.
//  Copyright © 2024 ha100. All rights reserved.
//

// sourcery: PublicInit
public struct Extract: Codable {

    // MARK: - Properties

    var marko: String
    var polo: Int

// sourcery:inline:auto:Extract.PublicInit

    // MARK: - Init

    public init(
    ) {
    }
// sourcery:end
}

public extension Extract {

    static let mock = Extract(marko: "", polo: 100)
}

]]

Helper.structExtractTemplate = [[//
//  Extract.swift
//  thor.nvim
//
//  Created by ha100 on 07/12/2024.
//  Copyright © 2024 ha100. All rights reserved.
//

// sourcery: PublicInit
struct Extract {

    // MARK: - Properties

    var marko: String
    var polo: Int

// sourcery:inline:auto:Extract.PublicInit

    // MARK: - Init

    public init(
    ) {
    }
// sourcery:end
}

]]

Helper.enumExtractTemplate = [[//
//  Extract.swift
//  thor.nvim
//
//  Created by ha100 on 07/12/2024.
//  Copyright © 2024 ha100. All rights reserved.
//

enum Extract {

    case marko
    case polo
}

]]

Helper.enumExtExtractTemplate = [[//
//  Extract.swift
//  thor.nvim
//
//  Created by ha100 on 07/12/2024.
//  Copyright © 2024 ha100. All rights reserved.
//

public enum Extract: Int {

    case marko = 1
    case polo = 2
}

public extension Extract {

    static let mock = Extract.marko
}

]]

Helper.classExtractTemplate = [[//
//  Extract.swift
//  thor.nvim
//
//  Created by ha100 on 07/12/2024.
//  Copyright © 2024 ha100. All rights reserved.
//

// sourcery: PublicInit
class Extract {

    // MARK: - Properties

    var marko: String
    var polo: Int

// sourcery:inline:auto:Extract.PublicInit

    // MARK: - Init

    public init(
    ) {
    }
// sourcery:end
}

]]

Helper.classExtExtractTemplate = [[//
//  Extract.swift
//  thor.nvim
//
//  Created by ha100 on 07/12/2024.
//  Copyright © 2024 ha100. All rights reserved.
//

// sourcery: PublicInit
public class Extract: Codable {

    // MARK: - Properties

    var marko: String
    var polo: Int

// sourcery:inline:auto:Extract.PublicInit

    // MARK: - Init

    public init(
    ) {
    }
// sourcery:end
}

public extension Extract {

    static let mock = Extract(marko: "", polo: 100)
}

]]

Helper.protocolExtractTemplate = [[//
//  Extract.swift
//  thor.nvim
//
//  Created by ha100 on 07/12/2024.
//  Copyright © 2024 ha100. All rights reserved.
//

public protocol Extract {

    func encode(sentence: String) async -> [Float]?
}

]]

Helper.visibilityTemplate = [[//
//  Test.swift
//  mocks
//
//  Created by ha100 on 15/11/2024.
//  Copyright © 2024 apperiodic OÜ. All rights reserved.
//

// sourcery: PublicInit
struct Test {

    // MARK: - Properties

    // sourcery:default=""test""
    var uno: String
    var duo: Int

// sourcery:inline:auto:Test.PublicInit

    // MARK: - Init

    public init(
    ) {
    }
// sourcery:end
}

// sourcery: PublicInit
private class Extract: Codable {

    // MARK: - Properties

    var marko: String
    var polo: Int

// sourcery:inline:auto:Extract.PublicInit

    // MARK: - Init

    public init(
    ) {
    }
// sourcery:end
}

public extension Extract {

    static let mock = Extract(marko: "", polo: 100)
}
]]

Helper.packageTemplate = [[// swift-tools-version:5.9

import PackageDescription

let targets: [Target] = [
        .target(name: "Target",
            dependencies: [
                "Dep"
            ]
        ),
        .systemLibrary(name: "Lib",
            pkgConfig: "lib",
            providers: [
                .brew(["lib"]),
                .apt(["lib-dev"])
            ])
    ]

let package = Package(
    name: "Example",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "Example", targets: ["Target"] )
    ],
    targets: targets,
    swiftLanguageVersions: [.v5]
)
]]

Helper.templateValid = [[//
//  Test.swift
//  thor.nvim
//
//  Created by ha100 on 30/11/2024.
//  Copyright © 2024 ha100. All rights reserved.
//
]]

Helper.templateNew = [[//
//  Test.swift
//  thor.nvim
//
//  Created by ha100 on 28/01/1985.
//  Copyright © 2000 ha100. All rights reserved.
//


]]

Helper.template = [[//
//  Test.swift
//  thor.nvim
//
//  Created by ha100 on 28/01/1985.
//  Copyright © 2000 ha100. All rights reserved.
//

struct Sample {

    let soYouKnow: Bool
}
]]

function Helper.set_visual_selection(start_row, start_col, end_row, end_col, buffer)
    buffer = buffer or 0 -- Default to the current buffer
    -- Set the start of the visual selection ('< mark)
    vim.api.nvim_buf_set_mark(buffer, "<", start_row, start_col, {})
    -- Set the end of the visual selection ('> mark)
    vim.api.nvim_buf_set_mark(buffer, ">", end_row, end_col, {})
end

function Helper.save_close_buffers(buffers)
    for _, buffer in ipairs(buffers) do
        vim.api.nvim_buf_call(buffer, function()
            vim.cmd("write!")
            vim.cmd("bdelete")
        end)
    end
end

function Helper.read_file(path)
    local file = io.open(path, "r")
    assert(file, "Failed to open file: " .. path)
    local content = file:read("*a")
    file:close()
    return content
end

function Helper.update_dates(content)
    local now = os.time()
    local formatted_date =
        string.format("%02d/%02d/%04d", os.date("*t", now).day, os.date("*t", now).month, os.date("*t", now).year)
    local current_year = os.date("%Y", now)

    content = string.gsub(content, "(Created by .- on )%d%d/%d%d/%d%d%d%d", "%1" .. formatted_date)
    content = string.gsub(content, "(Copyright © )%d%d%d%d(.*)", "%1" .. current_year .. "%2")

    return content
end

return Helper
