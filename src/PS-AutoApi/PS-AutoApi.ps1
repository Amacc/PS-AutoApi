
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
        [string]$PathParameters,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Resource,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Path
    )
    process{
        Write-Host "Path: $Path"
        Write-Host "Resource: $Resource"
        Write-Host "PathParameters: $PathParameters"
        Write-Host "Routes: $($Routes | out-string)"
        
        # Using contains for comparison as it will capture cases when its
        #   Prepended with /
        $FoundRoute = $Routes | Where-Object { $Resource.Contains($_.Route) }
        
        Write-Host "Found Routes: $FoundRoute"
        $params = $PathParameters | ConvertFrom-Json
        return & $FoundRoute.ScriptBlock @params
        
    }
}

Export-ModuleMember -Function Invoke-Path, Get-RegisteredRoutes,
    Clear-Routes, Register-Route
