# Performance Benchmarking of Azure Synapse Analytics using NYC Taxi Open dataset

This repository provides sample data and sample scripts that can be used to perform various benchmarking tests for Azure Synapse Analytics.
Initial release includes benchmarking for Dedicated SQL Pools. Other services will be added in the future releases.

## Prerequisite
In order to run this performance benchmarking, you would need the following resources created in Azure:
- Azure Synapse Analytics Workspace
- Dedicated SQL Pool inside the workspace (SKU: DW1000c)
- Apache Spark Pool inside the workspace
- Azure Storage Account (You can use the default storage account of Azure Synapse Analytics workspace)

Note: It is recommended to use atleast DWU1000c for the dedicated SQL Pools to get optimal results for the prformance benchmarking.
Reference: [Azure Synapse proof of concept playbook](https://learn.microsoft.com/en-us/azure/synapse-analytics/guidance/proof-of-concept-playbook-dedicated-sql-pool#setup)

## About the dataset
We are going to use NYC Taxi yellow dataset for our performance benchmarking. This dataset is provided by Microsoft as part of [Azure Open datasets](https://learn.microsoft.com/en-us/azure/open-datasets/overview-what-are-open-datasets)

This dataset is stored in Parquet format. There are about 1.5B rows (50 GB) in total. This dataset contains historical records accumulated from 2009 to 2018. This dataset is stored in the East US Azure region.

You can learn more about the structure and sample of the dataset from this link: [NYC Taxi & Limousine Commission - yellow taxi trip records](https://learn.microsoft.com/en-us/azure/open-datasets/dataset-taxi-yellow?tabs=azureml-opendatasets)

## Setting up the dataset
