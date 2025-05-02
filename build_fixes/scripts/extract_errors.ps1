param(
  [Parameter(Mandatory)][string]$InputFile,
  [Parameter(Mandatory)][string]$OutputFile
)

# Read each raw error line, parse with named‐group regex, emit structured block
Get-Content $InputFile | ForEach-Object {
    if ($_ -match '^(?<file>[A-Za-z]:\\[^()]+)\((?<line>\d+)\):\s*error\s+(?<code>C\d+):\s*(?<message>.+)$') {
        "File: $($matches['file'])"
        "Line: $($matches['line'])"
        "Error code: $($matches['code'])"
        "Error text: $($matches['message'])"
        ""
    }
} | Set-Content $OutputFile
