
#Requires -version 2.0 
 
<#
      this version takes an array of computer names and creates a new
      XLS-Ws for each one.
#>

<#[cmdletbinding()] 
      Param([string[]]$computername = $ervice)
#>
#I hope it goes without saying that Excel needs to be installed

$computername = get-service | select -Property * -First 50
function Add-ColumnHeadings
{
   param
   (
      [Parameter(Mandatory, ValueFromPipeline, HelpMessage='Data to process')]
      $InputObject
   )
   process
   {
      
      $cells.item($row,$col)=$InputObject
      $cells.item($row,$col).font.bold=$True
      $col++
          
   }
} 

Add-Type -AssemblyName Microsoft.Office.Interop.Excel
Write-Verbose -Message 'Creating Excel application'
$xl=New-Object -ComObject 'Excel.Application'
$xl.Visible=$True
$Workbook =$xl.Workbooks.Add()

#we'll need some constants
$xlConditionValues=[Microsoft.Office.Interop.Excel.XLConditionValueTypes]
$xlTheme=[Microsoft.Office.Interop.Excel.XLThemeColor]
$xlChart=[Microsoft.Office.Interop.Excel.XLChartType]
$xlIconSet=[Microsoft.Office.Interop.Excel.XLIconSet]
$xlDirection=[Microsoft.Office.Interop.Excel.XLDirection]

#get disk data
Write-Verbose -Message ('Getting disk data from {0}' -f $computer)
#$disks=Get-WmiObject -Class Win32_LogicalDisk -ComputerName $computer -Filter 'DriveType=3'


Function Create-Worksheets {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true,ValueFromPipeline=$true)][object] $Excel,
        [string[]] $WorkSheets
    )
    ForEach ($Worksheet in $Worksheets) {
        $Script:Excel_Count_Worksheet++
        If ($Excel_Count_Worksheet -gt $Excel.Worksheets.Count) {$Excel.Worksheets.Add([System.Reflection.Missing]::Value, $Excel.Worksheets.Item($Script:Excel.Worksheets.Count)) |Out-Null}
        $Excel.Worksheets.Item($Excel_Count_Worksheet).Name = $Worksheet
    }
    While ($Excel.Worksheets.Count -gt $Script:Excel_Count_Worksheet) {
        $Excel.Worksheets.Item($Excel.Worksheets.Count).Delete()
    }
}


<#Write-Verbose -Message 'Adding Worksheet'
      #$WrkSheet=$Workbook.XLS-Wss.Add()
      Write-Verbose -Message 'Renaming the worksheet'  
      #rename the XLS-Ws
      $wsname ='service'
      $WrkSheet= $workbook.Worksheets.Item(1)
      $WrkSheet.Name = 'service' #$wsname
      #select A1
      $null = $WrkSheet.Range('B3').Select()
#>
#Create-Worksheets 
$cells=$WrkSheet.Cells
 
$cells.item(1,1)='Disk Drive Report'
$cells.

#define some variables to control navigation
$row=3
$col=1

#insert column headings
Write-Verbose -Message 'Adding drive headings'

'Name','Status','Service Type' | Add-ColumnHeadings
<#   Foreach ($computer in $computername) {

      Write-Verbose -Message 'Adding drive data'
      #foreach ($drive in $disks) {
      $row++
      $col=1
      $cells.item($Row,$col)=$computer.name
      $col++
      $cells.item($Row,$col)=$computer.status
      #$cells.item($Row,$col).NumberFormat='0'
      $col++
      $cells.item($Row,$col)=$computer.Servicetype
      $cells.item($Row,$col).NumberFormat='0.00'
      $col++
      $cells.item($Row,$col)=($drive.Size - $drive.Freespace)/1GB
      $cells.item($Row,$col).NumberFormat='0.00'
      $col++
      $cells.item($Row,$col)=($drive.Freespace/$drive.size)
      $cells.item($Row,$col).NumberFormat='0.00%'
      $col++
      $cells.item($Row,$col)=($drive.Size - $drive.Freespace) / $drive.size
