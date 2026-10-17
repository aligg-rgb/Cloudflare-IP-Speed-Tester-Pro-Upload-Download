<div align="center">

# 🚀 Cloudflare IP Speed Tester Pro (Upload & Download)
### ابزار تخصصی، چندنخی و هوشمند ارزیابی و استخراج تمیزترین آی‌پی‌های کلادفلر
### High-Performance Multi-Threaded Cloudflare Clean IP Scanner & Benchmarking Suite

[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue.svg)](https://learn.microsoft.com/en-us/powershell/)
[![Xray-core](https://img.shields.io/badge/Xray--core-Official_Upstream-red.svg)](https://github.com/XTLS/Xray-core)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

### 🌐 زبان / Language Selection
**[ 👈 برای مشاهده راهنما به زبان انگلیسی اینجا کلیک کنید | Click here for English Documentation 👉](#-english-documentation)**

---

👉 **[لینک ویدیو آموزشی هم به زودی میزارم]**

</div>

---

## 📑 فهرست مطالب (Table of Contents)
1. [🌟 معرفی کلی پروژه](#-معرفی-کلی-پروژه)
2. [🚀 قابلیت‌های اصلی و ویژگی‌های جدید (نسخه حرفه‌ای آپلود و دانلود)](#-قابلیت‌های-اصلی-و-ویژگی‌های-جدید-نسخه-حرفه‌ای-آپلود-و-دانلود)
3. [⚠️ مرحله صفر و بسیار مهم: دریافت آخرین نسخه هسته Xray-core](#-مرحله-صفر-و-بسیار-مهم-دریافت-آخرین-نسخه-هسته-xray-core)
4. [🧰 پیش‌نیازها و نحوه استخراج آی‌پی‌های اولیه (ip.txt)](#-پیش‌نیازها-و-نحوه-استخراج-آی‌پی‌های-اولیه-iptxt)
5. [☁️ آموزش گام‌به‌گام راه‌اندازی ورکر کلادفلر (worker.js)](#-آموزش-گام‌به‌گام-راه‌اندازی-ورکر-کلادفلر-workerjs)
6. [📤 راهنمای جامع تنظیمات اسکریپت آپلود و فایل config.json](#-راهنمای-جامع-تنظیمات-اسکریپت-آپلود-و-فایل-configjson)
7. [📥 راهنمای جامع تنظیمات اسکریپت دانلود (Download Scanner)](#-راهنمای-جامع-تنظیمات-اسکریپت-دانلود-download-scanner)
8. [🚀 روش اجرای اسکریپت‌ها (مرحله به مرحله)](#-روش-اجرای-اسکریپت‌ها-مرحله-به-مرحله)
9. [💾 قابلیت هوشمند ادامه کار (Resume Feature)](#-قابلیت-هوشمند-ادامه-کار-resume-feature)
10. [📊 تحلیل ستون‌های خروجی و صدک پایداری P90](#-تحلیل-ستون‌های-خروجی-و-صدک-پایداری-p90)
11. [🔀 تغییر فرمول ساخت چیدمان خروجی دلخواه (Sorting Options)](#-تغییر-فرمول-ساخت-چیدمان-خروجی-دلخواه-sorting-options)
12. [🧹 پاک‌سازی متن‌های اضافی از فایل‌های CSV (ترفند VS Code)](#-پاک‌سازی-متن‌های-اضافی-از-فایل‌های-csv-ترفند-vs-code)
13. [🧠 پرسش‌های چالش‌برانگیز، شبهات فنی گسترده و رفع عیب (FAQ)](#-پرسش‌های-چالش‌برانگیز-شبهات-فنی-گسترده-و-رفع-عیب-faq)
14. [🌐 ابزارهای پیشنهادی، مانیتورینگ و آموزش ویدیویی](#-ابزارهای-پیشنهادی-مانیتورینگ-و-آموزش-ویدیویی)
15. [🌐 English Documentation](#-english-documentation)

---

## 🌟 معرفی کلی پروژه

به کامل‌ترین و پیشرفته‌ترین مستندات پروژه اسکریپت‌های سنجش کیفیت آی‌پی‌های کلادفلر (Cloudflare) خوش آمدید!  
این پروژه یک پکیج جامع، مهندسی‌شده و فوق‌العاده سریع شامل مجموعه اسکریپت‌های قدرتمند بر پایه **Windows PowerShell 5.1 و بالاتر** است که برای تست، آنالیز شبکه‌ای و استخراج پایدارترین و سریع‌ترین آی‌پی‌های تمیز (Clean IPs) جهت استفاده در شبکه‌های فیلترشده (پنل‌های BPB، کانفیگ‌های V2Ray/VLESS، Fragment و غیره) طراحی و توسعه یافته است.

برخلاف اسکنرهای سنتی که صرفاً به پینگ ساده (ICMP Ping) یا دانلود فایل‌های کوچک تکیه می‌کنند، این ابزار علاوه بر سنجش دقیق پهنای باند دانلود، گلوگاه اصلی ارتباطات اینترنت محدودشده—یعنی **مسیر آپلود (Egress)، زمان دست‌دهی امن TLS/TCP Handshake، پکت لاس و نوسان (Jitter)، و سازگاری با تکنیک‌های بای‌پس فیلترینگ مانند Fragment**—را با هسته رسمی **Xray-core** مورد ارزیابی دقیق قرار می‌دهد.

---

## 🚀 قابلیت‌های اصلی و ویژگی‌های جدید (نسخه حرفه‌ای آپلود و دانلود)

### 📥 ۱. اسکریپت تست دانلود (Download Scanner)
این اسکریپت پهنای باند دریافت (Ingress) اطلاعات را از لبه شبکه کلادفلر به سمت کلاینت می‌سنجد:
* ⚡ **تست همزمان (Multi-Threading):** بررسی چند آی‌پی به صورت موازی برای صرفه‌جویی چشمگیر در زمان.
* 📊 **سنجش دقیق پهنای باند:** محاسبه دقیق سرعت دریافت و تبدیل هوشمند بایت به مگابیت (Mbps) و مگابایت بر ثانیه (MB/s) در خروجی.

### 📤 ۲. اسکریپت پیشرفته تست آپلود (Upload Scanner - نسخه حرفه‌ای)
ابزاری فوق‌العاده دقیق برای سنجش گلوگاه اصلی اینترنت محدودشده (اختلالات آپلود و TLS/TCP). در نسخه جدید این اسکریپت، ساختار برنامه به طور کامل بازنویسی و ماژولار شده و قابلیت‌های کلیدی زیر را ارائه می‌دهد:

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
   * **عدم تداخل با VPN سیستم:** اگر از کلاینت‌های v2rayN، Hiddify، Nekoray یا هر فیلترشکن دیگری که از Xray استفاده می‌کند روی سیستم خود استفاده می‌کنید، اسکریپت به هیچ عنوان VPN شما را قطع نخواهد کرد و فقط پروسه‌های تست محلی خود را پاکسازی می‌کند.
   * جلوگیری قطعی از تجمع ده‌ها پروسه معلق در Task Manager.
6. **بافر هوشمند (Smart Buffer):** اجرای تست‌ها به صورت همزمان، اما نمایش خروجی‌ها در ترمینال دقیقاً به ترتیب شماره نوبت با ظاهری منظم و رنگی.
7. **تایم‌اوت حجمی (Volume-Based Timeout):** ارزیابی سرعت بر اساس حجم منتقل‌شده در یک بازه زمانی مشخص.
8. **سنجش Jitter، Packet Loss و تست اختصاصی Handshake:** ارزیابی افت بسته‌ها، نوسان شبکه پیش از شروع تست و محاسبه میانگین زمان دست‌دهی امن (TCP/TLS).
9. **محاسبه هوشمند صدک پایداری P90 (Speed P90):** حذف رکوردهای جهشی و نویزهای کاذب به کمک فرمول‌های آماری صدک ۹۰ام و رتبه‌بندی نهایی آی‌پی‌ها بر اساس حداقل سرعت پایدار تضمین‌شده.
10. **پشتیبانی کامل از مسیرهای دارای فاصله (Folders with Spaces):** اجرای بی‌نقص در مسیرهایی مانند `C:\My Projects\Speed Tester\` بدون ایجاد خطای پارس در cURL یا Xray.
11. **تولید پرسرعت فایل تستی در حافظه و هارد (Fast Zero-Fill Payload):** ساخت فوری فایل تستی چند ده مگابایتی با استفاده از کلاس‌های خالص دات‌نت `[System.IO.File]` در کسری از ثانیه بدون فشار به رم یا هارد.

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

برای استفاده از این اسکریپت‌های قدرتمند، شما ابتدا به یک لیست خام از آی‌پی‌های کلادفلر نیاز دارید تا اسکریپت بتواند آن‌ها را تست و غربالگری کند.

### ۱. استفاده از نرم‌افزار قدرتمند Angry IP Scanner (پیشنهادی)
در دنیای شبکه، هزاران برنامه و اسکنر مختلف برای پیدا کردن آی‌پی وجود دارد که ممکن است شما را سردرگم کنند. اما **پیشنهاد قطعی و تاییدشده‌ی ما** برای استخراج رنج آی‌پی‌ها، استفاده از نرم‌افزار محبوب، سبک و متن‌باز **Angry IP Scanner** است.

**لینک‌های ضروری برای شروع:**
* 📥 **[دانلود نسخه رسمی Angry IP Scanner (سایت رسمی)](https://angryip.org/download/)**
* 💻 **[مخزن سورس‌کد Angry IP Scanner در گیت‌هاب](https://github.com/angryip/ipscan)**
* 🌐 **[لیست کامل رنج آی‌پی‌های رسمی کلادفلر (برای اسکن اولیه)](https://www.cloudflare.com/ips/)**

### ۲. نحوه اسکن اولیه در Angry IP Scanner:
1. برنامه Angry IP Scanner را باز کنید.
2. در بخش **IP Range** یکی از ساب‌نت‌های کلادفلر (مثلاً `104.16.0.0` تا `104.16.255.255` یا `188.114.96.0` تا `188.114.99.255`) را وارد کنید.
3. در بخش **Preferences -> Ports**، پورت هدف را روی **`443`** قرار دهید.
4. دکمه **Start** را بزنید تا آی‌پی‌هایی که پورت ۴۴۳ آن‌ها باز است و پینگ می‌دهند مشخص شوند.
5. پس از اسکن و پیدا کردن آی‌پی‌های فعال (سبزشده) توسط این برنامه، کافیست آن‌ها را داخل فایل متنی **`ip.txt`** (هر آی‌پی در یک خط جداگانه) کپی و ذخیره کنید و بقیه کار (سنجش آپلود، دانلود، Handshake و...) را به اسکریپت‌های هوشمند ما بسپارید!

> 💡 **نکته مهم:** بنده یک لیست `ip.txt` برای شروع در پروژه گذاشته‌ام، ولی استفاده از لیست آماده اصلاً گزینه خوب و حرفه‌ای نیست؛ چرا که ممکن است هیچ‌یک از این آی‌پی‌ها مناسب اینترنت و سرویس‌دهنده (ISP) شما نباشند. بنابراین حتماً با استفاده از اسکنر، لیست آی‌پی مخصوص به خط خودتان را تهیه کنید.

---

## ☁️ آموزش گام‌به‌گام راه‌اندازی ورکر کلادفلر (worker.js)

این پروژه شامل کدهای سمت سرور (جاوا اسکریپت) در فایل `worker.js` است که باید روی شبکه کلادفلر دیپلوی (Deploy) شود. اسکریپت‌های تست در سیستم ویندوز، درخواست‌های سنگین خود را به این ورکر ارسال می‌کنند تا پایداری مسیر شبکه با بالاترین دقت سنجیده شود.

برای قرار دادن این کد روی کلادفلر، مراحل ساده‌ی زیر را طی کنید:

1. **ورود به اکانت کلادفلر:** وارد حساب کاربری خود در داشبورد [Cloudflare](https://dash.cloudflare.com) شوید.
2. **بخش ورکرها:** از منوی سمت چپ، روی گزینه **`Workers & Pages`** کلیک کنید.
3. **ساخت ورکر جدید:** 
   * روی دکمه آبی رنگ **`Create application`** و سپس **`Create Worker`** کلیک نمایید.
   * یک نام دلخواه برای ورکر خود انتخاب کرده و دکمه **`Deploy`** را بزنید.
4. **قرار دادن کد:**
   * پس از ساخته شدن، در صفحه جدید روی دکمه **`Edit code`** کلیک کنید.
   * تمام کدهای پیش‌فرضِ موجود در صفحه ویرایشگر را به طور کامل پاک کنید.
   * کدهای داخل فایل **`worker.js`** موجود در پوشه پروژه را باز کرده، کپی کنید و در ادیتور کلادفلر Paste نمایید.
5. **ذخیره نهایی:** در گوشه بالا سمت راست، روی دکمه **`Save and Deploy`** کلیک کنید.
6. اکنون آدرس دامنه ورکر شما (مثلاً `my-speed-worker.myname.workers.dev`) آماده است. این آدرس را برای مرحله بعد به خاطر بسپارید.

---

## 📤 راهنمای جامع تنظیمات اسکریپت آپلود و فایل config.json

در ریشه برنامه، فایلی به نام `config.json` وجود دارد. این فایل قلب تنظیمات اسکریپت آپلود شماست.

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
| **`WorkerDomain`** | String | `دامنه ورکر شما` | آدرس ساب‌دامین ورکر کلادفلر شما یا دامنه اختصاصی (بدون `https://` و بدون اسلش اضافی). |
| **`VlessConfig`** | String | `لینک کامل vless://` | کانفیگ VLESS بر بستر TLS/WS که روی کلادفلر کار می‌کند. اسکریپت آدرس، پورت، UUID، مسیر (Path) و SNI را به صورت خودکار از آن استخراج می‌کند. |
| **`EnableXrayTest`** | Boolean | `true` | اگر `true` باشد، هسته Xray برای تست سلامت کانفیگ روشن می‌شود. اگر `false` باشد، اسکریپت بدون درگیر کردن Xray فقط آپلود مستقیم cURL روی ورکر را می‌سنجد. |
| **`UploadViaXray`** | Boolean | `true` | **ویژگی کلیدی:** اگر `true` باشد، فایل ۲۰ مگابایتی آپلود از طریق تونل محلی SOCKS5 و هسته Xray ارسال می‌شود تا سرعت واقعی با فرگمنت سنجیده شود. اگر `false` باشد، آپلود از طریق cURL مستقیم به آی‌پی ارسال می‌گردد. |
| **`Fragmentation.enable`** | Boolean | `true` | روشن یا خاموش کردن قابلیت خرد کردن پکت‌های TLS برای دور زدن فیلترینگ DPI. |
| **`Fragmentation.packets`** | String | `"tlshello"` | بسته‌های هدف فرگمنت. مقدار متداول `"tlshello"` یا بازه عددی مانند `"1-3"` است. |
| **`Fragmentation.length`** | String | `"100-200"` | بازه بایت‌هایی که هر تکه فرگمنت تقسیم می‌شود (مثلاً بین ۱۰۰ تا ۲۰۰ بایت). |
| **`Fragmentation.interval`** | String | `"10-20"` | فاصله زمانی تاخیر ارسال پکت‌ها به میلی‌ثانیه (برای عبور بدون مسدودی از سیستم‌های فیلترینگ). |
| **`AdvancedSettings.FileSizeMB`** | Number | `20` | حجم فایل مجازی (داده ارسالی) برای تست اشباع پهنای باند آپلود (به مگابایت). |
| **`AdvancedSettings.UploadTimeSec`**| Number | `15` | حداکثر زمان مجاز به ثانیه برای تست آپلود هر راند. کاهش این عدد به مثلاً `10` ثانیه سرعت اسکن را بالا می‌برد اما دقت رسیدن به سقف سرعت را در خطوط نوسان‌دار کاهش می‌دهد. |
| **`AdvancedSettings.TestRounds`** | Number | `2` | هر آی‌پی چند بار پشت سر هم زیر تست آپلود برود. عدد `2` برای اطمینان از صحت سرعت و محاسبه صدک آماری دقیق P90 عالی است. |
| **`AdvancedSettings.HandshakeRounds`**| Number | `3` | تعداد دفعات سنجش دقیق زمان اتصال اولیه و دست‌دهی امن TLS Handshake برای هر آی‌پی. |
| **`AdvancedSettings.PingCount`** | Number | `4` | تعداد پینگ برای محاسبه نرخ نوسان (Jitter) و افت بسته (Packet Loss). |
| **`AdvancedSettings.MaxJobs`** | Number | `3` | تعداد آی‌پی‌هایی که همزمان تست می‌شوند (Threads). برای آپلود، اعداد بالای ۳ تا ۵ ممکن است پهنای باند شما را خفه کنند. |
| **`AdvancedSettings.ConnectTimeout`** | Number | `5` | حداکثر زمان انتظار (به ثانیه) برای برقراری اتصال اولیه پیش از رد کردن آی‌پی. |

### ⏱️ مکانیزم زمان اتصال در موتور اجرایی آپلود (نحوه عملکرد cURL):

در بخش اجرایی اسکریپت آپلود، پارامترهای شما به این شکل به موتور `curl` خورانده می‌شوند:

```powershell
$curlArgs = @(
    "-k", "-s",
    "-o", "`"$DiscardBody`"",
    "-w", "%{size_upload}|%{time_total}",
    "-X", "POST",
    "--data-binary", "@$PayloadPath",
    "--connect-timeout", "5",                    # زمان تایم‌اوت اتصال (ثانیه)
    "--max-time", "$UploadTimeSec",              # زمان کل تست آپلود
    "--resolve", "${CleanDomain}:443:${ip}",
    "https://${CleanDomain}/"
)
```

* **`--connect-timeout 5` (معادل `ConnectTimeout`):** این پارامتر به `curl` می‌گوید که مانند زنگ در، نهایتاً **۵ ثانیه** منتظر باز شدن در (برقراری اتصال اولیه و Handshake) بماند. اگر اینترنت قطعی‌های لحظه‌ای زیادی دارد این عدد برای شما مناسب است، اما اگر می‌خواهید فقط آی‌پی‌های فوق‌سریع را پیدا کنید، می‌توانید این عدد را روی `3` تنظیم کنید تا آی‌پی‌های کند سریع‌تر خط بخورند.
* **`--max-time "$UploadTimeSec"`:** این دستور محدودیت زمانی کل فرآیند را از متغیر اولیه (مثلاً ۱۵ ثانیه) می‌گیرد.

*(نکته: در نسخه‌های قدیمی‌تر اسکریپت آپلود که فاقد `config.json` هستند، متغیرهایی نظیر `$Domain`، `$FileSizeMB`، `$UploadTimeSec`، `$TestRounds`، `$HandshakeRounds`، `$PingCount` و `$MaxJobs` مستقیماً در بالای فایل پاورشل مقداردهی می‌شوند).*

---

## 📥 راهنمای جامع تنظیمات اسکریپت دانلود (Download Scanner)

اسکریپت دانلود تنظیمات بسیار ساده اما مهمی دارد. تنظیمات متغیرهای اولیه در بالای اسکریپت قرار دارند:

```powershell
$TargetUrl = "[https://www.digitalocean.com](https://www.digitalocean.com)" # سایت هدف برای دانلود
$Domain = "[www.digitalocean.com](https://www.digitalocean.com)"            # دامنه سایت هدف برای تفکیک SNI
$MaxThreads = 6                             # تعداد تست‌های همزمان (Threads)
```

### توضیحات متغیرهای دانلود با مثال:

* **`$TargetUrl` و `$Domain`:** در این بخش باید آدرس سایتی را قرار دهید که پشت کلادفلر باشد و در شبکه شما فیلتر نباشد. این سایت به عنوان سرور دانلود برای سنجش سرعت آی‌پی‌ها استفاده می‌شود.
  * *مثال:* در کد پیش‌فرض از `https://www.digitalocean.com` استفاده شده است. اگر این سایت فیلتر شد، می‌توانید آن را به سایت دیگری مثل `https://www.speedtest.net` تغییر دهید (هر دو متغیر باید هم‌نام باشند).
* **`$MaxThreads = 6`:** تعیین‌کننده تعداد آی‌پی‌هایی است که به صورت همزمان در لحظه تست می‌شوند. برای اینترنت‌های خانگی معمولی اعداد **۴ تا ۶** مناسب است.

### ⏱️ تنظیمات پیشرفته زمان اتصال (پنهان در کد دانلود):

در قلب اسکریپت دانلود، خطی وجود دارد که فرمان اصلی `curl` را اجرا می‌کند:

```powershell
$output = & curl.exe -s -k -L -o NUL -w '%{speed_download}' --connect-timeout 2 --max-time 4 --resolve "$($Domain):443:$IP" $TargetUrl
```

* **`--connect-timeout 2`:** این پارامتر به اسکریپت می‌گوید برای برقراری اتصال اولیه (Handshake) با هر آی‌پی، حداکثر **۲ ثانیه** منتظر بماند. اگر آی‌پی در ۲ ثانیه پاسخ نداد، به عنوان آی‌پی مرده (Failed) شناسایی شده و رد می‌شود. اگر اینترنت شما کند است، می‌توانید این عدد را به `3` یا `4` افزایش دهید.
* **`--max-time 4`:** کل زمان تست دانلود روی ۴ ثانیه محدود شده است. این زمان برای رسیدن به پیک سرعت لبه شبکه کافیست و از هدر رفتن ترافیک جلوگیری می‌کند.

---

## 🚀 روش اجرای اسکریپت‌ها (مرحله به مرحله)

پس از آماده‌سازی پیش‌نیازها، مراحل زیر را به سادگی انجام دهید:

### مرحله اول: بررسی فایل‌های پوشه
مطمئن شوید در پوشه برنامه فایل‌های زیر حاضر باشند:
* `test-Upload-v0.08.ps1` (و یا اسکریپت دانلود)
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

## 💾 قابلیت هوشمند ادامه کار (Resume Feature)

هر دو اسکریپت آپلود و دانلود مجهز به مکانیزم قدرتمند **Resume (بازیابی خودکار)** هستند:

* نتایج هر آی‌پی به صورت لحظه به لحظه در فایل موقت **`temp_data.csv`** ذخیره می‌شوند.
* در صورت قطعی برق، کرش کردن سیستم یا بستن ناگهانی برنامه، زحمات شما به هیچ عنوان هدر نمی‌رود.
* با اجرای مجدد اسکریپت، برنامه به صورت خودکار فایل `temp_data.csv` را شناسایی کرده، آی‌پی‌های تست‌شده قبلی را رد می‌کند و مستقیماً از ادامه لیست تست را از سر می‌گیرد.

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

## 🔀 تغییر فرمول ساخت چیدمان خروجی دلخواه (Sorting Options)

به صورت پیش‌فرض، اسکریپت نتایج را بر اساس سرعت آپلود مرتب می‌کند. در بخش مرتب‌سازی انتهای اسکریپت آپلود، کد پیش‌فرض به شکل زیر است:

```powershell
$sorted = $validData | Sort-Object -Property @{Expression={[double]($_.Speed_Avg_Mbps -replace ',', '.')}; Descending=$true}
```

شما می‌توانید با جایگزین کردن کدهای زیر، اولویت چیدمان خروجی نهایی را مطابق نیاز خود تغییر دهید:

* **چیدمان بر اساس کمترین زمان Handshake (سریع‌ترین پینگ واقعی):**
  ```powershell
  $sorted = $validData | Sort-Object -Property @{Expression={[double]($_.Handshake_ms -replace ',', '.')}; Descending=$false}
  ```

* **چیدمان بر اساس کمترین نوسان (Jitter) مناسب برای گیمرها و تماس صوتی/تصویری:**
  ```powershell
  $sorted = $validData | Sort-Object -Property @{Expression={[double]($_.Jitter_ms -replace ',', '.')}; Descending=$false}
  ```

* **چیدمان بر اساس بالاترین سرعت صدک (P90) برای تضمین پایداری:**
  ```powershell
  $sorted = $validData | Sort-Object -Property @{Expression={[double]($_.Speed_P90_Mbps -replace ',', '.')}; Descending=$true}
  ```

---

## 🧹 پاک‌سازی متن‌های اضافی از فایل‌های CSV (ترفند VS Code)

برای پاک کردن سریع متن‌ها و ستون‌های اضافی جلوی آی‌پی‌ها در فایل‌های خروجی یا خام، نرم‌افزار **VS Code** را باز کرده، کلیدهای ترکیبی `Ctrl + H` را بزنید، آیکون قابلیت **Regex (`.*`)** را روشن کرده و از کدهای زیر استفاده کنید:

1. **برای پاک کردن فاصله‌ها و هر متنی که بعد از آن است:**
   * عبارت جستجو (Find): `\s+.*`
   * عبارت جایگزین (Replace): *(خالی بگذارید)*

2. **برای استخراج آی‌پی خالص از داخل کوتیشن‌ها:**
   * عبارت جستجو (Find): `^"([^"]+)".*`
   * عبارت جایگزین (Replace): `$1`

3. **برای پاک کردن کاما و تمام عبارات بعد از آن:**
   * عبارت جستجو (Find): `,.*`
   * عبارت جایگزین (Replace): *(خالی بگذارید)*

---

## 🧠 پرسش‌های چالش‌برانگیز، شبهات فنی گسترده و رفع عیب (FAQ)

### ❓ سوال ۱: چرا فرگمنت در سرعت تست من تاثیری نگذاشت؟
> **پاسخ فنی:** اگر در فایل تنظیمات مقدار `UploadViaXray: false` باشد، تست آپلود مستقیماً توسط cURL به آی‌پی ارسال می‌شود و بسته‌ها فرگمنت نمی‌شوند. حتماً در `config.json` مقدار **`UploadViaXray: true`** را قرار دهید تا آپلود از دل تونل محلی Xray و قوانین فرگمنت عبور کند.

### ❓ سوال ۲: آیا اجرای اسکریپت باعث قطع شدن VPN شخصی من روی ویندوز می‌شود؟
> **پاسخ فنی:** **خیر!** در این نسخه، مکانیزم کشتن پروسه‌ها بر اساس رهگیری اختصاصی Process ID پیاده‌سازی شده و فقط و فقط همان پروسه‌هایی که توسط اسکریپت آغاز شده‌اند بسته می‌شوند. نرم‌افزارهای v2rayN، Hiddify، Nekoray و غیره هیچ آسیبی نمی‌بینند.

### ❓ سوال ۳: چرا سرعت دانلود با آپلود متفاوت است؟
> **پاسخ فنی:** در اکثر شبکه‌های اینترنت (مخصوصاً ADSL و اینترنت‌های همراه در ایران)، پهنای باند آپلود نامتقارن (Asymmetric) و محدودتر از دانلود است. علاوه بر این، سیستم‌های فیلترینگ DPI تمرکز شدیدی بر مسدودسازی بسته‌های ارسالی (Upload TLS ClientHello) دارند. یافتن یک آی‌پی با آپلود پایدار بزرگترین چالش در حفظ پایداری تونل‌های V2Ray است.

### ❓ سوال ۴: در اسکریپت دانلود زمان تست را فقط ۴ ثانیه (`--max-time 4`) گذاشته‌اید. آیا ۴ ثانیه برای گرفتن سرعت واقعی یک آی‌پی کافی است؟
> **پاسخ فنی:** بله، در معماری شبکه‌های مدرن ۴ ثانیه کاملاً منطقی است. هدف ما در این اسکریپت دانلودِ یک فایل حجیم نیست؛ بلکه می‌خواهیم از مرحله TCP Slow-Start عبور کرده و به پیکِ (Peak) سرعت لوله ارتباطی برسیم. در تست‌های متعدد ثابت شده است که اتصال به لبه (Edge) کلادفلر در ثانیه دوم به حداکثر پهنای باند می‌رسد. با محدود کردن تست به ۴ ثانیه، هم از هدر رفتن صدها گیگابایت ترافیک اینترنت جلوگیری می‌کنیم و هم می‌توانیم هزاران آی‌پی را در کسری از زمان اسکن کنیم.

### ❓ سوال ۵: شما در تست دانلود از سایتی مثل DigitalOcean استفاده کرده‌اید. آیا کش شدن (Caching) فایل‌ها روی کلادفلر نتایج سرعت را نامعتبر نمی‌کند؟
> **پاسخ فنی:** برعکس، کش شدن دقیقاً همان چیزی است که ما می‌خواهیم! ما قصد نداریم سرعت سرورهای اصلی DigitalOcean را بسنجیم. ما در حال تستِ **ارتباط بین مودم شما و سرور لبه (Edge Node) کلادفلر** هستیم. وقتی دیتا روی کلادفلر کش شده باشد، سرور لبه با حداکثر سرعتِ ممکن دیتا را به سمت شما شلیک می‌کند و تنها گلوگاه موجود، سیستم فیلترینگ یا پهنای باند مودم شما خواهد بود. این دقیق‌ترین روش برای یافتن یک IP فیلترنشده و پرسرعت است.

### ❓ سوال ۶: شما ادعای تست آپلود روی Cloudflare Worker دارید، در حالی که ورکرها فضای ذخیره‌سازی (Disk) ندارند! چطور می‌توانید فایل آپلود کرده و سرعت بسنجید؟
> **پاسخ فنی:** هدف ما از این تست، ارزیابی "سرعت هارد دیسک سرور مقصد" نیست، بلکه **اشباع کردن لوله ارسال داده (TCP Pipeline Saturation) و سنجش اختلالات فیلترینگ (Ingress Throttling)** است.  
> وقتی اسکریپت با دستور `curl` یک استریم داده ۲۰ مگابایتی را به سمت پورت ۴۴۳ آی‌پی کلادفلر پرتاب می‌کند، این دیتا از شبکه زیرساخت فیلترینگ عبور کرده و به اولین لبه کلادفلر می‌رسد. ما با پارامتر `size_upload` دقیقاً می‌سنجیم که مسیر شبکه روی آن آی‌پی خاص چقدر اجازه داده است دیتا در ثانیه رد شود. بنابراین عدم وجود هارد دیسک روی ورکر هیچ تاثیری در صحت سنجش خط ارتباطی ندارد.

### ❓ سوال ۷: چگونه اسکریپت شما زمان Handshake را می‌سنجد در حالی که به هیچ سرور VPS اختصاصی متصل نیست؟
> **پاسخ فنی:** دست‌دهی امن (TLS Handshake) ابداً نیازی به VPS ندارد. این عملیات بین سیستم شما و لبه فیزیکی کلادفلر روی پورت ۴۴۳ انجام می‌شود. اسکریپت با فراخوانی متغیرهای داخلی `curl` شامل `%{time_connect}` و `%{time_appconnect}`، دقیقاً زمان صرف‌شده برای برقراری اتصال امن اولیه با همان آی‌پی کلادفلر را تا میلی‌ثانیه محاسبه می‌کند تا مشخص شود کدام آی‌پی در کانکت شدن فاقد تأخیر است.

### ❓ سوال ۸: شبکه کلادفلر Anycast است. وقتی تمام آی‌پی‌ها به نزدیک‌ترین دیتاسنتر مسیریابی می‌شوند، تست کردن صدها آی‌پی مختلف چه فایده‌ای دارد؟
> **پاسخ فنی:** در شرایط نرمال جهانی Anycast همه را به یک دیتاسنتر هدایت می‌کند، اما در شبکه‌های محدودشده دو اتفاق رخ می‌دهد:
> ۱. **اختلالات هدفمند (ISP Throttling):** سیستم مسدودسازی روی رنج‌های خاصی از آی‌پی‌های کلادفلر افت سرعت شدید ایجاد می‌کند در حالی که Subnetهای دیگر هنوز تمیز مانده‌اند.
> ۲. **مسیریابی بین‌المللی متفاوت (BGP Routing):** آی‌پی‌های مختلف کلادفلر گاهی از مسیرهای کاملاً متفاوتی (مثلاً از مسیر اروپا یا خاورمیانه) خارج می‌شوند. اسکن کردن آی‌پی‌ها به ما کمک می‌کند آی‌پی‌هایی را پیدا کنیم که دقیقاً از مسیرهای خروجیِ بدون نویز عبور می‌کنند.

### ❓ سوال ۹: چرا برای تست از cURL با تک‌کانکشن (Single-Stream) استفاده کرده‌اید؟
> **پاسخ فنی:** استفاده از Single-Stream یک انتخاب مهندسی‌شده است. موازی‌سازی (Multi-Stream) می‌تواند گلوگاه‌ها و اختلالات واقعی لایه TLS/TCP را پنهان کند. زمانی که شما کیفیت یک اتصال تک‌مسیره را می‌سنجید، پایه‌ترین و واقعی‌ترین کششِ خط فیزیکی خود را در برابر اختلالات تست کرده‌اید. آی‌پی‌ای که در Single-Stream موفق باشد، در تونل‌های Multi-Stream عملکردی خارق‌العاده خواهد داشت.

---

## 🌐 ابزارهای پیشنهادی، مانیتورینگ و آموزش ویدیویی

* 🔗 **[دانلود Angry IP Scanner از گیت‌هاب رسمی](https://github.com/angryip/ipscan)** (جهت استخراج رنج آی‌پی‌های اولیه)
* 🔗 **[Javid Network Watch :: Iran Internet Freedom Monitor](https://javidnetworkwatch.com/)** (جهت مانیتورینگ ۲۴ ساعته تمامی زیرساخت‌های فیلترنت)

### 🎥 آموزش ویدیویی کامل
برای درک بهتر نحوه کارکرد اسکریپت‌ها، نحوه استخراج آی‌پی‌ها و بررسی خط به خط کدها، ویدیوی آموزشی جامع (حدود ۵۰ دقیقه) تهیه شده است.  
👉 **[لینک ویدیو آموزشی هم به زودی میزارم]**

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

**[👈 برای بازگشت به راهنمای زبان فارسی اینجا کلیک کنید | Back to Persian Documentation 👉](#-cloudflare-ip-speed-tester-pro-upload--download)**

---

</div>

## 📑 English Table of Contents
1. [🌟 Overview & Architecture](#-overview--architecture)
2. [🚀 Core Capabilities & What's New in Pro Edition](#-core-capabilities--whats-new-in-pro-edition)
3. [⚠️ Step 0: Fetching Upstream Xray-Core (Mandatory)](#-step-0-fetching-upstream-xray-core-mandatory)
4. [🧰 Prerequisites & Clean IP Discovery (ip.txt)](#-prerequisites--clean-ip-discovery-iptxt)
5. [☁️ Cloudflare Worker Deployment (worker.js)](#-cloudflare-worker-deployment-workerjs)
6. [📤 Upload Scanner & Configuration Reference (config.json)](#-upload-scanner--configuration-reference-configjson)
7. [📥 Download Scanner Configuration Guide](#-download-scanner-configuration-guide)
8. [🚀 Step-by-Step Execution Guide](#-step-by-step-execution-guide)
9. [💾 Smart Resume & Crash Recovery Feature](#-smart-resume--crash-recovery-feature)
10. [📊 Interpreting Results & The P90 Metric](#-interpreting-results--the-p90-metric)
11. [🔀 Customizing Output Sorting Options (PowerShell)](#-customizing-output-sorting-options-powershell)
12. [🧹 Cleaning Extra Text from CSV Files (VS Code Regex Trick)](#-cleaning-extra-text-from-csv-files-vs-code-regex-trick)
13. [🧠 Technical Deep Dive, Skeptical FAQ & Troubleshooting](#-technical-deep-dive-skeptical-faq--troubleshooting)

---

## 🌟 Overview & Architecture

Welcome to the comprehensive documentation for **Cloudflare IP Speed Tester Pro**!  
This project is an enterprise-grade, multi-threaded **Windows PowerShell 5.1+** benchmarking suite engineered to test, analyze, and extract the fastest, most stable, and unthrottled Cloudflare Anycast edge IPs (Clean IPs) for use in restricted networks (BPB panels, V2Ray/VLESS configurations, Fragmentation tunnels, etc.).

While basic ICMP ping tools or naive download scanners fail to capture real-world connection resilience under Deep Packet Inspection (DPI), this suite evaluates both ingress download bandwidth and the primary bottleneck of restricted networks: **Egress upload throughput, TCP/TLS Handshake latency, Packet Loss, Jitter, and end-to-end VLESS tunneling with Fragmentation bypass** powered by the official **Xray-core**.

---

## 🚀 Core Capabilities & What's New in Pro Edition

### 📥 1. Download Scanner
Measures ingress bandwidth from the Cloudflare edge node directly to the client:
* ⚡ **Multi-Threading:** Evaluates multiple candidate IPs concurrently to drastically reduce scan times.
* 📊 **Accurate Bandwidth Measurement:** Calculates exact download speeds and automatically formats output in both Megabits per second (Mbps) and Megabytes per second (MB/s).

### 📤 2. Advanced Upload Scanner (Pro Edition)
A precision tool designed to benchmark the primary bottleneck of throttled networks (upload throttling and TLS/TCP disruption):
* **External `config.json` Configuration:** Zero code editing required. Worker domains, VLESS configurations, fragmentation parameters, and thread limits are managed in a clean JSON file.
* **Dual Operation Modes:**
  * **Direct Worker Mode (`EnableXrayTest: false`):** Directly evaluates raw HTTP/TLS POST throughput to the Cloudflare edge node using native cURL without proxy overhead.
  * **Xray Tunnel Mode (`EnableXrayTest: true`):** Establishes an authentic VLESS tunnel through the local Xray-core.
* **In-Tunnel Upload Benchmarking (`UploadViaXray: true`):**
  * When enabled, the test payload is streamed through the ephemeral local SOCKS5 proxy spawned by Xray. This allows you to evaluate actual upload throughput while packets are fragmented under **Fragment** rules.
* **Full Fragmentation Suite:**
  * Granular control over target `packets` (e.g., `tlshello` or `1-3`)
  * Byte chunk `length` (e.g., `100-200`)
  * Packet delay `interval` (e.g., `10-20` ms)
  * Instant toggle (`enable: true/false`)
* **Non-Destructive Process Management (Safe Kill Mechanism):**
  * Thread-safe PID tracking (`$Global:TrackedXrayPids`) targets only the `xray.exe` instances spawned by the script itself.
  * **Zero conflict with system VPNs:** Your running desktop VPN clients (v2rayN, Nekoray, Hiddify, etc.) will never be terminated or disrupted, while preventing orphaned `xray.exe` processes in Task Manager.
* **Smart Buffer Console:** Executes tests concurrently across multiple threads while printing terminal outputs strictly in sequential order.
* **Volume-Based Timeout:** Evaluates throughput based on total bytes transferred within a strict time window.
* **Jitter, Packet Loss & Dedicated Handshake Benchmarking:** Evaluates network stability prior to upload streaming and measures average TCP/TLS handshake latency.
* **P90 Percentile Sorting (`Speed_P90_Mbps`):** Eliminates false spikes and ranks IPs by guaranteed sustained minimum bandwidth using the 90th percentile statistical metric.
* **Space-Resilient Path Support:** Runs seamlessly inside directories containing spaces (e.g., `C:\My Projects\Speed Tester\`) without cURL or Xray argument parsing errors.
* **Fast Zero-Fill Payload Generation:** Instantly generates multi-megabyte test payloads in a fraction of a second using native .NET `[System.IO.File]` classes without stressing RAM or disk I/O.

---

## ⚠️ Step 0: Fetching Upstream Xray-Core (Mandatory)

> [!IMPORTANT]
> **Bundled Xray binaries may become outdated over time.**
> To ensure maximum compatibility with modern protocols and DPI evasion techniques, **always download the latest official Xray-core binaries directly from the upstream repository.**

### 📥 How to download and extract Xray-core:
1. Visit the official XTLS/Xray-core releases page:
   👈 **[https://github.com/XTLS/Xray-core/releases](https://github.com/XTLS/Xray-core/releases)**
2. Locate the **Latest Release**.
3. Download the archive matching your Windows architecture:
   * Standard 64-bit Windows: **`Xray-windows-64.zip`**
   * ARM64 Windows: **`Xray-windows-arm64-v8a.zip`**
4. Open the ZIP archive and extract the following three files **directly alongside the scripts** (in the root project directory):
   * `xray.exe` (Core executable)
   * `geoip.dat` (GeoIP database)
   * `geosite.dat` (Domain routing database)

*(If prompted by Windows, choose Replace to overwrite older files).*

---

## 🧰 Prerequisites & Clean IP Discovery (ip.txt)

Before running the benchmarking scripts, you need a raw list of candidate Cloudflare IP addresses to test and filter.

### 1. Recommended Scanner: Angry IP Scanner
While numerous IP scanners exist, our **definitive and verified recommendation** for fast initial port discovery is the lightweight, open-source **Angry IP Scanner**:
* 📥 **[Download Angry IP Scanner (Official Website)](https://angryip.org/download/)**
* 💻 **[Angry IP Scanner GitHub Repository](https://github.com/angryip/ipscan)**
* 🌐 **[Official Cloudflare IP Ranges (CIDR List)](https://www.cloudflare.com/ips/)**

### 2. Initial Scanning Instructions:
1. Open Angry IP Scanner.
2. In the **IP Range** fields, enter a Cloudflare subnet (e.g., `104.16.0.0` to `104.16.255.255` or `188.114.96.0` to `188.114.99.255`).
3. Navigate to **Preferences -> Ports** and set the target port to **`443`**.
4. Click **Start** to identify live IPs that respond to ping and have port 443 open.
5. Export the active (green) IP addresses and paste them into **`ip.txt`** (one IP per line), then let our scripts handle the deep upload, download, and handshake benchmarking!

> 💡 **Important Note:** Although a sample `ip.txt` file is included in the repository to help you get started, relying on a pre-made list is not recommended for optimal results—none of those IPs may be ideal for your specific ISP or routing path. Always scan and generate a fresh IP list tailored to your own network connection.

---

## ☁️ Cloudflare Worker Deployment (worker.js)

This repository includes the server-side JavaScript code (`worker.js`) to be deployed on Cloudflare's edge network. Your Windows upload/download scripts send heavy payload requests to this worker to measure true network path stability.

Follow these simple steps to deploy your worker:

1. **Log In:** Sign in to your [Cloudflare Dashboard](https://dash.cloudflare.com).
2. **Navigate to Workers:** Click **`Workers & Pages`** from the left sidebar.
3. **Create a New Worker:**
   * Click the blue **`Create application`** button, then select **`Create Worker`**.
   * Choose a custom name for your worker and click **`Deploy`**.
4. **Insert the Code:**
   * On the next screen, click **`Edit code`**.
   * Completely delete all default template code in the editor.
   * Copy the contents of **`worker.js`** (from this project folder) and paste it into the Cloudflare editor.
5. **Save and Deploy:** Click **`Save and Deploy`** in the top-right corner.
6. Your worker domain (e.g., `my-speed-worker.myname.workers.dev`) is now ready for use in `config.json`.

---

## 📤 Upload Scanner & Configuration Reference (config.json)

Located in the root folder, `config.json` is the central control hub for the Upload Scanner.

Sample `config.json`:

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

### 📋 Parameter Breakdown:

| Parameter | Type | Recommended | Technical Description |
| :--- | :--- | :--- | :--- |
| **`WorkerDomain`** | String | `subdomain.workers.dev` | Your Cloudflare Worker hostname or custom domain (without `https://` or trailing slashes). |
| **`VlessConfig`** | String | `vless://...` | Complete TLS/WS VLESS URI proxied through Cloudflare. The script automatically parses the address, port, UUID, path, and SNI. |
| **`EnableXrayTest`** | Boolean | `true` | If `true`, launches Xray-core to verify tunnel connectivity. If `false`, bypasses Xray and benchmarks direct cURL upload to the worker. |
| **`UploadViaXray`** | Boolean | `true` | **Key Feature:** If `true`, routes the 20MB upload stream through the local SOCKS5 Xray tunnel to measure real upload speed under Fragmentation. If `false`, sends upload payloads directly via cURL. |
| **`Fragmentation.enable`** | Boolean | `true` | Enables or disables TLS packet fragmentation to bypass DPI censorship. |
| **`Fragmentation.packets`** | String | `"tlshello"` | Target packets for fragmentation (typically `"tlshello"` or a range such as `"1-3"`). |
| **`Fragmentation.length`** | String | `"100-200"` | Byte length range for each fragmented chunk (e.g., 100 to 200 bytes). |
| **`Fragmentation.interval`** | String | `"10-20"` | Delay interval between fragmented packets in milliseconds. |
| **`AdvancedSettings.FileSizeMB`** | Number | `20` | Virtual payload size (in MB) generated for upload bandwidth saturation testing. |
| **`AdvancedSettings.UploadTimeSec`** | Number | `15` | Maximum time allowed (in seconds) per upload round. Lowering this (e.g., to `10`) speeds up scanning but may reduce peak accuracy on unstable lines. |
| **`AdvancedSettings.TestRounds`** | Number | `2` | Number of consecutive upload test cycles per IP. `2` is ideal for verifying consistency and computing P90. |
| **`AdvancedSettings.HandshakeRounds`**| Number | `3` | Number of iterations used to measure average TCP/TLS Handshake latency per IP. |
| **`AdvancedSettings.PingCount`** | Number | `4` | Number of ICMP pings sent to compute Packet Loss and Jitter. |
| **`AdvancedSettings.MaxJobs`** | Number | `3` | Number of concurrent test threads. For upload testing, values above 3–5 may saturate your local uplink. |
| **`AdvancedSettings.ConnectTimeout`** | Number | `5` | Maximum wait time (in seconds) for initial connection establishment before discarding an IP. |

### ⏱️ Connection Timing Under the Hood (cURL Upload Engine):

During execution, the upload script passes these timing parameters to `curl`:

```powershell
$curlArgs = @(
    "-k", "-s",
    "-o", "`"$DiscardBody`"",
    "-w", "%{size_upload}|%{time_total}",
    "-X", "POST",
    "--data-binary", "@$PayloadPath",
    "--connect-timeout", "5",                    # Connection timeout (seconds)
    "--max-time", "$UploadTimeSec",              # Total upload test duration
    "--resolve", "${CleanDomain}:443:${ip}",
    "https://${CleanDomain}/"
)
```

* **`--connect-timeout 5` (`ConnectTimeout`):** Instructs `curl` to wait at most **5 seconds** for the initial TCP/TLS handshake. Suitable for connections with occasional micro-dropouts; if you only want ultra-responsive IPs, lower this to `3` to filter out slow nodes faster.
* **`--max-time "$UploadTimeSec"`:** Enforces the total round duration limit from your configuration (e.g., 15 seconds).

*(Note: In standalone/legacy upload script versions without `config.json`, variables such as `$Domain`, `$FileSizeMB`, `$UploadTimeSec`, `$TestRounds`, `$HandshakeRounds`, `$PingCount`, and `$MaxJobs` are configured directly at the top of the PowerShell script).*

---

## 📥 Download Scanner Configuration Guide

The Download Scanner features straightforward configuration variables located at the top of the script:

```powershell
$TargetUrl = "[https://www.digitalocean.com](https://www.digitalocean.com)" # Target URL for download testing
$Domain = "[www.digitalocean.com](https://www.digitalocean.com)"            # Target domain for SNI resolution
$MaxThreads = 6                             # Number of concurrent test threads
```

### Download Variable Breakdown:

* **`$TargetUrl` and `$Domain`:** Specify a website hosted behind Cloudflare that is accessible on your network. This site acts as the download server for benchmarking candidate IPs.
  * *Example:* By default, `https://www.digitalocean.com` is used. If blocked on your network, you can replace both variables with another Cloudflare-backed site such as `https://www.speedtest.net` (ensure both variables match the same domain).
* **`$MaxThreads = 6`:** Defines how many IPs are tested simultaneously. For standard home broadband connections, values between **4 and 6** are optimal.

### ⏱️ Advanced Connection Timing (Inside the Download Script):

At the core of the download scanner is the following `curl` command:

```powershell
$output = & curl.exe -s -k -L -o NUL -w '%{speed_download}' --connect-timeout 2 --max-time 4 --resolve "$($Domain):443:$IP" $TargetUrl
```

* **`--connect-timeout 2`:** Instructs the script to wait a maximum of **2 seconds** for the initial handshake with each IP. If the IP fails to respond within 2 seconds, it is marked as dead (Failed) and skipped. On slower connections, you can increase this to `3` or `4`.
* **`--max-time 4`:** Caps the total download test duration at 4 seconds per IP—long enough to reach peak edge bandwidth without wasting data quota.

---

## 🚀 Step-by-Step Execution Guide

1. **Verify Workspace Files:** Ensure the following files are present in your project directory:
   * `test-Upload-v0.08.ps1` (and/or the Download script)
   * `Run.bat`
   * `config.json`
   * `ip.txt` (containing your candidate IPs)
   * `xray.exe`, `geoip.dat`, `geosite.dat`
2. **Launch the Script:**
   * **Easy Method (Recommended):** Double-click **`Run.bat`**. It automatically sets the required PowerShell execution policy and starts the scanner.
   * **Manual Terminal Method (PowerShell):** Open PowerShell and run:
     ```powershell
     powershell.exe -ExecutionPolicy Bypass -File .\test-Upload-v0.08.ps1
     ```
3. **Monitor Progress via Smart Buffer:** The script first validates your configuration, fragmentation state, and core files. Despite running multi-threaded tests in parallel, the **Smart Buffer** outputs each IP's telemetry cleanly and sequentially in color:
   * Handshake latency (`Handshake ms`)
   * Ping stability (`Jitter ms`)
   * Packet Loss (`Packet Loss %`)
   * Xray tunnel verification status
   * Per-round upload speeds and final averages (`Mbps` and `MB/s`)

---

## 💾 Smart Resume & Crash Recovery Feature

Both the Upload and Download scanners include a built-in **Resume Mechanism**:

* Test results are written in real time to a temporary file named **`temp_data.csv`**.
* In the event of a power outage, system crash, or accidental window closure, your progress is completely preserved.
* Simply re-run the script; it will automatically detect `temp_data.csv`, skip already-tested IPs, and resume scanning from where it left off.

---

## 📊 Interpreting Results & The P90 Metric

Upon completion (or manual stop), sorted results are exported to **`output_upload_result.csv`**.

### CSV Column Reference:
* **`IP`:** The tested Cloudflare clean IP address.
* **`Speed_P90_Mbps` (The Gold Standard Metric):** 90th percentile upload speed. Guarantees that the connection sustains at least this bandwidth 90% of the time, filtering out transient spikes. Top candidate IPs have the highest value in this column.
* **`Speed_Avg_Mbps`:** Average upload speed across all test rounds.
* **`Speed_Max_Mbps`:** Maximum peak speed recorded during testing.
* **`Handshake_ms`:** Time in milliseconds required to complete a secure TLS handshake with the edge server (lower means snappier connection establishment).
* **`PacketLoss_Percent`:** Percentage of lost ICMP packets (`0%` on healthy IPs).
* **`Jitter_ms`:** Ping variance in milliseconds (values under `5ms` are ideal for real-time gaming and VoIP).
* **`RoundResults_Mbps`:** Detailed speeds recorded in each individual test round.
* **`TestDate`:** Exact timestamp of the test record.

---

## 🔀 Customizing Output Sorting Options (PowerShell)

By default, the script sorts final results by upload speed:

```powershell
$sorted = $validData | Sort-Object -Property @{Expression={[double]($_.Speed_Avg_Mbps -replace ',', '.')}; Descending=$true}
```

You can customize the sorting priority by replacing the sorting line in the script with any of the following formulas:

* **Sort by Lowest Handshake Latency (Fastest Real Connection Ping):**
  ```powershell
  $sorted = $validData | Sort-Object -Property @{Expression={[double]($_.Handshake_ms -replace ',', '.')}; Descending=$false}
  ```

* **Sort by Lowest Jitter (Best for Online Gaming & Real-Time Calls):**
  ```powershell
  $sorted = $validData | Sort-Object -Property @{Expression={[double]($_.Jitter_ms -replace ',', '.')}; Descending=$false}
  ```

* **Sort by Highest P90 Speed (Guaranteed Sustained Stability):**
  ```powershell
  $sorted = $validData | Sort-Object -Property @{Expression={[double]($_.Speed_P90_Mbps -replace ',', '.')}; Descending=$true}
  ```

---

## 🧹 Cleaning Extra Text from CSV Files (VS Code Regex Trick)

To quickly strip extra columns or text next to IP addresses in raw or CSV files, open the file in **VS Code**, press `Ctrl + H`, enable the **Use Regular Expression (`.*`)** toggle, and use these patterns:

1. **Remove spaces and all text following the IP:**
   * Find: `\s+.*`
   * Replace: *(leave empty)*

2. **Extract pure IP addresses from inside quotation marks:**
   * Find: `^"([^"]+)".*`
   * Replace: `$1`

3. **Remove commas and all text following the IP:**
   * Find: `,.*`
   * Replace: *(leave empty)*

---

## 🧠 Technical Deep Dive, Skeptical FAQ & Troubleshooting

### ❓ Q1: Why did Fragmentation not affect my upload test results?
> **Technical Answer:** If `UploadViaXray` is set to `false` in `config.json`, the upload payload is sent directly via cURL to the IP without passing through Xray's fragmentation engine. Make sure **`UploadViaXray: true`** is set in `config.json` so the upload stream routes through the local fragmented Xray tunnel.

### ❓ Q2: Will running this script disconnect my active personal VPN on Windows?
> **Technical Answer:** **No!** Process termination uses strict Process ID tracking (`$Global:TrackedXrayPids`) and only closes child `xray.exe` processes spawned by the script itself. System-wide VPN clients such as v2rayN, Hiddify, and Nekoray remain completely unaffected.

### ❓ Q3: Why do upload speeds differ significantly from download speeds?
> **Technical Answer:** On most consumer internet connections (especially ADSL and mobile networks), bandwidth is asymmetric with much tighter uplink limits. Furthermore, DPI censorship firewalls aggressively inspect and throttle outbound packets (such as Upload TLS ClientHello). Finding an IP with stable upload throughput is the single most critical factor in maintaining resilient V2Ray tunnels.

### ❓ Q4: In the Download Scanner, the test duration is capped at 4 seconds (`--max-time 4`). Is 4 seconds enough to measure true IP speed?
> **Technical Answer:** Yes, in modern network architecture 4 seconds is completely optimal. Our goal is not to download a massive file, but to move past the TCP Slow-Start phase and hit the peak capacity of the communication pipe. Extensive testing confirms that connections to Cloudflare Edge nodes reach maximum bandwidth by the second second. Capping the test at 4 seconds prevents wasting ratusan gigabytes of bandwidth while allowing thousands of IPs to be scanned in a fraction of the time.

### ❓ Q5: The Download Scanner uses a site like DigitalOcean. Doesn't Cloudflare caching invalidate the speed test results?
> **Technical Answer:** On the contrary, caching is **exactly** what we want! We are not benchmarking DigitalOcean's origin servers—we are benchmarking the **last-mile connection between your router and the Cloudflare Edge Node**. When content is cached on Cloudflare's edge, the node delivers data at maximum possible velocity, leaving ISP throttling or your local bandwidth as the only bottleneck. This is the most accurate way to isolate an unthrottled, high-speed edge IP.

### ❓ Q6: You claim to test upload speeds against a Cloudflare Worker, yet Workers have no persistent disk storage! How can you upload a file and measure speed?
> **Technical Answer:** Our goal is not to benchmark "destination server disk write speed," but rather **TCP Pipeline Saturation and Ingress Throttling detection**.  
> When the script uses `curl` to stream a 20MB binary payload to port 443 of a Cloudflare IP, that stream traverses your ISP's filtering infrastructure to reach the Cloudflare edge. Using cURL's `size_upload` metric, we measure exactly how much data successfully crossed the network pipe per second on that specific IP. The absence of a hard disk on the Worker has zero impact on measuring network link throughput.

### ❓ Q7: How does the script measure TLS Handshake time without connecting to a private VPS?
> **Technical Answer:** A TLS Handshake does not require a private VPS. The negotiation occurs directly between your machine and Cloudflare's physical edge node over port 443. By querying cURL's internal timing variables (`%{time_connect}` and `%{time_appconnect}`), the script calculates the exact millisecond latency required to establish an encrypted connection with that specific Cloudflare IP.

### ❓ Q8: Cloudflare uses an Anycast network where all IPs route to the nearest data center. What is the point of scanning hundreds of different IPs?
> **Technical Answer:** Under normal global routing, Anycast directs traffic uniformly. However, in restricted and heavily throttled networks, two key phenomena occur:
> 1. **Targeted ISP Throttling:** Censorship firewalls heavily throttle specific Cloudflare IP subnets while leaving other subnets completely untouched.
> 2. **Divergent International BGP Routing:** Different Cloudflare IP ranges often exit the country through completely different upstream transit providers and geographical routes (e.g., Europe vs. Middle East). Scanning across subnets helps discover IPs routed through clean, unthrottled BGP paths.

### ❓ Q9: Why do you use single-connection (Single-Stream) cURL instead of Multi-Stream testing?
> **Technical Answer:** Using Single-Stream is a deliberate engineering choice. Multi-stream parallelization masks underlying TCP/TLS layer bottlenecks and packet throttling. By benchmarking a single stream, you stress-test the raw baseline resilience of the physical route against DPI interference. An IP that performs strongly in Single-Stream will deliver exceptional performance in multi-stream proxy tunnels.

---

<div align="center">
Developed with precision for network freedom and high-resilience connectivity.
</div>
