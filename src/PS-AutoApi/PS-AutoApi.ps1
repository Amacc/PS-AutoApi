
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
        $Routes.Add($_) | Out-Null
    }
}

Function Clear-Routes {
    $Routes.clear()
}

Function Get-RegisteredRoutes {
    return $Routes
}

Function Invoke-AutoApiPath{
    [cmdletbinding()] param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [PSCustomObject] $PathParameters,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Resource,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $Path,
        [Parameter(ValueFromPipelineByPropertyName)]
        [string] $HttpMethod,
        [Parameter(ValueFromPipelineByPropertyName)]
        $Body,
        [Parameter(ValueFromPipeline)]
        $InputObject
    )
    # TODO Integrate Auth Endpoint
    # begin{
    #     if($EnableCognitonLogin){
    #         Write-Host "Checking login:"
    #         [PSCustomObject]@{
    #             Route ="login"; Name="login";
    #             ScriptBlock= {
    #                 Write-Host "Hit login Callback"
    #             }
    #         } | Register-Path
    #     }
    # }
    process{
        Write-Verbose "Path: $Path"
        Write-Verbose "Resource: $Resource"

        # Using contains for comparison as it will capture cases when its
        #   Prepended with /
        $FoundRoute = $Routes |
            Where-Object { $Resource -eq $_.Route } |
            Where-Object { $HttpMethod -eq $_.Method }

        $params = $InputObject.psobject.Properties |
            New-HashtablefromPsobjectProps

        Write-Verbose "Found Routes: $FoundRoute"
        Write-Verbose "Params: $($Params|out-string)"

        if($FoundRoute){
            return & $FoundRoute.ScriptBlock @params
        } else {
            return "Not Found" | Format-AutoApiResponse -StatusCode 404
        }
    }
}

New-Alias Invoke-Path Invoke-AutoApiPath

Export-ModuleMember -Alias Invoke-Path -Function Get-RegisteredRoutes,
    Clear-Routes, Register-Route, Invoke-AutoApiPath
