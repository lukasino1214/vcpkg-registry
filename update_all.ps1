function update_vcpkg_port() {
    $name = $args[0]
    $n_versions = ($args.length - 1) / 3
    For ($i = 0; $i -lt $n_versions; $i++) {
        $arg_i = 1 + $i * 3
        $port_version = $args[$arg_i + 0]
        $port_path = "ports/$name/$port_version"
        $branch = $args[$arg_i + 2]
        $template_path = "ports/$name/templates/$($args[$arg_i + 1])"
        $template_portfile = Get-Content "$template_path/portfile.cmake"
        $template_manifest = Get-Content "$template_path/vcpkg.json"
        if (Test-Path -Path "$port_path") {
            Remove-Item "$port_path" -Recurse -Force | Out-Null
        }
        New-Item -Path "$port_path" -ItemType Directory | Out-Null
        if ("$template_portfile" -match 'URL ([^\s]*)') {
            $url = $Matches[1]
            $result = git ls-remote $url $branch
            $result = $result -split { $_ -match "[^0-9a-f]"}
            $hash = $result[0]
            ($template_portfile) ` -replace 'REF [^\n]*', "REF $hash" ` | Out-File $port_path/portfile.cmake -Encoding ascii
        } else {
            Copy-Item "$template_path/portfile.cmake" -Destination "$port_path/portfile.cmake" | Out-Null
        }
        ($template_manifest) ` -replace '"version": [^,]*', "`"version`": `"$port_version`"" ` | Out-File $port_path/vcpkg.json -Encoding ascii
    }
    $git_status = git status "ports/$name"
    if ("$git_status" -match 'Changes not staged') { 
        git add "ports/$name"
        git commit -m "Updated $name"
        $new_versionfile_content = "{`"versions`":["
        For ($i = 0; $i -lt $n_versions; $i++) {
            $arg_i = 1 + $i * 3
            $port_version = $args[$arg_i + 0]
            $port_path = "ports/$name/$port_version"
            $branch = $args[$arg_i + 2]
            $hash = git rev-parse HEAD:"$port_path"
            $name_first_char = $name[0]
            if ($i -gt 0) {
                $new_versionfile_content = "$new_versionfile_content,"
            }
            $new_versionfile_content = "$new_versionfile_content{`"version`": `"$port_version`",`"git-tree`": `"$hash`"}"
        }
        $new_versionfile_content = "$new_versionfile_content]}"
        "$new_versionfile_content" | Out-File "versions/$name_first_char-/$name.json" -Encoding ascii
        git add "versions/$name_first_char-/$name.json"
        git commit --amend --no-edit
    }
}

update_vcpkg_port    daxa    "0.1.0" "0" packaged    "1.0.0" "1" refs/tags/1.0.0-rc3
update_vcpkg_port    dxc     "0.1.2" "0" master
update_vcpkg_port    fsr2    "0.1.0" "0" refs/tags/v2.0.1a

git pull
git push

$new_commit_hash = git rev-parse HEAD
Write-Host "$new_commit_hash"
