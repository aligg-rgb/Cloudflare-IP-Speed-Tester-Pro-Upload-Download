# ============================================================================
# اسکریپت تست آپلود کلادفلر (نسخه نهایی پاورشل 5.1 - بافر هوشمند + Handshake Avg)
# قابلیت‌ها: مرتب‌سازی دقیق + Jitter + میانگین Handshake + P90 + تایم‌اوت حجمی
# ============================================================================

# ==================================================
# تنظیمات پایه و قابل ویرایش (متغیرهای اصلی)
# ==================================================
$Domain          = "your-worker-domain.com" # دامنه ورکر یا سرور شما (ترجیحاً بدون https وارد کنید)
$FileSizeMB      = 20                       # حجم فایل مجازی برای تست آپلود (به مگابایت). ۲۰ مگابایت برای اشباع خط کافیست.
$UploadTimeSec   = 15                       # زمان مجاز برای هر راند آپلود (تایم‌اوت حجمی به ثانیه). پس از این زمان تست قطع و سرعت محاسبه می‌شود.
$TestRounds      = 3                        # تعداد مراحل تست آپلود روی هر آی‌پی (برای محاسبه سرعت میانگین و صدک P90).
$HandshakeRounds = 3                        # تعداد مراحل تستِ اختصاصی دست‌دهی (Handshake) برای محاسبه میانگین دقیق.
$PingCount       = 4                        # تعداد بسته‌های پینگ ارسالی برای محاسبه میزان قطعی (Packet Loss) و نوسان شبکه (Jitter).
$MaxJobs         = 3                        # تعداد آی‌پی‌هایی که همزمان تست می‌شوند (Multi-threading). اعداد ۳ تا ۵ برای جلوگیری از افت سرعت پیشنهاد می‌شود.
$PayloadName     = "upload_payload.dat"     # نام فایلی که به صورت خودکار برای آپلود ساخته می‌شود.
# ==================================================

# ---------------------------------------------------------
# آماده‌سازی مسیرها و فایل‌های مورد نیاز سیستم
# ---------------------------------------------------------
$CurrentDir = $PSScriptRoot
if ([string]::IsNullOrEmpty($CurrentDir)) { $CurrentDir = (Get-Location).Path }

$PayloadPath  = Join-Path $CurrentDir $PayloadName
$TempCsvPath  = Join-Path $CurrentDir "temp_data.csv"
$FinalCsvPath = Join-Path $CurrentDir "final_report.csv"
$FinalTxtPath = Join-Path $CurrentDir "final_report.txt"
$IpFilePath   = Join-Path $CurrentDir "ip.txt"

# تمیز کردن آدرس دامنه از کاراکترهای اضافی (حذف https و اسلش‌ها)
$CleanDomain = $Domain -replace "^https?://", "" -replace "/.*$", ""

if ([string]::IsNullOrWhiteSpace($CleanDomain) -or $CleanDomain -eq "your-worker-domain.com") {
    Write-Host "[X] Error: Please set your actual domain in the `$Domain variable!" -ForegroundColor Red
    Pause
    exit
}

# پیدا کردن موتور curl در سیستم‌عامل ویندوز
$CurlExe = "$env:SystemRoot\System32\curl.exe"
if (-not (Test-Path $CurlExe)) {
    $CurlExe = (Get-Command curl.exe -ErrorAction SilentlyContinue).Source
}
if (-not $CurlExe) {
    Write-Host "[X] Error: curl.exe not found on your system." -ForegroundColor Red
    Pause
    exit
}

# ساخت خودکار فایل تستی (Payload) در صورتی که وجود نداشته باشد یا حجمش تغییر کرده باشد
$FileSizeBytes = $FileSizeMB * 1024 * 1024
if (Test-Path $PayloadPath) {
    if ((Get-Item $PayloadPath).Length -ne $FileSizeBytes) {
        Remove-Item $PayloadPath -Force -ErrorAction SilentlyContinue
    }
}
if (-not (Test-Path $PayloadPath)) {
    Write-Host "[*] Creating $FileSizeMB MB payload file..." -ForegroundColor Cyan
    fsutil file createnew "$PayloadPath" $FileSizeBytes | Out-Null
}

if (-not (Test-Path $IpFilePath)) {
    Write-Host "[X] Error: ip.txt not found next to this script." -ForegroundColor Red
    Pause
    exit
}

