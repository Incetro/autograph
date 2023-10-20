//
//  File.swift
//  
//
//  Created by incetro on 12/1/20.
//

import Files
import Foundation

// MARK: - AutographFileWriter

/// Utility responsible for writing implementation
/// to their final destinations
public final class AutographFileWriter {

    // MARK: - Private

    private func createFoldersIfNeeded(
        forImplementations implementations: [AutographImplementation],
        parameters: AutographExecutionParameters
    ) throws {
        try implementations.forEach { implementation in
            let folderURL = URL(fileURLWithPath: implementation.filePath).deletingLastPathComponent()
            if let folder = try? Folder(path: folderURL.path) {
                if parameters.verbose {
                    print("Folder \(folder.path) already exist")
                }
            } else {
                try FileManager.default.createDirectory(
                    at: folderURL,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
            }
        }
    }

    private func write(
        sourceCode: String,
        toFilepath filePath: String,
        withParameters parameters: AutographExecutionParameters
    ) throws {
        
        func vp(_ string: String) {
            if parameters.verbose {
                print(string)
            }
        }
        
        vp("Processing file: \(filePath)")

        if let file = try? File(path: filePath), try file.readAsString() == sourceCode {
            vp("File \(filePath) didn't change, skipping...")
        } else {
            vp("Creating URL from '\(filePath)'")
            guard let fileURL = URL(string: filePath) else {
                vp("❌ Cannot create URL from '\(filePath)'")
                return
            }
            let folderURL = fileURL.deletingLastPathComponent()
            let file = try Folder(path: folderURL.path).createFile(at: fileURL.lastPathComponent)
            try file.write(sourceCode)
        }
    }
}

// MARK: - FileWriter

extension AutographFileWriter: FileWriter {

    public func write(
        implementations: [AutographImplementation],
        parameters: AutographExecutionParameters
    ) throws {
        try createFoldersIfNeeded(forImplementations: implementations, parameters: parameters)
        try implementations.forEach {
            try write(sourceCode: $0.sourceCode, toFilepath: $0.filePath, withParameters: parameters)
        }
    }
}
