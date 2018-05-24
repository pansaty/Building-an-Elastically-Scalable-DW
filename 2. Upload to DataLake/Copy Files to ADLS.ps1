 # Data Lake items
$foldertoupload = "<Local folder containing NY Dataset>"
$destinationDataLakeAccount = "<DataLakeAccount>"
$dataLakeFolder = "/Path within datalake account to upload to/" #ex "/DataFiles/NyTaxi/Raw/"

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
 
#Upload an entire folder
Import-AzureRmDataLakeStoreItem -AccountName $destinationDataLakeAccount -Path $foldertoupload -Destination $dataLakeFolder -Force


#Upload certain files in a folder
<#
$files = Get-ChildItem $foldertoupload\* -Include *.tbl 
foreach ($file in $files)
{
    $dataLakePath = "$datalakeFolder$file" 
    $write =  "BEGIN Upload: " + $file
    Write-Output $write
    Import-AzureRmDataLakeStoreItem -AccountName $destinationDataLakeAccount -Path $file.FullName -Destination $dataLakePath -Force
    $write =  "END   Upload: " + $file
    Write-Output $write
}
#>