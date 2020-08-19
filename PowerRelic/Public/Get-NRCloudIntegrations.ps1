<#
  .SYNOPSIS
  Queries an account to either list all active cloud integrations or find a specific integration.
  
  .DESCRIPTION
  The Get-NRCloudIntegrations cmdlet queries NerdGraph for a list of all active cloud integrations or searches for a specific integration by linked account and integration ID in an account.
  
  .PARAMETER PersonalAPIKey
  [REQUIRED] The Personal API Key to be used with the NerdGraph API.
  
  .PARAMETER AccountID
  [REQUIRED] The New Relic Account ID to be queried against.
  
  .PARAMETER LinkedAccountID
  [OPTIONAL] The cloud linked account ID to be queried against.
  
  .PARAMETER IntegrationID
  [OPTIONAL] The cloud integration ID to return details for.
  
  .OUTPUTS
  id: The linked account ID
  integrations:
    createdAt: DateTime (epoch) the integration was created
    id: The integration ID
    name: The integration ID
    service:
        name: The service name
        slug: The service short name
    updatedAt: DateTime (epoch) the integration was last updated
  name: The linked account name
  provider:
    name: The provider name
    slug: The provider short name

  .EXAMPLE
  PS> Get-NRCloudIntegrations -PersonalAPIKey 'NRAK-123456789ABCDEFGHIJKLMNOPQR' -AccountID 1234567
  Find and list all configured cloud integrations for Account ID 1234567

  .EXAMPLE
  PS> Get-NRCloudIntegrations -PersonalAPIKey 'NRAK-123456789ABCDEFGHIJKLMNOPQR' -AccountID 1234567 -LinkedAccountID 999999 -IntegrationID 888888
  Find cloud integration 888888 for linked account 999999 in Account ID 1234567
#>
Function Get-NRCloudIntegrations {

    [ cmdletbinding() ]
    Param (
    
        [ Parameter ( Mandatory = $true ) ] [ string ] $PersonalAPIKey,
        [ Parameter ( Mandatory = $true ) ] [ int ] $AccountID,
        [ Parameter ( Mandatory = $false ) ] [ int ] $LinkedAccountID,
        [ Parameter ( Mandatory = $false ) ] [ int ] $IntegrationID
    
    )

# Set the NerdGraph URL
$nerdGraphUrl = 'https://api.newrelic.com/graphql'

# Build our authentication header
$header = @{ 'API-Key' = $PersonalAPIKey }

# Check to make sure that we use both $LinkedAccountID and $IntegrationID, if we use either
If( ( $LinkedAccountID -and !( $IntegrationID ) ) -or ( !( $LinkedAccountID ) -and $IntegrationID ) ) {

    Write-Error -Message "When searching for a specific integration, you must provide BOTH -LinkedAccountID and -IntegrationID parameters."

}

# Build our query payload for a specific integration search
If( $LinkedAccountID -and $IntegrationID ) {

$integrationQuery = @"
{
    "query": "{ actor { account(id: $AccountID) { cloud { linkedAccount(id: $LinkedAccountID) { id name provider { name slug } integration(id: $IntegrationID) { id name createdAt updatedAt service { name slug } } } } } } }",
    "variables": ""
}
"@

# Query the NerdGraph API, renaming the 'integration' output to 'integrations' to standardize
$results = ( Invoke-RestMethod -Method Post -Uri $nerdGraphUrl -ContentType 'application/json' -Headers $header -Body $integrationQuery ).data.actor.account.cloud.linkedAccount | Select-Object -Property id, @{ Name='integrations';Expression={ $_.integration } }, name, provider 

RETURN $results

}

# Build our query payload for a list of all integrations
Else{

$integrationQuery = @"
{
    "query": "{ actor { account(id: $AccountID) { cloud { linkedAccounts { id name provider { name slug } integrations { createdAt updatedAt id name service { name slug } } } } } } }",
    "variables": ""
}
"@

# Query the NerdGraph API
$results = ( Invoke-RestMethod -Method Post -Uri $nerdGraphUrl -ContentType 'application/json' -Headers $header -Body $integrationQuery ).data.actor.account.cloud.linkedAccounts

RETURN $results

}

}
