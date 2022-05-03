function UpdateVcpkgPort {
    param (
        $Path,
        $Branch
    )
    $old_portfile = Get-Content "$Path/portfile.cmake"
    if ("$old_portfile" -match 'URL ([^\s]*)') {
        $url = $Matches[1]
        $result = git ls-remote $url $Branch
        $result = $result -split { $_ -match "[^0-9a-f]"}
        $hash = $result[0]
        ($old_portfile) ` -replace 'REF [^\n]*', "REF $hash" ` | Out-File $Path/portfile.cmake -Encoding ascii
    }
}

UpdateVcpkgPort -Path ports/daxa/ -Branch packaged