if (-not (Test-Path $TempCsvPath)) {
    "IP,Speed_Avg_Mbps,Speed_P90_Mbps,Speed_MB,Packet_Loss,Jitter_ms,Handshake_ms" | Out-File -FilePath $TempCsvPath -Encoding UTF8
}

# خواندن فایل موقت برای قابلیت Resume (ادامه تست در صورت بسته شدن اسکریپت)
$TestedIPs = @()
if (Test-Path $TempCsvPath) {
    $csvData = Import-Csv $TempCsvPath -ErrorAction SilentlyContinue
    if ($csvData) { $TestedIPs = $csvData.IP }
}

$AllIPs = Get-Content $IpFilePath | Where-Object { $_.Trim() -ne '' }
$TotalIPsCount = $AllIPs.Count
$PendingIPs = $AllIPs | Where-Object { $TestedIPs -notcontains $_ }

if ($PendingIPs.Count -eq 0) {
    Write-Host "[-] All IPs have already been tested." -ForegroundColor Yellow
    Pause
    exit
}

Write-Host "[*] Target Domain: $CleanDomain" -ForegroundColor Cyan
Write-Host "[*] Testing $TestRounds round(s) of $UploadTimeSec sec per IP (Smart Buffer Mode)..." -ForegroundColor Cyan
Write-Host "[*] Total IPs: $TotalIPsCount | Remaining: $($PendingIPs.Count)" -ForegroundColor Cyan
Write-Host "---------------------------------------------------" -ForegroundColor Gray

# باز کردن استخر پردازش موازی برای تست همزمان
$RunspacePool = [runspacefactory]::CreateRunspacePool(1, $MaxJobs)
$RunspacePool.Open()
$Jobs = [System.Collections.ArrayList]::new()

