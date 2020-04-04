Function New-AutoApiServerlessFile{
    param(
        [string] $EntryPoint = "./src/main.ps1",
        $PackageManifest = $(Get-Content -raw package.json | ConvertFrom-Json),
        $OutputFile = "build/serverless.yml"
    )
    Clear-Routes
    Write-Verbose "Importing Routes"
    . $EntryPoint | Out-Null

    $templateParameters = @{
        Routes= Get-RegisteredRoutes
        Package=$PackageManifest
    }

    $template = "$PSScriptRoot\..\templates\serverless-template.yml"
    return $templateParameters |
        ConvertTo-Json |
        j2 --format=json $template
        # j2 --format=json $template -o $OutputFile
}

Export-ModuleMember -Function New-AutoApiServerlessFile
