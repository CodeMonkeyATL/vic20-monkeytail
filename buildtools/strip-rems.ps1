param(
    [Parameter(Mandatory = $true)]
    [string]$BasFile,
    [Parameter(Mandatory = $true)]
    [string]$OutFile
)

# writes a copy of a petcat source file without its rems, for the build: a line that holds only a rem
# is dropped, and a ":rem ..." at the end of a line is cut off. rems cost memory in the PRG (their text,
# plus 5 bytes for a line of their own), so the source keeps them and the PRG doesn't. The rem is found
# with the same tokenizer as check-basic.ps1, so a "rem" inside a string is left alone. check-basic.ps1
# warns when a goto/gosub/then targets a rem-only line, which this would remove.
# used by build-and-run.ps1 and the CI workflow (with pwsh), so local and CI builds stay byte-identical
. (Join-Path $PSScriptRoot 'basic-tokens.ps1')

$out = New-Object System.Collections.Generic.List[string]
foreach ($raw in [System.IO.File]::ReadAllLines($BasFile)) {
    if ($raw -match '^(\s*\d+\s?)(.*)$') {
        $prefix = $Matches[1]
        $text = $Matches[2]
    } else {
        # blank lines (petcat skips them) and unnumbered lines
        $prefix = ''
        $text = $raw
    }

    $rem = $null
    foreach ($t in (Get-Tokens $text)) {
        if ($t.Type -eq 'kw' -and $t.Text -eq 'rem') {
            $rem = $t
            break
        }
    }
    if ($null -eq $rem) {
        $out.Add($raw)
        continue
    }

    # the code before the rem, without the ":" that joined them
    $code = $text.Substring(0, $rem.Pos).TrimEnd()
    if ($code.EndsWith(':')) {
        $code = $code.Substring(0, $code.Length - 1)
    }
    if ($code -ne '') {
        $out.Add($prefix + $code)
    }
}
[System.IO.File]::WriteAllLines($OutFile, $out)
