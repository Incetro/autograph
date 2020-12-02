//
//  File.swift
//  
//
//  Created by incetro on 12/1/20.
//

import Foundation

// MARK: - ExecutionParametersReader

/// Utility responsible for command line parameters parsing
public protocol ExecutionParametersReader {

    /// Execution parameters alias
    associatedtype Parameters: ExecutionParameters

    /// Read all available parameters from command line arguments
    /// - Parameter commandLineArguments: current command line arguments
    func readExecutionParameters(fromCommandLineArguments commandLineArguments: [String]) throws -> Parameters
}
