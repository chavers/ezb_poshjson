function Write-ObjectToNewtonsoftFriendlyValue() {
    Param(
        [Parameter(Position = 0)]
        [Object] $InputObject 
    )
   
    if ($InputObject -eq $null) {
        return $null;
    }
    switch ($InputObject.GetType().Name) {
        string { return [string] $InputObject }
        Array {
            $result = @()
            foreach ($item in $InputObject) {
                $result += Write-ObjectToNewtonsoftFriendlyValue -InputObject $item 
            }
            return $result; 
        }
        hashtable {
            $dictionary = New-Object "System.Collections.Generic.Dictionary[[string],[Object]]"
            foreach ($key in $InputObject.Keys) {
                $value = Write-ObjectToNewtonsoftFriendlyValue -InputObject $InputObject[$key] 
                $dictionary.Add($key, $value)
            }
            return $dictionary 
        }
        psobject {
            $dictionary = New-Object "System.Collections.Generic.Dictionary[[string],[Object]]"
            $InputObject | Get-Member -MemberType Properties | Foreach-Object {
                $name = $_.Name 
                $value = Write-ObjectToNewtonsoftFriendlyValue  -InputObject ($InputObject.$Name)
                $dictionary.Add($name, $value)
            }

            return $dictionary; 
        }
        PSCustomObject {
            $dictionary = New-Object "System.Collections.Generic.Dictionary[[string],[Object]]"
            $InputObject | Get-Member -MemberType Properties | Foreach-Object {
                $name = $_.Name 
                $value = Write-ObjectToNewtonsoftFriendlyValue  -InputObject ($InputObject.$Name)
                $dictionary.Add($name, $value)
            }

            return $dictionary; 
        }
        Default {return $InputObject; }
    }
}