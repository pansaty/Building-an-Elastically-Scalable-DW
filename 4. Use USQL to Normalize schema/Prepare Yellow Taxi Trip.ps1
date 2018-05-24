$dataLakeStoreName = "pankajcsa"
$DLAnalyticsName = "pankajcsa"
$DLAnalyticsDoP = 2
$SourceFolder = "/DataFiles/NYTaxi/Raw/TaxiData/yellow/" 
$DestFolder = "/DataFiles/NYTaxi/Prepared/TaxiData/yellow/" 

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
    if ($year.name -lt 2015)
    {
        write-host $year.name
        $YearFolder = $SourceFolder+$year.Name
        $Files = Get-AzureRmDataLakeStoreChildItem  -Account $dataLakeStoreName -Path $YearFolder | ?{$_.Type -eq "FILE"} 
        ForEach ($file in $files)
        {
            $InputPath = $file.path
            $outputPath = $DestFolder+$year.name+'/'+$file.name
            $USQLProcCall = '[NYCTaxi].[dbo].[yellow_pre2015]("' + $InputPath + '","' + $OutputPath + '" );'
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
    elseif ($year.Name -eq 2015)
    {
        write-host $year.name
        $YearFolder = $SourceFolder+$year.Name
        $Files = Get-AzureRmDataLakeStoreChildItem  -Account $dataLakeStoreName -Path $YearFolder | ?{$_.Type -eq "FILE"} 
        ForEach ($file in $files)
        {
            $InputPath = $file.path
            $outputPath = $DestFolder+$year.name+'/'+$file.name
            $USQLProcCall = '[NYCTaxi].[dbo].[yellow_2015_2016H1]("' + $InputPath + '","' + $OutputPath + '" );'

                $JobName = 'Output daily avg dataset for ' + $file.name         
                Write-Host $USQLProcCall

                $job = Submit-AzureRmDataLakeAnalyticsJob `
                -Name $JobName `
                -AccountName $DLAnalyticsName `
                –Script $USQLProcCall `
                -DegreeOfParallelism $DLAnalyticsDoP
                Write-Host "Job submitted for " $JobNamex
        }
    }
    elseif ($year.Name -eq 2016)
    {
        write-host $year.name
        $YearFolder = $SourceFolder+$year.Name
        $Files = Get-AzureRmDataLakeStoreChildItem  -Account $dataLakeStoreName -Path $YearFolder | ?{$_.Type -eq "FILE"} 
        ForEach ($file in $files)
        {
            $InputPath = $file.path
            $outputPath = $DestFolder+$year.name+'/'+$file.name
            #First half has different format

            $parts = (($file.name).Split('-')).split('.')
            If ($parts[1] -match '0[1-6]') 
            {
                $USQLProcCall = '[NYCTaxi].[dbo].[yellow_2015_2016H1]("' + $InputPath + '","' + $OutputPath + '" );'
                $JobName = 'Output daily avg dataset for ' + $file.name         
                Write-Host $USQLProcCall

                $job = Submit-AzureRmDataLakeAnalyticsJob `
                -Name $JobName `
                -AccountName $DLAnalyticsName `
                –Script $USQLProcCall `
                -DegreeOfParallelism $DLAnalyticsDoP
                Write-Host "Job submitted for " $JobNamex
            
            }
            else
            {
                $USQLProcCall = '[NYCTaxi].[dbo].[yellow_2016H2]("' + $InputPath + '","' + $OutputPath + '" );'
                $JobName = 'Output daily avg dataset for ' + $file.name         
                Write-Host $USQLProcCall

                $job = Submit-AzureRmDataLakeAnalyticsJob `
                -Name $JobName `
                -AccountName $DLAnalyticsName `
                –Script $USQLProcCall `
                -DegreeOfParallelism $DLAnalyticsDoP
                Write-Host "Job submitted for " $JobNamex
            }
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
            #First half has different format

            $USQLProcCall = '[NYCTaxi].[dbo].[yellow_2017]("' + $InputPath + '","' + $OutputPath + '" );'
            $JobName = 'Output daily avg dataset for ' + $file.name         
            Write-Host $USQLProcCall

                $job = Submit-AzureRmDataLakeAnalyticsJob `
                -Name $JobName `
                -AccountName $DLAnalyticsName `
                –Script $USQLProcCall `
                -DegreeOfParallelism $DLAnalyticsDoP
                Write-Host "Job submitted for " $JobNamex
            
        }
    }

}
