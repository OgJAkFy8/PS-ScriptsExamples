# Archives each file. 

# Assign the information to a splat for easy editing
$SplatZips = @{
  Path    = '.\' #\\NAS\Share'
  Filter  = '*.csv'
  Recurse = $false  #$true
}

# Assign the first 100 csv files to $files
$files = Get-ChildItem @SplatZips | Select-Object -First 100 

foreach ($file in $files) 
{
  #Only compress if greater then 2k in size
  if($file.Length -gt 2000)
  {
    # Created file name variables for easy reading, but not neccessary.
    $FileName = $file.Name 
  
    # Created Archive Name with date, so that if run tomorrow, the files with the same name will not be over written
    $ArchiveName = ('{0}({1}).zip' -f $($file.BaseName), $(Get-Date -Format yyMMdd-mm))

    #SET 7-ZIP ARGUMENTS, CHANGE AS NEEDED
    $FileArgs = @($ArchiveName, $FileName)
    $arrArgs = @('a')

    $Splat7z = @{
      FilePath     = 'C:\Program Files\7-Zip\7z.exe'
      ArgumentList = $arrArgs + $FileArgs
    }
    #RUN 7-ZIP EXE WITH ARGUMENTS
    Start-Process @Splat7z -Wait -NoNewWindow
  }
}

# Same as above in a single line
Gci *.csv | %{ if($_.Length -gt 2000) { & 'C:\Program Files\7-Zip\7z.exe' a $($_.BaseName+"($(Get-Date -Format yyMMdd-mm)).zip") $($_.Name)} }

