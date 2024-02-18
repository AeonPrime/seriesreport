## Why this exists at all
I have been maintaining a plex/emby setup for a few years now and so far I've done literally everything by hand when it comes to sorting and organizing the files. This has led to a few mistakes over the years and I couldn't be asked to browse 400+ folders just to miss them. So I sat down and hammered together a PowerShell script.
Now I'm just, a hobby programmer and there are certainly better ways of doing this, but it's fast and it works. 

## Important notes!
This script does NOT modify or attempt to correct anything, it just generates the output file with the issues! This is just a ToDo list or report. 
You need to set your file paths! This isn't perfect and requires some setup, but you can set all parameters at the top of the script.
This script just checks FOLDER Structures and file types, it does NOT care about file naming conventions!
## Main Features
- Season 1 Check: Verifies the presence of a "Season 1" folder for each TV series. (for those new series where I just create the series folder and dumped the season 1 content directly into the main series folder...) (Side note, I use "Season 1" instead of "Season 01" so the script looks for this.)
- Root Files Check: Detects any files located directly in the series' root folder. (forgotten zip files, etc)
- Season Gaps Check: Identifies missing seasons by checking the sequence of season numbers.
- Empty Folders Check: Finds any empty series folders or season subfolders.
- Incorrect File Types Check: Flags any files that don't match common video formats (.mkv, .mp4, .avi, .mov).
- Loose Subtitles Check: Lists season folders containing loose .srt subtitle files. (I added this since I am currently embedding all subtitles into their respective episodes into MKV files)
- Exclusion List: Allows specifying series folders to be excluded from checks via an "exclusion.txt" file. Each line in the file specifies a Series name (needs to be precisely the series folder name, not the full path!)
## How do I make it spin?
To set up the script download it from GitHub  and adjust the file paths at the top of the script. The script can be placed anywhere and the report/exclusion files can be set separately. Provide full paths for everything!
The script follows Plex's/Emby's folder naming/sorting conventions
Series -> Adventure Time -> Season 1
Series -> Rick and Morty -> Season 1
So if your structure is different than this, this will not work and probably just list your entire folder structure as one big mistake. Sit down and think about your choices. 
## Flaws
So far I've ran into issues with series that don't follow the conventional naming scheme/release cycle of seasons. For example Popeye or Tom and Jerry (the original series) are grouped by release decade , 1940, 1950 for example. Since those are the outliers I chose to implement the exclusion file. I also haven't tried to see what happens if you try to run this for a UNC path on the network, since I run it locally on my machine. I would assume it works the same but no promises.
