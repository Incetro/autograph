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
public final class AutographExecutionParameters: ExecutionParameters {

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

    /// This param will add disabling comment to codegen helper.
    /// It means that after first generation there won't be
    /// a new generation attempt until you delete the disabling comment
    /// from your necessary files. Use it when you want to generate your code
    /// once and maintain it manually after that.
    ///
    /// Default value: false
    /// ```
    /// -ephemeral
    /// ```
    public let ephemeral: Bool

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

    /// Due to https://github.com/jpsim/SourceKitten/issues/444
    /// we were needed to add this parameter to temporary solve the issue
    public let resolvingInterpolation: Bool

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
        projectName:            String,
        recursiveSearch:        Bool,
        verbose:                Bool,
        ephemeral:              Bool,
        printHelp:              Bool,
        resolvingInterpolation: Bool,
        raw:                    [String: String]
    ) {
        self.projectName            = projectName
        self.recursiveSearch        = recursiveSearch
        self.verbose                = verbose
        self.ephemeral              = ephemeral
        self.printHelp              = printHelp
        self.resolvingInterpolation = resolvingInterpolation
        self.raw                    = raw
        self.workingDirectory       = FileManager.default.currentDirectoryPath
    }

    // MARK: - Accessors

    public subscript(key: String) -> String? {
        raw[key]
    }

    // MARK: - Equatable

    public static func == (left: AutographExecutionParameters, right: AutographExecutionParameters) -> Bool {
        return left.projectName             == right.projectName
            && left.verbose                 == right.verbose
            && left.printHelp               == right.printHelp
            && left.raw                     == right.raw
            && left.ephemeral               == right.ephemeral
            && left.workingDirectory        == right.workingDirectory
            && left.recursiveSearch         == right.recursiveSearch
            && left.resolvingInterpolation  == right.resolvingInterpolation
    }
}
