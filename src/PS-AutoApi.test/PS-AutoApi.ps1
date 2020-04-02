#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='4.9.0' }

$moduleDir= "$PSScriptRoot\..\PS-AutoApi\"
$module="PS-AutoApi"
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
}
