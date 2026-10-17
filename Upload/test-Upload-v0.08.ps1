# ============================================================================
# Cloudflare Speed Tester Pro + Stage 0 DPI Bypass Pre-check
# Pure ASCII / Ultra Reliability Edition for Windows PowerShell 5.1 & Core
# Auto-Cleanup & Safe Process Killer Engine Enabled
# ============================================================================

# ----------------------------------------------------------------------------
# Determine Directories and Setup Paths
# ----------------------------------------------------------------------------
$CurrentDir = $PSScriptRoot
if ([string]::IsNullOrEmpty($CurrentDir)) { $CurrentDir = (Get-Location).Path }

$ConfigFile   = Join-Path $CurrentDir "config.json"
$ConfigSample = Join-Path $CurrentDir "config.example.json"
$IpFilePath   = Join-Path $CurrentDir "ip.txt"
$TempCsvPath  = Join-Path $CurrentDir "temp_data.csv"
$FinalCsvPath = Join-Path $CurrentDir "final_report.csv"
$FinalTxtPath = Join-Path $CurrentDir "final_report.txt"

function Safe-Pause {
    if ([Environment]::UserInteractive -and -not [Console]::IsInputRedirected) {
        Write-Host "`nPress any key to continue..." -ForegroundColor Yellow
        try {
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        } catch {
            $null = $Host.UI.ReadLine()
        }
    }
}

# ----------------------------------------------------------------------------
# Configuration Loader (Secure & Privacy-friendly for Public Release)
# ----------------------------------------------------------------------------
$Domain              = "your-worker.your-subdomain.workers.dev"
$VlessLink           = ""
$EnableXrayTest      = $true
$UploadViaXray       = $false
$EnableFragmentation = $true
$FragmentPackets     = "1-3"
$FragmentLength      = "100-200"
$FragmentInterval    = "10-20"
$DpiTestUrl          = "http://www.google.com/generate_204"
$FileSizeMB          = 10
$UploadTimeSec       = 10
$TestRounds          = 3
$HandshakeRounds     = 4
$PingCount           = 6
$MaxJobs             = 4
$PayloadName         = "upload_payload.dat"

if (Test-Path $ConfigFile) {
    try {
        $jsonContent = Get-Content -Path $ConfigFile -Raw -Encoding UTF8 -ErrorAction Stop
        $cfg = ConvertFrom-Json $jsonContent -ErrorAction Stop
        if ($cfg.Domain)                        { $Domain              = [string]$cfg.Domain }
        if ($cfg.VlessLink)                     { $VlessLink           = [string]$cfg.VlessLink }
        if ($null -ne $cfg.EnableXrayTest)      { $EnableXrayTest      = [bool]$cfg.EnableXrayTest }
        if ($null -ne $cfg.UploadViaXray)       { $UploadViaXray       = [bool]$cfg.UploadViaXray }
        if ($null -ne $cfg.EnableFragmentation) { $EnableFragmentation = [bool]$cfg.EnableFragmentation }
        if ($cfg.FragmentPackets)               { $FragmentPackets     = [string]$cfg.FragmentPackets }
        if ($cfg.FragmentLength)                { $FragmentLength      = [string]$cfg.FragmentLength }
        if ($cfg.FragmentInterval)              { $FragmentInterval    = [string]$cfg.FragmentInterval }
        if ($cfg.DpiTestUrl)                    { $DpiTestUrl          = [string]$cfg.DpiTestUrl }
        if ($cfg.FileSizeMB)                    { $FileSizeMB          = [int]$cfg.FileSizeMB }
        if ($cfg.UploadTimeSec)                 { $UploadTimeSec       = [int]$cfg.UploadTimeSec }
        if ($cfg.TestRounds)                    { $TestRounds          = [int]$cfg.TestRounds }
        if ($cfg.HandshakeRounds)               { $HandshakeRounds     = [int]$cfg.HandshakeRounds }
        if ($cfg.PingCount)                     { $PingCount           = [int]$cfg.PingCount }
        if ($cfg.MaxJobs)                       { $MaxJobs             = [int]$cfg.MaxJobs }
        if ($cfg.PayloadName)                   { $PayloadName         = [string]$cfg.PayloadName }
    } catch {
        Write-Host "[WARN] Failed to parse config.json: $_. Using defaults." -ForegroundColor Yellow
    }
} else {
    # Generate template config.json if not found
    $template = [ordered]@{
        Domain              = $Domain
        VlessLink           = $VlessLink
        EnableXrayTest      = $EnableXrayTest
        UploadViaXray       = $UploadViaXray
        EnableFragmentation = $EnableFragmentation
        FragmentPackets     = $FragmentPackets
        FragmentLength      = $FragmentLength
        FragmentInterval    = $FragmentInterval
        DpiTestUrl          = $DpiTestUrl
        FileSizeMB          = $FileSizeMB
        UploadTimeSec       = $UploadTimeSec
        TestRounds          = $TestRounds
        HandshakeRounds     = $HandshakeRounds
        PingCount           = $PingCount
        MaxJobs             = $MaxJobs
        PayloadName         = $PayloadName
    }
    $template | ConvertTo-Json -Depth 4 | Out-File -FilePath $ConfigFile -Encoding UTF8
    Write-Host "[INFO] Generated new template configuration at: $ConfigFile" -ForegroundColor Cyan
}

$PayloadPath = Join-Path $CurrentDir $PayloadName

