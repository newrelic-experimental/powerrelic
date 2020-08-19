<#
  .SYNOPSIS
  Queries an account for all available provider accounts.
  
  .DESCRIPTION
  The Get-NRCloudProvider cmdlet queries NerdGraph for a list of all New Relic provider accounts available in an account.
  
  .PARAMETER PersonalAPIKey
  [REQUIRED] The Personal API Key to be used with the NerdGraph API.
  
  .PARAMETER AccountID
  [REQUIRED] The New Relic Account ID to be queried against.
  
  .OUTPUTS
  name: The cloud provider name
  roleAccountId: The New Relic AWS Account ID [AWS]
  roleExternalId: The external ID required to assume the Role by the New Relic account [AWS]
  serviceAccountId: The service account used to like the project to New Relic [GCP]
  slug: The cloud provider short name

  .EXAMPLE
  PS> Get-NRCloudProvider -PersonalAPIKey 'NRAK-123456789ABCDEFGHIJKLMNOPQR' -AccountID 1234567
  Find and list all available New Relic provider accounts for Account ID 1234567
#>
Function Get-NRCloudProvider {

    [ cmdletbinding() ]
    Param (
    
        [ Parameter ( Mandatory = $true ) ] [ string ] $PersonalAPIKey,
        [ Parameter ( Mandatory = $true ) ] [ int ] $AccountID
    
    )

# Set the NerdGraph URL
$nerdGraphUrl = 'https://api.newrelic.com/graphql'

# Build our authentication header
$header = @{ 'API-Key' = $PersonalAPIKey }

# Build our query payload
$providersQuery = @"
{
    "query": "{ actor { account(id: $AccountID) { cloud { providers { ... on CloudAwsProvider { name roleAccountId roleExternalId slug } ... on CloudGcpProvider { name serviceAccountId slug } name slug } } } } }",
    "variables": ""
}
"@

# Query the NerdGraph API
$results = ( Invoke-RestMethod -Method Post -Uri $nerdGraphUrl -ContentType 'application/json' -Headers $header -Body $providersQuery ).data.actor.account.cloud.providers

RETURN $results

}
