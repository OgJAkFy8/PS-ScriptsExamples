$m = @'
<#
A column for the 1st item of 4 characters, left-aligned and adds a space
A column for the 2nd item of 20 characters left-aligned and adds a space
A column for the 3rd item of 20 characters right-aligned.
#>

$Item1 = @{Item = 1}
$Item2 = 'Left Aligned'
$Item3 = 'Right Aligned'

('{0,-4}:{1,-20}:{2,20}' -f $Item1.Item, $Item2, $Item3)
'@
New-IseSnippet -Text $m -Title 'Format -f Operator' -Description 'Output format with -f operator' -Author 'Knarr Studio'


