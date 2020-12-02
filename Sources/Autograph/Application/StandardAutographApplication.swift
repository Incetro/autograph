//
//  File.swift
//  
//
//  Created by incetro on 12/2/20.
//

import Foundation

// MARK: - StandardAutographApplication

open class StandardAutographApplication<
    C: ImplementationComposer,
    M: InputFoldersProvider
>: AutographApplication<AutographExecutionParametersReader, AutographFileFinder, AutographFileWriter, C, M>
where
    C.Imp == AutographImplementation,
    C.Parameters == AutographExecutionParameters,
    M.Parameters == AutographExecutionParameters {

    public init(implementationComposer: C, inputFoldersProvider: M, help: String) {
        super.init(
            executionParametersReader: AutographExecutionParametersReader(),
            implementationComposer: implementationComposer,
            inputFoldersProvider: inputFoldersProvider,
            fileFinder: AutographFileFinder(),
            fileWriter: AutographFileWriter(),
            help: help
        )
    }
}
