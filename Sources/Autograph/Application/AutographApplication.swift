//
//  File.swift
//  
//
//  Created by incetro on 12/1/20.
//

import Synopsis
import Foundation

// MARK: - AutographApplication

open class AutographApplication<
    E: ExecutionParametersReader,
    F: FileFinder,
    W: FileWriter,
    C: ImplementationComposer,
    M: InputFoldersProvider
> where
    E.Parameters == F.Parameters,
    F.Parameters == W.Parameters,
    W.Parameters == C.Parameters,
    C.Parameters == M.Parameters,
    W.Imp == C.Imp {

    // MARK: - Properties

    /// Execution parameters reader instance
    public let executionParametersReader: E

    /// Implementation composer instnace
    public let implementationComposer: C

    /// Input folders provider instance
    public let inputFoldersProvider: M

    /// Files finder instance
    public let fileFinder: F

    /// Files writer instance
    public let fileWriter: W

    /// Current command line arguments
    public let commandLineArguments: [String]

    /// Help info string
    public let help: String

    // MARK: - Initializers

    /// Default initializer
    /// - Parameters:
    ///   - executionParametersReader: execution parameters reader instance
    ///   - implementationComposer: implementation composer instnace
    ///   - inputFoldersProvider: input folders provider instance
    ///   - fileFinder: files finder instance
    ///   - fileWriter: files writer instance
    ///   - help: help info string
    public init(
        executionParametersReader: E,
        implementationComposer: C,
        inputFoldersProvider: M,
        fileFinder: F,
        fileWriter: W,
        help: String
    ) {
        self.executionParametersReader = executionParametersReader
        self.implementationComposer = implementationComposer
        self.inputFoldersProvider = inputFoldersProvider
        self.fileFinder = fileFinder
        self.fileWriter = fileWriter
        self.commandLineArguments = CommandLine.arguments
        self.help = help
    }

    // MARK: - Public

    public func run() -> Int32 {

        do {

            let executionParameters = try executionParametersReader.readExecutionParameters(fromCommandLineArguments: commandLineArguments)

            if executionParameters.printHelp {
                print(help)
                return 0
            }

            let inputFolders = try inputFoldersProvider.inputFoldersList(
                fromParameters: executionParameters
            )
            let files = try fileFinder.findFiles(
                inFolders: inputFolders,
                parameters: executionParameters
            )

            let synopsis = Synopsis(sourceCodeProvider: SourceKittenCodeProvider())
            let specifications = synopsis.specifications(from: files)

            if executionParameters.verbose {
                specifications.errors.forEach {
                    print("\($0.file) -> \($0.description)")
                }
            }

            let implementations = try implementationComposer.compose(
                forSpecifications: specifications.result,
                parameters: executionParameters
            )

            try fileWriter.write(
                implementations: implementations,
                parameters: executionParameters
            )

        } catch {
            print(error)
            return 1
        }

        return 0
    }
}
