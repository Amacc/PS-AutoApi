
$Routes = New-Object System.Collections.ArrayList

#Utility Function
Function New-HashtablefromPsobjectProps {
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        $Name,
        [Parameter(ValueFromPipelineByPropertyName)]
        $Value
    )
    begin { $hash = @{} }
    process { $hash.Add($Name,$Value) }
    end { return $hash }
}


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

Function Invoke-Path{ #Deprecating in the future
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [PSCustomObject] $PathParameters,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Resource,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Path
    )
    process{
        Write-Host "Path: $Path"
        Write-Host "Resource: $Resource"
        Write-Host "PathParameters: $PathParameters"
        Write-Host "Routes: $($Routes | out-string)"

        # Using contains for comparison as it will capture cases when its
        #   Prepended with /
        $FoundRoute = $Routes | Where-Object { $Resource.Contains($_.Route) }
        $params = $PathParameters.psobject.Properties |
            New-HashtablefromPsobjectProps
        Write-Host "Found Routes: $FoundRoute"
        return & $FoundRoute.ScriptBlock @params
    }
}

Function Invoke-AutoApiPath {
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [PSCustomObject] $PathParameters,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Resource,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Path
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

        $params = $PathParameters.psobject.Properties |
            New-HashtablefromPsobjectProps

        try{
            $invokeResult = & $FoundRoute.ScriptBlock @params
            return @{
                statusCode = 200;
                body = $invokeResult | Out-String
                headers = @{'Content-Type' = 'text/plain'}
                # 'headers' = @{'Content-Type' = 'application/json'}
            }
            # return & $FoundRoute.ScriptBlock @params
        } catch {
            return @{
                'statusCode' = 500;
                'body' = $_ | Out-String
                'headers' = @{'Content-Type' = 'text/plain'}
            }
        }
    }
}

Export-ModuleMember -Function Invoke-Path, Get-RegisteredRoutes,
    Clear-Routes, Register-Route, Invoke-AutoApiPath
