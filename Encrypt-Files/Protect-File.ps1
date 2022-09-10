function Protect-TextFile
{
  <#
      .SYNOPSIS
      A nice way to secure those desktop notes.
      Encrypts a file using a local "DocumentEncryption" cert.  

      .DESCRIPTION
      This is a quick way to encrypt files that you want to keep secure, but shouldn't be the only copy of the data.  
      This relys on a local cert that could be lost if the computer is reimaged or your profile is deleted.

      .PARAMETER InputFile
      File to be encrypted.  Suggest keeping it simple and use a text (.txt) file.

      .EXAMPLE
      Protect-File -InputFile Value
      Encrypts the file "Value.txt" and renames it to "Value.cqr".

      .NOTES
      Currently None
  #>

  [CmdletBinding(SupportsShouldProcess,ConfirmImpact = 'High')]
  param(
    [Parameter(Mandatory,
        ValueFromPipeline = $true,
        ValueFromPipelineByPropertyName = $true,
    HelpMessage = 'File to encrypt')]
    [Alias('InputFile')]
    [String[]]$Name
  )
  Begin{
    $SecureExt = '.cqr'
    $CertHash = Get-ChildItem -Path Cert:\CurrentUser\My\
    $CertThumb = $CertHash.GetEnumerator().Where({
        $_.Subject -match 'MyDocumentEncryption'
    }).thumbprint

    if(-Not (Test-Path -Path ('Cert:\CurrentUser\My\{0}' -f $CertThumb)))
    {
      New-SelfSignedCertificate -DnsName MyDocumentEncryption -FriendlyName MyDocumentEncryption -CertStoreLocation 'Cert:\CurrentUser\My' -KeyUsage KeyEncipherment, DataEncipherment, KeyAgreement -Type DocumentEncryptionCert
    }
  }
  Process{
    foreach($InputFile in $Name)
    {
      $InputFile = (Get-ItemProperty $InputFile).Name

      $ext = (Get-ItemProperty -Path $InputFile).Extension
      if($ext -ne 'txt')
      {
        Write-Warning -Message ('{0} in not a "txt" file and may not be able to be unencrypted' -f $InputFile)
        $ans = Read-Host -Prompt 'Type "YES" to continue'
        if($ans -ne 'yes')
        {
          Write-Host -Object 'Exiting...' -ForegroundColor Cyan
          Break
        }
      }
      Write-Host -Object ('Encrypting {0}' -f $InputFile) -ForegroundColor Red
      $CqrFile = ($InputFile).Replace($ext,$SecureExt)
      Rename-Item -Path (Get-ItemProperty $InputFile).Name -NewName $CqrFile -Force

      $InputFile = (Get-ItemProperty -Path $CqrFile).FullName
      Get-Content -Path $InputFile | Protect-CmsMessage -To CN=MyDocumentEncryption -OutFile $InputFile
    }
  }
  End{}
}
