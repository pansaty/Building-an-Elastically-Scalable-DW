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

## Setting up your folder structure in Azure DataLake
For the purposes of this data set, I tried to partition my data by year within seperate folders. Initially we will be uploading all the files to the root of the Raw folder in the next step and subsequently we will run a PowerShell script to move the files around into their respective folders. Optionally we could have uploaded to a staging folder then moved to subfolders under raw. The intent of the Raw folder is to keep a prisitine copy of the source data untransformed in it raw state with all columns and no cleansing. The purpose for keeping this raw dataset can serve multiple purposes a few being, audit, being able to go back at any point and seeing what the untransformed version of the data looked like, extracting data elements in the future that may not be relevant today and more. 

Below is a sampling of the structure. We have the root called NYTaxi and two subfolders beneath Prepared which is our cleansed data set and Raw which is our original dataset.
![alt text](https://github.com/pansaty/Building-an-Elastically-Scalable-DW/blob/master/images/High%20Level%20Folder.png "High level folders")



## Uploading the data to Azure DataLake Store
In the second folder [2. Uploade to DataLake](https://github.com/pansaty/Building-an-Elastically-Scalable-DW/tree/master/2.%20Upload%20to%20DataLake) the powershell script "Copy Files to ADLS.ps1. will copy the files that you downloaded in the prior step to th
