//
//  File.swift
//  
//
//  Created by incetro on 12/1/20.
//

import Foundation

// MARK: - AutographExecutionParameters

/// All available execution parameters which we
/// can use for our code generation
public struct AutographExecutionParameters: ExecutionParameters {

    /// Target project name
    ///
    /// Default value: "ProjectName"
    ///
    /// ```
    /// -project_name $NAME
    /// ```
    public let projectName: String

    /// True if need to find target files
    /// during current codegen tool process
    /// recursively – going inside all subfolders
    ///
    /// Default value: true
    /// ```
    /// -non_recursive flag turns it to false
    /// ```
    public let recursiveSearch: Bool

    /// True if need to print detailed info
    /// about current codegen tool process
    ///
    /// Default value: false
    /// ```
    /// -verbose
    /// ```
    public let verbose: Bool

    /// True if need to print detailed info
    /// about current codegen tool
    ///
    /// Default value: false
    /// ```
    /// -help
    /// ```
    public let printHelp: Bool

    /// Application working directory
    public let workingDirectory: String

    /// Collected parameters
    public let raw: [String: String]

    /// Default initializer
    /// - Parameters:
    ///   - projectName: target project name
    ///   - recursiveSearch:  True if need to find target files
    ///     during current codegen tool process
    ///     recursively – going inside all subfolders
    ///   - verbose: true if need to print detailed info
    ///     about current codegen tool process
    ///   - printHelp: true if need to print detailed info
    ///     about current codegen tool
    ///   - raw: collected parameters
    public init(
        projectName:     String,
        recursiveSearch: Bool,
        verbose:         Bool,
        printHelp:       Bool,
        raw:             [String: String]
    ) {
        self.projectName      = projectName
        self.recursiveSearch  = recursiveSearch
        self.verbose          = verbose
        self.printHelp        = printHelp
        self.raw              = raw
        self.workingDirectory = FileManager.default.currentDirectoryPath
    }

    // MARK: - Accessors

    public subscript(key: String) -> String? {
        raw[key]
    }

    // MARK: - Equatable

    public static func == (left: AutographExecutionParameters, right: AutographExecutionParameters) -> Bool {
        return left.projectName == right.projectName
            && left.verbose     == right.verbose
            && left.printHelp   == right.printHelp
            && left.raw         == right.raw
    }
}
