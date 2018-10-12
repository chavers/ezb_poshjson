
function ConvertTo-EzbJson() {
    <#
    .SYNOPSIS
    Converts the PsObject, Array, or Hashtable into a json string.

    .DESCRIPTION
    An alternate ConvertTo-Json method that outputs readable json unlike
    the native version for Powershell 5 and below. 

    .PARAMETER InputObject
    The Array, PsObject, or Hashtable object that should be serialized to json

    .EXAMPLE
    $jsonText = @("One", "Two") 
    ConvertTo-EzbJson $jsonText
#>
    Param(
        [Parameter(Position = 0, Mandatory = $true )]
        $InputObject
    )

    $Settings = New-Object  "Newtonsoft.Json.JsonSerializerSettings"
    $Settings.ContractResolver = New-Object "Newtonsoft.Json.Serialization.CamelCasePropertyNamesContractResolver"
    $settings.Converters.Add($(New-Object "Newtonsoft.Json.Converters.StringEnumConverter"))

    $obj = Write-ObjectToNewtonsoftFriendlyValue -InputObject $InputObject
    return [Newtonsoft.Json.JsonConvert]::SerializeObject($obj, 0, $Settings)
}
