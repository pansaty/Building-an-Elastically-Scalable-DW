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

If we expand Raw, you can see the subfolder setup by year for each of the datasets from fhv, Green and yellow taxis

![alt text](https://github.com/pansaty/Building-an-Elastically-Scalable-DW/blob/master/images/Expanded%20View.png "Expanded view")

Setting up the folder structure was a manual step taken, but could easily be scripted. An example script,"Create Folder Structure.ps1", for creating months within a subfolder is provided in the [2. Upload to DataLake](https://github.com/pansaty/Building-an-Elastically-Scalable-DW/tree/master/2.%20Upload%20to%20DataLake) folder. 

## Uploading the data to Azure DataLake Store
In the second folder [2. Uploade to DataLake](https://github.com/pansaty/Building-an-Elastically-Scalable-DW/tree/master/2.%20Upload%20to%20DataLake) the powershell script "Copy Files to ADLS.ps1" will copy the files that you downloaded in the prior step to a single folder in your Datalake account. Alternatively you could leverage [Azure Data Factory's Copy Activity](https://docs.microsoft.com/en-us/azure/data-factory/copy-activity-overview) to copy the data from on-prem file share to Azure Data Lake or you could use your ETL tool of choice to get the data in Azure. 

**NOTE:** In order to use this script, you first need to setup [Service-to-service authentication](https://docs.microsoft.com/en-us/azure/data-lake-store/data-lake-store-service-to-service-authenticate-using-active-directory)

## Organize files into seperate Subfolders by year per dataset
The next step will be to organize the files. You can leverage the script "Move Files Around.ps1" from the [3. Organize files to folders](https://github.com/pansaty/Building-an-Elastically-Scalable-DW/tree/master/3.%20Organize%20files%20to%20folders) folder. 

## Prepare the data using USQL and PowerShell
Now that we have all our data landed in DataLake store we can prepare the data to be ingested into SQLDW. For this task we are using Azure Data Lake Analytics (ADLA). In the folder [4. Use USQL to Normalize schema](https://github.com/pansaty/Building-an-Elastically-Scalable-DW/tree/master/4.%20Use%20USQL%20to%20Normalize%20schema) are a series of USQL script files to handle for the various schemas from different years for each of the taxi data sets. The scripts are installed as stored procedures in your ADLA acocunt and will be invoked in parallel in the next step via PowerShell to transform all the files. You can review [U-SQL concepts](https://msdn.microsoft.com/en-us/azure/data-lake-analytics/u-sql/u-sql-concepts) for more information on working with ADLA and U-SQL. 

Once we have the Stored Procedures deployed to the ADLA Account, we can now invoke them via PowerShell. There are 3 PowerShell scripts within [4. Use USQL to Normalize schema](https://github.com/pansaty/Building-an-Elastically-Scalable-DW/tree/master/4.%20Use%20USQL%20to%20Normalize%20schema) to handle for fhv, green and yellow Taxi datasets. The PowerShell script contain the logic by looking at the files names to invoke the right stored procedure that corresponds to that year's schema. The result will be a new set of files created into the Prepared folder with standardized schema across all files. For example for yellow Taxi data between 2015 and the first halk for 2016, there was no  pickup_location_id or dropoff_location_id. To create a unified schema, we can read the file and artificially inject two columns with that name and null values written to a new file in the prepared folder. 

## Recording on Cloud Simplified showcasing this project
<a href="http://www.youtube.com/watch?feature=player_embedded&v=uNzH5kcAaTk
" target="_blank"><img src="http://img.youtube.com/vi/uNzH5kcAaTk/0.jpg" 
alt="IMAGE ALT TEXT HERE" width="240" height="180" border="10" /></a>

