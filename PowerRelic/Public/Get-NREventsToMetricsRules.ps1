<#
  .SYNOPSIS
  Queries an account to either list all E2M rules or find a specific rule.
  
  .DESCRIPTION
  The Get-NREventsToMetricsRules cmdlet queries NerdGraph for a list of all Event to Metric (E2M) rules or searches for a specific rule by ID in an account.
  
  .PARAMETER PersonalAPIKey
  [REQUIRED] The Personal API Key to be used with the NerdGraph API.
  
  .PARAMETER AccountID
  [REQUIRED] The New Relic Account ID to be queried against.
  
  .PARAMETER RuleID
  [OPTIONAL] The E2M rule ID to search for.
  
  .OUTPUTS
  createdAt: DateTime the E2M rule was created
  description: Description of E2M rule
  enabled: Boolean indicator of E2M rule status
  id: E2M rule ID
  name: E2M rule name
  nrql: E2M rule NRQL query
  updatedAt: DateTime the E2M rule was last updated

  .EXAMPLE
  PS> Get-NREventsToMetricsRules -PersonalAPIKey 'NRAK-123456789ABCDEFGHIJKLMNOPQR' -AccountID 1234567
  Find and list all available E2M rules for Account ID 1234567

  .EXAMPLE
  PS> Get-NREventsToMetricsRules -PersonalAPIKey 'NRAK-123456789ABCDEFGHIJKLMNOPQR' -AccountID 1234567 -RuleID 99999
  Find E2M rule ID 99999 for Account ID 1234567
#>
Function Get-NREventsToMetricsRules {

    [ cmdletbinding() ]
    Param (
    
        [ Parameter ( Mandatory = $true ) ] [ string ] $PersonalAPIKey,
        [ Parameter ( Mandatory = $true ) ] [ int ] $AccountID,
        [ Parameter ( Mandatory = $false ) ] [ int ] $RuleID
    
    )

# Set the NerdGraph URL
$nerdGraphUrl = 'https://api.newrelic.com/graphql'

# Build our authentication header
$header = @{ 'API-Key' = $PersonalAPIKey }

If( $RuleID ) { 

# Build our query payload
$rulesQuery = @"
{
    "query": "{ actor { account(id: $AccountID) { eventsToMetrics { rulesById(ruleIds: $RuleID) { rules { createdAt description enabled id name nrql updatedAt } } } } } }",
    "variables": ""
}
"@

# Query the NerdGraph API
$results = ( Invoke-RestMethod -Method Post -Uri $nerdGraphUrl -ContentType 'application/json' -Headers $header -Body $rulesQuery ).data.actor.account.eventsToMetrics.rulesById.rules

RETURN $results

}

Else{ 

# Build our query payload
$rulesQuery = @"
{
    "query": "{ actor { account(id: $AccountID) { eventsToMetrics { allRules { rules { createdAt description enabled id name nrql updatedAt } } } } } }",
    "variables": ""
}
"@

# Query the NerdGraph API
$results = ( Invoke-RestMethod -Method Post -Uri $nerdGraphUrl -ContentType 'application/json' -Headers $header -Body $rulesQuery ).data.actor.account.eventsToMetrics.allRules.rules

RETURN $results

}

}
