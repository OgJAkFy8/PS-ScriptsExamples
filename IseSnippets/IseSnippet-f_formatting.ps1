
$m = @'

# Pad integers with zeros
"{0:00000}" -f 181 

# "C" represents currency
"{0:C2}" -f 181 

# "F" letter allows to set how many decimal symbols to show
"{0:F2}" -f 1.8292

# ":x or :X" represents Hexa Decimal
"{0:x}" -f 909887

# "#" Digit Place Holder
"{0:###-##-##}" -f 8976203

# "," Thousand separator
"{0:#,#}" -f 100980243

# dates - see below
"{0:dddd}" -f (get-date)

# Format "2 decimal" places.
$Big32 = Get-ChildItem .\ -recurse | Sort-Object length -descending | select-object -first 32 | measure-object -property length –sum
$DfsrQuota = $Big32.sum /1MB
('The recommended Quota size is {0:n2} MB' -f $DfsrQuota)

# Format Padding / Columns
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


****
The syntax for -F format operator is
{<index>[,<alignment>][:<formatString>]}

Format Strings ...... Description
C ...... Currency
X ...... Display Number in Hexa Decimal
p ...... Display Number as Percentage
n ...... Display with width n to left side
-n ...... Display with width -n to right side
dn ...... Display Numbers Padded by 0 by n times
# ...... Digit placeholder
, ...... Thousand separator
\ ...... Escape Character
:ddd ...... Day of Week
:dd ...... Day of Month
:dddd ...... Full name of Day of Week
:hh ...... Hour
:HH ...... Hour in 24 Hour format
:mm ...... Minutes
:SS ...... Seconds
:MM ...... Month in Number
:MMMM ...... Name of the Month
:yy ...... Year in short
:yyyy ...... Full year
#>

'@
New-IseSnippet -Text $m -Title 'ks: Format -f Operator' -Description 'Output format with -f operator' -Author 'Knarr Studio' 


