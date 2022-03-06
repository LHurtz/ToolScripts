param(
    [Parameter(Mandatory=$false)]
    [string] $sourcePath = '.\Source',
    [parameter(Mandatory=$false)]
    [String] $destination = '.\Dest'
)

function CopyFile
{
    param
    (
        [parameter(Mandatory=$true)]
        [System.IO.FileInfo] $file
    )
    process
    {
        $extensionNoPoint = $file.Extension -replace '[.]'
        $extensionDirectory = Join-Path $destination $extensionNoPoint.ToLower()
        $filePath = Join-Path -Path $extensionDirectory -ChildPath $file.Name

        # if the destination folder does not already exist, create it
        if (!(Test-Path -Path $extensionDirectory -PathType Container)) {
            $null = New-Item -Path $extensionDirectory -ItemType Directory
        }

        $file | Copy-Item -Destination $filePath
    }
}

$counter = 0;
$loggingIncrement = 100;

function LogProgress
{
    $script:counter++

    if ($script:counter % $loggingIncrement -eq 0)
    {
        $percentage = [int]($script:counter / $fileCount * 100)

        Write-Progress -Activity "Kopiere Dateien" -Status "$script:counter of $fileCount files copied" -PercentComplete $percentage
    }
}

$files = Get-ChildItem -Path $sourcePath -Include *.jpg, *.png -File -Recurse
$fileCount = $files.Count

Write-Host "$fileCount Files to copy"

foreach ($file in $files) {
    CopyFile -file $file
    LogProgress
}