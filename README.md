<div align="center">

# 🚀 Cloudflare IP Speed Tester Pro (Upload & Download)
### ابزار تخصصی، چندنخی و هوشمند ارزیابی و استخراج تمیزترین آی‌پی‌های کلادفلر
### High-Performance Multi-Threaded Cloudflare Clean IP Scanner & Benchmarking Suite

[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue.svg)](https://learn.microsoft.com/en-us/powershell/)
[![Xray-core](https://img.shields.io/badge/Xray--core-Official_Upstream-red.svg)](https://github.com/XTLS/Xray-core)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

### 🌐 زبان / Language Selection
**[ 👈برای مشاهده راهنما به زبان انگلیسی اینجا کلیک کنید | Click here for English Documentation 👉](#-english-documentation)**

---

</div>

## 📑 فهرست مطالب (Table of Contents)
1. [معرفی کلی پروژه](#-معرفی-کلی-پروژه)
2. [قابلیت‌ها و ویژگی‌های جدید نسخه آپلود (نسخه حرفه‌ای)](#-قابلیت‌ها-و-ویژگی‌های-جدید-نسخه-آپلود-نسخه-حرفه‌ای)
3. [⚠️ مرحله صفر و بسیار مهم: دریافت آخرین نسخه هسته Xray-core](#-مرحله-صفر-و-بسیار-مهم-دریافت-آخرین-نسخه-هسته-xray-core)
4. [پیش‌نیازها و نحوه استخراج آی‌پی‌های اولیه (ip.txt)](#-پیش‌نیازها-و-نحوه-استخراج-آی‌پی‌های-اولیه-iptxt)
5. [آموزش گام‌به‌گام راه‌اندازی ورکر کلادفلر (worker.js)](#-آموزش-گام‌به‌گام-راه‌اندازی-ورکر-کلادفلر-workerjs)
6. [راهنمای جامع پیکربندی فایل config.json](#-راهنمای-جامع-پیکربندی-فایل-configjson)
7. [روش اجرای اسکریپت آپلود (مرحله به مرحله)](#-روش-اجرای-اسکریپت-آپلود-مرحله-به-مرحله)
8. [تحلیل ستون‌های خروجی و صدک پایداری P90](#-تحلیل-ستون‌های-خروجی-و-صدک-پایداری-p90)
9. [سوالات متداول، شبهات فنی و رفع عیب](#-سوالات-متداول-شبهات-فنی-و-رفع-عیب)
10. [🌐 English Documentation](#-english-documentation)

---

## 🌟 معرفی کلی پروژه

این پروژه یک پکیج جامع، مهندسی‌شده و فوق‌العاده سریع بر پایه **Windows PowerShell 5.1 و بالاتر** است که با هدف ارزیابی واقعی و موشکافانه آی‌پی‌های کلادفلر (Cloudflare Clean IPs) در بستر اینترنت‌های دارای اختلال و فیلترینگ شدید توسعه یافته است.

برخلاف اسکنرهای سنتی که صرفاً به پینگ ساده (ICMP Ping) یا دانلود فایل‌های کوچک تکیه می‌کنند، این ابزار گلوگاه اصلی ارتباطات اینترنت—یعنی **مسیر آپلود (Egress)، زمان دست‌دهی امن TLS/TCP Handshake، پکت لاس و نوسان (Jitter)، و سازگاری با تکنیک‌های بای‌پس فیلترینگ مانند Fragment**—را با هسته رسمی **Xray-core** مورد ارزیابی دقیق قرار می‌دهد.

---

## 🚀 قابلیت‌ها و ویژگی‌های جدید نسخه آپلود (نسخه حرفه‌ای)

در نسخه جدید این اسکریپت، ساختار برنامه به طور کامل بازنویسی و ماژولار شده و قابلیت‌های کلیدی زیر اضافه شده‌اند:

1. **فایل تنظیمات مستقل (`config.json`):** دیگر نیازی به دستکاری کدهای اسکریپت یا فایل‌های PowerShell ندارید. کلیه تنظیمات ورکر، کانفیگ VLESS، فرگمنت و پارامترهای زمانی از طریق فایل خوانای `config.json` کنترل می‌شوند.
2. **دو حالت تست مجزا و انعطاف‌پذیر:**
   * **حالت تست مستقیم ورکر (`EnableXrayTest: false`):** ارسال درخواست‌های آپلود مستقیماً با ابزار cURL به سمت لبه کلادفلر برای سنجش خام خط ارتباطی بدون درگیر شدن هسته پروکسی.
   * **حالت تست از طریق هسته Xray (`EnableXrayTest: true`):** تست کامل اتصال تونل VLESS به همراه کلیه قابلیت‌های مدرن هسته Xray.
3. **تست آپلود اختصاصی از داخل تونل Xray (`UploadViaXray: true`):**
   * با فعال بودن این گزینه، ترافیک استریم آپلود (Payload) از طریق پورت SOCKS5 محلی که خود اسکریپت برای هر تست ایجاد می‌کند تونل می‌شود. این کار به شما امکان می‌دهد سرعت واقعی آپلود را در حالتی که بسته‌ها تحت قوانین **Fragment** خرد می‌شوند اندازه بگیرید.
4. **تنظیمات کامل دور زدن فیلترینگ با فرگمنت (Fragmentation):**
   * کنترل مستقیم پارامترهای `packets` (مانند `tlshello` یا `1-3`)
   * کنترل طول بسته‌ها `length` (مانند `100-200`)
   * کنترل فاصله زمانی ارسال بسته‌ها `interval` (مانند `10-20` میلی‌ثانیه)
   * قابلیت خاموش/روشن کردن آنی (`enable: true/false`)
5. **مکانیزم هوشمند و تضمین‌شده بستن پروسه‌های Xray (Safe Kill Mechanism):**
   * رهگیری دقیق شناسه‌های فرآیند (Process ID) فقط برای نمونه‌هایی از `xray.exe` که توسط خود اسکریپت باز شده‌اند.
   * **عدم تداخل با VPN سیستم:** اگر از کلاینت‌های V2RayN، Hiddify، Nekoray یا هر فیلترشکن دیگری که از Xray استفاده می‌کند روی سیستم خود استفاده می‌کنید، اسکریپت به هیچ عنوان VPN شما را قطع نخواهد کرد و فقط پروسه‌های تست محلی خود را پاکسازی می‌کند.
   * جلوگیری قطعی از تجمع ده‌ها پروسه معلق در Task Manager.
6. **سیستم بازیابی و ادامه خودکار (Resume / Crash Recovery):**
   * ذخیره لحظه‌ای نتایج هر آی‌پی در فایل موقت `temp_data.csv`.
   * اگر برنامه به هر دلیلی بسته شود یا برق برود، با اجرای مجدد، آی‌پی‌های تست‌شده قبلی به صورت خودکار شناسایی شده و اسکریپت از ادامه کار شروع می‌کند.
7. **محاسبه هوشمند صدک پایداری P90 (Speed P90):**
   * حذف رکوردهای جهشی و کاذب به کمک فرمول‌های آماری صدک ۹۰ام و رتبه‌بندی نهایی آی‌پی‌ها بر اساس حداقل سرعت پایدار تضمین‌شده.
8. **پشتیبانی کامل از مسیرهای دارای فاصله (Folders with Spaces):**
   * اجرای بی‌نقص در مسیرهایی مانند `C:\My Projects\Speed Tester\` بدون ایجاد خطای پارس در cURL یا Xray.
9. **تولید پرسرعت فایل تستی در حافظه و هارد (Fast Zero-Fill Payload):**
   * ساخت فوری فایل تستی چند ده مگابایتی با استفاده از کلاس‌های خالص دات‌نت `[System.IO.File]` در کسری از ثانیه بدون فشار به رم یا هارد.

---

## ⚠️ مرحله صفر و بسیار مهم: دریافت آخرین نسخه هسته Xray-core

> [!IMPORTANT]
> **هسته Xray موجود در پکیج‌ها ممکن است به مرور زمان قدیمی شود.**
> برای اینکه اسکریپت بتواند به درستی با آخرین پروتکل‌ها ارتباط برقرار کرده و فیلترینگ شدید و اختلالات DPI را با دقت بالا دور بزند، **شما همیشه باید آخرین نسخه باینری رسمی Xray-core را مستقیماً از مخزن اصلی سازندگان آن دریافت کنید.**

### 📥 مراحل دانلود و استخراج هسته رسمی:
1. وارد صفحه انتشارات رسمی گیت‌هاب پروژه XTLS شوید:
   👈 **[https://github.com/XTLS/Xray-core/releases](https://github.com/XTLS/Xray-core/releases)**
2. آخرین نسخه پایدار (Latest Release) را پیدا کنید.
3. با توجه به معماری ویندوز خود، فایل زیپ مربوطه را دانلود کنید:
   * برای اکثر کامپیوترها (ویندوز ۶۴ بیتی معمولی): **`Xray-windows-64.zip`**
   * برای سیستم‌های ARM64: **`Xray-windows-arm64-v8a.zip`**
4. فایل زیپ را باز کرده و سه فایل زیر را استخراج کنید و **دقیقاً در کنار اسکریپت‌ها** (در همان پوشه اصلی برنامه) قرار دهید:
   * `xray.exe` (فایل اجرایی اصلی هسته)
   * `geoip.dat` (دیتابیس تشخیص موقعیت جغرافیایی)
   * `geosite.dat` (دیتابیس شناسایی دامنه‌ها)

*(اگر سیستم شما اجازه جایگزینی فایل داد، گزینه Replace را انتخاب کنید).*

---

## 🧰 پیش‌نیازها و نحوه استخراج آی‌پی‌های اولیه (ip.txt)

برای اینکه اسکریپت بتواند بهترین آی‌پی را برای شما پیدا کند، ابتدا به یک لیست خام از آی‌پی‌های کلادفلر نیاز دارید.

### ۱. استفاده از نرم‌افزار قدرتمند Angry IP Scanner (پیشنهادی)
بهترین، سبک‌ترین و مطمئن‌ترین ابزار برای اسکن مقدماتی پورت‌ها، نرم‌افزار متن‌باز **Angry IP Scanner** است:
* 📥 **[دانلود نسخه رسمی Angry IP Scanner](https://angryip.org/download/)**
* 💻 **[مشاهده سورس‌کد Angry IP Scanner در گیت‌هاب](https://github.com/angryip/ipscan)**
* 🌐 **[لیست کامل رنج آی‌پی‌های رسمی کلادفلر](https://www.cloudflare.com/ips/)**

### ۲. نحوه اسکن اولیه در Angry IP Scanner:
1. برنامه Angry IP Scanner را باز کنید.
2. در بخش **IP Range** یکی از ساب‌نت‌های کلادفلر (مثلاً `104.16.0.0` تا `104.16.255.255` یا `188.114.96.0` تا `188.114.99.255`) را وارد کنید.
3. در بخش **Preferences -> Ports**، پورت هدف را روی **`443`** قرار دهید.
4. دکمه **Start** را بزنید تا آی‌پی‌هایی که پورت ۴۴۳ آن‌ها باز است و پینگ می‌دهند مشخص شوند.
5. لیست آی‌پی‌های سبز شده را استخراج کرده و آن‌ها را داخل فایل متنی **`ip.txt`** (هر آی‌پی در یک خط جداگانه) ذخیره کنید.

---

## ☁️ آموزش گام‌به‌گام راه‌اندازی ورکر کلادفلر (worker.js)

برای اینکه تست‌های آپلود روی شبکه لبه کلادفلر با بالاترین دقت انجام شوند، نیاز به یک ورکر ساده و استاندارد در اکانت کلادفلر خود دارید:

1. وارد حساب کاربری خود در داشبورد [Cloudflare](https://dash.cloudflare.com) شوید.
2. از منوی سمت چپ روی **Workers & Pages** کلیک کنید.
3. روی دکمه آبی رنگ **Create application** و سپس **Create Worker** کلیک نمایید.
4. یک نام دلخواه برای ورکر خود انتخاب کرده و روی **Deploy** کلیک کنید.
5. پس از ساخته شدن، روی دکمه **Edit code** بزنید.
6. تمامی کدهای پیش‌فرض داخل ادیتور را پاک کنید.
7. محتویات فایل **`worker.js`** موجود در پوشه پروژه را باز کرده، کپی کنید و در ادیتور کلادفلر Paste نمایید.
8. دکمه **Save and Deploy** را در گوشه بالا سمت راست بزنید.
9. اکنون آدرس دامنه ورکر شما (مثلاً `my-speed-worker.myname.workers.dev`) آماده است. این آدرس را برای مرحله بعد به خاطر بسپارید.

---

## ⚙️ راهنمای جامع پیکربندی فایل config.json

در ریشه برنامه، فایلی به نام `config.json` وجود دارد. این فایل قلب تنظیمات شماست.

نمونه فایل `config.json`:

```json
{
  "WorkerDomain": "your-worker-subdomain.workers.dev",
  "VlessConfig": "vless://00000000-0000-0000-0000-000000000000@your-domain.com:443?path=%2F&security=tls&encryption=none&type=ws#MyConfig",
  "EnableXrayTest": true,
  "UploadViaXray": true,
  "Fragmentation": {
    "enable": true,
    "packets": "tlshello",
    "length": "100-200",
    "interval": "10-20"
  },
  "AdvancedSettings": {
    "FileSizeMB": 20,
    "UploadTimeSec": 15,
    "TestRounds": 2,
    "HandshakeRounds": 3,
    "PingCount": 4,
    "MaxJobs": 3,
    "ConnectTimeout": 5
  }
}
```

### 📋 تشریح کامل پارامترها و متغیرها:

| پارامتر | نوع | مقدار پیشنهادی | توضیحات فنی |
| :--- | :--- | :--- | :--- |
| **`WorkerDomain`** | String | `دامنه ورکر شما` | آدرس ساب‌دامین ورکر کلادفلر شما (بدون https:// و بدون اسلش اضافی). |
| **`VlessConfig`** | String | `لینک کامل vless://` | کانفیگ VLESS بر بستر TLS/WS که روی کلادفلر کار می‌کند. اسکریپت آدرس، پورت، UUID، مسیر (Path) و SNI را به صورت خودکار از آن استخراج می‌کند. |
| **`EnableXrayTest`** | Boolean | `true` | اگر `true` باشد، هسته Xray برای تست سلامت کانفیگ روشن می‌شود. اگر `false` باشد، اسکریپت بدون درگیر کردن Xray فقط آپلود مستقیم cURL روی ورکر را می‌سنجد. |
| **`UploadViaXray`** | Boolean | `true` | **ویژگی کلیدی:** اگر `true` باشد، فایل ۲۰ مگابایتی آپلود از طریق تونل محلی SOCKS5 و هسته Xray ارسال می‌شود تا سرعت واقعی با فرگمنت سنجیده شود. اگر `false` باشد، آپلود از طریق cURL مستقیم به آی‌پی ارسال می‌گردد. |
| **`Fragmentation.enable`** | Boolean | `true` | روشن یا خاموش کردن قابلیت خرد کردن پکت‌های TLS برای دور زدن فیلترینگ DPI. |
| **`Fragmentation.packets`** | String | `"tlshello"` | بسته‌های هدف فرگمنت. مقدار متداول `"tlshello"` یا بازه عددی مانند `"1-3"` است. |
| **`Fragmentation.length`** | String | `"100-200"` | بازه بایت‌هایی که هر تکه فرگمنت تقسیم می‌شود (مثلاً بین ۱۰۰ تا ۲۰۰ بایت). |
| **`Fragmentation.interval`** | String | `"10-20"` | فاصله زمانی تاخیر ارسال پکت‌ها به میلی‌ثانیه (برای عبور بدون مسدودی از سیستم‌های فیلترینگ). |
| **`AdvancedSettings.FileSizeMB`** | Number | `20` | حجم داده ارسالی برای تست اشباع پهنای باند آپلود (به مگابایت). |
| **`AdvancedSettings.UploadTimeSec`**| Number | `15` | حداکثر زمان مجاز به ثانیه برای تست آپلود هر راند. |
| **`AdvancedSettings.TestRounds`** | Number | `2` | تعداد راندهای تست آپلود برای محاسبه صدک آماری دقیق P90. |
| **`AdvancedSettings.HandshakeRounds`**| Number | `3` | تعداد دفعات سنجش دقیق زمان دست‌دهی امن TLS Handshake. |
| **`AdvancedSettings.PingCount`** | Number | `4` | تعداد پینگ برای محاسبه نرخ نوسان (Jitter) و افت بسته (Packet Loss). |
| **`AdvancedSettings.MaxJobs`** | Number | `3` | تعداد تست‌های همزمان (Threads). برای تست آپلود مقادیر ۳ تا ۵ توصیه می‌شود تا اینترنت شما دچار خفگی نشود. |

---

## 🚀 روش اجرای اسکریپت آپلود (مرحله به مرحله)

پس از آماده‌سازی پیش‌نیازها، مراحل زیر را به سادگی انجام دهید:

### مرحله اول: بررسی فایل‌های پوشه
مطمئن شوید در پوشه برنامه فایل‌های زیر حاضر باشند:
* `test-Upload-v0.08.ps1`
* `Run.bat`
* `config.json`
* `ip.txt` (شامل لیست آی‌پی‌های مدنظر)
* `xray.exe`, `geoip.dat`, `geosite.dat`

### مرحله دوم: اجرای اسکریپت
شما می‌توانید به دو روش اسکریپت را آغاز کنید:
1. **روش ساده (توصیه‌شده):** روی فایل **`Run.bat`** دابل‌کلیک کنید. این فایل به صورت خودکار مجوزهای لازم اجرای پاورشل را اعمال کرده و برنامه را استارت می‌زند.
2. **روش دستی در محیط ترمینال (PowerShell):**
   یک پنجره PowerShell باز کرده و دستور زیر را اجرا کنید:
   ```powershell
   powershell.exe -ExecutionPolicy Bypass -File .\test-Upload-v0.08.ps1
   ```

### مرحله سوم: نظارت بر فرآیند تست در کنسول هوشمند
اسکریپت با شروع کار، ابتدا تنظیمات پیکربندی، وضعیت فرگمنت و سلامت فایل‌های دیتابیس را بررسی می‌کند.
سپس به کمک **سیستم بافر هوشمند (Smart Buffer)** با وجود اینکه تست‌ها به صورت چندنخی و موازی اجرا می‌شوند، گزارش هر آی‌پی را با ظاهری مرتب، منظم و رنگی در ترمینال چاپ می‌کند:
* زمان دست‌دهی (Handshake ms)
* نوسان پینگ (Jitter ms)
* پکت لاس (Packet Loss %)
* وضعیت تست Xray
* سرعت هر راند آپلود و میانگین نهایی (Mbps و MB/s)

---

## 📊 تحلیل ستون‌های خروجی و صدک پایداری P90

پس از اتمام فرآیند (یا در صورت توقف)، نتایج نهایی به همراه مرتب‌سازی در فایل اکسل **`output_upload_result.csv`** ذخیره می‌شوند.

### تشریح ستون‌های فایل CSV:
* **`IP`:** آی‌پی تمیز تست‌شده کلادفلر.
* **`Speed_P90_Mbps` (معیار طلایی انتخاب):** سرعت بر پایه صدک ۹۰ام. این عدد تضمین‌کننده این است که ۹۰ درصد مواقع خط ارتباطی شما حداقل این پهنای باند را ارائه می‌دهد. بهترین آی‌پی‌ها بالاترین عدد را در این ستون دارند.
* **`Speed_Avg_Mbps`:** میانگین سرعت آپلود در راندهای مختلف.
* **`Speed_Max_Mbps`:** بیشترین سرعتی که آی‌پی در طول تست لمس کرده است.
* **`Handshake_ms`:** زمان لازم بر حسب میلی‌ثانیه برای اتصال امن TLS به سرور لبه. هر چقدر کمتر باشد، کانکشن شما سریع‌تر باز می‌شود.
* **`PacketLoss_Percent`:** درصد افت پکت (در آی‌پی‌های سالم باید ۰٪ باشد).
* **`Jitter_ms`:** میزان نوسان پینگ (برای وب‌گردی روان و بازی آنلاین مقادیر زیر ۵ میلی‌ثانیه عالی است).
* **`RoundResults_Mbps`:** جزئیات سرعت ثبت‌شده در تک‌تک راندها.
* **`TestDate`:** تاریخ و ساعت دقیق ثبت رکورد.

---

## 🧠 سوالات متداول، شبهات فنی و رفع عیب

### ۱. چرا فرگمنت در سرعت تست من تاثیری نگذاشت؟
اگر `UploadViaXray: false` باشد، تست آپلود مستقیماً توسط cURL به آی‌پی ارسال می‌شود و بسته‌ها فرگمنت نمی‌شوند. حتماً در `config.json` مقدار **`UploadViaXray: true`** را قرار دهید تا آپلود از دل تونل فرگمنت عبور کند.

### ۲. آیا اجرای اسکریپت باعث قطع شدن VPN شخصی من روی ویندوز می‌شود؟
**خیر!** در این نسخه، مکانیزم کشتن پروسه‌ها بر اساس رهگیری اختصاصی Process ID پیاده‌سازی شده و فقط و فقط همان پروسه‌هایی که توسط اسکریپت آغاز شده‌اند بسته می‌شوند. نرم‌افزارهای V2RayN، Hiddify، Nekoray و غیره هیچ آسیبی نمی‌بینند.

### ۳. چرا سرعت دانلود با آپلود متفاوت است؟
در اکثر شبکه‌های اینترنت (مخصوصاً ADSL و اینترنت‌های همراه در ایران)، پهنای باند آپلود نامتقارن (Asymmetric) و محدودتر از دانلود است. علاوه بر این، سیستم‌های فیلترینگ DPI تمرکز شدیدی بر مسدودسازی بسته‌های ارسالی (Upload TLS ClientHello) دارند. یافتن یک آی‌پی با آپلود پایدار بزرگترین چالش در حفظ پایداری تونل‌های V2Ray است.

---
---

<div id="-english-documentation"></div>

<div align="center">

# 🌐 English Documentation
### Cloudflare IP Speed Tester Pro (Upload & Download Suite)
**A state-of-the-art, multi-threaded benchmarking scanner for discovering resilient Cloudflare clean IPs under harsh censorship and DPI throttling.**

[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue.svg)](https://learn.microsoft.com/en-us/powershell/)
[![Xray-core](https://img.shields.io/badge/Xray--core-Official_Upstream-red.svg)](https://github.com/XTLS/Xray-core)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

**[👈 برای بازگشت به راهنمای زبان فارسی اینجا کلیک کنید 👉](#-cloudflare-ip-speed-tester-pro-upload--download)**

---

</div>

## 📑 English Table of Contents
1. [Overview & Architecture](#overview--architecture)
2. [What's New in the Upload Edition](#whats-new-in-the-upload-edition)
3. [⚠️ Step 0: Fetching Upstream Xray-Core (Mandatory)](#-step-0-fetching-upstream-xray-core-mandatory)
4. [Prerequisites & Clean IP Discovery (ip.txt)](#prerequisites--clean-ip-discovery-iptxt)
5. [Cloudflare Worker Deployment (worker.js)](#cloudflare-worker-deployment-workerjs)
6. [Configuration Reference (config.json)](#configuration-reference-configjson)
7. [Step-by-Step Execution Guide](#step-by-step-execution-guide)
8. [Interpreting Results & The P90 Metric](#interpreting-results--the-p90-metric)
9. [Technical FAQ & Troubleshooting](#technical-faq--troubleshooting)

---

## Overview & Architecture

**Cloudflare IP Speed Tester Pro** is an enterprise-grade PowerShell benchmarking suite engineered to identify the highest quality, most stable, and unthrottled Cloudflare Anycast edge IP addresses.

While basic ping tools or naive download tests fail to capture real-world connection resilience under deep packet inspection (DPI), this suite evaluates **Egress upload throughput, TCP/TLS Handshake latency, Packet Loss, Jitter, and end-to-end VLESS tunneling with Fragmentation bypass**.

---

## What's New in the Upload Edition

* **External `config.json` Configuration:** Zero code editing required. Worker domains, VLESS configuration, fragmentation parameters, and thread limits are managed in a structured JSON file.
* **Dual Operation Modes:**
  * **Direct Worker Mode (`EnableXrayTest: false`):** Directly evaluates HTTP/TLS POST throughput to the Cloudflare edge node using native cURL.
  * **Xray Tunnel Mode (`EnableXrayTest: true`):** Establishes an authentic VLESS connection through the local Xray-core.
* **In-Tunnel Upload Benchmarking (`UploadViaXray: true`):**
  * When enabled, the 20MB test payload is streamed through the ephemeral local SOCKS5 proxy spawned by Xray. This allows you to evaluate actual throughput when packets are fragmented to bypass DPI.
* **Full Fragmentation Suite:** Granular control over `packets` (e.g. `tlshello`), byte chunk length (`length: 100-200`), and packet interval (`interval: 10-20ms`).
* **Non-Destructive Process Management (Safe Kill):**
  * Thread-safe PID tracking (`$Global:TrackedXrayPids`) targets only the script-spawned `xray.exe` instances.
  * **Zero conflict with system VPNs:** Your running desktop clients (v2rayN, Nekoray, Hiddify) will never be terminated or disrupted.
* **Seamless Resume & Crash Recovery:** Real-time state preservation in `temp_data.csv`. Interruptions or reboots will not lose progress.
* **P90 Percentile Sorting (`Speed_P90_Mbps`):** Filters out anomalous latency spikes and ranks IPs by guaranteed sustained minimum bandwidth.
* **Space-Resilient Path Support:** Fully supports directory paths containing spaces.
* **Pure Windows PowerShell 5.1+ Compatibility:** Out-of-the-box operation on standard Windows 10/11 installations without extra dependencies.

---

## ⚠️ Step 0: Fetching Upstream Xray-Core (Mandatory)

> [!IMPORTANT]
> To ensure maximum compatibility with modern DPI evasion techniques and protocol upgrades, **always source the official Xray core binaries directly from upstream developers.**

### How to update Xray-core:
1. Visit the official XTLS/Xray-core releases page:
   👉 **[https://github.com/XTLS/Xray-core/releases](https://github.com/XTLS/Xray-core/releases)**
2. Download the latest release archive for Windows:
   * 64-bit Windows: **`Xray-windows-64.zip`**
   * ARM64 Windows: **`Xray-windows-arm64-v8a.zip`**
3. Extract the following three files directly into the root folder of this project (alongside `SpeedTesterPro.ps1`):
   * `xray.exe`
   * `geoip.dat`
   * `geosite.dat`

---

## Prerequisites & Clean IP Discovery (ip.txt)

To scan and rank IPs, you need a pool of candidate Cloudflare IP addresses.

### 1. Recommended Scanner: Angry IP Scanner
* 📥 **[Download Angry IP Scanner (Official Site)](https://angryip.org/download/)**
* 💻 **[Angry IP Scanner GitHub Repository](https://github.com/angryip/ipscan)**
* 🌐 **[Official Cloudflare IP Ranges](https://www.cloudflare.com/ips/)**

### 2. Scanning Instructions:
1. Open Angry IP Scanner.
2. Enter a Cloudflare CIDR range (e.g., `104.16.0.0` to `104.16.255.255` or `188.114.96.0` to `188.114.99.255`).
3. Under **Preferences -> Ports**, configure target port to **`443`**.
4. Click **Start**. Export responsive IP addresses and paste them into **`ip.txt`** (one IP per line).

---

## Cloudflare Worker Deployment (worker.js)

To benchmark upload bandwidth against Cloudflare's edge without disk bottleneck:

1. Log into your [Cloudflare Dashboard](https://dash.cloudflare.com).
2. Navigate to **Workers & Pages -> Create Application -> Create Worker**.
3. Choose a worker name and click **Deploy**.
4. Click **Edit Code**, delete all default template code.
5. Paste the complete contents of **`worker.js`** located in this repository.
6. Click **Save and Deploy**.
7. Note your worker URL (e.g., `my-speed-worker.myname.workers.dev`).

---

## Configuration Reference (config.json)

Modify `config.json` with your parameters:

```json
{
  "WorkerDomain": "your-worker-subdomain.workers.dev",
  "VlessConfig": "vless://00000000-0000-0000-0000-000000000000@your-domain.com:443?path=%2F&security=tls&encryption=none&type=ws#MyConfig",
  "EnableXrayTest": true,
  "UploadViaXray": true,
  "Fragmentation": {
    "enable": true,
    "packets": "tlshello",
    "length": "100-200",
    "interval": "10-20"
  },
  "AdvancedSettings": {
    "FileSizeMB": 20,
    "UploadTimeSec": 15,
    "TestRounds": 2,
    "HandshakeRounds": 3,
    "PingCount": 4,
    "MaxJobs": 3,
    "ConnectTimeout": 5
  }
}
```

### Parameter Breakdown:

| Key | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| **`WorkerDomain`** | String | `subdomain.workers.dev` | Your Cloudflare Worker hostname (without https:// prefix). |
| **`VlessConfig`** | String | `vless://...` | Full VLESS URI. The script automatically parses the UUID, port, TLS security, and WS path. |
| **`EnableXrayTest`** | Boolean | `true` | When `true`, tests configuration connectivity via Xray-core. |
| **`UploadViaXray`** | Boolean | `true` | When `true`, the 20MB upload payload is routed through Xray's local SOCKS5 proxy to measure actual fragmentation upload speeds. |
| **`Fragmentation.enable`** | Boolean | `true` | Enables or disables TLS ClientHello packet fragmentation. |
| **`Fragmentation.packets`** | String | `"tlshello"` | Packet target for fragmentation (`"tlshello"` or packet range `"1-3"`). |
| **`Fragmentation.length`** | String | `"100-200"` | Fragment byte length range. |
| **`Fragmentation.interval`** | String | `"10-20"` | Delay interval between fragments in milliseconds. |
| **`AdvancedSettings.FileSizeMB`** | Number | `20` | Upload benchmark stream payload size in Megabytes. |
| **`AdvancedSettings.UploadTimeSec`** | Number | `15` | Maximum upload timeout per round in seconds. |
| **`AdvancedSettings.TestRounds`** | Number | `2` | Number of test cycles per IP to calculate statistical P90. |
| **`AdvancedSettings.HandshakeRounds`**| Number| `3` | Iterations for TCP/TLS handshake latency calculation. |
| **`AdvancedSettings.PingCount`** | Number | `4` | ICMP probe count for Jitter and Packet Loss evaluation. |
| **`AdvancedSettings.MaxJobs`** | Number | `3` | Concurrent worker threads (3-5 recommended to prevent local bandwidth saturation). |

---

## Step-by-Step Execution Guide

1. Ensure the following files reside in your workspace directory:
   * `test-Upload-v0.08.ps1`
   * `Run.bat`
   * `config.json`
   * `ip.txt`
   * `xray.exe`, `geoip.dat`, `geosite.dat`
2. **Launch the test:**
   * Double-click **`Run.bat`**, or
   * Launch a PowerShell terminal and run:
     ```powershell
     powershell.exe -ExecutionPolicy Bypass -File .\test-Upload-v0.08.ps1
     ```
3. Observe real-time progress via the **Smart Buffer** console. Handshake, jitter, loss, and upload speeds are printed sequentially.
4. When finished, inspect the ranked results in **`output_upload_result.csv`**.

---

## Interpreting Results & The P90 Metric

* **`IP`:** The candidate Cloudflare clean IP.
* **`Speed_P90_Mbps`:** The 90th percentile speed threshold. Indicates the speed sustained 90% of the time, effectively discarding illusory transient peaks.
* **`Speed_Avg_Mbps`:** Mathematical mean across all completed rounds.
* **`Speed_Max_Mbps`:** Highest peak velocity observed.
* **`Handshake_ms`:** Latency incurred during initial TCP + TLS negotiation.
* **`PacketLoss_Percent`:** Packet loss ratio (0% is ideal).
* **`Jitter_ms`:** Connection stability metric; values under 5ms provide optimal responsiveness.

---

## Technical FAQ & Troubleshooting

### Q: Why did fragmentation not alter my test results?
If `UploadViaXray` is set to `false`, the upload payload is transmitted directly via cURL without passing through Xray's outbound fragment rules. Set **`UploadViaXray: true`** in `config.json`.

### Q: Will this kill my personal active VPN connection?
**No.** The script utilizes precise PID tracking (`$Global:TrackedXrayPids`) and targets only child processes spawned by the current script execution. Any system-wide VPN client using Xray remains unaffected.

---

<div align="center">
Developed with precision for network freedom and high-resilience connectivity.
</div>
