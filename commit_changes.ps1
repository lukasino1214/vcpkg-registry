function CommitChanges {
    param (
        $Path
    )
    git add "ports/$Path"
    git commit -m "Updated $Path"
    $hash = git rev-parse HEAD:"ports/$Path"
    $path_first_char = $Path[0]
    $old_versionfile = Get-Content "versions/$path_first_char-/$Path.json"
    if ("$old_versionfile" -match '"git-tree": "[^\s]*"') {
        ($old_versionfile) ` -replace '"git-tree": "[^\s]*?"', "`"git-tree`": `"$hash`"" ` | Out-File "versions/$path_first_char-/$Path.json" -Encoding ascii
        git add "versions/$path_first_char-/$Path.json"
        git commit --amend --no-edit
    }
}

CommitChanges -Path daxa
