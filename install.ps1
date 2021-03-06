param([String]$profileHost = 'Install')

$profileDir = "http://$profileHost/Install/profiles";

Write-Output 'Install Chocolatey';
if (-Not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));
}
else {
    Write-Output '  Chocolatey already installed';
}

Write-Output 'Install BoxStarter';
if ((choco list -lo | where { $_.ToLower().StartsWith("Boxstarter".ToLower()) } | measure).Count -eq 0) {
    &choco install Boxstarter -y;
    &'C:\ProgramData\Boxstarter\BoxstarterShell.ps1';
}
else {
    Write-Output '  Boxstarter already installed';
}

function Run-BoxStarter ($packageType) {
    $packageName = "$profileDir/$packageType.txt";
    Write-Host $packageName;
    Import-Module Boxstarter.Chocolatey
    Install-BoxstarterPackage -PackageName $packageName -DisableReboots
}

$endloop = $False;

while (-Not ($endloop)) {

$sysType = "";
    while ($sysType -eq "") {
        Write-Output "";
        Write-Output "";
    Write-Output "System Type";
    Write-Output "  Profiles:";
    Write-Output "  1 - Standard";
    Write-Output "  2 - Dev: Common";
    Write-Output "  3 - Dev: Mobile";
    Write-Output "  4 - Dev: Doc";
    Write-Output "  5 - Dev: Multimedia";
    Write-Output "";
    Write-Output "  Special:";
        Write-Output "  A - Arnav";
        Write-Output "  I - Ishan";
    Write-Output "";
        Write-Output "  X - Exit";
    Write-Output "";

    $sysType = read-host "Select profiles(s)";
}

    $nums = $sysType.split(",");

Write-Host $nums;

    ForEach ($answer in $nums) {

        # Required for Powershell 2.0
        $answer = $answer.Trim();

        $installtype = "";

        switch ($answer) {
            1 {$installtype = 'common'};
            2 {$installtype = 'dev-common'};
            3 {$installtype = 'dev-mobile'};
            4 {$installtype = 'dev-doc'};
            5 {$installtype = 'dev-media'};
       
            A {$installtype = 'sp-arnav'};
            I {$installtype = 'sp-Ishan'};
       
            X {
                Write-Host -ForegroundColor Yellow "Exiting";
                $endloop = $True;
                Exit;
            }
            default {
                Write-Host -ForegroundColor red "Invalid Selection";
                timeout 2;
            }
        }

        if (-Not($installtype -eq "")) {
            $endloop = $True;
            Run-BoxStarter($installtype);
        }

    }
}

# Write-Output "$profileDir/common.txt";

#$sysType = $Host.UI.PromptForChoice("System type", "What type of system is this?", [System.Management.Automation.Host.ChoiceDescription[]]@("&Standard", "&Developerment"), 0);

#Install-BoxstarterPackage -PackageName "common.txt" -DisableReboots
#if ($sysType -eq 0) {
#    &choco install firefox -y
#}

#if ($sysType -eq 1) {
#    Install-BoxstarterPackage -PackageName http://jain56/Install/dev.txt -DisableReboots
#}