
$Routes = New-Object System.Collections.ArrayList

Function Register-Route {
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        $Route,
        [Parameter(ValueFromPipelineByPropertyName)]
        $ScriptBlock
    )
    process{
        if($Route.StartsWith("/")) {
            $Route = $Route.Substring(1)
        }
        $Routes.Add($_) | Out-Null
    }
}

Function Clear-Routes {
    $Routes.clear()
}

Function Get-RegisteredRoutes {
    return $Routes
}

Function Invoke-Path{
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Resource,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Path
    )
    process{
        Write-Host "Path: $Path"
        Write-Host "Resource: $Resource"
        Write-Host "Routes: $($Routes | out-string)"
        $FoundRoute = $Routes | Where-Object { $_.Route -eq $Resource }
        Write-Host "Found Routes: $($Routes | out-string)"
        $tokens = $path -split "/"
        switch($tokens[0])
        {
            'add' { [double]$tokens[1]  + [double]$tokens[2]}
            'sub' { [double]$tokens[1]  - [double]$tokens[2]}
            'mul' { [double]$tokens[1]  * [double]$tokens[2]}
            'div' { [double]$tokens[1]  / [double]$tokens[2]}
        }
    }
}

Export-ModuleMember -Function Invoke-Path, Get-RegisteredRoutes,
    Clear-Routes, Register-Route
