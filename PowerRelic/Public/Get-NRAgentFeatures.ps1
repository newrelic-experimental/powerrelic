<#
  .SYNOPSIS
  Returns a list of features for chosen agent.
  
  .DESCRIPTION
  The Get-NRAgentFeatures cmdlet queries NerdGraph for a list of all features and their minimum version requirement across various agents.
  
  .PARAMETER PersonalAPIKey
  [REQUIRED] The Personal API Key to be used with the NerdGraph API.
  
  .PARAMETER AgentName
  [REQUIRED] The New Relic Agent to be queried against.
  
  .OUTPUTS
  minVersion: The minimum agent version required for this feature
  name: The name of this feature

  .EXAMPLE
  PS> Get-NRAgentFeatures -PersonalAPIKey 'NRAK-123456789ABCDEFGHIJKLMNOPQR' -AgentName DOTNET
  Find and list all features for the DOTNET agent
#>
Function Get-NRAgentFeatures {

    [ cmdletbinding() ]
    Param (
    
        [ Parameter ( Mandatory = $true ) ] [ string ] $PersonalAPIKey,
        [ Parameter ( Mandatory = $true ) ] [ ValidateSet( 'DOTNET','GO','HTML','JAVA','MOBILE','NODEJS','PHP','PYTHON','RUBY','SDK' ) ] [ string ] $AgentName
    
    )

# Set the NerdGraph URL
$nerdGraphUrl = 'https://api.newrelic.com/graphql'

# Build our authentication header
$header = @{ 'API-Key' = $PersonalAPIKey }

# Build our query payload
$featuresQuery = @"
{
    "query": "{ docs { agentFeatures( agentName: $AgentName) { minVersion name } } }",
    "variables": ""
}
"@

# Query the NerdGraph API
$results = ( Invoke-RestMethod -Method Post -Uri $nerdGraphUrl -ContentType 'application/json' -Headers $header -Body $featuresQuery ).data.docs.agentFeatures

RETURN $results

}