# ----------------------------------------------------------------------------
# Locate Executables with Space-Safe Handling
# ----------------------------------------------------------------------------
$CurlExe = "$env:SystemRoot\System32\curl.exe"
if (-not (Test-Path $CurlExe)) {
    $cmdCurl = Get-Command curl.exe -ErrorAction SilentlyContinue
    if ($cmdCurl) { $CurlExe = $cmdCurl.Source }
}
if (-not $CurlExe -or -not (Test-Path $CurlExe)) {
    Write-Host "[ERROR] curl.exe not found on system." -ForegroundColor Red
    Safe-Pause
    exit
}

$XrayExe = Join-Path $CurrentDir "xray.exe"
if (-not (Test-Path $XrayExe)) {
    $cmdXray = Get-Command xray.exe -ErrorAction SilentlyContinue
    if ($cmdXray) { $XrayExe = $cmdXray.Source }
}
if ($EnableXrayTest) {
    if (-not $XrayExe -or -not (Test-Path $XrayExe)) {
        Write-Host "[ERROR] xray.exe not found in script folder ($CurrentDir)." -ForegroundColor Red
        Safe-Pause
        exit
    }
}
$Global:XrayExePath = $XrayExe

# ----------------------------------------------------------------------------
# Thread-Safe Process Tracking Collection & High-Reliability Cleanup
# ----------------------------------------------------------------------------
$Global:TrackedXrayPids = [System.Collections.ArrayList]::Synchronized((New-Object System.Collections.ArrayList))

function Global:Cleanup-AllResources {
    param([string]$TargetXrayPath)

    if ([string]::IsNullOrEmpty($TargetXrayPath)) {
        $TargetXrayPath = $Global:XrayExePath
    }

    # 1. Terminate all explicitly tracked xray processes initiated by this script
    if ($Global:TrackedXrayPids) {
        $pidsList = @($Global:TrackedXrayPids)
        foreach ($itemPid in $pidsList) {
            try {
                $p = Get-Process -Id $itemPid -ErrorAction SilentlyContinue
                if ($p -and -not $p.HasExited) {
                    $p.Kill()
                    $p.WaitForExit(300) | Out-Null
                }
            } catch {}
            try {
                Stop-Process -Id $itemPid -Force -ErrorAction SilentlyContinue
            } catch {}
            try {
                Start-Process -FilePath "taskkill.exe" -ArgumentList "/F /PID $itemPid /T" -WindowStyle Hidden -Wait -ErrorAction SilentlyContinue | Out-Null
            } catch {}
        }
        $Global:TrackedXrayPids.Clear()
    }

    # 2. Terminate any orphan xray.exe running specifically from this directory
    if (-not [string]::IsNullOrEmpty($TargetXrayPath) -and (Test-Path $TargetXrayPath)) {
        try {
            $procs = Get-Process -Name "xray" -ErrorAction SilentlyContinue
            foreach ($proc in $procs) {
                $isTarget = $false
                try {
                    if ($proc.Path -and ($proc.Path -eq $TargetXrayPath)) {
                        $isTarget = $true
                    }
                } catch {
                    # If reading Path fails due to permissions (e.g. system VPN service), skip it safely!
                    $isTarget = $false
                }

                if ($isTarget) {
                    try {
                        $proc.Kill()
                        $proc.WaitForExit(300) | Out-Null
                    } catch {}
                    try {
                        Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
                    } catch {}
                    try {
                        Start-Process -FilePath "taskkill.exe" -ArgumentList "/F /PID $($proc.Id) /T" -WindowStyle Hidden -Wait -ErrorAction SilentlyContinue | Out-Null
                    } catch {}
                }
            }
        } catch {}
    }

    # 3. Clean temporary files created in TEMP folder (target only specific files non-interactively)
    try {
        Get-ChildItem -Path $env:TEMP -Filter "xray_*.json" -File -ErrorAction SilentlyContinue | Remove-Item -Force -Confirm:$false -ErrorAction SilentlyContinue
        Get-ChildItem -Path $env:TEMP -Filter "curl_*.txt" -File -ErrorAction SilentlyContinue | Remove-Item -Force -Confirm:$false -ErrorAction SilentlyContinue
    } catch {}
}

# Run cleanup at startup if Xray is enabled
if ($EnableXrayTest) {
    Cleanup-AllResources -TargetXrayPath $XrayExe
}

# Register cleanup on PowerShell process exit
try {
    if ([Environment]::UserInteractive -and -not [Console]::IsInputRedirected) {
        [Console]::TreatControlCAsInput = $false
    }
    $null = Register-ObjectEvent -InputObject ([System.AppDomain]::CurrentDomain) -EventName ProcessExit -Action {
        Global:Cleanup-AllResources
    } -ErrorAction SilentlyContinue
} catch {}

# ----------------------------------------------------------------------------
# Input Validations
# ----------------------------------------------------------------------------
$CleanDomain = $Domain -replace "^https?://", "" -replace "/.*$", ""

if ([string]::IsNullOrWhiteSpace($CleanDomain) -or $CleanDomain -eq "your-worker.your-subdomain.workers.dev" -or $CleanDomain -eq "your-worker-domain.com") {
    Write-Host "[ERROR] Please configure your actual Cloudflare Worker domain in config.json!" -ForegroundColor Red
    Safe-Pause
    exit
}

if ($EnableXrayTest) {
    if ([string]::IsNullOrWhiteSpace($VlessLink) -or -not ($VlessLink.StartsWith("vless://"))) {
        Write-Host "[ERROR] Please configure a valid VLESS link in config.json when EnableXrayTest is true!" -ForegroundColor Red
        Safe-Pause
        exit
    }
}

