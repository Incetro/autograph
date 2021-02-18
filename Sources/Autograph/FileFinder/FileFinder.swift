//
//  File.swift
//  
//
//  Created by incetro on 12/1/20.
//

import Foundation

// MARK: - FileFinder

/// Utility responsible for target files search
public protocol FileFinder {

    /// /// Execution parameters alias
    associatedtype Parameters: ExecutionParameters

    /// Find all available files in the given folders
    /// - Parameters:
    ///   - folders: target folders with files
    ///   - parameters: assistive parameters
    func findFiles(inFolders folders: [String], parameters: Parameters) throws -> [URL]

    /// Find all available files in the given folder
    /// - Parameters:
    ///   - folder: target folder with files
    ///   - parameters: assistive parameters
    func findFiles(inFolder folder: String, parameters: Parameters) throws -> [URL]
}
