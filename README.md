![](autograph.png)

## Description

**Autograph** provides instruments for building source code generation utilities (command line applications) on top of the
[Synopsis](https://github.com/Incetro/synopsis) framework.

## Installation
### Swift Package Manager dependency

```swift
.package(
    name: "Autograph",
    url: "https://github.com/Incetro/autograph",
    .branch("main")
)
```

## Usage
### Overview

First of all, in order to build a console executable using Swift there needs to be an execution entry point, a `main.swift` file.

**Autograph** uses a common approach when during the `main.swift` file execution your utility app instantiates a special
«Application» class object and passes control flow to it:

```swift
// main.swift sample code
import Foundation

exit(YourAutographApplication().run())
```

macOS console utilities are expected to return an `Int32` code after their execution, and any code different from `0` should be
treated as an error, thus `AutographApplication` method `run()` returns `Int32`. The method looks pretty much like this:

```swift
// class AutographApplication { ...

func run() -> Int32 {
    do {
        try someDangerousOperation()
        try someOtherDangerousOperation()
        ...
    } catch let error {
        print(error)
        return 1
    }
    return 0
}
```

Considering everything above, the entry point for you is an `AutographApplication` class.

### AutographApplication class

In order to create your own utility you'll need to create your own `main.swift` file following the example above,
and imlpement 2 protocols: `ImplementationComposer` and `InputFoldersProvider`.

You can use this snippet for implementatons composers:

```swift
// MARK: - <#name#>ImplementationComposer

public final class <#name#>ImplementationComposer {
}

// MARK: - ImplementationComposer

extension <#name#>ImplementationComposer: ImplementationComposer {

    public func compose(
        forSpecifications specifications: Specifications,
        parameters: AutographExecutionParameters
    ) throws -> [AutographImplementation] {
        <#your code generation from specifications#>
    }
}
```

And this for input folders providers:

```swift
import Autograph

// MARK: - <#name#>InputFoldersProvider

public final class <#name#>InputFoldersProvider {
}

// MARK: - InputFoldersProvider

extension <#name#>InputFoldersProvider: InputFoldersProvider {

    public func inputFoldersList(fromParameters parameters: AutographExecutionParameters) throws -> [String] {
        <#provide your input folders here#>
    }
}
```

And create `AutographApplication` subclass:

```swift
public final class SomeAutographApplication: AutographApplication<SomeComposer, SomeInputFoldersProvder> {
}
```

`AutographApplication` provides several convenient extension points for you to complete the execution process. When the app
runs, it goes through seven major steps:

##### 1. Gather execution parameters

`AutographApplication` console app supports four arguments by default:

* `-help` — print help;
* `-verbose` — print additional information during execution;
* `-non_recursive` — if we don't need to go through folders recursively;
* `-project_name [name]` — provide project name to be used in generated code; if not set, "ProjectName" is used as a default project name.

All arguments along with current working directory are aggregated in an `ExecutionParameters` protocol:

```swift
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
    /// -non_recursive
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
```

The standard implementation of `ExecutionParameters` is `AutographExecutionParameters`. An `AutographExecutionParameters` instance acts like a dictionary, so that you may query it for your own arguments:

```swift
/// ./MyUtility -verbose -my_argument value
 
let parameters: AutographExecutionParameters = getParameters()
let myArgument: = parameters["-my_argument"] ?? "default_value"
```

Arguments without values are stored in this dictionary with an empty `String` value.

##### 2. Print help

When your app is run with a `-help` argument, the execution is interrupted, and the `AutographApplication.printHelp()` method is called.

It's the first extension point for you. You may extend this method in order to provide your own help message like this:

```swift
override func printHelp() {
    super.printHelp()
    print("""
        -input
        Input folder with model source files.
        If not set, current working directory is used as an input folder.

        -output
        Where to put generated files.
        If not set, current working directory is used as an input folder.


        """)
}
```

Don't forget to leave an empty line after your help message.

##### 3. Provide list of folders with source code files

`AutographApplication` asks `inputFoldersProvider.provideInputFoldersList(fromParameters:)` for a list of input folders.

It's the next major extension point for you. Here, you need to implement a way your utility app determines the list of input folders, whence the app should search for the source code files to be analysed.

You have to implement `InputFoldersProvider` class like this:

```swift
// MARK: - SomeInputFoldersProvider

public final class SomeInputFoldersProvider {
}

// MARK: - InputFoldersProvider

extension SomeInputFoldersProvider: InputFoldersProvider {

    public func inputFoldersList(fromParameters parameters: AutographExecutionParameters) throws -> [String] {
        parameters["-input"] ?? ""
    }
}
```

Such that, you query the `AutographExecutionParameters ` for an `-input` argument, and throw an error (if you want) when there is no necessary parameter.

`AutographApplication` later transforms all relative paths into absolute paths by concatenating with the current working directory,
thus the empty string `""` will result in the working directory as a default input folder.

If you think it's crucial for the execution to have an explicit `-input` argument value, you may throw an exception like this:

```swift
// MARK: - SomeAutographError

public enum SomeAutographError {

    // MARK: - Cases

    /// You haven't specified a path to plain objects
    case noInputFolder
}

// MARK: - LocalizedError

extension SomeAutographError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .noInputFolder:
            return "You haven't specified a path to plain objects"
        }
    }
}
```

##### 4. Find all *.swift files in provided input folders

When the step #3 is complete, `AutographApplication` recursively scans input folders and their subfolders for `*.swift` files.
The result of this operation is a list of `URL` objects, which is then passed to the **Synopsis** framework in the step #5, see below.

There's not much you can do about this process, though there's a `public` property
`AutographApplication.fileFinder`, where you may put your own `FileFinder` subclass instance if you want.

##### 5. Make a Synopsis out of all found source code

Step #5 is pretty straightforward, as it makes a `Synopsis` instance using the list of `URL` entities of source code files found in the
previous step.

Also, it calls `Specifications.printToXcode()` in case your app is running in `-verbose` mode.

You can't extend or override this step.

##### 6. Compose utilities

A `Specifications` instance is passed into the `ImplementationComposer.compose(forSpecifications:parameters:)` method, where you need to generate new source code. At last!

This method returns a list of `Implementation` objects, each one contains the generated source code and a file path, where this
source code needs to be stored:

```swift
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
```

Usually, this composition process is divided into several steps.

First, you'll need to define an output folder path.
Second, you'll need to extract all necessary information out of the obtained `Specifications` entity.
At last, you'll generate the actual source code.

During each step you may throw errors in case if something went wrong. Consider using an `XcodeMessage` errors in case you want
your app to rant over some particular source code.

```swift
// MARK: - SomeImplementationComposer

public final class SomeImplementationComposer {
}

// MARK: - ImplementationComposer

extension SomeImplementationComposer: ImplementationComposer {

    public func compose(
        forSpecifications specifications: Specifications,
        parameters: AutographExecutionParameters
    ) throws -> [AutographImplementation] {
    
        // use current directory as a default output folder:
        let output = parameters["-output"] ?? "."
        
        // make sure everything is annotated properly:
        try synopsis.classes.forEach { (classSpecification: ClassSpecification) in
            guard classSpecification.annotations.contains(annotationName: "model") else {
                throw XcodeMessage(
                    declaration: classSpecification.declaration,
                    message: "[MY GENERATOR] THIS CLASS IS NOT A MODEL"
                )
            }
        }
    
        // my composer may also throw:
        return try MyComposer().composeSourceCode(outOfModels: specifications.classes)
    }
}
```

##### 7. Write down to disk

Finally, your `Implementation` instances are being written to the hard drive.

All necessary output folders are created, if needed. Also, if there's a generated source code file already, and the source code didn't
change — `FileWriter` won't touch it.

Shall you want to adjust this process, there's an `open` calculated property `AutographApplication.fileWriter`, where you may
return your own `FileWriter` subclass instance.


## Authors

incetro, incetro@ya.ru / andrew@incetro.ru

Inspired by [RedMadRobot autograph](https://github.com/RedMadRobot/autograph)