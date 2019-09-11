$EventVwr = Get-EventLog -List
foreach ($Log in $EventVwr) {
($Log.log).Length + " " + $Log.OverflowAction + " " + $Log.MaximumKilobytes
}

# PowerShell testbed.  Example of the -f format output
$EventVwr = Get-EventLog -List
foreach ($Log in $EventVwr) {
#"{0,25} {1,20} {2,8}" -f `
#"{0,-10} {1,-20} {2,18}" -f `
"{0,-30}" -f `
$Log.log, $Log.OverflowAction, $Log.MaximumKilobytes
}



