function Compress-Files7z
{
  <#
      .SYNOPSIS
      Compress files
  #>
  [CmdletBinding(SupportsShouldProcess)]
  
  param
  (
    [Parameter(Position = 0)]
    [string]$Path = '.\',
    [Parameter(Position = 1)]
    [string]$Filter = 'csv',
    [Parameter(Position = 2)]
    [Switch]$Recurse,
    [Parameter(Position = 3)]
    [Switch]$Replace
  )
  
  $Path7z = 'C:\Program Files\7-Zip\7z.exe'
  
  # Assign the information to a splat for easy reading
  $SplatZips = @{
    Path    = $Path 
    Filter  = ('*.{0}' -f $Filter)
    Recurse = $Recurse
  }
  
  # Assign all the csv files to $files
  $files = Get-ChildItem @SplatZips
  
  foreach ($file in $files) 
  {
    # Created file name variables for easy reading, but not neccessary.
    # Created Archive Name, because files with same name would be over written
    $FileName = $file.Name 
    $ArchiveName = ('{0}({1}).zip' -f $($file.BaseName), $(Get-Date -Format yyMMdd))
    
    #SET 7-ZIP ARGUMENTS, CHANGE AS NEEDED
    $FileArgs = @($ArchiveName, $FileName)
    if($Replace)
    {
      $arrArgs = @('a', '-sdel')
    }
    else
    {
      $arrArgs = @('a')
    }
    
    $Splat7z = @{
      FilePath     = $Path7z
      ArgumentList = $arrArgs + $FileArgs
    }
    #RUN 7-ZIP EXE WITH ARGUMENTS
    Start-Process @Splat7z -Wait -NoNewWindow
  }
}

function Expand-FilesZip
{
  <#
      .SYNOPSIS
      Expand Archive
  #>
  [CmdletBinding(SupportsShouldProcess)]
  
  param
  (
    [Parameter(Position = 0)]
    [string]$Path = '.\',
    [Parameter(Mandatory,HelpMessage = 'Date as: 2/12/2022 or 12 Feb 2022', Position = 1)]
    [string]$Date = '2/12/2022',
    [Parameter(Position = 2)]
    [Switch]$Remove
  )
  
  $Path7z = 'C:\Program Files\7-Zip\7z.exe'
  
  $extractPath = $('.\Extracted_Files-{0}' -f (Get-Date -UFormat %j_%H%M%S))
  $null = New-Item -Name $extractPath -ItemType Directory
  Write-Verbose -Message ('Extracted file path is: {0}' -f $extractPath)

  $dateformat = Get-Date -Date $Date -Format 'MM/dd/yyyy'
  Write-Verbose -Message $dateformat

  # Assign all the csv files to $files
  $files = Get-ChildItem -Path $Path -File| Where-Object CreationTime -Match -Value $dateformat

  foreach ($file in $files) 
  {
    # Created file name variables for easy reading, but not neccessary.
    # Created Archive Name, because files with same name would be over written
    $FileName = $file.Name 
    Write-Verbose -Message $FileName

    #SET 7-ZIP ARGUMENTS, CHANGE AS NEEDED
    $FileArgs = @($FileName)
    $arrArgs = @('x', ('-o{0}' -f $extractPath))
    
    
    $Splat7z = @{
      FilePath     = $Path7z
      ArgumentList = $arrArgs + $FileArgs
    }
    #RUN 7-ZIP EXE WITH ARGUMENTS
    Start-Process @Splat7z -Wait -NoNewWindow
    if($Remove)
    {
      Remove-Item -Path $FileName -Force -WhatIf
    }
  }
}

function Compress-PSFile
{
  <#
      .SYNOPSIS
      Compress files individually
  #>
  [CmdletBinding(SupportsShouldProcess)]
  
  param
  (
    [Parameter(Position = 0)]
    [string]$Path = '.\',
    [Parameter(Mandatory,HelpMessage = 'File extension to select LOG, TXT, XLSX', Position = 1)]
    [string]$FileType = 'csv',
    [Parameter(Position = 2)]
    [Switch]$Recurse,
    [Parameter(Position = 3)]
    [Switch]$Replace
  )
  
  # Assign the information to a splat for easy reading
  $SplatGCI = @{
    Path    = $Path 
    Filter  = ('*.{0}' -f $FileType)
    Recurse = $Recurse
  }
  
  # Assign all the csv files to $files
  $files = Get-ChildItem @SplatGCI
  
  foreach ($file in $files) 
  {
    # Created file name variables for easy reading, but not neccessary.
    # Created Archive Name, because files with same name would be over written
    $FileName = $file.fullName 
    $ArchiveName = ('{0}({1}).zip' -f $($file.BaseName), $(Get-Date -Format yyMMdd))
    
    $compress = @{
      Path             = $FileName
      CompressionLevel = 'Fastest'
      DestinationPath  = $ArchiveName
    }
    Compress-Archive @compress
  }
}

function Expand-PSFileArchive
{
  <#
      .SYNOPSIS
      Expand Archive
  #>
  [CmdletBinding(SupportsShouldProcess)]
  param
  (
    [Parameter(Position = 0)]
    [string]$Path = '.\',
    [Parameter(Mandatory,HelpMessage = 'Date as: 2/12/2022 or 12 Feb 2022', Position = 1)]
    [string]$Date = '2/12/2022',
    [Parameter(Position = 2)]
    [Switch]$Remove
  )
  
  $extractPath = $('.\Extracted_Files-{0}' -f (Get-Date -UFormat %j_%H%M%S))
  $null = New-Item -Name $extractPath -ItemType Directory
  Write-Verbose -Message ('Extracted file path is: {0}' -f $extractPath)

  $dateformat = Get-Date -Date $Date -Format 'MM/dd/yyyy'
  Write-Verbose -Message $dateformat

  # Assign all the csv files to $files
  $files = Get-ChildItem -Path $Path -File| Where-Object CreationTime -Match -Value $dateformat

  foreach ($file in $files) 
  {
    # Created file name variables for easy reading, but not neccessary.
    # Created Archive Name, because files with same name would be over written
    $FileName = $file.Name 
    Write-Verbose -Message $FileName

    Expand-Archive -Path $FileName -DestinationPath $extractPath

    if($Remove)
    {
      Remove-Item -Path $FileName -Force -WhatIf
    }
  }
}


Export-ModuleMember -Function Compress-Files7z, Expand-FilesZip, Compress-PSFile, Expand-PSFileArchive


