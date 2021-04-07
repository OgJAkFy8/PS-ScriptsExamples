Function Compare-FileHash {
<#
    .Synopsis
        Generates a file hash and compares against a known hash
    .Description
        Generates a file hash and compares against a known hash.
    .Parameter File
        Mandatory. File name to generate hash. Example file.txt
    .Parameter Hash
        Mandatory. Known hash. Example 186F55AC6F4D2B60F8TB6B5485080A345ABA6F82
    .Parameter Algorithm
        Mandatory. Algorithm to use when generating the hash. Example SHA1
    .Notes
        Version: 1.0
        History:
    .Example
        Compare-FileHash -File file.txt -Hash  186F5AC26F4E9B12F861485485080A30BABA6F82 -Algorithm SHA1
#>
Param(
    [Parameter(Mandatory=$true)]
    [string] $fileName
,
    [Parameter(Mandatory=$true)]
    [string] $originalhash
,
    [Parameter(Mandatory=$true)]
    [ValidateSet("SHA1","SHA256","SHA384","SHA512","MD5")]
    [string] $algorithm
)
$fileHash = Get-FileHash -Algorithm $algorithm $fileName | ForEach { $_.Hash} |  Out-String
$filehash = $fileHash.Trim()
If ($fileHash -eq $originalHash) {
    Write-Host "File = " $fileName
    Write-Host "Algorithm = " + $algorithm
    Write-Host "Original hash = " $originalHash
    Write-Host "Current hash = " $fileHash
    Write-Host "Matches"
}
else {
    Write-Host "File = " $fileName
    Write-Host "Algorithm = " $algorithm
    Write-Host "Original hash = " $originalHash
    Write-Host "Current hash = " $fileHash
    Write-Host "Doesn't match"
}
}