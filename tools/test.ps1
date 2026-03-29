param(
  [Alias('c')]
  [string]$Config = "_config.yml",

  [Alias('h')]
  [switch]$Help
)

if ($Help) {
  Write-Host "Build and test the site content"
  Write-Host ""
  Write-Host "Usage:"
  Write-Host ""
  Write-Host "  powershell -File ./tools/test.ps1 [-Config \"config_a[,config_b[...]]\"]"
  exit 0
}

$ErrorActionPreference = 'Stop'

$siteDir = "_site"
$baseUrl = ""

# Ensure common runtime tool locations are available when launched from VS Code tasks.
$pathPrefixes = @(
  "C:\\Ruby33-x64\\msys64\\ucrt64\\bin",
  "C:\\Ruby33-x64\\bin",
  "C:\\Program Files\\nodejs"
)
$env:Path = ($pathPrefixes -join ';') + ';' + $env:Path

# html-proofer on Windows may look for libcurl.dll specifically.
$curlDll = "C:\\Ruby33-x64\\msys64\\ucrt64\\bin\\libcurl.dll"
$curl4Dll = "C:\\Ruby33-x64\\msys64\\ucrt64\\bin\\libcurl-4.dll"
if (-not (Test-Path $curlDll) -and (Test-Path $curl4Dll)) {
  Copy-Item -Path $curl4Dll -Destination $curlDll -Force
}

if ($Config.Contains(',')) {
  $configArray = $Config -split ','
  for ($i = $configArray.Length - 1; $i -ge 0; $i--) {
    $configPath = $configArray[$i].Trim()
    if (-not (Test-Path $configPath)) {
      continue
    }

    $line = Select-String -Path $configPath -Pattern '^\s*baseurl\s*:\s*(.+)$' | Select-Object -First 1
    if ($line) {
      $tmp = $line.Matches[0].Groups[1].Value
      $tmp = $tmp -replace '["''#]', ''
      $tmp = $tmp.Trim()
      if ($tmp) {
        $baseUrl = $tmp
        break
      }
    }
  }
} else {
  if (Test-Path $Config) {
    $line = Select-String -Path $Config -Pattern '^\s*baseurl\s*:\s*(.+)$' | Select-Object -First 1
    if ($line) {
      $tmp = $line.Matches[0].Groups[1].Value
      $tmp = $tmp -replace '["''#]', ''
      $baseUrl = $tmp.Trim()
    }
  }
}

if (Test-Path $siteDir) {
  Remove-Item -Path $siteDir -Recurse -Force
}

$env:JEKYLL_ENV = 'production'
& bundle exec jekyll b -d ("$siteDir$baseUrl") -c $Config

& bundle exec htmlproofer $siteDir `
  --disable-external `
  --ignore-urls "/^http:\/\/127.0.0.1/,/^http:\/\/0.0.0.0/,/^http:\/\/localhost/"
