function Write-ObjectToNewtonsoftFriendlyValue() {
    Param(
        [Parameter(Position = 0)]
        $InputObject 
    )
   #[Object] $InputObject 

   if ($InputObject -eq $null) {
        return $null;
    }
    if($InputObject -is [Array]) {
		Write-Verbose "is Array"
	    $result =  @()
	    foreach($item in $InputObject) {
	        $result += Write-ObjectToNewtonsoftFriendlyValue -InputObject $item 
	    }
	    return $result;
    } 

    if($InputObject -is [hashtable]) {
       Write-Verbose "is hashtable"
        #$dictionary = New-Object "System.Collections.Generic.Dictionary[[string],[Object]]"
		$dictionary = @{}
        foreach($key in $InputObject.Keys) {
            $value = Write-ObjectToNewtonsoftFriendlyValue -InputObject $InputObject[$key] 
            $dictionary.Add($key, $value)
        }
        return $dictionary
    }

    if($InputObject -is [psobject]) {
       Write-Verbose "is psobject"
        #$dictionary = New-Object "System.Collections.Generic.Dictionary[[string],[Object]]"
		$dictionary = @{}
         $InputObject | Get-Member -MemberType Properties | Foreach-Object {
            $name = $_.Name 
            $value = Write-ObjectToNewtonsoftFriendlyValue  -InputObject ($InputObject.$name)
            $dictionary.Add($name, $value)
         }

         return $dictionary;
    }

    return $InputObject;
	
}
