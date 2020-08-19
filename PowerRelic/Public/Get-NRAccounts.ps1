<#
  .SYNOPSIS
  Queries New Relic for a list of accounts.
  
  .DESCRIPTION
  The Get-NRAccounts cmdlet queries NerdGraph a list of all accounts viewable by the user who owns the Personal API Key passed as a parameter.
  
  .PARAMETER PersonalAPIKey
  [REQUIRED] The Personal API Key to be used with the NerdGraph API.
  
  .OUTPUTS
  id: The account ID
  name: The account name

  .EXAMPLE
  PS> Get-NRAccounts -PersonalAPIKey 'NRAK-123456789ABCDEFGHIJKLMNOPQR'
  List all New Relic accounts you are authorized to view with your Personal API Key
#>
Function Get-NRAccounts {

    [ cmdletbinding() ]
    Param (
    
        [ Parameter ( Mandatory = $true ) ] [ string ] $PersonalAPIKey
    
    )

# Set the NerdGraph URL
$nerdGraphUrl = 'https://api.newrelic.com/graphql'

# Build our authentication header
$header = @{ 'API-Key' = $PersonalAPIKey }

# Build our query payload
$accountsQuery = @"
{
    "query": "{ actor { accounts{ id name } } }",
    "variables": ""
}
"@

# Query the NerdGraph API
$results = ( Invoke-RestMethod -Method Post -Uri $nerdGraphUrl -ContentType 'application/json' -Headers $header -Body $accountsQuery ).data.actor.accounts

RETURN $results

}
