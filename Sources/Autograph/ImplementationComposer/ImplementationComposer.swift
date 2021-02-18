//
//  File.swift
//  
//
//  Created by incetro on 12/2/20.
//

import Synopsis
import Foundation

// MARK: - ImplementationComposer

/// Utility responsible for composing implementation
/// out of the given code specifications
public protocol ImplementationComposer {

    /// Source code implementation alias
    associatedtype Imp: Implementation

    /// Execution parameters alias
    associatedtype Parameters: ExecutionParameters

    /// Default initializer
    init()

    /// Compose some source code for parsed
    /// classes/structures/enums/functions/protocols etc.
    /// - Parameters:
    ///   - specifications: classes/structures/enums/functions/protocols
    ///   - parameters: current execution parameters
    func compose(forSpecifications specifications: Specifications, parameters: Parameters) throws -> [Imp]
}
