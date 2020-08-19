<#
  .SYNOPSIS
  Queries New Relic for a list of New Relic One Catalog applications.
  
  .DESCRIPTION
  The Get-NR1Catalog cmdlet queries NerdGraph for a list of all applications in the New Relic One Application Catalog.
  
  .PARAMETER PersonalAPIKey
  [REQUIRED] The Personal API Key to be used with the NerdGraph API.
  
  .OUTPUTS
  id: Application ID
  metadata:
    .description: Short form description of the application
    .details: Long form description of the application
    displayName: Human-readable name of the application
    publishDate: DateTime the application was published
    repository: URL to the source code repository
    support: 
        .community.url: Link to the Explorer's Hub tag for this application
        .email.address: Address for email support
        .issues.url: Link to repository issues page
    version: Current application version
  visibility: Current application permissions for your accounts

  .EXAMPLE
  PS> Get-NR1Catalog -PersonalAPIKey 'NRAK-123456789ABCDEFGHIJKLMNOPQR'
  List all applications currently in the New Relic One Catalog
#>
Function Get-NR1Catalog {

    [ cmdletbinding() ]
    Param (
    
        [ Parameter ( Mandatory = $true ) ] [ string ] $PersonalAPIKey
    
    )

# Set the NerdGraph URL
$nerdGraphUrl = 'https://api.newrelic.com/graphql'

# Build our authentication header
$header = @{ 'API-Key' = $PersonalAPIKey }

# Build our query payload
$nerdpacksQuery = @"
{
    "query": "{ actor { nr1Catalog { nerdpacks { id visibility metadata { displayName publishDate repository support { community { url } email { address } issues { url } } version description details } } } } }",
    "variables": ""
}
"@

# Query the NerdGraph API
$results = ( Invoke-RestMethod -Method Post -Uri $nerdGraphUrl -ContentType 'application/json' -Headers $header -Body $nerdpacksQuery ).data.actor.nr1Catalog.nerdpacks

RETURN $results

}
