
$firstLocation = Get-Location 
$script:FolderLevels = @('Zero','First','Second','Third','Fourth','Fifth','Sixth','Seventh','Eighth','Nineth')
$script:depth = 3
$script:dtstamp = Get-Date -UFormat %h%M

function script:Loop2{
     
   [CmdletBinding()]
   param
   (
      $l,

      $r
   )
   $FolderLevel = $FolderLevels[$l]
   for($i=1;$i-le $r;$i++){
      New-Item -ItemType Directory -Name ('{0}.{1}.{2}' -f $FolderLevel, $dtstamp, $i)
   }
   $script:dirlist = Get-ChildItem -Directory | Where-Object {$_.name -match $FolderLevel}
   
}

function script:loop1{
    
   [CmdletBinding()]
   param
   (
      $depth
   )
   
   for($i=1;$i -le $depth;$i++){
      if($i -eq 1){
         Loop2 $i $depth
      }
      Else{
         foreach($folder in $dirlist){
            $tempPath = Get-Location 
            $tempPath | Out-File C:\temp\NestedFolders\November10\tempPath.txt -Append
            Set-Location -Path $folder
            Loop2 $i $depth
            Get-ChildItem -Path .\ -Directory | select FullName | Out-File C:\temp\NestedFolders\November10\folders.txt -Append
            Set-Location $tempPath 
         }
      }
   }

   $script:dirlist = Get-ChildItem -Directory | Where-Object {$_.name -match $dtstamp}
}
Set-Location $firstLocation
Loop1 -depth 3






