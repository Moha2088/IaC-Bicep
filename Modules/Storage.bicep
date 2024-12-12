

@description('Name of the storage account')
param storageAccountName string = 'BicepStorageAccount'

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
param keyVaultName string = 'BicepKeyVault'

resource vault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  location: location
  name: keyVaultName
  properties: {
    sku:{
      family: 'A'
      name: 'standard'
    }

    tenantId: subscription().tenantId
  }
}