$cells.item($Row,$col).NumberFormat='0.00%'#>
#   }
    
Write-Verbose -Message 'Adding some style'

#add some style
$range=$WrkSheet.range('A1')
$range.Style='Title'
#or set it like this
$WrkSheet.Range('A3:F3').Style = 'Heading 2'

#adjust some column widths
Write-Verbose -Message 'Adjusting column widths'
$WrkSheet.columns.item('C:C').columnwidth=15
$WrkSheet.columns.item('D:F').columnwidth=10.5
$null = $WrkSheet.columns.item('B:B').EntireColumn.AutoFit()

#add some conditional formatting
Write-Verbose -Message 'Adding conditional formatting'

#get the starting cell
$start=$WrkSheet.range('F4')
#get the last cell
$Selection=$WrkSheet.Range($start,$start.End($xlDirection::xlDown))
#add the icon set
$null = $Selection.FormatConditions.AddIconSetCondition()
$Selection.FormatConditions.item($($Selection.FormatConditions.Count)).SetFirstPriority()
$Selection.FormatConditions.item(1).ReverseOrder = $True
$Selection.FormatConditions.item(1).ShowIconOnly = $False
$Selection.FormatConditions.item(1).IconSet = $xlIconSet::xl3TrafficLights1
$Selection.FormatConditions.item(1).IconCriteria.Item(2).Type=$xlConditionValues::xlConditionValueNumber
$Selection.FormatConditions.item(1).IconCriteria.Item(2).Value=0.8
$Selection.FormatConditions.item(1).IconCriteria.Item(2).Operator=7
$Selection.FormatConditions.item(1).IconCriteria.Item(3).Type=$xlConditionValues::xlConditionValueNumber
$Selection.FormatConditions.item(1).IconCriteria.Item(3).Value=0.9
$Selection.FormatConditions.item(1).IconCriteria.Item(3).Operator=7
   
<#   #insert a graph
      Write-Verbose -Message 'Creating a graph'
      $chart=$WrkSheet.Shapes.AddChart().Chart
      $chart.chartType=$xlChart::xlBarClustered
    
      $start=$WrkSheet.range('A3')
      #get the last cell
      $Y=$WrkSheet.Range($start,$start.End($xlDirection::xlDown))
      $start=$WrkSheet.range('F3')
      #get the last cell
      $X=$WrkSheet.Range($start,$start.End($xlDirection::xlDown))

      $chartdata=$WrkSheet.Range("A$($Y.item(1).Row):A$($Y.item($Y.count).Row),F$($X.item(1).Row):F$($X.item($X.count).Row)")
      $chart.SetSourceData($chartdata)

      #add labels
      $null = $chart.seriesCollection(1).Select()
      $null = $chart.SeriesCollection(1).ApplyDataLabels()
      #modify the chart title
      $chart.ChartTitle.Text = 'Utilization'
      Write-Verbose -Message 'Repositioning graph'
      $WrkSheet.shapes.item('Chart 1').top=40
$WrkSheet.shapes.item('Chart 1').left=400#>


#} #foreach

#delete extra sheets
Write-Verbose -Message 'Deleting extra worksheets'
#$xl.XLS-Wss.Item('Sheet1').Delete()
#$xl.XLS-Wss.Item('Sheet2').Delete()
#$xl.XLS-Wss.Item('Sheet3').Delete()

#make Excel visible
$xl.Visible=$True

<#
      $filepath=Read-Host -Prompt 'Enter a path and filename to save the file'

      if ($filepath) {
      Write-Verbose -Message ('Saving file to {0}' -f $filepath)
      $Workbook.SaveAs($filepath)
      $xl.displayAlerts=$False
      $Workbook.Close()
      $xl.Quit()
      }
#>
#end of script
 