# =========================================================
# بلوک اجرایی اصلی (قلب اسکریپت که روی هر آی‌پی اجرا می‌شود)
# =========================================================
$ScriptBlock = {
    param($ip, $CleanDomain, $PayloadPath, $UploadTimeSec, $TestRounds, $HandshakeRounds, $PingCount, $Index, $TotalCount, $CurlExe)

    # ---------------------------------------------------------
    # 1. تست پینگ، پکت لاس (Packet Loss) و نوسان شبکه (Jitter)
    # ---------------------------------------------------------
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

    # اگر قطعی 100% بود، نیازی به تست بقیه مراحل نیست
    if ($lossVal -eq 100) {
        return [PSCustomObject]@{ IP=$ip; Index=$Index; Total=$TotalCount; Success=$false; PacketLoss=100; Jitter=0; Speed_Mbps=0; Speed_P90=0; Speed_MB=0; Handshake_ms=0 }
    }

    # ---------------------------------------------------------
    # 2. تست اختصاصی و چندمرحله‌ای Handshake (دست‌دهی)
    # ---------------------------------------------------------
    $handshakes = @()
    for ($h = 1; $h -le $HandshakeRounds; $h++) {
        $OutFileHS = Join-Path $env:TEMP "curl_hs_$([guid]::NewGuid()).txt"
        $DiscardHS = Join-Path $env:TEMP "discard_hs_$([guid]::NewGuid()).tmp"
        
        # یک ریکوئست بسیار سبک و سریع فقط برای سنجش زمان ارتباط امن
        $curlArgsHS = @(
            "-k", "-s",
            "-o", "`"$DiscardHS`"",
            "-w", "%{time_connect}|%{time_appconnect}",
            "--connect-timeout", "5",
            "--resolve", "${CleanDomain}:443:${ip}",
            "https://${CleanDomain}/"
        )

        try {
            $p = Start-Process -FilePath $CurlExe -ArgumentList $curlArgsHS -NoNewWindow -PassThru -RedirectStandardOutput $OutFileHS
            $p.WaitForExit(6000) | Out-Null
            if (-not $p.HasExited) { $p.Kill() }

            if (Test-Path $OutFileHS) {
                $rawHS = (Get-Content $OutFileHS -Raw).Trim()
                $parts = $rawHS -split '\|'
                if ($parts.Count -ge 2) {
                    $tcpTime = $parts[0] -replace ',', '.'
                    $tlsTime = $parts[1] -replace ',', '.'
                    
                    $hsSec = 0
                    # اولویت با زمان کامل TLS است، اگر نبود زمان TCP ثبت می‌شود
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
            if (Test-Path $DiscardHS) { Remove-Item $DiscardHS -Force -ErrorAction SilentlyContinue }
        }
    }

    $avgHandshake = 0
    if ($handshakes.Count -gt 0) {
        $avgHandshake = [math]::Round(($handshakes | Measure-Object -Average).Average, 1)
    }

    # ---------------------------------------------------------
    # 3. تست اصلی آپلود با استفاده از تایم‌اوت حجمی
    # ---------------------------------------------------------
    $validSpeeds = @()

    for ($r = 1; $r -le $TestRounds; $r++) {
        $OutFile = Join-Path $env:TEMP "curl_out_$([guid]::NewGuid()).txt"
        $DiscardBody = Join-Path $env:TEMP "discard_$([guid]::NewGuid()).tmp"
        
        $curlArgs = @(
            "-k", "-s",
            "-o", "`"$DiscardBody`"",
            "-w", "%{size_upload}|%{time_total}",
            "-X", "POST",
            "--data-binary", "@$PayloadPath",
            "--connect-timeout", "5",
            "--max-time", "$UploadTimeSec",
            "--resolve", "${CleanDomain}:443:${ip}",
            "https://${CleanDomain}/"
        )

        try {
            $p = Start-Process -FilePath $CurlExe -ArgumentList $curlArgs -NoNewWindow -PassThru -RedirectStandardOutput $OutFile
            # زمان ارفاق پاورشل برای جلوگیری از هنگ کردن سیستم (زمان تست + 5 ثانیه)
            $p.WaitForExit(($UploadTimeSec + 5) * 1000) | Out-Null
            if (-not $p.HasExited) { $p.Kill() }
            
            if (Test-Path $OutFile) {
                $rawOutput = (Get-Content $OutFile -Raw).Trim()
                $parts = $rawOutput -split '\|'

                if ($parts.Count -ge 2) {
                    $sizeUpRaw = $parts[0] -replace ',', '.'
                    $timeTotRaw= $parts[1] -replace ',', '.'

                    $sizeUp = 0; $timeTot = 0
                    [double]::TryParse($sizeUpRaw, [ref]$sizeUp) | Out-Null
                    [double]::TryParse($timeTotRaw, [ref]$timeTot) | Out-Null

                    # تقسیم بایت‌های ارسال شده بر زمان واقعی طی شده (سرعت لحظه‌ای دقیق)
                    if ($sizeUp -gt 0 -and $timeTot -gt 0) {
                        $bytesPerSec = $sizeUp / $timeTot
                        $validSpeeds += $bytesPerSec
                    }
                }
            }
        } catch {}
        finally {
            if (Test-Path $OutFile) { Remove-Item $OutFile -Force -ErrorAction SilentlyContinue }
            if (Test-Path $DiscardBody) { Remove-Item $DiscardBody -Force -ErrorAction SilentlyContinue }
        }
    }

    # ---------------------------------------------------------
    # 4. محاسبات آماری نهایی (میانگین سرعت و صدک P90)
    # ---------------------------------------------------------
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
        Speed_Mbps   = $avgMbps
        Speed_P90    = $p90Mbps
        Speed_MB     = $mb
        PacketLoss   = $lossVal
        Jitter       = $jitterVal
        Handshake_ms = $avgHandshake
    }
}

# ---------------------------------------------------------
# مکانیزم بافر هوشمند (Smart Buffer) برای چاپ به ترتیب نتایج
# ---------------------------------------------------------
$OutputBuffer = @{}
$ExpectedQueue = [System.Collections.Generic.List[int]]::new()

# ارسال تمام آی‌پی‌ها به صف پردازش همزمان
foreach ($ip in $PendingIPs) {
    $ipIndex = ([array]::IndexOf($AllIPs, $ip)) + 1
    $ExpectedQueue.Add($ipIndex)

    $PowerShell = [powershell]::Create().AddScript($ScriptBlock)
    [void]$PowerShell.AddArgument($ip)
    [void]$PowerShell.AddArgument($CleanDomain)
    [void]$PowerShell.AddArgument($PayloadPath)
    [void]$PowerShell.AddArgument($UploadTimeSec)
    [void]$PowerShell.AddArgument($TestRounds)
    [void]$PowerShell.AddArgument($HandshakeRounds)
    [void]$PowerShell.AddArgument($PingCount)
    [void]$PowerShell.AddArgument($ipIndex)
    [void]$PowerShell.AddArgument($TotalIPsCount)
    [void]$PowerShell.AddArgument($CurlExe)

    $PowerShell.RunspacePool = $RunspacePool

    [void]$Jobs.Add([PSCustomObject]@{
        Pipe   = $PowerShell
        Status = $PowerShell.BeginInvoke()
        IP     = $ip
    })
}

