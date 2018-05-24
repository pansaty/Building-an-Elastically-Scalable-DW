# Building an Elastically Scalable DW

This project will guide you thru leveraging the New York taxi data set to demonstrate building an Elastically Scalable Datawarehouse in Azure. This builds upon the work done by Todd Schnieder and his original repo can be found here <https://github.com/toddwschneider/nyc-taxi-data>

Technologies that will be leveraged:
  * PowerShell
  * Azure Data Lake Store
  * Azure Data Lake Analytics
  * Azure Data Factory
  * Azure SQLDW
  * Azure Analysis Services
  * PowerBI

## Downloading the data
In the first folder [1. Downloading Taxi Dataset](https://github.com/pansaty/Building-an-Elastically-Scalable-DW/tree/master/1.%20Downloading%20Taxi%20Dataset) the powershell script "Download Rawdata.ps1" will download the required raw files. Ensure you update the PathToURLFile and PathToDownloadDataTo.

## Uploading the data to Azure DataLake Store
In the second folder [2. Uploade to DataLake](https://github.com/pansaty/Building-an-Elastically-Scalable-DW/tree/master/2.%20Upload%20to%20DataLake) the powershell script "Copy Files to ADLS.ps1. will copy the files that you downloaded in the prior step to a 
