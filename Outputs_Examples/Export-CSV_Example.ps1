#[Threading.Thread]::CurrentThread.CurrentCulture = 'en-US'
[CmdletBinding()]


$FilePath = "$env:HOMEDRIVE\temp\test-switch.csv"
$Boundaries = Import-Csv -Path $FilePath
<#
CSV format:
Displayname,BoundaryType,Value
Switch01,0,1
#>


foreach($Item in $Boundaries)
{
	Write-Debug "Item - $Item"
	Write-Verbose "Passing to Switch $item.'BoundaryType'"
	Switch($item.BoundaryType)
	{
		0 {$Type = 'IP Subnet'}
		1 {$Type = 'Active Directory Site'}
		2 {$Type = 'IPv6'}
		3 {$Type = 'Ip Address Range'}
	}

	# Build the Hash table.  Use the Key name to display the value. ex $Arguent.boundaryteyp
	$Arguments = @{'Display Name' = $Item.DisplayName; BoundaryType = $Type; Value = $Item.Value}

	Write-Information $Arguments.'Display Name'
	Write-Information $Arguments.BoundaryType
	Write-Information $Arguments.Value
}
Write-Debug $Arguments.Values
Write-Debug $Arguments.Keys
