targetScope = 'resourceGroup'

@description('Location of the resourcegroup')
param location string = resourceGroup().location



module storage 'Modules/Storage.bicep' = {
  name: 'Storage'
  params:{
    location: location
  }
}
