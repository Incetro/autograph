//
//  File.swift
//  
//
//  Created by incetro on 12/1/20.
//

import Foundation

// MARK: - AutographImplementation

/// Source code implementation.
///
/// After compilation, `ImplementationComposer` instances
/// are used to generate utilities. Generated source code
/// of these utilities is organised into `Implementation` instances.
public final class AutographImplementation: Implementation {

    // MARK: - Properties

    /// File path for future Swift class
    public let filePath: String

    /// Source code
    public let sourceCode: String

    // MARK: - Initializers

    /// Default initializer
    /// - Parameters:
    ///   - filePath: file path for future Swift class
    ///   - sourceCode: source code
    public init(filePath: String, sourceCode: String) {
        self.filePath = filePath
        self.sourceCode = sourceCode
    }

    // MARK: - Equatable

    public static func == (left: AutographImplementation, right: AutographImplementation) -> Bool {
        left.filePath == right.filePath && left.sourceCode == right.sourceCode
    }
}
