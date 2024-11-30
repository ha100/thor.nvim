//
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
