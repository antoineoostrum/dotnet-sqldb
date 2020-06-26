create app service and App gateway
create release 
# using a demo ASP.NET application with a SQL Managed database
# setup
1. Open dotnet-sqldb-tutorial-master/DotNetAppSqlDb.sln file in Visual Studio.
2. Publish 
3. connect to database
4 changed AD admin groep -> to do use script to do it
evt 5. run query on sql CREATE USER [oostruma@delagelanden.com] FROM EXTERNAL PROVIDER;  and ALTER ROLE DB_Owner ADD MEMBER [oostruma@delagelanden.com]
finish step app gateway
# explorer application
5. enable  log streaming?
6. Open up website and add some data 
7. Connect to database using Azure Data Studio/Visual studio -> view dbo.Todoes
8.
#apply access restrictions 
az webapp config access-restriction add `
    --resource-group $resourceGroupName --name $appName `
    --priority 200 --rule-name gateway-access `
    --subnet myAGSubnet --vnet-name myVNet

#output
[
  {
    "action": "Allow",
    "description": null,
    "ipAddress": null,
    "name": "gateway-access",
    "priority": 200,
    "subnetMask": null,
    "subnetTrafficTag": null,
    "tag": "Default",
    "vnetSubnetResourceId": "/subscriptions/f5878af0-ca26-411c-9906-acf91f5420e2/resourceGroups/oostrumA/providers/Microsoft.Network/virtualNetworks/myVNet/subnets/myAGSubnet",
    "vnetTrafficTag": null
  },
  {
    "action": "Deny",
    "description": "Deny all access",
    "ipAddress": "Any",
    "name": "Deny all",
    "priority": 2147483647,
    "subnetMask": null,
    "subnetTrafficTag": null,
    "tag": null,
    "vnetSubnetResourceId": null,
    "vnetTrafficTag": null
  }
]

#403 Error when trying to access



#
9. Enable VNet Integration
#connect Web APp to VNet
function Join-Vnet ($resourceGroup, $webAppName, $vnetName, $subnetName)
{
    $subscriptionId = az account show --query id -o tsv
    $location = az group show -n $resourceGroup --query location -o tsv
    $subnetId = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.Network/virtualNetworks/$vnetName/subnets/$subnetName"

    $resourceId = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.Web/sites/$webAppName/config/virtualNetwork"
    $url = "https://management.azure.com$resourceId" + "?api-version=2018-02-01"

    $payload = @{ id=$resourceId; location=$location;  properties=@{subnetResourceId=$subnetId; swiftSupported="true"} } | ConvertTo-Json
    $accessToken = az account get-access-token --query accessToken -o tsv
    $response = Invoke-RestMethod -Method Put -Uri $url -Headers @{ Authorization="Bearer $accessToken"; "Content-Type"="application/json" } -Body $payload
}
Join-Vnet $resourceGroup $frontendAppName $vnetName $subnetName

or

  - Create VNet Integration from networking tab
  - Create a new subnet (app1 10.0.2.0/24)
  - During the integration, your app is restarted
























#App Gateway
myVNet/myAGSubnet 
51.105.109.88 (webappwithgateway.westeurope.cloudapp.azure.com)

# enable service endpoint 
# enable on application gateway subnet Service endpoint -> Microsoft.Web
From the Overview blade of the App Gateway, note the subnet, 
and click on the Virtual Network link to go to the VNET resource. Click the Subnets blade on the left and then click on the App Gateway subnet to open its 
configuration blade.
