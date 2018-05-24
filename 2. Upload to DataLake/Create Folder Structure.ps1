#This script will create month folders within the 2015 Year for the fhv data set

$dataLakeStoreName = "<YourDataLakeAccount>"
$myrootdir = "/DataFiles/NYTaxi/Raw/TaxiData/fhv/2015" 

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


    $month = 0
    do
    {
        $month++
        if ($month -lt 10){$foldername='0'+$month} else {$foldername = $month}
        New-AzureRmDataLakeStoreItem -Folder -AccountName $dataLakeStoreName -Path $myrootdir/$foldername    
    }
    until ($month -eq 12)

    