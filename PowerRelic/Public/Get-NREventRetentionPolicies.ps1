<#
  .SYNOPSIS
  Queries an account for current event retention settings.
  
  .DESCRIPTION
  The Get-NREventRetentionPolicies cmdlet queries NerdGraph for a list of current event retention settings for all namespaces in an account.
  
  .PARAMETER PersonalAPIKey
  [REQUIRED] The Personal API Key to be used with the NerdGraph API.
  
  .PARAMETER AccountID
  [REQUIRED] The New Relic Account ID to be queried against.
  
  .OUTPUTS
  namespace: New Relic event type
  retentionInDays: Current retention setting

  .EXAMPLE
  PS> Get-NREventRetentionPolicies -PersonalAPIKey 'NRAK-123456789ABCDEFGHIJKLMNOPQR' -AccountID 1234567
  Find and list current event retention settings for Account ID 1234567
#>
Function Get-NREventRetentionPolicies {

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
$retentionQuery = @"
{
    "query": "{ actor { account(id: $AccountID) { dataManagement { eventRetentionPolicies { namespace namespaceLevelRetention { retentionInDays } } } } } }",
    "variables": ""
}
"@

# Query the NerdGraph API
$results = ( Invoke-RestMethod -Method Post -Uri $nerdGraphUrl -ContentType 'application/json' -Headers $header -Body $retentionQuery ).data.actor.account.dataManagement.eventRetentionPolicies | Select-Object -Property namespace, @{ 'Name'='retentionInDays'; 'Expression'={ $_.namespaceLevelRetention.retentionInDays } }

RETURN $results

}
