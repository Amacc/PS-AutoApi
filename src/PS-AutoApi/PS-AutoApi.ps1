
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
    [cmdletbinding()] param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [PSCustomObject] $PathParameters,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Resource,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Path,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $HttpMethod
    )
    process{
        Write-Verbose "Path: $Path"
        Write-Verbose "Resource: $Resource"
        Write-Verbose "PathParameters: $PathParameters"
        Write-Verbose "Routes: $($Routes | out-string)"

        # Using contains for comparison as it will capture cases when its
        #   Prepended with /
        $FoundRoute = $Routes |
            Where-Object { $Resource.Contains($_.Route) } |
            Where-Object { $HttpMethod -eq $_.Method }

        if($PathParameters){
            $params = $PathParameters.psobject.Properties |
                New-HashtablefromPsobjectProps
        } else {$params = @{}}

        Write-Host "Found Routes: $FoundRoute"
        if($FoundRoute){
            return & $FoundRoute.ScriptBlock @params
        } else {
            return "Not Found" | Format-AutoApiResponse -StatusCode 404
        }
    }
}

Function Invoke-AutoApiPath {
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [PSCustomObject] $PathParameters,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Resource,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Path,
        [switch] $EnableFacebookLogin,
        [switch] $EnableCognitonLogin
    )
    begin{
        if($EnableCognitonLogin){
            Write-Host "Checking login:"
            [PSCustomObject]@{
                Route ="login"; Name="login";
                ScriptBlock= {
                    Write-Host "Hit login Callback"
                }
            } | Register-Path
        }
    }
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
            if($params.Count -gt 0){
                $invokeResult = & $FoundRoute.ScriptBlock @params
            }else {
                $invokeResult = & $FoundRoute.ScriptBlock
            }
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