# دریافت خروجی‌ها و چاپ منظم
while ($Jobs.Count -gt 0 -or $OutputBuffer.Count -gt 0) {
    $CompletedJobs = @($Jobs | Where-Object { $_.Status.IsCompleted })

    foreach ($Job in $CompletedJobs) {
        $Result = $Job.Pipe.EndInvoke($Job.Status)
        $Job.Pipe.Dispose()
        $Jobs.Remove($Job) | Out-Null
        $OutputBuffer[$Result.Index] = $Result
    }

    # پردازش بافر: چاپ نتیجه فقط اگر نوبت آی‌پی بعدی در صف رسیده باشد
    while ($ExpectedQueue.Count -gt 0 -and $OutputBuffer.ContainsKey($ExpectedQueue[0])) {
        $idxToPrint = $ExpectedQueue[0]
        $Res = $OutputBuffer[$idxToPrint]

        $prefix = "[$($Res.Index)/$($Res.Total)]"

        if ($Res.Success) {
            Write-Host "$prefix + Success: $($Res.IP) -> $($Res.Speed_Mbps) Mbps ($($Res.Speed_MB) MB/s) | P90: $($Res.Speed_P90) Mbps | Loss: $($Res.PacketLoss)% | Jitter: $($Res.Jitter)ms | Handshake: $($Res.Handshake_ms)ms" -ForegroundColor Green
            "$($Res.IP),$($Res.Speed_Mbps),$($Res.Speed_P90),$($Res.Speed_MB),$($Res.PacketLoss)%,$($Res.Jitter),$($Res.Handshake_ms)" | Out-File -FilePath $TempCsvPath -Append -Encoding UTF8
        } else {
            Write-Host "$prefix - Failed:  $($Res.IP) (Timeout/No Connection) | Loss: $($Res.PacketLoss)%" -ForegroundColor Red
            "$($Res.IP),0,0,0,$($Res.PacketLoss)%,$($Res.Jitter),0" | Out-File -FilePath $TempCsvPath -Append -Encoding UTF8
        }

        $ExpectedQueue.RemoveAt(0)
        $OutputBuffer.Remove($idxToPrint)
    }

    Start-Sleep -Milliseconds 100
}

$RunspacePool.Close()
$RunspacePool.Dispose()

# ---------------------------------------------------------
# ساخت فایل‌های نهایی (CSV و TXT) با حفظ چیدمان قبلی (بر اساس P90)
# ---------------------------------------------------------
Write-Host "`n---------------------------------------------------" -ForegroundColor Gray
Write-Host "[*] All tested! Sorting results by P90 speed..." -ForegroundColor Cyan

if (Test-Path $TempCsvPath) {
    $data = Import-Csv $TempCsvPath -Encoding UTF8
    $validData = $data | Where-Object { [double]($_.Speed_Avg_Mbps -replace ',', '.') -gt 0 }

    if ($validData) {
        # مرتب‌سازی بر اساس سرعت صدک 90 (دقیق‌ترین معیار کیفیت آپلود)
        # طبق درخواست شما، چیدمان بر اساس سرعت آپلود دست‌نخورده باقی ماند
        $sorted = $validData | Sort-Object -Property @{Expression={[double]($_.Speed_Avg_Mbps -replace ',', '.')}; Descending=$true}
        
        $sorted | Export-Csv -Path $FinalCsvPath -NoTypeInformation -Encoding UTF8

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
        $txtLines | Out-File -FilePath $FinalTxtPath -Encoding UTF8

        Write-Host "[*] Reports generated successfully:" -ForegroundColor Green
        Write-Host "    - CSV: $FinalCsvPath" -ForegroundColor Green
        Write-Host "    - TXT: $FinalTxtPath" -ForegroundColor Green
    } else {
        Write-Host "[!] No working IPs with speed > 0 were found." -ForegroundColor Yellow
    }
}

Write-Host "`nPress any key to exit..."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null