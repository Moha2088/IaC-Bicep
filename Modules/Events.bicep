@description('Location of the serviceplan')
param location string

@description('Name of the AppServicePlan')
param servicePlanName string = 'bicepserviceplan'

resource servicePlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  location: location
  name: servicePlanName
  sku: {
    family: 'F1'
  }
  properties: {}
}

@description('Name of the function')
param functionName string = 'bicepfunction'

resource function 'Microsoft.Web/sites@2024-04-01' = {
  name: functionName
  location: location
  kind: 'functionapp'
  properties: {
    serverFarmId: servicePlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsights.properties.InstrumentationKey
        }
      ]
    }
  }
}

param insightsName string = 'bicepfunctioninsights'

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: insightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}
