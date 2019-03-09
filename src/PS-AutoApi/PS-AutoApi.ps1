
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
        [string]$Path
    )
    process{
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
