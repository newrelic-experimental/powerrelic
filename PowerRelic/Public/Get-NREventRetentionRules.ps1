<#
  .SYNOPSIS
  Queries an account for all existing event retention rules.
  
  .DESCRIPTION
  The Get-NREventRetentionRules cmdlet queries NerdGraph for a list of all existing event retention rules in an account.
  
  .PARAMETER PersonalAPIKey
  [REQUIRED] The Personal API Key to be used with the NerdGraph API.
  
  .PARAMETER AccountID
  [REQUIRED] The New Relic Account ID to be queried against.
  
  .OUTPUTS
  createdAt: DateTime (epoch) retention rule was created
  createdById: User ID who created this retention rule
  deletedAt: DateTime (epoch) retention rule was deleted
  deletedById: User ID who deleted this retention rule
  id: Retention rule ID
  namespace: Event type this rule effects
  retentionInDays: Current retention setting for this rule

  .EXAMPLE
  PS> Get-NREventRetentionRules -PersonalAPIKey 'NRAK-123456789ABCDEFGHIJKLMNOPQR' -AccountID 1234567
  Find and list all available event retention rules for Account ID 1234567
#>
Function Get-NREventRetentionRules {

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
$integrationsQuery = @"
{
    "query": "{ actor { account(id: $AccountID) { dataManagement { eventRetentionRules { createdAt createdById deletedAt deletedById id namespace retentionInDays } } } } }",
    "variables": ""
}
"@

# Query the NerdGraph API
$results = ( Invoke-RestMethod -Method Post -Uri $nerdGraphUrl -ContentType 'application/json' -Headers $header -Body $integrationsQuery ).data.actor.account.dataManagement.eventRetentionRules

RETURN $results

}
