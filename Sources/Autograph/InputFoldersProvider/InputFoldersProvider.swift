//
//  File.swift
//  
//
//  Created by incetro on 12/2/20.
//

import Foundation

// MARK: - InputFoldersProvider

/// Utility responsible for providing input folders list
/// out of the given console application parameters
public protocol InputFoldersProvider {

    /// Execution parameters alias
    associatedtype Parameters: ExecutionParameters

    /// Default initializer
    init()

    /// Obtain input folders list from
    /// - Parameter parameters: current execution parameters
    func inputFoldersList(fromParameters parameters: Parameters) throws -> [String]

    /// Obtain ephemeral input folders list from
    /// - Parameter parameters: current execution parameters
    func ephemeralFoldersList(fromParameters parameters: Parameters) throws -> [String]
}

public extension InputFoldersProvider {

    /// Obtain ephemeral input folders list from
    /// - Parameter parameters: current execution parameters
    func ephemeralFoldersList(fromParameters parameters: Parameters) throws -> [String] { [] }
}
