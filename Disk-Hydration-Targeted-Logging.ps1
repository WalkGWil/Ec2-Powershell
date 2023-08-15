param (
    $myFolder
)

## Get script Name
$scriptName = $MyInvocation.MyCommand.Name

# Log event info
$eventLogName = "Application"
$LogSourceName = "Disk Hydration"
$eventId = 42001
$entryType = "Information"
$message = "42001 disk hydration begins.  ver.20230721-0436-22 includes apppath"
$messageend = "42999 disk hydration ends. ver.20230721-0436-22 includes apppath"

#Function to write event to log
function Write-Event {
    param (
        [Parameter(Mandatory=$true)]
        [string]$LogSourceName,

        [Parameter(Mandatory=$true)]
        [int]$EventID,

        [Parameter(Mandatory=$true)]
        [string]$EventMessage
    )

    # Check Log Source and create if not exist
    $checksource = Get-ChildItem HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\Application
    if (!($LogSourceNameExist = Test-Path "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\Application\$LogSourceName"))
    {
    New-EventLog -Source $LogSourceName -LogName Application
    }

    # create event
    Write-EventLog -Source $LogSourceName -LogName Application -EventID $EventID -EntryType Information `
        -Message $EventMessage

}

# Function to process files recursively
function Get-FilesRecursively {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path
    )

    # Get all files in the current directory
    $files = Get-ChildItem -Path $Path -File

    # Process each file
    foreach ($file in $files) {
        # Output the file path to nul
        $file.FullName | Out-Null
        write-progress -Activity "Reading $path"-CurrentOperation $file
    }

    # Get all directories in the current directory
    $directories = Get-ChildItem -Path $Path -Directory

    # Recursively process files in each directory
    foreach ($directory in $directories) {
        Get-FilesRecursively -Path $directory.FullName
        write-progress -Activity "Reading $path"-CurrentOperation $directory
    }
}

#Function to get number of running PowerShell processes
function Get-NumofProcess {
    param (
        [Parameter(Mandatory=$true)]
        [string]$exename
    )

    $getnum = (Get-Process | Where-Object {$_.Name -eq ‘powershell'}).count
    $result = $getnum
    return $result
}

#Start all sub processes and create start logs for them
if (-not $myFolder) {
    Write-Event -LogSourceName $scriptName -EventID 42001 -EventMessage "Begin Reading all designated folders and files."

    ## Comment out sections based on what directories you need to hydrate

    ##$rootPath = "C:"
    ##Write-Event -LogSourceName $scriptName -EventID 42101 -EventMessage "Reading $($loc1)"
    ##$loc1 = "$($env:SystemRoot)\system32\WindowsPowerShell\v1.0\powershell.exe $($PSScriptRoot)\$($scriptName) -myFolder `"$($rootPath)`""
    ##Start-Process -Filepath powershell.exe -ArgumentList $($loc1)

    $rootPathWin = "C:\Windows"
    Write-Event -LogSourceName $scriptName -EventID 42201 -EventMessage "Reading $($loc2)"
    $loc2 = "$($env:SystemRoot)\system32\WindowsPowerShell\v1.0\powershell.exe $($PSScriptRoot)\$($scriptName) -myFolder `"$($rootPathWin)`""
    Start-Process -Filepath powershell.exe -ArgumentList $($loc2)

    $rootPathPF = "c:\Progra~1"
    #Write-Event -LogSourceName $scriptName -EventID 42301 -EventMessage "Reading $($loc3)"
    #$loc3 = "$($env:SystemRoot)\system32\WindowsPowerShell\v1.0\powershell.exe $($PSScriptRoot)\$($scriptName) -myFolder `"`"$($rootPathPF)`"`""
    #Start-Process -Filepath powershell.exe -ArgumentList $($loc3)

    ##$rootPathPF86 = "c:\Progra~2"
    #Write-Event -LogSourceName $scriptName -EventID 42401 -EventMessage "Reading $($loc4)"
    #$loc4 = "$($env:SystemRoot)\system32\WindowsPowerShell\v1.0\powershell.exe $($PSScriptRoot)\$($scriptName) -myFolder `"$($rootPathPF86)`""
    #Start-Process -Filepath powershell.exe -ArgumentList $($loc4)

    $mainAppPath = "c:\eclipse"
    Write-Event -LogSourceName $scriptName -EventID 42501 -EventMessage "Reading $($loc5)"
    $loc5 = "$($env:SystemRoot)\system32\WindowsPowerShell\v1.0\powershell.exe $($PSScriptRoot)\$($scriptName) -myFolder `"$($mainAppPath)`""
    Start-Process -Filepath powershell.exe -ArgumentList $($loc5)
}

#Start resursive reads to NULL
else {

    Write-Event -LogSourceName $scriptName -EventID 42001 -EventMessage "Read for $($myFolder) begins now. ver.20230721-2011-38 includes apppath."

    Write-Output "This script is recursively reading:"
    Write-Output $myFolder

    Get-FilesRecursively -Path $myFolder

    # find number of processes running
        Write-Output ""
        Start-Sleep -Seconds 5
        $numofdd = Get-NumofProcess -exename "powershell"
        Write-Output "number of powershell running is: $($numofdd)"
}

# Loop to find number of powershell running
    Start-Sleep -Seconds 5
    $numofdd = Get-NumofProcess -exename "powershell"
    Write-Output "number of ps running is: $($numofdd)"

    Start-Sleep -Seconds 5
    $numofdd = Get-NumofProcess -exename "powershell"
    Write-Output "number of ps running is: $($numofdd)"

    Start-Sleep -Seconds 5
    $numofdd = Get-NumofProcess -exename "powershell"
    Write-Output "number of ps running is: $($numofdd)"


 #Sleep until all running subprocesses end
 if (-not $myFolder) {
    while ($numofdd -gt 1 ) {

        Start-Sleep -Seconds 3
        $result= Get-NumofProcess -exename "powershell"
        $numofdd = $result
        $result
    }
}

#End log of sub processes
if ($myfolder) {
    Write-Event -LogSourceName $scriptName -EventID 42899 -EventMessage "Read of $($myFolder) ending now."
    }

#End log of main process
else {
    Write-Event -LogSourceName $scriptName -EventID 42999 -EventMessage "Recursive read ending now."
}