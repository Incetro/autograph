//
//  File.swift
//  
//
//  Created by incetro on 12/1/20.
//

import Foundation

// MARK: - ExecutionParameters

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
    /// -recursive
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
