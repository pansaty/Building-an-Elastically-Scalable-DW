$dataLakeStoreName = "<DataLakeAccount"
$myrootdir = "/DataFiles/NYTaxi/Raw/TaxiData" 
$name = 'yellow' #Which data set. Manually changed this for fhv, yellow and green
$year = 2017 #Manually changed this for the range of years for files downloaded from fhv, yellow and greem
$moveto = "/DataFiles/NYTaxi/Raw/TaxiData/$name/$year" 

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
#Select-AzureRmSubscription -SubscriptionId $subscriptionId

$filestomove = Get-AzureRmDataLakeStoreChildItem -Account $dataLakeStoreName -Path $myrootdir | ?{$_.Type -eq 'File' -and $_.name -like "$name*" -and $_.name -like "*$year*"}
foreach ($file in $filestomove)
{
    $destination = $moveto+"/"+$file.name
    Move-AzureRmDataLakeStoreItem -Account $dataLakeStoreName -Path $file.path -Destination $destination
}

