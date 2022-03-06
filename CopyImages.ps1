param(
    [Parameter(Mandatory=$false)]
    [string] $sourcePath = '.\Source',
    [parameter(Mandatory=$false)]
    [String] $destination = '.\Dest'
)

Get-ChildItem -Path $sourcePath -Include *.jpg, *.png -File -Recurse | ForEach-Object {
    $extensionNoPoint = $_.Extension -replace '[.]'
    $extensionDirectory = Join-Path $destination $extensionNoPoint.ToLower()
    $filePath = Join-Path -Path $extensionDirectory -ChildPath $_.Name


    # if the destination folder does not already exist, create it
    if (!(Test-Path -Path $extensionDirectory -PathType Container)) {
        $null = New-Item -Path $extensionDirectory -ItemType Directory
    }


    $_ | Copy-Item -Destination $filePath
}