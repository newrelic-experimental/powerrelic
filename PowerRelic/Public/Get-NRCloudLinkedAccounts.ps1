<#
  .SYNOPSIS
  Queries an account for all linked cloud integration accounts.
  
  .DESCRIPTION
  The Get-NRCloudLinkedAccounts cmdlet queries NerdGraph for a list of all linked cloud integrations.
  
  .PARAMETER PersonalAPIKey
  [REQUIRED] The Personal API Key to be used with the NerdGraph API.
  
  .PARAMETER AccountID
  [REQUIRED] The New Relic Account ID to be queried against.
  
  .OUTPUTS
  authLabel: The credential used to link the cloud account with New Relic
  createdAt: DateTime linked account was created
  disabled: Boolean indicator of linked account status
  externalId: The cloud account identifier
  id: The linked account identifier in New Relic
  name: The linked account name in New Relic
  provider: 
      .id: The cloud provider identifier in New Relic
      .name: The cloud provider name
      .slug: The cloud provider short name

  .EXAMPLE
  PS> Get-NRCloudLinkedAccounts -PersonalAPIKey 'NRAK-123456789ABCDEFGHIJKLMNOPQR' -AccountID 1234567
  Find and list all cloud integration linked accounts for Account ID 1234567
#>
Function Get-NRCloudLinkedAccounts {

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
$linkedAccountsQuery = @"
{
    "query": "{ actor { account(id: $AccountID) { cloud { linkedAccounts { authLabel createdAt disabled externalId id name provider { id name slug } } } } } }",
    "variables": ""
}
"@

# Query the NerdGraph API
$results = ( Invoke-RestMethod -Method Post -Uri $nerdGraphUrl -ContentType 'application/json' -Headers $header -Body $linkedAccountsQuery ).data.actor.account.cloud.linkedAccounts

RETURN $results

}
