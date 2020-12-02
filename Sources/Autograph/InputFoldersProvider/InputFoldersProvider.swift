//
//  File.swift
//  
//
//  Created by incetro on 12/2/20.
//

import Foundation

// MARK: - InputFoldersProvider

public protocol InputFoldersProvider {

    /// Execution parameters alias
    associatedtype Parameters: ExecutionParameters

    /// Obtain input folders list from
    /// - Parameter parameters: current execution parameters
    func inputFoldersList(fromParameters parameters: Parameters) throws -> [String]
}
