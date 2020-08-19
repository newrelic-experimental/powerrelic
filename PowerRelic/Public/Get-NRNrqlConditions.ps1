<#
  .SYNOPSIS
  Queries an account for NRQL alert conditions.
  
  .DESCRIPTION
  The Get-NRNrqlConditions cmdlet queries NerdGraph for either a specific NRQL alert condition by ID, or a list of all NRQL alert conditions matching specified search criteria.
  
  .PARAMETER PersonalAPIKey
  [REQUIRED] The Personal API Key to be used with the NerdGraph API.
  
  .PARAMETER AccountID
  [REQUIRED] The New Relic Account ID to be queried against.
  
  .PARAMETER SearchParameter
  [REQUIRED] The type of search to perform.
  
  .PARAMETER SearchValue
  [REQUIRED] The search parameters to evaluate against.
  
  .OUTPUTS
  description: NRQL condition custom violation description
  enabled: Boolean indicator of condition status
  expiration: 
      .closeViolationsOnExpiration: Boolean indicator, whether to close all open violations when the signal expires
      .expirationDuration: The amount of time (in seconds) to wait before considering the signal expired
      .openViolationOnExpiration: Boolean indicator, whether to create a new violation to capture that the signal expired
  id: NRQL condition ID
  name: NRQL condition name
  nrql: 
      .query: NRQL syntax
  policyId: Parent alert policy ID
  runbookUrl: Runbook URL
  signal: 
      .evaluationOffset: The number of time windows (backwards) aggregated data is evaluated against
      .fillOption: Which fill option to use
      .fillValue: If using static fill option, this is the value used for filling
  terms: 
      .operator: Operator used to compare against the threshold
      .priority: Priority of this potential violation
      .threshold: Value that triggers a violation
      .thresholdDuration: Duration, in seconds, that the condition must violate the threshold before creating a violation
      .thresholdOccurrences: How many data points must be in violation for the specified threshold duration
  type: Type of NRQL Condition
  violationTimeLimit: Duration after which a violation automatically closes

  .EXAMPLE
  PS> Get-NRNrqlConditions -PersonalAPIKey 'NRAK-123456789ABCDEFGHIJKLMNOPQR' -AccountID 1234567 -SearchParameter ConditionID -SearchValue 98765
  Find and list NRQL Condition ID 98765 for Account ID 1234567

  .EXAMPLE
  PS> Get-NRNrqlConditions -PersonalAPIKey 'NRAK-123456789ABCDEFGHIJKLMNOPQR' -AccountID 1234567 -SearchParameter Name -SearchValue "Test Alert"
  Find and list NRQL Conditions with the exact name "Test Alert" for Account ID 1234567

  .EXAMPLE
  PS> Get-NRNrqlConditions -PersonalAPIKey 'NRAK-123456789ABCDEFGHIJKLMNOPQR' -AccountID 1234567 -SearchParameter NameLike -SearchValue "Test"
  Find and list NRQL Conditions with names matching *Test* for Account ID 1234567

  .EXAMPLE
  PS> Get-NRNrqlConditions -PersonalAPIKey 'NRAK-123456789ABCDEFGHIJKLMNOPQR' -AccountID 1234567 -SearchParameter PolicyID -SearchValue 98765
  Find and list NRQL Conditions in Alert Policy ID 98765 for Account ID 1234567

  .EXAMPLE
  PS> Get-NRNrqlConditions -PersonalAPIKey 'NRAK-123456789ABCDEFGHIJKLMNOPQR' -AccountID 1234567 -SearchParameter Query -SearchValue "SELECT count(*) FROM NrConsumption"
  Find and list NRQL Conditions using the exact query "SELECT count(*) FROM NrConsumption" for Account ID 1234567

  .EXAMPLE
  PS> Get-NRNrqlConditions -PersonalAPIKey 'NRAK-123456789ABCDEFGHIJKLMNOPQR' -AccountID 1234567 -SearchParameter QueryLike -SearchValue "Metric"
  Find and list NRQL Conditions with queries matching *Metric* for Account ID 1234567
