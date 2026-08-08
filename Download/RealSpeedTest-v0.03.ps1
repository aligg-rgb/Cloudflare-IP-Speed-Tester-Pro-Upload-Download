# ============================================================================
# اسکریپت تست سرعت دانلود همزمان (Parallel) برای آی‌پی‌های کلادفلر
# دارای مکانیزم ادامه کار (Resume) و خروجی‌های مرتب شده
# ============================================================================

# ---------------------------------------------------------
# بخش اول: تنظیمات سایت هدف (تارگت)
# ---------------------------------------------------------
# در این بخش باید آدرس سایتی را قرار بدید که پشتش به کلادفلر باشه و فیلتر نباشه.
# این سایت به عنوان سرور دانلود برای سنجش سرعت آی‌پی‌ها استفاده می‌شود.
$TargetUrl = "https://www.digitalocean.com"
$Domain = "www.digitalocean.com"

# ---------------------------------------------------------
# بخش دوم: تنظیمات فایل‌ها و پردازش همزمان
# ---------------------------------------------------------
# نام فایلی که لیست آی‌پی‌های شما در آن قرار دارد. این فایل باید کنار همین اسکریپت باشد.
$IpListFile = "ip.txt"

# نام فایلی که نتایج را لحظه به لحظه ذخیره می‌کند تا در صورت قطعی برق، زحمات شما هدر نرود.
$TempFile = "temp_data.csv"

# نام فایل‌های خروجی نهایی که بعد از اتمام تست و مرتب‌سازی ساخته می‌شوند.
$FinalCsvFile = "final_sorted_ips.csv"
$FinalTxtFile = "final_sorted_ips.txt"

# این گزینه برای این است که مقدار تست همزمان را تنظیم کنید.
# مثلا اگر عدد 3 قرار بگیرد، 3 تست در لحظه به صورت همزمان انجام می‌شود.
# بهتر است این عدد بر اساس قدرت پردازنده شما (تعداد هسته‌ها) تنظیم شود.
$MaxThreads = 6 

# ---------------------------------------------------------
# بخش سوم: آماده‌سازی محیط و خواندن لیست آی‌پی‌ها
# ---------------------------------------------------------
# این دستور باعث می‌شود اسکریپت مسیر اجرای خودش را بشناسد تا فایل‌ها را در پوشه درستی بسازد.
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location -Path $ScriptDir

Write-Host "[INFO] Target: $Domain" -ForegroundColor Cyan
Write-Host "[INFO] Reading IPs from: $IpListFile" -ForegroundColor Cyan
Write-Host "---------------------------------------------------" -ForegroundColor Gray

# بررسی اینکه آیا فایل لیست آی‌پی اصلاً وجود دارد یا خیر.
if (-not (Test-Path $IpListFile)) {
    Write-Host "File $IpListFile not found!" -ForegroundColor Red
    Pause
    exit
}

# خواندن تمام آی‌پی‌ها و نادیده گرفتن خطوط خالی در فایل متنی
$AllIPs = Get-Content $IpListFile | Where-Object { $_ -match "\S" }

if ($AllIPs.Count -eq 0) {
    Write-Host "IP list is empty!" -ForegroundColor Red
    Pause
    exit
}

# ---------------------------------------------------------
# بخش چهارم: سیستم هوشمند ادامه کار (Resume)
# ---------------------------------------------------------
$TestedSet = [System.Collections.Generic.HashSet[string]]::new()

# بررسی می‌کند که آیا فایل Temp (تست‌های قبلی) وجود دارد؟
# اگر سیستم قبلاً کرش کرده باشد، آی‌پی‌های تست شده را می‌خواند تا دوباره آن‌ها را تست نکند.
if (Test-Path $TempFile) {
    Write-Host "[INFO] Temp file found. Loading previously tested IPs to resume..." -ForegroundColor Yellow
    $TempData = Import-Csv $TempFile
    foreach ($row in $TempData) {
        [void]$TestedSet.Add($row.IP)
    }
} else {
    # اگر فایل Temp وجود نداشت، یک فایل جدید با تیترهای مورد نیاز می‌سازد.
    "IP,Bytes,Speed_KB" | Out-File -FilePath $TempFile -Encoding UTF8
}

