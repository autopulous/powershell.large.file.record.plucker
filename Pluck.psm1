<#
    .SYNOPSIS
        Display a range of newline delimited records from a file

    .DESCRIPTION
        Powershell cmdlet that extracts a range of records from a newline delimited file

    .EXAMPLE
        ./pluck.ps1 -start 500 -end 200 large.txt
        Plck records between 200 and 500 inclusive

    .EXAMPLE
        ./pluck.ps1 large.txt -start 10000 -count 50
        Pluck 50 records including and after record 10000

    .EXAMPLE
        ./pluck.ps1 large.txt -c 50 -cls
        Clear the scren and pluck the first 50 records

    .EXAMPLE
        ./pluck.ps1 -f large.txt -e 500 -index
        Pluck all records before and including record 500 with a line number index

    .EXAMPLE
        ./pluck.ps1 -s 700000 large.txt -cyan
        Pluck all records including and after record 700000 display in cyan
#>

# Get-Help -Name .\pluck.ps1 -Full
# Get-Help -Name .\pluck.ps1 -Detailed
# Get-Help -Name .\pluck.ps1 -Examples

function Pluck {
    Param (
        [Alias("f")]
        [Parameter(ParameterSetName=’file’,Position=1,Mandatory=$true)]
        [string]$file,
        [Alias("s")]
        [Parameter(ParameterSetName=’file’)]
        [int32]$start,
        [Alias("e")]
        [Parameter(ParameterSetName=’file’)]
        [int32]$end,
        [Alias("c")]
        [Parameter(ParameterSetName=’file’)]
        [int32]$count,

        [Alias("i")]
        [Parameter(ParameterSetName=’file’)]
        [switch]$index,

        [Parameter(ParameterSetName=’file’)]
        [switch]$cls,

        [Parameter(ParameterSetName=’file’)]
        [switch]$black,
        [Parameter(ParameterSetName=’file’)]
        [switch]$blue,
        [Parameter(ParameterSetName=’file’)]
        [switch]$cyan,
        [Parameter(ParameterSetName=’file’)]
        [switch]$darkblue,
        [Parameter(ParameterSetName=’file’)]
        [switch]$darkcyan,
        [Parameter(ParameterSetName=’file’)]
        [switch]$darkgray,
        [Parameter(ParameterSetName=’file’)]
        [switch]$darkgreen,
        [Parameter(ParameterSetName=’file’)]
        [switch]$darkmagenta,
        [Parameter(ParameterSetName=’file’)]
        [switch]$darkred,
        [Parameter(ParameterSetName=’file’)]
        [switch]$darkyellow,
        [Parameter(ParameterSetName=’file’)]
        [switch]$gray,
        [Parameter(ParameterSetName=’file’)]
        [switch]$green,
        [Parameter(ParameterSetName=’file’)]
        [switch]$magenta,
        [Parameter(ParameterSetName=’file’)]
        [switch]$red,
        [Parameter(ParameterSetName=’file’)]
        [switch]$yellow,
        [Parameter(ParameterSetName=’file’)]
        [switch]$white,

        [Alias("h")]
        [Parameter(ParameterSetName=’help’)]
        [switch]$help
    )

    if ($PSCmdlet.ParameterSetName.Equals("help")) {
        Invoke-Expression "Get-Help -Name Pluck -Full"
        Return
    }

    $color = "White"

    if ($black) {$color = "Black"}
    if ($blue) {$color = "Blue"}
    if ($cyan) {$color = "Cyan"}
    if ($darkblue) {$color = "DarkBlue"}
    if ($darkcyan) {$color = "DarkCyan"}
    if ($darkgray) {$color = "DarkGray"}
    if ($darkgreen) {$color = "DarkGreen"}
    if ($darkmagenta) {$color = "DarkMagenta"}
    if ($darkred) {$color = "DarkRed"}
    if ($darkyellow) {$color = "DarkYellow"}
    if ($gray) {$color = "Gray"}
    if ($green) {$color = "Green"}
    if ($magenta) {$color = "Magenta"}
    if ($red) {$color = "Red"}
    if ($yellow) {$color = "Yellow"}
    if ($white) {$color = "White"}

    if ($cls) {
        Clear-Host
    }
    else {
        Write-Host
    }

    try {
        $ErrorActionPreference = "Stop";
        $path = Resolve-Path -Path $file
    }
    catch {
        Write-Host "Error: " -ForegroundColor DarkYellow -NoNewline
        Write-Host "File $file doesn't exist"
        Exit
    }

    if ($end -gt 0) {
        if ($count -gt 0) {
            Write-Warning "Overriding -count value because -end value was passed" 
        }

        if ($start -gt $end) {
            $swap = $start
            $start = $end
            $end = $swap
        }

        $count = $end - $start + 1
    }


    $row = $start


    if ($count -lt 1) {
        $command = 'Get-Content $path | Select-Object -Skip $start'
    }
    else {
        $command = 'Get-Content $path | Select-Object -Skip $start -First $count'
    }
    
    foreach ($line in Invoke-Expression $command) {
        if ($index) {
            Write-Host $row $line -ForegroundColor $color
            $row += 1
        }
        else {
            Write-Host $line -ForegroundColor $color
        }
    }

    
    Write-Host
}

Export-ModuleMember -Function Pluck
