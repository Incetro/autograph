//
//  File.swift
//  
//
//  Created by incetro on 12/1/20.
//

import Foundation

// MARK: - FileWriter

public protocol FileWriter {

    /// Source code implementation alias
    associatedtype Imp: Implementation

    /// Execution parameters alias
    associatedtype Parameters: ExecutionParameters

    /// Write implementations to disk
    /// - Parameters:
    ///   - implementations: target Swift classes implmentations
    ///   - parameters: current execution parameters
    func write(
        implementations: [Imp],
        parameters: Parameters
    ) throws
}
