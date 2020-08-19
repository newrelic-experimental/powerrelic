<#
  .SYNOPSIS
  Queries an account for all available cloud integrations.
  
  .DESCRIPTION
  The Get-NRCloudAvailableIntegrations cmdlet queries NerdGraph for a list of all cloud integrations available to be configured in an account.
  
  .PARAMETER PersonalAPIKey
  [REQUIRED] The Personal API Key to be used with the NerdGraph API.
  
  .PARAMETER AccountID
  [REQUIRED] The New Relic Account ID to be queried against.
  
  .PARAMETER Provider
  [REQUIRED] The cloud provider slug to search for integrations in.
  
  .OUTPUTS
  name: The cloud integration name
  slug: The cloud integration short name

  .EXAMPLE
  PS> Get-NRCloudAvailableIntegrations -PersonalAPIKey 'NRAK-123456789ABCDEFGHIJKLMNOPQR' -AccountID 1234567 -Provider aws
  Find and list all available AWS cloud integrations for Account ID 1234567
#>
Function Get-NRCloudAvailableIntegrations {

    [ cmdletbinding() ]
    Param (
    
        [ Parameter ( Mandatory = $true ) ] [ string ] $PersonalAPIKey,
        [ Parameter ( Mandatory = $true ) ] [ int ] $AccountID,
        [ Parameter ( Mandatory = $true ) ] [ ValidateSet( 'aws','azure','gcp' ) ] [ string ] $Provider
    
    )

# Set the NerdGraph URL
$nerdGraphUrl = 'https://api.newrelic.com/graphql'

# Build our authentication header
$header = @{ 'API-Key' = $PersonalAPIKey }

# Build our query payload
$integrationsQuery = @"
{
    "query": "{ actor { account(id: $AccountID) { cloud { provider(slug: \"$Provider\") { slug name services { name slug } } } } } }",
    "variables": ""
}
"@

# Query the NerdGraph API
$results = ( Invoke-RestMethod -Method Post -Uri $nerdGraphUrl -ContentType 'application/json' -Headers $header -Body $integrationsQuery ).data.actor.account.cloud.provider.services

RETURN $results

}
