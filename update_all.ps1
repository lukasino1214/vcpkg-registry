function update_vcpkg_port() {
    $name = $args[0]
    $n_versions = ($args.length - 1) / 3
    For ($i = 0; $i -lt $n_versions; $i++)
    {
        $arg_i = 1 + $i * 3
        $port_version = $args[$arg_i + 0]
        $port_path = "ports/$name/$port_version"
        $branch = $args[$arg_i + 2]
        $template_path = "ports/$name/templates/$($args[$arg_i + 1])"
        $template_portfile = Get-Content "$template_path/portfile.cmake"
        $template_manifest = Get-Content "$template_path/vcpkg.json"
        if ("$template_portfile" -match 'URL ([^\s]*)') {
            $url = $Matches[1]
            $result = git ls-remote $url $branch
            $result = $result -split { $_ -match "[^0-9a-f]"}
            $hash = $result[0]
            if (Test-Path -Path "$port_path") {
                Remove-Item "$port_path" -Recurse -Force
            }
            New-Item -Path "$port_path" -ItemType Directory
            ($template_portfile) ` -replace 'REF [^\n]*', "REF $hash" ` | Out-File $port_path/portfile.cmake -Encoding ascii
            ($template_manifest) ` -replace '"version": [^,]*', "`"version`": `"$port_version`"" ` | Out-File $port_path/vcpkg.json -Encoding ascii
        }
    }

    git add "ports/$name"
    git commit -m "Updated $name"

    $new_versionfile_content = "{`"versions`":["

    For ($i = 0; $i -lt $n_versions; $i++)
    {
        $arg_i = 1 + $i * 3
        $port_version = $args[$arg_i + 0]
        $port_path = "ports/$name/$port_version"
        $branch = $args[$arg_i + 2]
        $hash = git rev-parse $branch : $port_path
        $name_first_char = $name[0]
        Write-Host "$hash"

        # $old_versionfile = Get-Content "versions/$path_first_char-/$Path.json"
        # if ("$old_versionfile" -match '"git-tree": "[^\s]*"') {
        #     ($old_versionfile) ` -replace '"git-tree": "[^\s]*?"', "`"git-tree`": `"$hash`"" ` | Out-File "versions/$path_first_char-/$Path.json" -Encoding ascii
        #     git add "versions/$path_first_char-/$Path.json"
        #     git commit --amend --no-edit
        # }
    }

    # Out-File "versions/$name_first_char-/$name.json" -Encoding ascii $new_versionfile_content

}

update_vcpkg_port daxa    "0.1.0" 0 packaged    "1.0.0" 0 1.0
# HEAD 0 master
