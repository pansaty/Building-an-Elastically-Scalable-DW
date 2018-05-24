$dataLakeStoreName = "pankajcsa"
$DLAnalyticsName = "pankajcsa"
$DLAnalyticsDoP = 2
$SourceFolder = "/DataFiles/NYTaxi/Raw/TaxiData/fhv/" 
$DestFolder = "/DataFiles/NYTaxi/Prepared/TaxiData/fhv/" 

# Login Items
#You need to first setup Service-to-service auth by following these instructions:
##https://docs.microsoft.com/en-us/azure/data-lake-store/data-lake-store-service-to-service-authenticate-using-active-directory
$tenantID = "<Your Tenant ID>"
$AuthKey = "<AUTH Key for your application>"
$AppId = "<App ID>" 

# Login an select subscription
$secpasswd = ConvertTo-SecureString $AuthKey -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential ($AppId, $secpasswd)
Login-AzureRmAccount -ServicePrincipal -Tenant $tenantID  -Credential $mycreds

# Get files to Process
$Years = Get-AzureRmDataLakeStoreChildItem -Account $dataLakeStoreName -Path $SourceFolder | ?{$_.Type -eq "DIRECTORY"} | Select Name

#Source Logic: https://stackoverflow.com/questions/42635439/u-sql-cursor-in-azure-data-lake
ForEach ($year in $Years)
{
    if ($year.name -ne 2017)
    {
        write-host $year.name
        $YearFolder = $SourceFolder+$year.Name
        $Files = Get-AzureRmDataLakeStoreChildItem  -Account $dataLakeStoreName -Path $YearFolder | ?{$_.Type -eq "FILE"} 
        ForEach ($file in $files)
        {
            $InputPath = $file.path
            $outputPath = $DestFolder+$year.name+'/'+$file.name
            $USQLProcCall = '[NYCTaxi].[dbo].[PrepFHV_Pre2017]("' + $InputPath + '","' + $OutputPath + '" );'
            $JobName = 'Output daily avg dataset for ' + $file.name         
            Write-Host $USQLProcCall

           <# $job = Submit-AzureRmDataLakeAnalyticsJob `
            -Name $JobName `
            -AccountName $DLAnalyticsName `
            –Script $USQLProcCall `
            -DegreeOfParallelism $DLAnalyticsDoP
             Write-Host "Job submitted for " $JobName #>
        }

        
    }
    elseif ($year.Name -eq 2017)
    {
        write-host $year.name
        $YearFolder = $SourceFolder+$year.Name
        $Files = Get-AzureRmDataLakeStoreChildItem  -Account $dataLakeStoreName -Path $YearFolder | ?{$_.Type -eq "FILE"} 
        ForEach ($file in $files)
        {
            $InputPath = $file.path
            $outputPath = $DestFolder+$year.name+'/'+$file.name
            $USQLProcCall = '[NYCTaxi].[dbo].[PrepFHV_2017]("' + $InputPath + '","' + $OutputPath + '" );'
            $JobName = 'Output daily avg dataset for ' + $file.name         
            Write-Host $USQLProcCall

            $job = Submit-AzureRmDataLakeAnalyticsJob `
            -Name $JobName `
            -AccountName $DLAnalyticsName `
            –Script $USQLProcCall `
            -DegreeOfParallelism $DLAnalyticsDoP
             Write-Host "Job submitted for " $JobName
        }
    }
}
