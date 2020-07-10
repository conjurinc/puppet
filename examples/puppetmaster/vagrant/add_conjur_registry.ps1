# Add Conjur connection settings Windows registry
# Usage:
#     add_conjur_registry.ps1 <conjur-host-port>

param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [String]$conjurHostPort
)


$usage = @"
Usage:
    add_conjur_registry.ps1 <conjur-host-port>
"@

if (-not($conjurHostPort)) {
    echo "ERROR: <conjur-host-port> not provided on command line"
    echo $usage
    exit 1
}

reg ADD HKLM\Software\CyberArk\Conjur /f /v ApplianceUrl /t REG_SZ /d http://conjur:$conjurHostPort
reg ADD HKLM\Software\CyberArk\Conjur /f /v Version /t REG_DWORD /d 5
reg ADD HKLM\Software\CyberArk\Conjur /f /v Account /t REG_SZ /d cucumber
