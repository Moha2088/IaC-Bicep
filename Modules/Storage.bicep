

@description('Name of the storage account')
param storageAccountName string = 'bstorage${uniqueString(resourceGroup().id)}'

@description('Location of the resourcegroup')
param location string

@allowed(['Standard_LRS'])
@description('Storage redundancy type')
param skuName string ='Standard_LRS'

resource storage 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  sku: {
    name: skuName
  }
    
  kind: 'StorageV2'
  location: location
}




@description('Name of the Key Vault')
param keyVaultName string = 'bvault${uniqueString(resourceGroup().id)}'

resource vault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  location: location
  name: keyVaultName
  properties: {
    sku:{
      family: 'A'
      name: 'standard'
    }

    tenantId: subscription().tenantId
    accessPolicies: []
  }
}


@description('Name of the AppServicePlan')
param servicePlanName string = 'bplan${uniqueString(resourceGroup().id)}'

resource servicePlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  location: location
  name: servicePlanName
  sku: {
    name: 'Y1'
  }
  properties: {}
}

@description('Name of the function')
param functionName string = 'bfunction${uniqueString(resourceGroup().id)}'

resource function 'Microsoft.Web/sites@2024-04-01' = {
  name: functionName
  location: location
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: servicePlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsights.properties.InstrumentationKey
        }

        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet'
        }

        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storage.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storage.listKeys().keys[0].value}'
        }
      ]
    }
  }
}

param insightsName string = 'binsights${uniqueString(resourceGroup().id)}'

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: insightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