#>
Function Get-NRNrqlConditions {

    [ cmdletbinding() ]
    Param (
    
        [ Parameter ( Mandatory = $true ) ] [ string ] $PersonalAPIKey,
        [ Parameter ( Mandatory = $true ) ] [ int ] $AccountID,
        [ Parameter ( Mandatory = $true ) ] [ ValidateSet( 'ConditionID','Name','NameLike','PolicyID','Query','QueryLike' ) ] [ string ] $SearchParameter,
        [ Parameter ( Mandatory = $true ) ] [ string ] $SearchValue
    
    )

# Set the NerdGraph URL
$nerdGraphUrl = 'https://api.newrelic.com/graphql'

# Build our authentication header
$header = @{ 'API-Key' = $PersonalAPIKey }

# Build our query payload for $SearchParameter = 'ConditionID'
If( $SearchParameter -eq 'ConditionID' ) {

$nrqlConditionsQuery = @"
{
    "query": "{ actor { account(id: $AccountID) { alerts { nrqlCondition(id: $SearchValue) { description enabled expiration { closeViolationsOnExpiration expirationDuration openViolationOnExpiration } name id nrql { query } policyId runbookUrl signal { evaluationOffset fillOption fillValue } terms { operator priority threshold thresholdDuration thresholdOccurrences } type violationTimeLimit } } } } }",
    "variables": null
}
"@

# Query the NerdGraph API
$results = ( Invoke-RestMethod -Method Post -Uri $nerdGraphUrl -ContentType 'application/json' -Headers $header -Body $nrqlConditionsQuery ).data.actor.account.alerts.nrqlCondition

RETURN $results

}

# Build our query payload for $SearchParameter = 'Name'
If( $SearchParameter -eq 'Name' ) {

$nrqlConditionsQuery = @"
{
    "query": "{ actor { account(id: $AccountID) { alerts { nrqlConditionsSearch(searchCriteria: {name: \"$SearchValue\"}) { nrqlConditions { description enabled expiration { closeViolationsOnExpiration expirationDuration openViolationOnExpiration } id name nrql { query } policyId runbookUrl signal { evaluationOffset fillOption fillValue } terms { operator priority threshold thresholdDuration thresholdOccurrences } type violationTimeLimit } } } } } }",
    "variables": ""
}
"@

# Query the NerdGraph API
$results = ( Invoke-RestMethod -Method Post -Uri $nerdGraphUrl -ContentType 'application/json' -Headers $header -Body $nrqlConditionsQuery ).data.actor.account.alerts.nrqlConditionsSearch.nrqlConditions

RETURN $results

}

# Build our query payload for $SearchParameter = 'NameLike'
If( $SearchParameter -eq 'NameLike' ) {

$nrqlConditionsQuery = @"
{
    "query": "{ actor { account(id: $AccountID) { alerts { nrqlConditionsSearch(searchCriteria: {nameLike: \"$SearchValue\"}) { nrqlConditions { description enabled expiration { closeViolationsOnExpiration expirationDuration openViolationOnExpiration } id name nrql { query } policyId runbookUrl signal { evaluationOffset fillOption fillValue } terms { operator priority threshold thresholdDuration thresholdOccurrences } type violationTimeLimit } } } } } }",
    "variables": ""
}
"@

# Query the NerdGraph API
$results = ( Invoke-RestMethod -Method Post -Uri $nerdGraphUrl -ContentType 'application/json' -Headers $header -Body $nrqlConditionsQuery ).data.actor.account.alerts.nrqlConditionsSearch.nrqlConditions

RETURN $results

}

# Build our query payload for $SearchParameter = 'PolicyID'
If( $SearchParameter -eq 'PolicyID' ) {

$nrqlConditionsQuery = @"
{
    "query": "{ actor { account(id: $AccountID) { alerts { nrqlConditionsSearch(searchCriteria: {policyId: \"$SearchValue\"}) { nrqlConditions { description enabled expiration { closeViolationsOnExpiration expirationDuration openViolationOnExpiration } id name nrql { query } policyId runbookUrl signal { evaluationOffset fillOption fillValue } terms { operator priority threshold thresholdDuration thresholdOccurrences } type violationTimeLimit } } } } } }",
    "variables": ""
}
"@

# Query the NerdGraph API
$results = ( Invoke-RestMethod -Method Post -Uri $nerdGraphUrl -ContentType 'application/json' -Headers $header -Body $nrqlConditionsQuery ).data.actor.account.alerts.nrqlConditionsSearch.nrqlConditions

RETURN $results

}

# Build our query payload for $SearchParameter = 'Query'
If( $SearchParameter -eq 'Query' ) {

$nrqlConditionsQuery = @"
{
    "query": "{ actor { account(id: $AccountID) { alerts { nrqlConditionsSearch(searchCriteria: {query: \"$SearchValue\"}) { nrqlConditions { description enabled expiration { closeViolationsOnExpiration expirationDuration openViolationOnExpiration } id name nrql { query } policyId runbookUrl signal { evaluationOffset fillOption fillValue } terms { operator priority threshold thresholdDuration thresholdOccurrences } type violationTimeLimit } } } } } }",
    "variables": ""
}
"@

# Query the NerdGraph API
$results = ( Invoke-RestMethod -Method Post -Uri $nerdGraphUrl -ContentType 'application/json' -Headers $header -Body $nrqlConditionsQuery ).data.actor.account.alerts.nrqlConditionsSearch.nrqlConditions

RETURN $results

}

# Build our query payload for $SearchParameter = 'QueryLike'
If( $SearchParameter -eq 'QueryLike' ) {

$nrqlConditionsQuery = @"
{
    "query": "{ actor { account(id: $AccountID) { alerts { nrqlConditionsSearch(searchCriteria: {queryLike: \"$SearchValue\"}) { nrqlConditions { description enabled expiration { closeViolationsOnExpiration expirationDuration openViolationOnExpiration } id name nrql { query } policyId runbookUrl signal { evaluationOffset fillOption fillValue } terms { operator priority threshold thresholdDuration thresholdOccurrences } type violationTimeLimit } } } } } }",
    "variables": ""
}
"@

# Query the NerdGraph API
$results = ( Invoke-RestMethod -Method Post -Uri $nerdGraphUrl -ContentType 'application/json' -Headers $header -Body $nrqlConditionsQuery ).data.actor.account.alerts.nrqlConditionsSearch.nrqlConditions

RETURN $results

}

}