# جدا کردن آی‌پی‌هایی که هنوز تست نشده‌اند از کل لیست
$IPsToTest = $AllIPs | Where-Object { -not $TestedSet.Contains($_) }

# اگر لیست خالی بود یعنی همه آی‌پی‌ها قبلا تست شده‌اند، پس مستقیم می‌رود سراغ ساخت خروجی نهایی.
if ($IPsToTest.Count -eq 0) {
    Write-Host "[INFO] All IPs have already been tested! Skipping to results..." -ForegroundColor Green
} else {
    Write-Host "[INFO] $($IPsToTest.Count) IPs remaining to test..." -ForegroundColor Cyan
    Write-Host "[INFO] Starting CONCURRENT download tests ($MaxThreads threads)..." -ForegroundColor Yellow
    Write-Host "Please wait..." -ForegroundColor DarkGray

    # ایجاد یک "استخر پردازشی" برای اجرای تست‌های همزمان
    $RunspacePool = [runspacefactory]::CreateRunspacePool(1, $MaxThreads)
    $RunspacePool.Open()
    $Jobs = [System.Collections.ArrayList]::new()

    foreach ($IP in $IPsToTest) {
        $PowerShell = [powershell]::Create().AddScript({
            param($IP, $Domain, $TargetUrl)
            
            # این دستور قلب تپنده اسکریپت است که کار تست سرعت دانلود را انجام می‌دهد.
            # حداکثر زمان مجاز برای اتصال 2 ثانیه و برای کل دانلود 4 ثانیه تنظیم شده است.
            $output = & curl.exe -s -k -L -o NUL -w '%{speed_download}' --connect-timeout 2 --max-time 4 --resolve "$($Domain):443:$IP" $TargetUrl
            
            # حذف اعشار از عدد سرعت برای جلوگیری از خطای محاسباتی
            $speedBpsStr = $output -replace '\..*', ''
            $speedBps = 0
            
            # تبدیل سرعت از بایت بر ثانیه به کیلوبایت بر ثانیه
            if ([int64]::TryParse($speedBpsStr, [ref]$speedBps) -and $speedBps -gt 0) {
                $speedKb = [math]::Round($speedBps / 1024, 2)
            } else {
                $speedKb = 0
                $speedBps = 0
            }
            
            # ارسال نتیجه تست به بیرون از چرخه پردازش
            return [PSCustomObject]@{
                IP = $IP
                Bytes = $speedBps
                Speed_KB = $speedKb
            }
        }).AddArgument($IP).AddArgument($Domain).AddArgument($TargetUrl)

        # اضافه کردن کار به استخر پردازشی
        $PowerShell.RunspacePool = $RunspacePool
        [void]$Jobs.Add([PSCustomObject]@{
            Pipe = $PowerShell
            Status = $PowerShell.BeginInvoke()
        })
    }

    # ---------------------------------------------------------
    # بخش پنجم: جمع‌آوری نتایج تست‌ها در لحظه
    # ---------------------------------------------------------
    $CompletedCount = 0
    $TotalToTest = $IPsToTest.Count

    while ($Jobs.Count -gt 0) {
        # بررسی اینکه کدام تست‌ها تمام شده‌اند
        $CompletedJobs = @($Jobs | Where-Object { $_.Status.IsCompleted })
        
        foreach ($Job in $CompletedJobs) {
            $Result = $Job.Pipe.EndInvoke($Job.Status)
            $Job.Pipe.Dispose()
            $Jobs.Remove($Job) | Out-Null
            
            $CompletedCount++
            
            # ذخیره نتیجه در فایل Temp برای جلوگیری از تست مجدد در صورت کرش کردن اسکریپت
            # تمام آی‌پی‌ها (حتی خراب‌ها) ذخیره می‌شوند تا سیستم بداند تکلیفشان مشخص شده است.
            $csvLine = "$($Result.IP),$($Result.Bytes),$($Result.Speed_KB)"
            Add-Content -Path $TempFile -Value $csvLine
            
            # نمایش نتیجه در صفحه ترمینال با رنگ سبز (موفق) و قرمز (ناموفق)
            if ($Result.Speed_KB -gt 0) {
                Write-Host "[$CompletedCount/$TotalToTest] Tested: $($Result.IP) - Speed: $($Result.Speed_KB) KB/s" -ForegroundColor Green
            } else {
                Write-Host "[$CompletedCount/$TotalToTest] Tested: $($Result.IP) - Failed or 0 KB/s" -ForegroundColor DarkRed
            }
        }
        # صبر کوتاه برای کاهش فشار روی پردازنده سیستم
        Start-Sleep -Milliseconds 100
    }

    # بستن پروسه‌های درگیر بعد از اتمام تست‌ها
    $RunspacePool.Close()
    $RunspacePool.Dispose()
}

