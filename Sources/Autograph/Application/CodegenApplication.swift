//
//  File.swift
//  
//
//  Created by incetro on 12/1/20.
//

import Files
import Synopsis
import Foundation

// MARK: - CodegenApplication

/// General cdegen application class which will be used
/// as an entry point for different codegen tools where
/// it's necessary to customize code generation way
/// (in other cases you should use `AutographApplication` class)
open class CodegenApplication<
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
        fileWriter: W
    ) {
        self.executionParametersReader = executionParametersReader
        self.implementationComposer = implementationComposer
        self.inputFoldersProvider = inputFoldersProvider
        self.fileFinder = fileFinder
        self.fileWriter = fileWriter
        self.commandLineArguments = CommandLine.arguments
    }

    // MARK: - Public

    /// Main code generation method.
    /// Combines all available components to strict algorithm
    /// which will give you necessary code generation
    /// - Returns: error code
    open func run() -> Int32 {

        do {

            let executionParameters = try executionParametersReader.readExecutionParameters(
                fromCommandLineArguments: commandLineArguments
            )

            func verbosePrint(_ string: String) {
                if executionParameters.verbose {
                    print(string)
                }
            }

            if executionParameters.printHelp {
                printHelp()
                return 0
            }

            verbosePrint("Obtaining input folders...")
            let inputFolders = try inputFoldersProvider.inputFoldersList(
                fromParameters: executionParameters
            )
            verbosePrint("Input folders list:\n\(inputFolders.joined(separator: "\n"))")
            verbosePrint("Finding files in input folders...")
            let files = try fileFinder.findFiles(
                inFolders: inputFolders,
                parameters: executionParameters
            )
            verbosePrint("Files list:\n\(files.map(\.absoluteString).joined(separator: "\n"))")

            var resolvingInterpolationContent: [String: String] = [:]
            if executionParameters.resolvingInterpolation {
                try files.forEach { url in
                    verbosePrint("Resolving interpolation for file at: \(url.path)")
                    let file = try File(path: url.path)
                    let content = try file.readAsString()
                    let regex = "[а-яА-Я]+"
                    if content.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil {
                        let resolvedContent = content.removingRegexMatches(pattern: regex)
                        resolvingInterpolationContent[file.path] = content
                        try file.write(resolvedContent)
                    }
                }
            }

            verbosePrint("Running Synopsis through files list...")
            let synopsis = Synopsis(sourceCodeProvider: SourceKittenCodeProvider())
            let specifications = synopsis.specifications(from: files)

            if !resolvingInterpolationContent.isEmpty {
                try resolvingInterpolationContent.forEach { key, value in
                    try File(path: key).write(value)
                }
            }

            if executionParameters.verbose {
                print("Specifications print to Xcode:")
                specifications.result.printToXcode()
                if !specifications.errors.isEmpty {
                    print("Specifications errors")
                    specifications.errors.forEach {
                        print("\($0.file) -> \($0.description)")
                    }
                }
            }

            if executionParameters.ephemeral {
                verbosePrint("Processing ephemeral files...")
                let ephemeralFoldersList = try inputFoldersProvider.ephemeralFoldersList(fromParameters: executionParameters)
                for file in try ephemeralFoldersList.flatMap({ try Folder(path: $0).files }) {
                    verbosePrint("Adding disabling flag to file \(file.name)...")
                    let content = try file.readAsString()
                    let disabler = "// synopsis:disable"
                    if !content.contains(disabler) {
                        var rows = content.components(separatedBy: "\n")
                        var disablerIndex = 0
                        for row in rows {
                            if row.hasPrefix("//") {
                                disablerIndex += 1
                            } else {
                                break
                            }
                        }
                        rows.insert(disabler, at: disablerIndex)
                        let newContent = rows.joined(separator: "\n")
                        try file.write(newContent)
                    }
                }
            }

            verbosePrint("Composing implementations...")
            let implementations = try implementationComposer.compose(
                forSpecifications: specifications.result,
                parameters: executionParameters
            )
            verbosePrint("Implementations successfully composed")

            verbosePrint("Writing implementations to their destinations...")
            try fileWriter.write(
                implementations: implementations,
                parameters: executionParameters
            )
            verbosePrint("Done!")

        } catch let error as CustomStringConvertible {
            print("CodegenApplication error:\n\(error.description)")
            return 1
        } catch {
            print("CodegenApplication error:\n\(error.localizedDescription)")
            return 2
        }

        return 0
    }

    /// Prints current codegen tool help
    open func printHelp() {
        print("""
        Accepted arguments:

        -project_name [name]
        Project name to be used in generated files.
        If not set, "\(AutographConstants.defaultProjectName)" is used as a default project name.

        -verbose
        Application prints additional verbose information: found input files and folders, successfully saved files etc.

        -non_recursive
        This flag means that Autograph won't go through all subfolders to find implementations.
        Search will be made only in the input folder.

        -ephemeral
        This param will add disabling comment to codegen helper.
        It means that after first generation there won't be
        a new generation attempt until you delete the disabling comment
        from your necessary files. Use it when you want to generate your code
        once and maintain it manually after that.

        -resolving_interpolation
        Due to https://github.com/jpsim/SourceKitten/issues/444
        we were needed to add this parameter to temporary solve the issue

        """)
    }
}
