<#
  .SYNOPSIS
  Queries New Relic for a list of workloads.
  
  .DESCRIPTION
  The Get-NRWorkloads cmdlet queries NerdGraph for a list of all workloads assigned to an account.
  
  .PARAMETER PersonalAPIKey
  [REQUIRED] The Personal API Key to be used with the NerdGraph API.
  
  .PARAMETER AccountID
  [REQUIRED] The New Relic Account ID to be queried against.
  
  .OUTPUTS
  createdAt: The DateTime (epoch) this workload was created
  createdBy:
      .email: The user's email address who created this workload
      .id: The user's ID who created this workload
      .name: The user's name who created this workload
  guid: The GUID of this workload
  name: The display name of this workload
  permalink: The permalink URL of this workload
  scopeAccounts:
      .accountIds: List of accounts that will be used to get entities from
  updatedAt: The DateTime (epoch) this workload was last updated

  .EXAMPLE
  PS> Get-NRWorkloads -PersonalAPIKey 'NRAK-123456789ABCDEFGHIJKLMNOPQR' -AccountID 1234567
  List all workloads currently in account 1234567
#>
Function Get-NRWorkloads {

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
$workloadsQuery = @"
{
    "query": "{ actor { account(id: $AccountID) { workload { collections { createdAt createdBy { email id name } guid name permalink scopeAccounts { accountIds } updatedAt } } } } }",
    "variables": ""
}
"@

# Query the NerdGraph API
$results = ( Invoke-RestMethod -Method Post -Uri $nerdGraphUrl -ContentType 'application/json' -Headers $header -Body $workloadsQuery ).data.actor.account.workload.collections

RETURN $results

}