if (-not (Test-Path $IpFilePath)) {
    Write-Host "[ERROR] ip.txt not found next to script ($IpFilePath)." -ForegroundColor Red
    Safe-Pause
    exit
}

# ----------------------------------------------------------------------------
# Build Xray Configuration Function (With Customizable Fragment)
# ----------------------------------------------------------------------------
function Build-XrayConfigTemplate {
    param(
        [string]$Link,
        [string]$FallbackDomain,
        [bool]$UseFrag,
        [string]$FragPackets = "1-3",
        [string]$FragLength = "100-200",
        [string]$FragInterval = "10-20"
    )

    $pattern = '^vless://(?<id>[^@]+)@(?<host>\[[0-9a-fA-F:]+\]|[^:/?#]+)(?::(?<port>\d+))?(?:\?(?<query>[^#]*))?(?:#.*)?$'
    if (-not ($Link -match $pattern)) {
        throw "Invalid VLESS URI format."
    }

    $uuid = $Matches['id'].Trim()
    $remotePort = if ($Matches['port']) { [int]$Matches['port'] } else { 443 }
    $rawQuery = $Matches['query']

    $params = @{}
    if ($rawQuery) {
        foreach ($part in ($rawQuery -split '&')) {
            $kv = $part -split '=', 2
            if ($kv.Length -eq 2) {
                $k = [System.Uri]::UnescapeDataString($kv[0]).ToLower().Trim()
                $v = [System.Uri]::UnescapeDataString($kv[1]).Trim()
                $params[$k] = $v
            }
        }
    }

    $netType     = if ($params.ContainsKey('type')) { $params['type'].ToLower() } else { "ws" }
    $security    = if ($params.ContainsKey('security')) { $params['security'].ToLower() } else { "tls" }
    $sni         = if ($params.ContainsKey('sni')) { $params['sni'] } else { $FallbackDomain }
    $fp          = if ($params.ContainsKey('fp')) { $params['fp'] } else { "chrome" }
    $wsPath      = if ($params.ContainsKey('path')) { $params['path'] } else { "/" }
    $wsHost      = if ($params.ContainsKey('host')) { $params['host'] } else { $sni }
    $grpcService = if ($params.ContainsKey('servicename')) { $params['servicename'] } elseif ($params.ContainsKey('service_name')) { $params['service_name'] } else { "" }

    $streamSettingsObj = [ordered]@{
        network  = $netType
        security = $security
    }

    if ($security -eq "tls") {
        $streamSettingsObj["tlsSettings"] = [ordered]@{
            serverName  = $sni
            fingerprint = $fp
        }
    }

    if ($netType -eq "ws") {
        $streamSettingsObj["wsSettings"] = [ordered]@{
            path    = $wsPath
            headers = [ordered]@{
                Host = $wsHost
            }
        }
    } elseif ($netType -eq "grpc") {
        $streamSettingsObj["grpcSettings"] = [ordered]@{
            serviceName = $grpcService
            multiMode   = $false
        }
    }

    $fragJson = ""
    if ($UseFrag) {
        $streamSettingsObj["sockopt"] = [ordered]@{
            dialerProxy = "fragment"
        }
        $fragJson = ',{"tag":"fragment","protocol":"freedom","settings":{"domainStrategy":"AsIs","fragment":{"packets":"' + $FragPackets + '","length":"' + $FragLength + '","interval":"' + $FragInterval + '"}}}'
    }

    $streamJson = ($streamSettingsObj | ConvertTo-Json -Depth 6 -Compress)

    $json = '{"log":{"loglevel":"none"},"inbounds":[{"tag":"socks-in","port":__LOCAL_PORT__,"listen":"127.0.0.1","protocol":"socks","settings":{"auth":"noauth","udp":false}}],"outbounds":[{"tag":"proxy","protocol":"vless","settings":{"vnext":[{"address":"__TARGET_IP__","port":' + $remotePort + ',"users":[{"id":"' + $uuid + '","encryption":"none"}]}]},"streamSettings":' + $streamJson + '}' + $fragJson + ']}'
    
    return $json
}

$XrayConfigTemplate = ""
if ($EnableXrayTest) {
    try {
        $XrayConfigTemplate = Build-XrayConfigTemplate `
            -Link $VlessLink `
            -FallbackDomain $CleanDomain `
            -UseFrag $EnableFragmentation `
            -FragPackets $FragmentPackets `
            -FragLength $FragmentLength `
            -FragInterval $FragmentInterval
    } catch {
        Write-Host "[ERROR] Failed to build Xray configuration: $_" -ForegroundColor Red
        Safe-Pause
        exit
    }
}

# ----------------------------------------------------------------------------
# Space-Safe Fast Payload Creation (Pure .NET - No fsutil Space Glitches)
# ----------------------------------------------------------------------------
$FileSizeBytes = [int64]$FileSizeMB * 1024 * 1024
if (Test-Path $PayloadPath) {
    if ((Get-Item $PayloadPath).Length -ne $FileSizeBytes) {
        Remove-Item $PayloadPath -Force -ErrorAction SilentlyContinue
    }
}
if (-not (Test-Path $PayloadPath)) {
    Write-Host "[INFO] Creating $FileSizeMB MB upload payload file..." -ForegroundColor Cyan
    try {
        $fs = [System.IO.File]::Create($PayloadPath)
        $fs.SetLength($FileSizeBytes)
        $fs.Close()
        $fs.Dispose()
    } catch {
        Write-Host "[ERROR] Could not create payload file at $PayloadPath : $_" -ForegroundColor Red
        Safe-Pause
        exit
    }
}

