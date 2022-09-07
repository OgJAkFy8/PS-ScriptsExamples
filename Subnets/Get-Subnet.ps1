function Show-Subnet 
{
  <#
      .SYNOPSIS
      Provides a quick reference for subnet information.

      .DESCRIPTION
      Returns the CIDR, Subnet, Total Address and Class based on parameters selected.

      .PARAMETER Filter
      How you want to filter the output either CIDR,Subnet or Class .

      .PARAMETER Value
      Describe parameter -Value.

      .EXAMPLE
      Show-Subnet
      Default returns all of the information
      
      .EXAMPLE
      Show-Subnet -Filter CIDR -Value 20
      
      Class B
      CIDR  Subnet          Total Addresses 
      /16   255.255.0.0     65,534          
      /17   255.255.128.0   32,766          
      /18   255.255.192.0   16,382          
      /19   255.255.224.0   8,190           
      *** /20   255.255.240.0   4,094 ***          
      /21   255.255.248.0   2,046           
      /22   255.255.252.0   1,022           
      /23   255.255.254.0   510  
      

      .LINK
      URLs to related sites
      The first link is opened by Get-Help -Online Show-Subnet
  #>

  [CmdletBinding(DefaultParametersetName = 'None')]
  param(    
    [Parameter(ParametersetName = 'one',HelpMessage = 'Mandatory if using Value',Mandatory = $true,Position = 0)]
    [ValidateSet('Class','CIDR','Subnet')]
    [String]$Filter,
    [Parameter(ParametersetName = 'one',HelpMessage = 'Mandatory if using Filter',Mandatory = $true,Position = 1)]
    [String]$Value
  )

  function Select-ClassList
  {
    <#
        .SYNOPSIS
        Help filter for Switch
    #>
    param
    (
      [Parameter(Mandatory, ValueFromPipeline, HelpMessage = 'Data to filter')]
      [Object]$InputObject,
      [AllowNull()]
      [Parameter(Mandatory,HelpMessage = 'From main body Value')]
      [String]$Value
    )
    process
    {
      if ($InputObject.Class -eq $Value)
      {
        $InputObject
      }
    }
  }

  $Column23 = '{0,-16}'
  $Column1 = '/{0,-5}'
  $sc = $null
  $OutputHighlightColor = @{
    BackgroundColor = 'DarkGreen'
  }
  
  $SubnetJson = '
    [
    {
    "Class":  "A",
    "CIDR":  "8",
    "Subnet":  "255.0.0.0",
    "TotalAddresses":  "16,777,214"
    },
    {
    "Class":  "A",
    "CIDR":  "9",
    "Subnet":  "255.128.0.0",
    "TotalAddresses":  "8,388,606"
    },
    {
    "Class":  "A",
    "CIDR":  "10",
    "Subnet":  "255.192.0.0",
    "TotalAddresses":  "4,194,302"
    },
    {
    "Class":  "A",
    "CIDR":  "11",
    "Subnet":  "255.224.0.0",
    "TotalAddresses":  "2,097,150"
    },
    {
    "Class":  "A",
    "CIDR":  "12",
    "Subnet":  "255.240.0.0",
    "TotalAddresses":  "1,048,574"
    },
    {
    "Class":  "A",
    "CIDR":  "13",
    "Subnet":  "255.248.0.0",
    "TotalAddresses":  "524,286"
    },
    {
    "Class":  "A",
    "CIDR":  "14",
    "Subnet":  "255.252.0.0",
    "TotalAddresses":  "262,142"
    },
    {
    "Class":  "A",
    "CIDR":  "15",
    "Subnet":  "255.254.0.0",
    "TotalAddresses":  "131,070"
    },
    {
    "Class":  "B",
    "CIDR":  "16",
    "Subnet":  "255.255.0.0",
    "TotalAddresses":  "65,534"
    },
    {
    "Class":  "B",
    "CIDR":  "17",
    "Subnet":  "255.255.128.0",
    "TotalAddresses":  "32,766"
    },
    {
    "Class":  "B",
    "CIDR":  "18",
    "Subnet":  "255.255.192.0",
    "TotalAddresses":  "16,382"
    },
    {
    "Class":  "B",
    "CIDR":  "19",
    "Subnet":  "255.255.224.0",
    "TotalAddresses":  "8,190"
    },
    {
    "Class":  "B",
    "CIDR":  "20",
    "Subnet":  "255.255.240.0",
    "TotalAddresses":  "4,094"
    },
    {
    "Class":  "B",
    "CIDR":  "21",
    "Subnet":  "255.255.248.0",
    "TotalAddresses":  "2,046"
    },
    {
    "Class":  "B",
    "CIDR":  "22",
    "Subnet":  "255.255.252.0",
    "TotalAddresses":  "1,022"
    },
    {
    "Class":  "B",
    "CIDR":  "23",
    "Subnet":  "255.255.254.0",
    "TotalAddresses":  "510"
    },
    {
    "Class":  "C",
    "CIDR":  "24",
    "Subnet":  "255.255.255.0",
    "TotalAddresses":  "254"
    },
    {
    "Class":  "C",
    "CIDR":  "25",
    "Subnet":  "255.255.255.128",
    "TotalAddresses":  "126"
    },
    {
    "Class":  "C",
    "CIDR":  "26",
    "Subnet":  "255.255.255.192",
    "TotalAddresses":  "62"
    },
    {
    "Class":  "C",
    "CIDR":  "27",
    "Subnet":  "255.255.255.224",
    "TotalAddresses":  "30"
    },
    {
    "Class":  "C",
    "CIDR":  "28",
    "Subnet":  "255.255.255.240",
    "TotalAddresses":  "14"
    },
    {
    "Class":  "C",
    "CIDR":  "29",
    "Subnet":  "255.255.255.248",
    "TotalAddresses":  "6"
    },
    {
    "Class":  "C",
    "CIDR":  "30",
    "Subnet":  "255.255.255.252",
    "TotalAddresses":  "2"
    },
    {
    "Class":  "C",
    "CIDR":  "31",
    "Subnet":  "255.255.255.254",
    "TotalAddresses":  "0"
    },
    {
    "Class":  "C",
    "CIDR":  "32",
    "Subnet":  "255.255.255.255",
    "TotalAddresses":  "0"
    }
    ]
  '
  
  $subnetList = $SubnetJson | ConvertFrom-Json
  
  Switch ($Filter) {
    Class
    {
      $list = $subnetList | Where-Object -FilterScript {
        $_.Class -eq $Value
      }
    }
    CIDR
    {
      $list = $subnetList | Select-ClassList -Value ($subnetList | Where-Object -FilterScript {
          $_.cidr -eq $Value
      }).class
    }
    Subnet
    {
      $list = $subnetList | Select-ClassList -Value ($subnetList | Where-Object -FilterScript {
          $_.Subnet -eq $Value
      }).class
    }
    Default 
    {
      $list = $subnetList
    }
  }
  
  foreach($SubnetRcd in $list)
  {
    $cc = $SubnetRcd.class 
    if($sc -ne $cc)
    {
      Write-Host -Object "`n"
      Write-Host -Object ('{0,16} {1}' -f 'Class', $cc) -ForegroundColor Green
      Write-Host -Object ('{0,-6}{1,-16}{2,-16}' -f 'CIDR', 'Subnet', 'Total Addresses' ) -ForegroundColor White
      $sc = $cc
    }
    if(($SubnetRcd.$Filter -eq $Value) -and ($Filter -ne 'Class'))
    {
      Write-Host -Object ($Column1 -f $SubnetRcd.CIDR) -NoNewline @OutputHighlightColor
      Write-Host -Object ($Column23 -f $SubnetRcd.Subnet) -NoNewline @OutputHighlightColor
      Write-Host -Object ($Column23 -f $SubnetRcd.TotalAddresses) @OutputHighlightColor
    }
    Else
    {
      Write-Host -Object ($Column1 -f $SubnetRcd.CIDR) -NoNewline 
      Write-Host -Object ($Column23 -f $SubnetRcd.Subnet) -NoNewline 
      Write-Host -Object ($Column23 -f $SubnetRcd.TotalAddresses)
    }
  }
}
