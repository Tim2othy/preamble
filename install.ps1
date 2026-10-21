# Links this folder into Typst's local package directory, so that
#   #import "@local/preamble:<version>": *
# works in any document on this machine. Edits here take effect immediately.
# Re-run after moving this folder or bumping the version in typst.toml.

$version = (Select-String -Path "$PSScriptRoot\typst.toml" -Pattern '^version\s*=\s*"(.+)"').Matches[0].Groups[1].Value
$target = Join-Path $env:APPDATA "typst\packages\local\preamble\$version"

New-Item -ItemType Directory -Force (Split-Path $target) | Out-Null
if (Test-Path $target) {
    $item = Get-Item $target -Force
    if ($item.LinkType -ne "Junction") {
        throw "$target exists and is not a link. Remove it by hand if you want to replace it."
    }
    # Removes only the link, never the files it points to
    [System.IO.Directory]::Delete($target)
}
New-Item -ItemType Junction -Path $target -Target $PSScriptRoot | Out-Null
Write-Host "@local/preamble:$version -> $PSScriptRoot"