# ----------------------------------------------------------------------------
# Resume Capability: Initialize CSV & Filter Already Tested IPs
# ----------------------------------------------------------------------------
if (-not (Test-Path $TempCsvPath)) {
    "IP,Speed_Avg_Mbps,Speed_P90_Mbps,Speed_MB,Packet_Loss,Jitter_ms,Handshake_ms" | Out-File -FilePath $TempCsvPath -Encoding ASCII
}

$TestedIPs = @()
if (Test-Path $TempCsvPath) {
    $csvData = Import-Csv $TempCsvPath -ErrorAction SilentlyContinue
    if ($csvData) {
        $TestedIPs = @($csvData | ForEach-Object { $_.IP.Trim() } | Where-Object { $_ -ne "" })
    }
}

$AllIPs = @(Get-Content $IpFilePath | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" })
$TotalIPsCount = $AllIPs.Count

# Filter pending IPs that were not previously tested
$PendingIPs = @($AllIPs | Where-Object { $TestedIPs -notcontains $_ })

if ($PendingIPs.Count -eq 0) {
    Write-Host "[INFO] All $TotalIPsCount IPs have already been tested. Skipping to report generation." -ForegroundColor Yellow
} else {
    # ----------------------------------------------------------------------------
    # Pre-flight Check on the First Available Pending IP
    # ----------------------------------------------------------------------------
    if ($EnableXrayTest) {
        Write-Host "[INFO] Running Pre-flight Check on first IP ($($PendingIPs[0]))..." -ForegroundColor Cyan

        $testPort = 10790
        $testCfgFile = Join-Path $env:TEMP "xray_preflight_$([guid]::NewGuid()).json"
        $testOutFile = Join-Path $env:TEMP "curl_preflight_$([guid]::NewGuid()).txt"

        $testJson = $XrayConfigTemplate.Replace('__LOCAL_PORT__', $testPort.ToString()).Replace('__TARGET_IP__', $PendingIPs[0])
        $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
        [System.IO.File]::WriteAllText($testCfgFile, $testJson, $utf8NoBom)

        $preProc = $null
        try {
            $psi = New-Object System.Diagnostics.ProcessStartInfo
            $psi.FileName = $XrayExe
            $psi.WorkingDirectory = [System.IO.Path]::GetDirectoryName($XrayExe)
            $psi.Arguments = "run -c `"$testCfgFile`""
            $psi.UseShellExecute = $false
            $psi.CreateNoWindow = $true
            $psi.RedirectStandardError = $true
            $psi.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden

            $preProc = [System.Diagnostics.Process]::Start($psi)
            if ($preProc -and -not $preProc.HasExited) {
                [void]$Global:TrackedXrayPids.Add($preProc.Id)
            }
            Start-Sleep -Milliseconds 600

            if ($preProc.HasExited) {
                $errText = $preProc.StandardError.ReadToEnd()
                Write-Host "[ERROR] xray.exe failed to start during pre-flight check!" -ForegroundColor Red
                Write-Host "[DETAILS] $errText" -ForegroundColor Yellow
                Cleanup-AllResources -TargetXrayPath $XrayExe
                Safe-Pause
                exit
            }

            $curlTestArgs = @(
                "-s", "-k",
                "-o", "NUL",
                "-w", "%{http_code}",
                "-x", "socks5h://127.0.0.1:$testPort",
                "--connect-timeout", "4",
                "--max-time", "5",
                $DpiTestUrl
            )

            $cp = Start-Process -FilePath $CurlExe -ArgumentList $curlTestArgs -NoNewWindow -PassThru -RedirectStandardOutput $testOutFile
            $cp.WaitForExit(9000) | Out-Null
            if (-not $cp.HasExited) {
                try { $cp.Kill() } catch {}
            }

            $preHttpCode = 0
            if (Test-Path $testOutFile) {
                $codeStr = (Get-Content $testOutFile -Raw).Trim()
                [int]::TryParse($codeStr, [ref]$preHttpCode) | Out-Null
            }

            if ($preHttpCode -ge 200 -and $preHttpCode -lt 400) {
                Write-Host "[OK] Pre-flight Check Passed! (HTTP $preHttpCode via Xray)" -ForegroundColor Green
            } else {
                Write-Host "[WARN] First IP returned HTTP $preHttpCode via Xray. Continuing batch test..." -ForegroundColor Yellow
            }
        } finally {
            if ($preProc) {
                $preProcPid = $preProc.Id
                try {
                    if (-not $preProc.HasExited) {
                        $preProc.Kill()
                        $preProc.WaitForExit(500) | Out-Null
                    }
                } catch {}
                try { Stop-Process -Id $preProcPid -Force -ErrorAction SilentlyContinue } catch {}
                $preProc.Dispose()
                [void]$Global:TrackedXrayPids.Remove($preProcPid)
            }
            Remove-Item $testCfgFile, $testOutFile -Force -ErrorAction SilentlyContinue
        }
    } else {
        Write-Host "[INFO] Xray is disabled. Running Direct Mode pre-flight check on first IP ($($PendingIPs[0]))..." -ForegroundColor Cyan
        $testOutFile = Join-Path $env:TEMP "curl_direct_preflight_$([guid]::NewGuid()).txt"
        $curlDirectArgs = @(
            "-s", "-k",
            "-o", "NUL",
            "-w", "%{http_code}",
            "--connect-timeout", "4",
            "--max-time", "5",
            "--resolve", "${CleanDomain}:443:$($PendingIPs[0])",
            "https://${CleanDomain}/"
        )
        try {
            $cp = Start-Process -FilePath $CurlExe -ArgumentList $curlDirectArgs -NoNewWindow -PassThru -RedirectStandardOutput $testOutFile
            $cp.WaitForExit(6000) | Out-Null
            if (-not $cp.HasExited) { try { $cp.Kill() } catch {} }
            $directHttp = 0
            if (Test-Path $testOutFile) {
                $codeStr = (Get-Content $testOutFile -Raw).Trim()
                [int]::TryParse($codeStr, [ref]$directHttp) | Out-Null
            }
            if ($directHttp -gt 0) {
                Write-Host "[OK] Direct Pre-flight Check Passed! (HTTP $directHttp from Worker)" -ForegroundColor Green
            } else {
                Write-Host "[WARN] Direct check returned HTTP $directHttp. Continuing batch test..." -ForegroundColor Yellow
            }
        } finally {
            Remove-Item $testOutFile -Force -ErrorAction SilentlyContinue
        }
    }
}

Write-Host "---------------------------------------------------" -ForegroundColor Gray
Write-Host "[INFO] Target Domain : $CleanDomain" -ForegroundColor Cyan
if (-not $EnableXrayTest) {
    Write-Host "[INFO] Xray Stage 0  : Disabled (Direct Mode - Testing directly against Worker)" -ForegroundColor Yellow
} else {
    Write-Host "[INFO] Xray Stage 0  : Enabled (DPI Bypass Pre-check active)" -ForegroundColor Green
    if ($EnableFragmentation) {
        Write-Host "[INFO] Fragmentation : Enabled (Packets: $FragmentPackets | Length: $FragmentLength | Interval: $FragmentInterval)" -ForegroundColor Cyan
    } else {
        Write-Host "[INFO] Fragmentation : Disabled" -ForegroundColor Yellow
    }
    if ($UploadViaXray) {
        Write-Host "[INFO] Upload Route  : Tunneled via Xray VLESS (Directly measures Fragment speed)" -ForegroundColor Magenta
    } else {
        Write-Host "[INFO] Upload Route  : Direct to Worker IP (--resolve)" -ForegroundColor Cyan
    }
}
Write-Host "[INFO] Concurrency   : $MaxJobs Workers" -ForegroundColor Cyan
Write-Host "[INFO] Total IPs     : $TotalIPsCount | Remaining to test: $($PendingIPs.Count)" -ForegroundColor Cyan
Write-Host "---------------------------------------------------" -ForegroundColor Gray

# ----------------------------------------------------------------------------
# Multi-threaded Testing Engine (With Safe Queue Throttling & Process Killing)
# ----------------------------------------------------------------------------
$RunspacePool = $null
$Jobs = [System.Collections.ArrayList]::new()

try {
    $RunspacePool = [runspacefactory]::CreateRunspacePool(1, $MaxJobs)
    $RunspacePool.Open()

    $ScriptBlock = {
        param(
            $ip,
            $CleanDomain,
            $PayloadPath,
            $UploadTimeSec,
            $TestRounds,
            $HandshakeRounds,
            $PingCount,
            $Index,
            $TotalCount,
            $CurlExe,
            $XrayExe,
            $XrayTemplate,
            $DpiTestUrl,
            $TrackedList,
            $EnableXrayTest,
            $UploadViaXray
        )

        # 1. ICMP Ping & Jitter Measurement
        $ping = New-Object System.Net.NetworkInformation.Ping
        $pingTimes = @()
        for ($i = 0; $i -lt $PingCount; $i++) {
            try {
                $reply = $ping.Send($ip, 1000)
                if ($reply.Status -eq 'Success') {
                    $pingTimes += $reply.RoundtripTime
                }
            } catch {}
            Start-Sleep -Milliseconds 50
        }

        $lossVal = [math]::Round((($PingCount - $pingTimes.Count) / $PingCount) * 100)
        $jitterVal = 0
        if ($pingTimes.Count -gt 1) {
            $diffs = @()
            for ($i = 1; $i -lt $pingTimes.Count; $i++) {
                $diffs += [math]::Abs($pingTimes[$i] - $pingTimes[$i-1])
            }
            $jitterVal = [math]::Round(($diffs | Measure-Object -Average).Average, 1)
        }

        if ($lossVal -eq 100) {
            return [PSCustomObject]@{
                IP           = $ip
                Index        = $Index
                Total        = $TotalCount
                Success      = $false
                DpiBlocked   = $false
                PacketLoss   = 100
                Jitter       = 0
                Speed_Mbps   = 0
                Speed_P90    = 0
                Speed_MB     = 0
                Handshake_ms = 0
            }
        }

        $localPort = 10800 + ($Index % 1500)
        $tempConfigFile = Join-Path $env:TEMP "xray_cfg_$([guid]::NewGuid()).json"
        $curlDpiOut     = Join-Path $env:TEMP "curl_dpi_$([guid]::NewGuid()).txt"
        $xrayProcess = $null
        $dpiSuccess  = $false
        $startedPid  = 0

        try {
            # 2. Stage 0: DPI Bypass Pre-check with Xray (If Enabled)
            if ($EnableXrayTest) {
                $configJson = $XrayTemplate.Replace('__LOCAL_PORT__', $localPort.ToString()).Replace('__TARGET_IP__', $ip)
                $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
                [System.IO.File]::WriteAllText($tempConfigFile, $configJson, $utf8NoBom)

                $psi = New-Object System.Diagnostics.ProcessStartInfo
                $psi.FileName = $XrayExe
                $psi.WorkingDirectory = [System.IO.Path]::GetDirectoryName($XrayExe)
                $psi.Arguments = "run -c `"$tempConfigFile`""
                $psi.UseShellExecute = $false
                $psi.CreateNoWindow = $true
                $psi.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden

                $xrayProcess = [System.Diagnostics.Process]::Start($psi)
                if ($xrayProcess -and -not $xrayProcess.HasExited) {
                    $startedPid = $xrayProcess.Id
                    if ($TrackedList) { [void]$TrackedList.Add($startedPid) }
                }

                Start-Sleep -Milliseconds 500

                $curlArgsDPI = @(
                    "-s", "-k",
                    "-o", "NUL",
                    "-w", "%{http_code}",
                    "-x", "socks5h://127.0.0.1:$localPort",
                    "--connect-timeout", "4",
                    "--max-time", "5",
                    $DpiTestUrl
                )

                $pDpi = Start-Process -FilePath $CurlExe -ArgumentList $curlArgsDPI -NoNewWindow -PassThru -RedirectStandardOutput $curlDpiOut
                $pDpi.WaitForExit(7000) | Out-Null
                if (-not $pDpi.HasExited) {
                    try { $pDpi.Kill() } catch {}
                }

                if (Test-Path $curlDpiOut) {
                    $codeStr = (Get-Content $curlDpiOut -Raw).Trim()
                    $httpCode = 0
                    if ([int]::TryParse($codeStr, [ref]$httpCode)) {
                        if ($httpCode -ge 200 -and $httpCode -lt 400) {
                            $dpiSuccess = $true
                        }
                    }
                }

                if (-not $dpiSuccess) {
                    return [PSCustomObject]@{
                        IP           = $ip
                        Index        = $Index
                        Total        = $TotalCount
                        Success      = $false
                        DpiBlocked   = $true
                        PacketLoss   = $lossVal
                        Jitter       = $jitterVal
                        Speed_Mbps   = 0
                        Speed_P90    = 0
                        Speed_MB     = 0
                        Handshake_ms = 0
                    }
                }
            } else {
                # In Direct Mode, Xray is completely bypassed
                $dpiSuccess = $true
            }

            # 3. Handshake Time Measurement (TCP + TLS via curl)
            $handshakes = @()
            for ($h = 1; $h -le $HandshakeRounds; $h++) {
                $OutFileHS = Join-Path $env:TEMP "curl_hs_$([guid]::NewGuid()).txt"
                
                $curlArgsHS = @(
                    "-k", "-s",
                    "-o", "NUL",
                    "-w", "%{time_connect}|%{time_appconnect}",
                    "--connect-timeout", "5",
                    "--resolve", "${CleanDomain}:443:${ip}",
                    "https://${CleanDomain}/"
                )

                try {
                    $p = Start-Process -FilePath $CurlExe -ArgumentList $curlArgsHS -NoNewWindow -PassThru -RedirectStandardOutput $OutFileHS
                    $p.WaitForExit(6000) | Out-Null
                    if (-not $p.HasExited) {
                        try { $p.Kill() } catch {}
                    }

                    if (Test-Path $OutFileHS) {
                        $rawHS = (Get-Content $OutFileHS -Raw).Trim()
                        $parts = $rawHS -split '\|'
                        if ($parts.Count -ge 2) {
                            $tcpTime = $parts[0] -replace ',', '.'
                            $tlsTime = $parts[1] -replace ',', '.'
                            
                            $hsSec = 0
                            if ([double]::TryParse($tlsTime, [ref]$hsSec) -and $hsSec -gt 0) {
                                $handshakes += ($hsSec * 1000)
                            } elseif ([double]::TryParse($tcpTime, [ref]$hsSec) -and $hsSec -gt 0) {
                                $handshakes += ($hsSec * 1000)
                            }
                        }
                    }
                } catch {}
                finally {
                    if (Test-Path $OutFileHS) { Remove-Item $OutFileHS -Force -ErrorAction SilentlyContinue }
                }
            }

            $avgHandshake = 0
            if ($handshakes.Count -gt 0) {
                $avgHandshake = [math]::Round(($handshakes | Measure-Object -Average).Average, 1)
            }

            # 4. Upload Speed Measurement (Tunneled via Xray if UploadViaXray is True, else Direct via --resolve)
            $validSpeeds = @()
            $quotedPayloadArg = "@`"$PayloadPath`""

            for ($r = 1; $r -le $TestRounds; $r++) {
                $OutFile = Join-Path $env:TEMP "curl_out_$([guid]::NewGuid()).txt"
                
                $curlArgs = @()
                if ($EnableXrayTest -and $UploadViaXray) {
                    # Tunneled upload: traffic passes through Xray VLESS + Fragment
                    $curlArgs = @(
                        "-k", "-s",
                        "-o", "NUL",
                        "-w", "%{size_upload}|%{time_total}",
                        "-X", "POST",
                        "--data-binary", $quotedPayloadArg,
                        "-x", "socks5h://127.0.0.1:$localPort",
                        "--connect-timeout", "5",
                        "--max-time", "$UploadTimeSec",
                        "https://${CleanDomain}/"
                    )
                } else {
                    # Direct upload: resolves domain directly to IP
                    $curlArgs = @(
                        "-k", "-s",
                        "-o", "NUL",
                        "-w", "%{size_upload}|%{time_total}",
                        "-X", "POST",
                        "--data-binary", $quotedPayloadArg,
                        "--connect-timeout", "5",
                        "--max-time", "$UploadTimeSec",
                        "--resolve", "${CleanDomain}:443:${ip}",
                        "https://${CleanDomain}/"
                    )
                }

                try {
                    $p = Start-Process -FilePath $CurlExe -ArgumentList $curlArgs -NoNewWindow -PassThru -RedirectStandardOutput $OutFile
                    $p.WaitForExit(($UploadTimeSec + 5) * 1000) | Out-Null
                    if (-not $p.HasExited) {
                        try { $p.Kill() } catch {}
                    }
                    
                    if (Test-Path $OutFile) {
                        $rawOutput = (Get-Content $OutFile -Raw).Trim()
                        $parts = $rawOutput -split '\|'

                        if ($parts.Count -ge 2) {
                            $sizeUpRaw  = $parts[0] -replace ',', '.'
                            $timeTotRaw = $parts[1] -replace ',', '.'

                            $sizeUp = 0; $timeTot = 0
                            [double]::TryParse($sizeUpRaw, [ref]$sizeUp) | Out-Null
                            [double]::TryParse($timeTotRaw, [ref]$timeTot) | Out-Null

                            if ($sizeUp -gt 0 -and $timeTot -gt 0) {
                                $bytesPerSec = $sizeUp / $timeTot
                                $validSpeeds += $bytesPerSec
                            }
                        }
                    }
                } catch {}
                finally {
                    if (Test-Path $OutFile) { Remove-Item $OutFile -Force -ErrorAction SilentlyContinue }
                }
            }

            $avgMbps = 0
            $p90Mbps = 0
            $mb = 0
            $isSuccess = $false

            if ($validSpeeds.Count -gt 0) {
                $isSuccess = $true
                
                $avgBytes = ($validSpeeds | Measure-Object -Average).Average
                $avgMbps  = [math]::Round(($avgBytes * 8) / 1000000, 2)
                $mb       = [math]::Round($avgBytes / 1048576, 2)

                $sortedSpeeds = $validSpeeds | Sort-Object
                $p90Index     = [math]::Floor($sortedSpeeds.Count * 0.90)
                if ($p90Index -ge $sortedSpeeds.Count) { $p90Index = $sortedSpeeds.Count - 1 }
                $p90Bytes     = $sortedSpeeds[$p90Index]
                $p90Mbps      = [math]::Round(($p90Bytes * 8) / 1000000, 2)
            }

            return [PSCustomObject]@{
                IP           = $ip
                Index        = $Index
                Total        = $TotalCount
                Success      = $isSuccess
                DpiBlocked   = $false
                Speed_Mbps   = $avgMbps
                Speed_P90    = $p90Mbps
                Speed_MB     = $mb
                PacketLoss   = $lossVal
                Jitter       = $jitterVal
                Handshake_ms = $avgHandshake
            }
        } finally {
            # STRICT XRAY TERMINATION: Kill immediately after job completes
            if ($xrayProcess) {
                try {
                    if (-not $xrayProcess.HasExited) {
                        $xrayProcess.Kill()
                        $xrayProcess.WaitForExit(500) | Out-Null
                    }
                } catch {}
                try {
                    if (-not $xrayProcess.HasExited) {
                        Stop-Process -Id $xrayProcess.Id -Force -ErrorAction SilentlyContinue
                    }
                } catch {}
                try { $xrayProcess.Dispose() } catch {}
            }
            if ($startedPid -gt 0 -and $TrackedList) {
                [void]$TrackedList.Remove($startedPid)
            }
            if (Test-Path $tempConfigFile) { Remove-Item $tempConfigFile -Force -Confirm:$false -ErrorAction SilentlyContinue }
            if (Test-Path $curlDpiOut)     { Remove-Item $curlDpiOut -Force -Confirm:$false -ErrorAction SilentlyContinue }
        }
    }

    $OutputBuffer = @{}
    $ExpectedQueue = [System.Collections.Generic.List[int]]::new()
    $IpQueue = [System.Collections.Generic.Queue[string]]::new()
    foreach ($pendingIp in $PendingIPs) {
        $IpQueue.Enqueue($pendingIp)
    }

    # Sliding Window Loop: Keep at most $MaxJobs active in memory
    while ($Jobs.Count -gt 0 -or $IpQueue.Count -gt 0 -or $OutputBuffer.Count -gt 0) {

        # Fill active workers pool up to $MaxJobs
        while ($Jobs.Count -lt $MaxJobs -and $IpQueue.Count -gt 0) {
            $currentIp = $IpQueue.Dequeue()
            $ipIndex = ([array]::IndexOf($AllIPs, $currentIp)) + 1
            $ExpectedQueue.Add($ipIndex)

            $PowerShell = [powershell]::Create().AddScript($ScriptBlock)
            [void]$PowerShell.AddArgument($currentIp)
            [void]$PowerShell.AddArgument($CleanDomain)
            [void]$PowerShell.AddArgument($PayloadPath)
            [void]$PowerShell.AddArgument($UploadTimeSec)
            [void]$PowerShell.AddArgument($TestRounds)
            [void]$PowerShell.AddArgument($HandshakeRounds)
            [void]$PowerShell.AddArgument($PingCount)
            [void]$PowerShell.AddArgument($ipIndex)
            [void]$PowerShell.AddArgument($TotalIPsCount)
            [void]$PowerShell.AddArgument($CurlExe)
            [void]$PowerShell.AddArgument($XrayExe)
            [void]$PowerShell.AddArgument($XrayConfigTemplate)
            [void]$PowerShell.AddArgument($DpiTestUrl)
            [void]$PowerShell.AddArgument($Global:TrackedXrayPids)
            [void]$PowerShell.AddArgument($EnableXrayTest)
            [void]$PowerShell.AddArgument($UploadViaXray)

            $PowerShell.RunspacePool = $RunspacePool

            [void]$Jobs.Add([PSCustomObject]@{
                Pipe   = $PowerShell
                Status = $PowerShell.BeginInvoke()
                IP     = $currentIp
                Index  = $ipIndex
            })
        }

        # Check and collect completed jobs
        $CompletedJobs = @($Jobs | Where-Object { $_.Status.IsCompleted })

        foreach ($Job in $CompletedJobs) {
            try {
                $Result = $Job.Pipe.EndInvoke($Job.Status)
                if ($Result) {
                    $OutputBuffer[$Job.Index] = $Result
                }
            } catch {}
            finally {
                $Job.Pipe.Dispose()
                $Jobs.Remove($Job) | Out-Null
            }
        }

        # Process and print output buffer in original IP sequence
        while ($ExpectedQueue.Count -gt 0 -and $OutputBuffer.ContainsKey($ExpectedQueue[0])) {
            $idxToPrint = $ExpectedQueue[0]
            $Res = $OutputBuffer[$idxToPrint]

            $prefix = "[$($Res.Index)/$($Res.Total)]"

            if ($Res.Success) {
                Write-Host "$prefix SUCCESS: $($Res.IP) -> $($Res.Speed_Mbps) Mbps ($($Res.Speed_MB) MB/s) | P90: $($Res.Speed_P90) Mbps | Loss: $($Res.PacketLoss)% | Jitter: $($Res.Jitter)ms | Handshake: $($Res.Handshake_ms)ms" -ForegroundColor Green
                "$($Res.IP),$($Res.Speed_Mbps),$($Res.Speed_P90),$($Res.Speed_MB),$($Res.PacketLoss)%,$($Res.Jitter),$($Res.Handshake_ms)" | Out-File -FilePath $TempCsvPath -Append -Encoding ASCII
            } elseif ($Res.DpiBlocked) {
                Write-Host "$prefix BLOCKED: $($Res.IP) (Xray Stage 0 Failed) | Loss: $($Res.PacketLoss)%" -ForegroundColor Magenta
                "$($Res.IP),0,0,0,$($Res.PacketLoss)%,$($Res.Jitter),0" | Out-File -FilePath $TempCsvPath -Append -Encoding ASCII
            } else {
                Write-Host "$prefix FAILED:  $($Res.IP) (Timeout/No Connection) | Loss: $($Res.PacketLoss)%" -ForegroundColor Red
                "$($Res.IP),0,0,0,$($Res.PacketLoss)%,$($Res.Jitter),0" | Out-File -FilePath $TempCsvPath -Append -Encoding ASCII
            }

            $ExpectedQueue.RemoveAt(0)
            $OutputBuffer.Remove($idxToPrint)
        }

        Start-Sleep -Milliseconds 100
    }
}
finally {
    # Emergency termination: ensure all runspaces and child Xray processes die immediately
    if ($RunspacePool) {
        try {
            $RunspacePool.Close()
            $RunspacePool.Dispose()
        } catch {}
    }
    if ($EnableXrayTest) {
        Cleanup-AllResources -TargetXrayPath $XrayExe
    }
}

# ----------------------------------------------------------------------------
# Generate Final Formatted Reports (Sorted by P90 Speed)
# ----------------------------------------------------------------------------
Write-Host "`n---------------------------------------------------" -ForegroundColor Gray
Write-Host "[INFO] Sorting results by P90 speed..." -ForegroundColor Cyan

if (Test-Path $TempCsvPath) {
    $data = Import-Csv $TempCsvPath -Encoding ASCII
    $validData = @($data | Where-Object { [double]($_.Speed_Avg_Mbps -replace ',', '.') -gt 0 })

    if ($validData -and $validData.Count -gt 0) {
        $sorted = $validData | Sort-Object -Property @{Expression={[double]($_.Speed_P90_Mbps -replace ',', '.')}; Descending=$true}
        
        $sorted | Export-Csv -Path $FinalCsvPath -NoTypeInformation -Encoding ASCII

        $txtLines = [System.Collections.Generic.List[string]]::new()
        foreach ($r in $sorted) {
            $txtLines.Add("=======================================")
            $txtLines.Add("Target IP      : $($r.IP)")
            $txtLines.Add("Upload Speed   : $($r.Speed_Avg_Mbps) Mbps  ($($r.Speed_MB) MB/s)")
            $txtLines.Add("P90 Speed      : $($r.Speed_P90_Mbps) Mbps")
            $txtLines.Add("Packet Loss    : $($r.Packet_Loss)")
            $txtLines.Add("Jitter         : $($r.Jitter_ms) ms")
            $txtLines.Add("Handshake Time : $($r.Handshake_ms) ms")
            $txtLines.Add("=======================================")
            $txtLines.Add("")
        }
        $txtLines | Out-File -FilePath $FinalTxtPath -Encoding ASCII

        Write-Host "[SUCCESS] Reports generated successfully:" -ForegroundColor Green
        Write-Host "    - CSV: $FinalCsvPath" -ForegroundColor Green
        Write-Host "    - TXT: $FinalTxtPath" -ForegroundColor Green
    } else {
        Write-Host "[WARN] No working IPs with speed > 0 were found in this batch." -ForegroundColor Yellow
    }
}

if ([Environment]::UserInteractive -and -not [Console]::IsInputRedirected) {
    Write-Host "`nPress any key to exit..."
    try {
        $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
    } catch {
        $null = $Host.UI.ReadLine()
    }
}