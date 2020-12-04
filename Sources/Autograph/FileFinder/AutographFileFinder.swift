//
//  File.swift
//  
//
//  Created by incetro on 12/1/20.
//

import Files
import Foundation

// MARK: - AutographFileFinder

public final class AutographFileFinder {
}

// MARK: - FileFinder

extension AutographFileFinder: FileFinder {

    public func findFiles(inFolders folders: [String], parameters: AutographExecutionParameters) throws -> [URL] {
        try folders
            .reduce([URL]()) { (files, folder) in
                try files + self.findFiles(inFolder: folder, parameters: parameters)
            }
    }

    public func findFiles(inFolder folder: String, parameters: AutographExecutionParameters) throws -> [URL] {
        let folder = try Folder(path: folder)
        let files = parameters.recursiveSearch ? folder.files.recursive : folder.files
        if parameters.verbose {
            print("Finding files in the folder '\(folder.name)'")
            files.forEach {
                print($0.name)
            }
        }
        return files.map(\.path).compactMap(URL.init)
    }
}
