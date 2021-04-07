$m = @'

### Kill the process that the user selects
$Process = Get-Process | 
Out-GridView -Title 'Please select a process to kill' -OutputMode Single;
Stop-Process -InputObject $Process;

### Kill multiple processes that the user selects
$ProcessList = Get-Process | 
Out-GridView -Title 'Please select a process to kill' -OutputMode Multiple;
Stop-Process -InputObject $ProcessList;

### Prompt the user to abort or retry some operation, using custom input values
do {
    $Result = @('Abort', 'Retry') | 
    Out-GridView -Title 'Which action should be performed?' -OutputMode Single;
} while ($Result -eq 'Retry');
  
'@
New-IseSnippet -Text $m -Title 'ks: Select-UsingGridview' -Description 'Outputs a list to grid-view, for the user to select one or more items.  Easier than typing.' -Author 'Knarr Studio'

