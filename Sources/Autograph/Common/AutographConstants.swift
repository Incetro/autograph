//
//  File.swift
//  
//
//  Created by incetro on 12/1/20.
//

import Foundation

// MARK: - AutographConstants

/// General constants class
public enum AutographConstants {

    /// Default ptoject name constant
    public static let defaultProjectName = "ProjectName"

    /// `Help` info
    public static let help = """
        Accepted arguments:

        -project_name [name]
        Project name to be used in generated files.
        If not set, "GEN" is used as a default project name.

        -verbose
        Application prints additional verbose information: found input files and folders, successfully saved files etc.

        -recursive
        Application will go through all nested folders in the input folder path
    """
}
