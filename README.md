[![New Relic Experimental header](https://github.com/newrelic/opensource-website/raw/master/src/images/categories/Experimental.png)](https://opensource.newrelic.com/oss-category/#new-relic-experimental)

# PowerRelic
PowerRelic is a [PowerShell script module](https://docs.microsoft.com/en-us/powershell/scripting/learn/ps101/10-script-modules?view=powershell-7) with various cmdlets used to interact with both [NerdGraph API](https://docs.newrelic.com/docs/apis/nerdgraph/get-started/introduction-new-relic-nerdgraph) and the [REST v2 API](https://docs.newrelic.com/docs/apis/rest-api-v2) for New Relic.

## Open source license

This project is distributed under the [Apache 2 license](LICENSE).

## What do you need to make this work?

### Required:

  * This module was built to be compatible with PowerShell v 6.0+ (aka "[PowerShell Core](https://github.com/PowerShell/PowerShell)") for cross-platform compatibility and to take advantage of the [-FollowRelLink](https://docs.microsoft.com/en-us/powershell/scripting/whats-new/what-s-new-in-powershell-core-60?view=powershell-7#web-cmdlets) switch added to the [Invoke-RestMethod](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-restmethod?view=powershell-7) cmdlet.

### Installation in PowerShell
```pwsh
# Clone the repository locally via HTTPS
git clone https://github.com/newrelic-experimental/powerrelic.git

# Or via SSH
# git clone git@github.com:newrelic-experimental/powerrelic.git

# Import the module into PowerShell
Import-Module -Name "./powerrelic/PowerRelic"

# Validate module was imported successfully
Get-Module -All | Where-Object { $_.Name -eq "PowerRelic" } | Format-List -Property Name, Description, ModuleBase, Version

# Get a list of available cmdlets
Get-Command -Module PowerRelic | Select-Object Name
```

  
# Support

New Relic has open-sourced this project. This project is provided AS-IS WITHOUT WARRANTY OR DEDICATED SUPPORT. Issues and contributions should be reported to the project here on GitHub.

# Issues / Enhancement Requests

Issues and enhancement requests can be submitted in the [Issues tab of this repository](../issues). Please search for and review the existing open issues before submitting a new issue.

# Contributing

Contributions are encouraged! If you submit an enhancement request, we'll invite you to contribute the change yourself. Please review our [Contributors Guide](CONTRIBUTING.md).

Keep in mind that when you submit your pull request, you'll need to sign the CLA via the click-through using CLA-Assistant.