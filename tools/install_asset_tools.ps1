$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot

python -m pip install piper-tts Pillow
if ($LASTEXITCODE) { throw 'pip install failed' }

if (-not (Get-Command ffmpeg -ErrorAction SilentlyContinue)) {
    winget install -e --id Gyan.FFmpeg
    if ($LASTEXITCODE) { throw 'ffmpeg install failed' }
}

if (-not (Get-Command inkscape -ErrorAction SilentlyContinue)) {
    winget install -e --id Inkscape.Inkscape
    if ($LASTEXITCODE) { throw 'Inkscape install failed' }
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

# winget changes PATH only for new sessions.
Write-Output 'Done. Open a new terminal if ffmpeg or inkscape were just installed.'
