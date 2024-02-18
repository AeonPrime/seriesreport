# Define the paths
$seriesDirectory = "F:\TV Series"
$reportFilePath = "F:\TV Series Report.txt"
$exclusionFilePath = "F:\exclusion.txt"

# Ensure the exclusion file exists, or create it if it doesn't
if (-not (Test-Path $exclusionFilePath)) {
    New-Item -Path $exclusionFilePath -ItemType File
}

# Read the exclusion list, if any
$excludedSeries = Get-Content -Path $exclusionFilePath

# Ensure the report file is empty or create it if it doesn't exist
if (Test-Path $reportFilePath) {
    Clear-Content $reportFilePath
} else {
    New-Item -Path $reportFilePath -ItemType File
}

# List of acceptable video file extensions
$acceptableExtensions = @('.mkv', '.mp4', '.avi', '.mov')

# Get all series directories, excluding the ones listed in exclusion.txt
$seriesFolders = Get-ChildItem -Path $seriesDirectory -Directory | Where-Object { $excludedSeries -notcontains $_.Name }

foreach ($series in $seriesFolders) {
    $reportEntries = @()

    # Initialize check variables
    $season1Exists = $false
    $filesInRoot = @()
    $emptyFolders = @()
    $incorrectFiles = @()
    $looseSubtitles = @()

    # Perform checks
    foreach ($item in (Get-ChildItem -Path $series.FullName)) {
        if ($item.PSIsContainer) {
            # Check for empty folders
            if ((Get-ChildItem -Path $item.FullName).Count -eq 0) {
                $emptyFolders += $item.Name
            }

            # Season folder specific checks
            if ($item.Name -match "Season (\d+)") {
                $seasonNumber = $matches[1]
                if ($seasonNumber -eq 1) {
                    $season1Exists = $true
                }

                # Check for .srt files in season folders
                $srtFiles = Get-ChildItem -Path $item.FullName -Filter "*.srt"
                if ($srtFiles.Count -gt 0) {
                    $looseSubtitles += $item.Name
                }
            }
        } else {
            $filesInRoot += $item
            # Check for incorrect file types
            if ($acceptableExtensions -notcontains $item.Extension) {
                $incorrectFiles += $item.Name
            }
        }
    }

    # Summarize and format report entries
    if (!$season1Exists) { $reportEntries += "Missing 'Season 1' folder" }
    if ($filesInRoot.Count -gt 0) { $reportEntries += "Contains files directly in root" }
    if ($emptyFolders.Count -gt 0) { $reportEntries += "Empty folders: $($emptyFolders -join ', ')" }
    if ($incorrectFiles.Count -gt 0) { $reportEntries += "Incorrect file types: $($incorrectFiles -join ', ')" }
    if ($looseSubtitles.Count -gt 0) { $reportEntries += "Loose subtitles in: $($looseSubtitles -join ', ')" }

    # Write report entries for the current series
    if ($reportEntries.Count -gt 0) {
        "$($series.Name):" | Out-File -FilePath $reportFilePath -Append
        foreach ($entry in $reportEntries) {
            "`t- $entry" | Out-File -FilePath $reportFilePath -Append
        }
        "`n" | Out-File -FilePath $reportFilePath -Append
    }
}

Write-Host "TV Series report generated at $reportFilePath"
