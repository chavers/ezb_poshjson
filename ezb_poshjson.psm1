
if(!$PSScriptRoot) {
    $PSScriptRoot = $MyInovocation.PSScriptRoot
}
# $Global:moduleroot = $MyInovocation.PSScriptRoot
$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )
if ([Type]::GetType("Newtonsoft.Json.Serialization.CamelCasePropertyNamesContractResolver") -eq $Null) {
    if ($PSVersionTable.PSEdition -eq "Core") {
        [System.Reflection.Assembly]::LoadFile("${PSScriptRoot}\lib\netstandard1.3\Newtonsoft.Json.dll")
    }
    else {
        [System.Reflection.Assembly]::LoadFile("${PSScriptRoot}\lib\net45\Newtonsoft.Json.dll")
    }
}
Foreach($import in @($Public + $Private))
{
    Try
    {
		Write-Verbose "loading:$($import.fullname)" 
        . $import.fullname
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}



Export-ModuleMember -Function $Public.Basename