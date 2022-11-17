function update_vcpkg_port() {
    $name = $args[0]
    $n_versions = ($args.length - 1) / 3
    For ($i = 0; $i -lt $n_versions; $i++) {
        $arg_i = 1 + $i * 3
        $version_string = $args[$arg_i + 0]
        $port_path = "ports/$name/$version_string"
        $branch = $args[$arg_i + 2]
        $template_path = "ports/$name/templates/$($args[$arg_i + 1])"
        $template_portfile = Get-Content "$template_path/portfile.cmake"
        $template_manifest = Get-Content "$template_path/vcpkg.json"
        if (Test-Path -Path "$port_path") {
            Remove-Item "$port_path" -Recurse -Force | Out-Null
        }
        New-Item -Path "$port_path" -ItemType Directory | Out-Null
        if ("$template_manifest" -match '"port-version": ([^\s]*),') {
            $port_version = $Matches[1]
            $new_version = [int]$port_version + 1
            ($template_manifest) ` -replace '"port-version": [^\s]*,', "`"port-version`": $new_version," ` | Out-File $template_path/vcpkg.json -Encoding ascii
        }
        if ("$template_portfile" -match 'URL ([^\s]*)') {
            $url = $Matches[1]
            $result = git ls-remote $url $branch
            $result = $result -split { $_ -match "[^0-9a-f]"}
            $hash = $result[0]
            ($template_portfile) ` -replace 'REF [^\n]*', "REF $hash" ` | Out-File $port_path/portfile.cmake -Encoding ascii
            if ("$url" -match "https://github.com/(.*)") {
                $owner_and_repo = $Matches[1]
                # TODO: Figure out why I can't download a file through the script
                # Invoke-WebRequest -Uri "raw.githubusercontent.com/$owner_and_repo/$branch/vcpkg.json" -OutFile "$template_path/vcpkg.json"
            }
        } else {
            Copy-Item "$template_path/portfile.cmake" -Destination "$port_path/portfile.cmake" | Out-Null
        }
        $template_manifest = Get-Content "$template_path/vcpkg.json"
        ($template_manifest) ` -replace '"version-string": [^,]*', "`"version-string`": `"$version_string`"" ` | Out-File $port_path/vcpkg.json -Encoding ascii
    }
    $git_status = git status "ports/$name"
    if ("$git_status" -match 'Changes not staged') { 
        git add "ports/$name"
        git commit -m "Updated $name"
        $new_versionfile_content = "{`"versions`":["
        For ($i = 0; $i -lt $n_versions; $i++) {
            $arg_i = 1 + $i * 3
            $version_string = $args[$arg_i + 0]
            $port_path = "ports/$name/$version_string"
            $manifest = Get-Content "$port_path/vcpkg.json"
            $branch = $args[$arg_i + 2]
            $name_first_char = $name[0]
            if ($i -gt 0) {
                $new_versionfile_content = "$new_versionfile_content,"
            }
            $new_versionfile_content = "$new_versionfile_content{`"version-string`": `"$version_string`""
            if ("$template_manifest" -match '"port-version": ([^\s]*),') {
                $port_version = $Matches[1]
                $new_versionfile_content = "$new_versionfile_content,`"port-version`": $port_version"
            }
            $new_versionfile_content = "$new_versionfile_content,`"git-tree`": `"$hash`"}"
        }
        $new_versionfile_content = "$new_versionfile_content]}"
        "$new_versionfile_content" | Out-File "versions/$name_first_char-/$name.json" -Encoding ascii
        git add "versions/$name_first_char-/$name.json"
        git commit --amend --no-edit
    }
}

update_vcpkg_port    daxa     "0.0.1"   "0" packaged              "0.1.0" "1" 0.1.0       "nightly" "1" refs/heads/master
update_vcpkg_port    dxc      "0.1.2"   "0" refs/heads/master
update_vcpkg_port    fsr2     "2.0.0"   "0" refs/tags/v2.0.1a
update_vcpkg_port    glfw3    "custom"  "0" refs/heads/master
update_vcpkg_port    gvox     "nightly" "0" refs/heads/master
update_vcpkg_port    imnodes  "0.5.0"   "0" refs/tags/v0.5

git pull
git push

$new_commit_hash = git rev-parse HEAD
Write-Host "$new_commit_hash"
