#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='4.9.0' }
$routes = & "$PSScriptRoot/mocs/routes.ps1"
$mocs = & "$PSScriptRoot/mocs/apigateway.ps1"
$moduleDir= "$PSScriptRoot\..\PS-AutoApi\"
$module="PS-AutoApi"

Import-Module .\src\PS-AutoApi\PS-AutoApi.psd1

Describe $module {
    Context 'Module Setup' {
        It "has the root module $module.psm1" {
            "$moduleDir\$module.psm1" | Should -Exist
        }
        It "has the a manifest file of $module.psd1" {
            "$moduleDir\$module.psd1" | Should -Exist
            "$moduleDir\$module.psd1" | Should -FileContentMatch "$module.psm1"
        }
    }
    Context "When a POST request comes in" {
        $routes.PostHandler | Register-Route
        It "Passes Body to the Scriptblock" {
            $response = $mocs.SlackChallenge | Invoke-Path
            $response | Should -Be $mocs.SlackChallenge.body.challenge
        }
        Clear-Routes
    }
}
