//
//  File.swift
//  
//
//  Created by incetro on 12/1/20.
//

import Files
import Foundation

// MARK: - AutographFileFinder

/// Utility responsible for target files search
public final class AutographFileFinder {
}

// MARK: - FileFinder

extension AutographFileFinder: FileFinder {

    public func findFiles(inFolders folders: [String], parameters: AutographExecutionParameters) throws -> [URL] {
        try folders.reduce([URL]()) { (files, folder) in
            try files + self.findFiles(inFolder: folder, parameters: parameters)
        }
    }

    public func findFiles(inFolder folder: String, parameters: AutographExecutionParameters) throws -> [URL] {
        let path = folder.isEmpty ? parameters.workingDirectory : folder
        if let file = try? File(path: path) {
            return [URL(string: path)]
        }
        let folder = try Folder(path: path)
        let files = parameters.recursiveSearch ? folder.files.recursive : folder.files
        if parameters.verbose {
            print("Finding files in the folder '\(folder.name)'")
            files.forEach {
                print($0.name)
            }
        }
        return files
            .filter { $0.extension == "swift" }
            .map(\.path)
            .compactMap(URL.init)
    }
}
