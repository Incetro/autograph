//
//  File.swift
//  
//
//  Created by incetro on 12/2/20.
//

import Foundation

// MARK: - AutographApplication

/// General application class which will be used
/// as an entry point for most of our codegen tools
open class AutographApplication<Composer: ImplementationComposer, InputProvider: InputFoldersProvider>:
    CodegenApplication<
        AutographExecutionParametersReader,
        AutographFileFinder,
        AutographFileWriter,
        Composer,
        InputProvider
    >
where
    Composer.Imp == AutographImplementation,
    Composer.Parameters == AutographExecutionParameters,
    InputProvider.Parameters == AutographExecutionParameters {

    // MARK: - Initializers

    public init() {
        super.init(
            executionParametersReader: AutographExecutionParametersReader(),
            implementationComposer: Composer(),
            inputFoldersProvider: InputProvider(),
            fileFinder: AutographFileFinder(),
            fileWriter: AutographFileWriter()
        )
    }
}
