$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot

python -m pip install piper-tts Pillow
if ($LASTEXITCODE) { throw 'pip install failed' }

if (-not (Get-Command ffmpeg -ErrorAction SilentlyContinue)) {
    winget install -e --id Gyan.FFmpeg
    if ($LASTEXITCODE) { throw 'ffmpeg install failed' }
}

$inkscapeBin = Join-Path $env:ProgramFiles 'Inkscape\bin'
if (-not (Get-Command inkscape -ErrorAction SilentlyContinue)) {
    if (-not (Test-Path (Join-Path $inkscapeBin 'inkscape.exe'))) {
        winget install -e --id Inkscape.Inkscape
        if ($LASTEXITCODE) { throw 'Inkscape install failed' }
    }
    # Installed but not on PATH; gen_assets.py calls `inkscape` by name.
    $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
    [Environment]::SetEnvironmentVariable('Path', "$userPath;$inkscapeBin", 'User')
    $env:Path += ";$inkscapeBin"
}

$voices = Join-Path $root 'voices'
New-Item -ItemType Directory -Path $voices -Force | Out-Null
$base = 'https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/ryan/high/en_US-ryan-high'
foreach ($ext in '.onnx', '.onnx.json') {
    $file = Join-Path $voices ("en_US-ryan-high" + $ext)
    if (-not (Test-Path $file)) {
        Invoke-WebRequest -Uri ($base + $ext + '?download=true') -OutFile $file
    }
}

$twemoji = Join-Path $root 'twemoji-svg'
if (-not (Test-Path (Join-Path $twemoji 'package'))) {
    New-Item -ItemType Directory -Path $twemoji -Force | Out-Null
    $tgz = npm pack @twemoji/svg --pack-destination $twemoji | Select-Object -Last 1
    if ($LASTEXITCODE) { throw 'npm pack failed' }
    tar -xzf (Join-Path $twemoji $tgz) -C $twemoji
    if ($LASTEXITCODE) { throw 'tar extract failed' }
    Remove-Item (Join-Path $twemoji $tgz)
}

# winget changes PATH only for new sessions.
Write-Output 'Done. Open a new terminal if ffmpeg or inkscape were just installed.'
