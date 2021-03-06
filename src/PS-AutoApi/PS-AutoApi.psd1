#
# Module manifest for module 'PS-AutoApi'
#
# Generated by: Adam Mcchesney
#
# Generated on: 3/9/2019
#

@{
# Script module or binary module file associated with this manifest.
RootModule = 'PS-AutoApi.psm1'

# Version number of this module.
ModuleVersion = '2.0.1'

# ID used to uniquely identify this module
GUID = '4d9b55a5-4738-4e3c-a300-06a64d3c518e'

# Author of this module
Author = 'Adam Mcchesney'

# Company or vendor of this module
CompanyName = 'Unknown'

# Copyright statement for this module
Copyright = '(c) 2019 Adam Mcchesney. All rights reserved.'

# Description of the functionality provided by this module
Description = 'powershell micro api framework'

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @(
    "Get-RegisteredRoutes",
    "Clear-Routes",
    "Register-Route",
    "Invoke-AutoApiPath",

    "Format-AutoApiResponse",
    "New-AutoApiServerlessFile"
)

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @("Invoke-Path")

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{
    PSData = @{
        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @("aws", "api-gateway", "lambda")

        # A URL to the license for this module.
        # LicenseUri = 'https://github.com/Amacc/AutoApi/blob/master/LICENSE'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/Amacc/PS-AutoApi/'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        # ReleaseNotes = ''
    } # End of PSData hashtable
} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''
}

