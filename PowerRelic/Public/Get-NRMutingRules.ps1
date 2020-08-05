<#
  .SYNOPSIS
  Lists Muting Rules for an account.
  
  .DESCRIPTION
  The Get-NRMutingRules cmdlet queries NerdGraph for either a specific muting rule by ID, or a list of all muting rules within an account.
  
  .PARAMETER PersonalAPIKey
  [REQUIRED] The Personal API Key to be used with the NerdGraph API.
  
  .PARAMETER AccountID
  [REQUIRED] The New Relic Account ID to be queried against.
  
  .PARAMETER PolicyID
  [OPTIONAL] A single Muting Rule ID to be queried.
  
  .OUTPUTS
  condition: PSCustomObject with the condition(s) that apply for the muting rule(s)
      .operator: Used to match n+1 conditions
      .conditions.attribute: The attribute on a violation
      .conditions.operator: Used to match .conditions.attribute with .conditions.values
      .conditions.values: The value(s) to compare against .conditions.attribute
  createdAt: DateTime muting rule was created
  createdByUser: PSCustomObject with details on the user who created the muting rule(s)
      .email: User's email address
      .id: User's numeric ID for New Relic
      .name: User's display name
  description: Muting rule description
  enabled: Boolean indicator of muting rule status
  id: Muting rule id
  name: Muting rule name
  schedule: PSCustomObject with the details on the schedule for the muting rule(s)
      .endTime: DateTime the muting rule(s) ends
      .startTime: DateTime the muting rule(s) starts
      .timeZone: Relative time zone for .endTime and .startTime
  status: Muting rule status
  updatedAt: DateTime muting rule was last updated
  updatedByUser: PSCustomObject with details on the user who last updated the muting rule(s)
      .email: User's email address
      .id: User's numeric ID for New Relic
      .name: User's display name

  .EXAMPLE
  PS> Get-NRMutingRules -PersonalAPIKey 'NRAK-123456789ABCDEFGHIJKLMNOPQR' -AccountID 1234567
  List all Muting Rules for Account ID 1234567
  
  .EXAMPLE
  PS> Get-NRMutingRules -PersonalAPIKey 'NRAK-123456789ABCDEFGHIJKLMNOPQR' -AccountID 1234567 -RuleID 98765
  Find and list Muting Rule ID 98765 for Account ID 1234567
#>
Function Get-NRMutingRules {

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

# Build our query payload based on whether $RuleID is provided or not
If( $RuleID ) {
    
$muteRulesQuery = @"
{
    "query":"{ actor { account(id: $accountID) { alerts { mutingRule(id: $RuleID) { id name createdAt createdByUser { email name id } enabled description schedule { timeZone startTime endTime } status condition { operator conditions { attribute operator values } } updatedAt updatedByUser { email name id } } } } } }",
    "variables": null
}
"@

}

Else {
    
$muteRulesQuery = @"
{
    "query":"{ actor { account(id: $accountID) { alerts { mutingRules { id name createdAt createdByUser { email name id } enabled description schedule { timeZone startTime endTime } status condition { operator conditions { attribute operator values } } updatedAt updatedByUser { email name id } } } } } }",
    "variables": null
}
"@

}

# Query the NerdGraph API
$results = ( Invoke-RestMethod -Method Post -Uri $nerdGraphUrl -FollowRelLink -ContentType 'application/json' -Headers $header -Body $muteRulesQuery ).data.actor.account.alerts.mutingRules

RETURN $results

}
