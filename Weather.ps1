#requires -Version 2

function Get-Airport
{
    param($Country, $City='*')

    $webservice = New-WebServiceProxy -Uri 'http://www.webservicex.net/globalweather.asmx?WSDL' 
    $data = [xml]$webservice.GetCitiesByCountry($Country)
    $data.NewDataSet.Table |
      Where-Object { $_.City -like "*$City*" }

}

function Get-Weather
{
    param($City, $Country='Germany')

    $webservice = New-WebServiceProxy -Uri 'http://www.webservicex.net/globalweather.asmx?WSDL'
    $data = [xml]$webservice.GetWeather($City, $Country)
    $data.CurrentWeather
}