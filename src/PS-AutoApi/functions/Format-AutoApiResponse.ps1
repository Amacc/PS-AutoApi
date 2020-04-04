Function Format-AutoApiResponse {
    [CmdletBinding()]param(
        [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
        $InputObject,
        [switch] $FormatJson,
        [switch] $FormatXML,
        [int]$StatusCode = 200
    )
    Write-Verbose "Input $InputObject"
    $body, $contentType = $(switch ($true) {
        { $FormatJson } {
            $( $InputObject | ConvertTo-Json -Compress),
            "application/json"
        }
        { $FormatXML } {
            $($InputObject | ConvertTo-Xml -As String -NoTypeInformation),
            "application/xml"
        }
        Default { $($InputObject | Out-String), $contentType }
    })
    return @{
        'statusCode' = $StatusCode;
        'body' = $body
        'headers' = @{'Content-Type' = $contentType}
    }
}

Export-ModuleMember -Function Format-AutoApiResponse