Write-Host "`n---------------------------------------------------" -ForegroundColor Gray
Write-Host "[INFO] Generating Final CSV and TXT files..." -ForegroundColor Cyan

# ---------------------------------------------------------
# بخش ششم: مرتب‌سازی نتایج و ساخت فایل‌های نهایی
# ---------------------------------------------------------
if (Test-Path $TempFile) {
    # خواندن تمام دیتای ذخیره شده در فایل Temp
    $data = Import-Csv $TempFile
    
    # فیلتر کردن لیست: فقط آی‌پی‌هایی که سرعتشان بیشتر از صفر بوده باقی می‌مانند (حذف آی‌پی‌های سوخته)
    $ValidData = $data | Where-Object { [int]$_.Bytes -gt 0 }
    
    if ($null -ne $ValidData -and $ValidData.Count -gt 0) {
        # مرتب‌سازی آی‌پی‌های سالم از پرسرعت‌ترین به کم‌سرعت‌ترین
        $SortedData = $ValidData | Sort-Object -Property @{Expression={[int]$_.Bytes}; Descending=$true}
        
        # ۱. ساخت خروجی اکسل (CSV)
        $SortedData | Export-Csv -Path $FinalCsvFile -NoTypeInformation -Encoding UTF8
        
        # ۲. ساخت خروجی متنی (TXT) با فرمت گرافیکی تمیز
        $TxtContent = [System.Collections.Generic.List[string]]::new()
        foreach ($row in $SortedData) {
            $bytes = [double]$row.Bytes
            # تبدیل بایت به مگابیت (برای نمایش سرعت به صورت مگابیت بر ثانیه)
            $mbps = [math]::Round(($bytes * 8) / 1000000, 2)
            # تبدیل بایت به مگابایت (برای نمایش مقدار دیتای دانلود شده در ثانیه)
            $mB_s = [math]::Round($bytes / 1048576, 2)
            
            $TxtContent.Add("=======================================")
            $TxtContent.Add("Target IP      : $($row.IP)")
            $TxtContent.Add("Download Speed : $mbps Mbps  ($mB_s MB/s)")
            $TxtContent.Add("=======================================")
            $TxtContent.Add("")
        }
        $TxtContent | Out-File -FilePath $FinalTxtFile -Encoding UTF8
        
        # در اینجا چون فایل‌های نهایی ساخته شدند و کار تمام شده، فایل موقت (Temp) را پاک می‌کنیم.
        # اگر می‌خواهید فایل Temp همیشه باقی بماند، کافی است ابتدای خط زیر یک علامت # بگذارید.
        #Remove-Item $TempFile -Force
        
        Write-Host "`n[SUCCESS] Done!" -ForegroundColor Green
        Write-Host "CSV File : $FinalCsvFile" -ForegroundColor Green
        Write-Host "TXT File : $FinalTxtFile" -ForegroundColor Green
    } else {
        # این پیام زمانی نمایش داده می‌شود که هیچ آی‌پی سالمی پیدا نشده باشد.
        Write-Host "`n[WARNING] No working IPs found. Only failed/0 KBps results exist." -ForegroundColor Yellow
        
        # در صورت پیدا نشدن آی‌پی سالم، فایل Temp پاک می‌شود تا در دفعه بعدی کل لیست از نو تست شود.
        # اگر نمی‌خواهید پاک شود، ابتدای خط زیر یک # بگذارید.
        #Remove-Item $TempFile -Force
    }
}

Write-Host "`nPress any key to exit..."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null