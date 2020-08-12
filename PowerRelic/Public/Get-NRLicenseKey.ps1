<#
  .SYNOPSIS
  Queries an account for the current license key.
  
  .DESCRIPTION
  The Get-NRLicenseKey cmdlet queries NerdGraph for the current license key assigned to an account.
  
  .PARAMETER PersonalAPIKey
  [REQUIRED] The Personal API Key to be used with the NerdGraph API.
  
  .PARAMETER AccountID
  [REQUIRED] The New Relic Account ID to be queried against.
  
  .OUTPUTS
  licenseKey: The New Relic license key

  .EXAMPLE
  PS> Get-NRLicenseKey -PersonalAPIKey 'NRAK-123456789ABCDEFGHIJKLMNOPQR' -AccountID 1234567
  Find the New Relic license key for Account ID 1234567
#>
Function Get-NRLicenseKey {

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
    "query": "{ actor { account(id: $AccountID) { licenseKey } } }",
    "variables": ""
}
"@

# Query the NerdGraph API
$results = ( Invoke-RestMethod -Method Post -Uri $nerdGraphUrl -ContentType 'application/json' -Headers $header -Body $providersQuery ).data.actor.account

RETURN $results

}
