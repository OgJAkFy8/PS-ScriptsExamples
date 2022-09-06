
 Configuration CopyDSCResource {
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String[]]$NodeName,
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$SourcePath,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$ModulePath = "$PSHOME\modules\PSDesiredStateConfiguration\PSProviders"
    )
Import-DscResource -ModuleName 'PSDesiredStateConfiguration'

    Node $NodeName {
        

	File FindText  
	{
		DestinationPath           = "C:\Users\erika\Documents\DSC_Test\Find-Text.pyw"
		Force                     = $true
		MatchSource               = $true
		SourcePath                = $SourcePath
		Type                      = "File"
	}

    }
}

CopyDSCResource -NodeName localhost -SourcePath "C:\Users\erika\Documents\GitHub\feathered-boa\Find-TextInFile\List-TextInFile-GUI.pyw"
