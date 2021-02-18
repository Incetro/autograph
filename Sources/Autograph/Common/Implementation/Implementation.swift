//
//  File.swift
//  
//
//  Created by incetro on 12/1/20.
//

import Foundation

// MARK: - Implementation

/// Source code implementation.
///
/// After compilation, `ImplementationComposer` instances
/// are used to generate utilities. Generated source code
/// of these utilities is organised into `Implementation` instances.
public protocol Implementation: Equatable {

    /// File path for future Swift class
    var filePath: String { get }

    /// Source code
    var sourceCode: String { get }
}
