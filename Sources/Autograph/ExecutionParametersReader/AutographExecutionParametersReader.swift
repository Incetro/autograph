//
//  File.swift
//  
//
//  Created by incetro on 12/1/20.
//

import Foundation

// MARK: - AutographExecutionParametersReader

/// Utility responsible for command line parameters parsing
public final class AutographExecutionParametersReader {

    // MARK: - Private

    private func isKey(_ argument: String) -> Bool {
        argument.hasPrefix("-")
    }
}

// MARK: - ExecutionParametersReader

extension AutographExecutionParametersReader: ExecutionParametersReader {

    public func readExecutionParameters(fromCommandLineArguments commandLineArguments: [String]) throws -> AutographExecutionParameters {

        var verbose = false
        var printHelp = false
        var recursiveSearch = true
        var projectName = AutographConstants.defaultProjectName
        var raw: [String: String] = [:]

        for (index, argument) in commandLineArguments.enumerated() {

            if "-verbose" == argument {
                verbose = true
            }

            if "-help" == argument {
                printHelp = true
            }

            if "-non_recursive" == argument {
                recursiveSearch = false
            }

            if "-project_name" == argument {
                if let value = commandLineArguments.nextAfter(index), !isKey(value) {
                    if verbose {
                        print("Project name: \(value)")
                    }
                    projectName = value
                } else {
                    throw NSError(
                        domain: "\(type(of: self))",
                        code: 13,
                        userInfo: [
                            NSLocalizedDescriptionKey: "-project_name parameter found, but key is absent"
                        ]
                    )
                }
            }

            if isKey(argument) {
                if let value = commandLineArguments.nextAfter(index), !isKey(value) {
                    if verbose {
                        print("Found pair of arguments: \(argument) = \(value)")
                    }
                    raw[argument] = value
                } else {
                    if verbose {
                        print("Found argument: \(argument)")
                    }
                    raw[argument] = ""
                }
            }
        }

        defer {
            print("Working directory: \(FileManager.default.currentDirectoryPath)")
        }

        return AutographExecutionParameters(
            projectName:     projectName,
            recursiveSearch: recursiveSearch,
            verbose:         verbose,
            printHelp:       printHelp,
            raw:             raw
        )
    }
}

// MARK: - Array

private extension Array {

    func nextAfter(_ index: Array.Index) -> Element? {
        count > index + 1 ? self[index + 1] : nil
    }
}
