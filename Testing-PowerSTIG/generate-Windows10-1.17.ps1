configuration Example
{
    param
    (
        [parameter()]
        [string]
        $NodeName = 'localhost'
    )

    Import-DscResource -ModuleName PowerStig

    Node $NodeName
    {
        WindowsClient BaseLine
        {
            OsVersion   = '10'
            StigVersion = '1.17'
            DomainName  = 'sample.test'
            ForestName  = 'sample.test'
            
        }
    }
}

Example -OutputPath 'C:\Users\Erik.Arnesen\Documents\GitHub\PS-Scripts\Testing-PowerSTIG'