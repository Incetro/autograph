//
//  File.swift
//  
//
//  Created by incetro on 12/2/20.
//

import Synopsis
import Foundation

// MARK: - ImplementationComposer

public protocol ImplementationComposer {

    /// Source code implementation alias
    associatedtype Imp: Implementation

    /// Execution parameters alias
    associatedtype Parameters: ExecutionParameters

    /// Compose some source code for parsed
    /// classes/structures/enums/functions/protocols etc.
    /// - Parameters:
    ///   - specifications: classes/structures/enums/functions/protocols
    ///   - parameters: current execution parameters
    func compose(forSpecifications specifications: Specifications, parameters: Parameters) throws -> [Imp]
}
