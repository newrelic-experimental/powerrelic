[![New Relic Experimental header](https://github.com/newrelic/opensource-website/raw/master/src/images/categories/Experimental.png)](https://opensource.newrelic.com/oss-category/#new-relic-experimental)

# PowerRelic
PowerRelic is a [PowerShell script module](https://docs.microsoft.com/en-us/powershell/scripting/learn/ps101/10-script-modules?view=powershell-7) with various cmdlets used to interact with both [NerdGraph API](https://docs.newrelic.com/docs/apis/nerdgraph/get-started/introduction-new-relic-nerdgraph) and the [REST v2 API](https://docs.newrelic.com/docs/apis/rest-api-v2) for New Relic.

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

  
## Support

New Relic has open-sourced this project. This project is provided AS-IS WITHOUT WARRANTY OR DEDICATED SUPPORT. Issues and contributions should be reported to the project here on GitHub.

## Issues / Enhancement Requests

Issues and enhancement requests can be submitted in the [Issues tab of this repository](../../issues). Please search for and review the existing open issues before submitting a new issue.

## Privacy

At New Relic we take your privacy and the security of your information seriously, and are committed to protecting your information. We must emphasize the importance of not sharing personal data in public forums, and ask all users to scrub logs and diagnostic information for sensitive information, whether personal, proprietary, or otherwise.

We define “Personal Data” as any information relating to an identified or identifiable individual, including, for example, your name, phone number, post code or zip code, Device ID, IP address, and email address.

For more information, review [New Relic’s General Data Privacy Notice](https://newrelic.com/termsandconditions/privacy).

## Contribute

We encourage your contributions to improve PowerRelic! Keep in mind that when you submit your pull request, you'll need to sign the CLA via the click-through using CLA-Assistant. You only have to sign the CLA one time per project.

If you have any questions, or to execute our corporate CLA (which is required if your contribution is on behalf of a company), drop us an email at opensource@newrelic.com.

**A note about vulnerabilities**

As noted in our [security policy](../../security/policy), New Relic is committed to the privacy and security of our customers and their data. We believe that providing coordinated disclosure by security researchers and engaging with the security community are important means to achieve our security goals.

If you believe you have found a security vulnerability in this project or any of New Relic's products or websites, we welcome and greatly appreciate you reporting it to New Relic through [HackerOne](https://hackerone.com/newrelic).

If you would like to contribute to this project, review [these guidelines](./CONTRIBUTING.md).

To [all contributors](https://github.com/newrelic-experimental/powerrelic/graphs/contributors), we thank you!  Without your contribution, this project would not be what it is today.

## License

PowerRelic is licensed under the [Apache 2.0](http://apache.org/licenses/LICENSE-2.0.txt) License.