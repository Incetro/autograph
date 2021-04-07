//
//  File.swift
//  
//
//  Created by incetro on 12/1/20.
//

import Foundation

// MARK: - ExecutionParameters

/// All available execution parameters which we
/// can use for our code generation
public protocol ExecutionParameters: Equatable {

    /// Target project name
    ///
    /// Default value: "ProjectName"
    ///
    /// ```
    /// -project_name $NAME
    /// ```
    var projectName: String { get }

    /// True if need to find target files
    /// during current codegen tool process
    /// recursively – going inside all subfolders
    ///
    /// Default value: false
    /// ```
    /// -non_recursive
    /// ```
    var recursiveSearch: Bool { get }

    /// True if need to print detailed info
    /// about current codegen tool process
    ///
    /// Default value: false
    /// ```
    /// -verbose
    /// ```
    var verbose: Bool { get }

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
    var ephemeral: Bool { get }

    /// True if need to print detailed info
    /// about current codegen tool
    ///
    /// Default value: false
    /// ```
    /// -help
    /// ```
    var printHelp: Bool { get }

    /// Application working directory
    var workingDirectory: String { get }

    /// Collected parameters
    var raw: [String: String] { get }
}
