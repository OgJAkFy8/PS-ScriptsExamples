$EventVwr = Get-EventLog -List
foreach ($Log in $EventVwr) {
($Log.log).Length + " " + $Log.OverflowAction + " " + $Log.MaximumKilobytes
}

# PowerShell testbed.  Example of the -f format output
$EventVwr = Get-EventLog -List
foreach ($Log in $EventVwr) {
"{0,-25} {1,-20} {2,8}" -f `
#"{0,-10} {1,-20} {2,18}" -f `
#"{0,-30}" -f `
$Log.log, $Log.OverflowAction, $Log.MaximumKilobytes
}

<#
{0,10} would create a column for the 1st item 10 characters wide and would right-align the contents because the 10 is positive.

{2,-20} would create a column for the 3rd item 20 characters wide and would left-align the contents because the 20 is negative.
“{0,28} {1, 20} {2,-8}” -f ` creates:

A column for the 1st item of 28 characters, right-aligned and adds a space
A column for the 2nd item of 20 characters right-aligned and adds a space
A column for the 3rd item of 8 characters left-aligned.
#>
