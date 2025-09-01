<p align="center">
<img src="https://hits.xykt.de/ip.svg?action=view&count_bg=%2379C83D&title_bg=%23555555&title=Runs&edge_flat=false"/> 
<img src="https://hits.xykt.de/ip_github.svg?action=hit&count_bg=%233DC8C0&title_bg=%23555555&title=Visits&edge_flat=false"/> 
<a href="/LICENSE"><img src="https://img.shields.io/badge/License-AGPL%20v3-blue.svg" alt="license" /></a>  
</p>

## IP Quality Check Script  -  [IP质量体检脚本 (中文)](https://github.com/xykt/IPQuality/blob/main/README.md)

**Supported OS/Platform: Ubuntu | Debian | Linux Mint | Fedora | Red Hat Enterprise Linux (RHEL) | CentOS | Arch Linux | Manjaro | Alpine Linux | AlmaLinux | Rocky Linux | macOS | Anolis OS | Alibaba Cloud Linux | SUSE Linux | openSUSE | Void Linux | Windows (via Docker)**

- Bilingual support in English and Chinese
- Supports dual-stack queries for IPv4/IPv6
- Beautifully formatted, intuitive display, optimized for single-screen multi-terminal display, facilitating screenshot sharing
- Six modules: Basic Information, IP Type, Risk Score, Risk Factors, Streaming Media Unlocking, and Post Office Check
- Basic data sourced from the *Maxmind* database
- Risk information integrated from multiple databases: *IPinfo / ipregistry / ipapi / AbuseIPDB / IP2LOCATION / IPQS / DB-IP / SCAMALYTICS / IPWHOIS / Cloudflare*
- Streaming and AI service providers' unlocking and type detection: *TikTok / Disney+ / Netflix / Youtube / AmazonPrimeVideo / Spotify / ChatGPT*
- Connectivity tests for multiple email providers: *Gmail / Outlook / Yahoo / Apple / QQ / Mail.ru / AOL / GMX / Mail.com / 163 / Sohu / Sina*
- Over 400 IP address blacklist database checks

##### Screenshots
![Screenshot](https://raw.githubusercontent.com/xykt/IPQuality/main/res/en_IPv4.svg)

## Usage

### Easy Mode: Run with Interactive Interface

![Net](https://github.com/xykt/ScriptMenu/raw/main/res/IP_EN.png)

##### Bash:
````bash
bash <(curl -Ls https://Check.Place) -EI
````

##### Docker:
- Linux
````bash
docker run --rm --net=host -it xykt/check -EI && docker rmi xykt/check > /dev/null 2>&1
````

- Windows (CMD)
````bash
docker run --rm --net=host -it xykt/check -EI & docker rmi xykt/check > NUL 2>&1
````

### Advanced Mode: Run with Parameters

![Help](https://github.com/xykt/IPQuality/raw/main/res/help.png)

##### English version of dual-stack test (Either):
````bash
bash <(curl -Ls https://IP.Check.Place) -E
bash <(curl -Ls https://IP.Check.Place) -l en
````

##### IPv4 only test:
````bash
bash <(curl -Ls https://IP.Check.Place) -E4
````

##### IPv6 only test:
````bash
bash <(curl -Ls https://IP.Check.Place) -E6
````

##### Specify network interface:
````bash
bash <(curl -Ls https://IP.Check.Place) -E -i eth0
````

##### Specify proxy server:
````bash
bash <(curl -Ls https://IP.Check.Place) -E -x http://username:password@proxyserver:port
bash <(curl -Ls https://IP.Check.Place) -E -x https://username:password@proxyserver:port
bash <(curl -Ls https://IP.Check.Place) -E -x socks5://username:password@socksproxy:port
````

##### Skip checking OS and dependencies:

```bash
bash <(curl -Ls https://IP.Check.Place) -En
```

##### Auto-install dependencies:

```bash
bash <(curl -Ls https://IP.Check.Place) -Ey
```

##### Show full IP on report:
````bash
bash <(curl -Ls https://IP.Check.Place) -Ef
````

##### JSON mode：
````bash
bash <(curl -Ls https://IP.Check.Place) -Ej
````

##### Output report to file in ANSI/JSON/Text format:
````bash
bash <(curl -Ls https://IP.Check.Place) -o /path/to/file.ansi
bash <(curl -Ls https://IP.Check.Place) -o /path/to/file.json
bash <(curl -Ls https://IP.Check.Place) -o /path/to/file.txtoranyother
````

##### Basic information multi-language support:
````bash
bash <(curl -Ls https://IP.Check.Place) -l jp|es|de|fr|ru|pt
````

##### privacy mode - Disable online report link:
````bash
bash <(curl -Ls https://IP.Check.Place) -Ep
````

##### Docker (supports runtime arguments; insert them before the ```&```):
- Linux
````bash
docker run --rm --net=host -it xykt/ipquality -E && docker rmi xykt/ipquality > /dev/null 2>&1
````

- Windows (CMD)
````bash
docker run --rm --net=host -it xykt/ipquality -E & docker rmi xykt/ipquality > NUL 2>&1
````

## Script Updates

2025/08/03 00:00 Add Docker support

2025/08/01 16:15 Add -p for privacy mode, which disables online report links

2025/07/30 16:30 Replace all HTTP requests with HTTPS to improve script security

2025/06/02 21:25 Fix the error logic in port 25 detection and standardize the connectivity testing method for email service providers

2025/04/23 18:00 Add -o to output report to file in ANSI/JSON/Text format

2025/04/19 21:00 Add -j for JSON mode

2025/03/13 23:15 Add -y -n for dependencies auto-install/skip

2024/11/09 00:30 Add Cloudflare threat score, fix IP2Location IP type bug

2024/10/06 01:15 Fixed bug causing script errors in very rare cases

2024/07/23 23:50 Add parameter -f to show full IP address on report

2024/07/22 01:50 Add prompt before installing dependent packages, fix Disney+ bug

2024/06/27 01:00 Add Anolis OS | Alibaba Cloud Linux | SUSE Linux | openSUSE support

2024/05/30 01:15 Add macOS support

2024/05/28 18:00 Fixed bug where default IP was detected for specified network interface/proxy server

2024/05/17 00:45 Add report svg image sharing link and fix some layout problems

2024/05/11 23:20 Fixed mail detection taking too long due to gateway blocking port 25, fix inaccurate Tiktok IPv6 results

2024/05/10 17:50 Fix dependency installation issue with no sudo installed

2024/05/10 11:00 Added support for specified network interface and proxy server

2024/05/09 15:00 Corrected errors caused by non-standard private IP addresses, and fixed several other bugs

2024/05/08 23:00 Fixed a bug affecting incorrect detection results for Netflix Australia

2024/05/08 18:10 Updated the dependency checks and installation for the 'dig' program

2024/05/08 00:00 Script published

## Script Contributions

**Acknowledgments:**

| Sponsor | Logo | Link | 
| - | - | - | 
| IP2Location | ![ip2location_logo](https://raw.githubusercontent.com/xykt/IPQuality/main/res/sponsor/logo_ip2location.png) | [https://ip2location.io](https://ip2location.io)</br>[https://ip2location.com](https://ip2location.com) | 

- Sincerely appreciate the IP threat intelligence data provided by leading providers (No ranking implied, listed in alphabetical order): [AbuseIPDB](https://www.abuseipdb.com/)/[Cloudflare](https://cloudflare.com/)/[DB-IP](https://db-ip.com/)/[IP2Location](https://www.ip2location.io/)/[ipapi](https://ipapi.is/)/[IPinfo](https://ipinfo.io/)/[IPQS](https://www.ipqualityscore.com/)/[ipregistry](https://ipregistry.co/)/[IPWHOIS](https://ipwhois.io/)/[SCAMALYTICS](https://scamalytics.com/) 

- Thanks to [lmc999](https://github.com/lmc999/RegionRestrictionCheck) for parts of this script reference the RegionRestrictionCheck script.

- Thanks to [spiritLHLS](https://github.com/spiritLHLS/ecs) for parts of this script reference the VPS Fusion Monster Server Test Script.

**Server Sponsors​ *(No ranking implied)*:**

| Sponsor | Logo | Link | 
| - | - | - |
| V.PS | ![vps_logo](https://raw.githubusercontent.com/xykt/IPQuality/main/res/sponsor/logo_vps.png) | [https://v.ps](https://v.ps)| 
| BAGE | ![bage_logo](https://raw.githubusercontent.com/xykt/IPQuality/main/res/sponsor/logo_bage.png) | [https://bagevm.com](https://bagevm.com)|
| LisaHost</br>丽萨主机 | ![lisa_logo](https://raw.githubusercontent.com/xykt/IPQuality/main/res/sponsor/logo_lisa.png) | [https://lisahost.com](https://lisahost.com)|
| DreamCloud | ![dreamcloud_logo](https://raw.githubusercontent.com/xykt/IPQuality/main/res/sponsor/logo_dreamcloud.png) | [https://as211392.com](https://as211392.com)|
| CNFaster | ![cnfaster_logo](https://raw.githubusercontent.com/xykt/IPQuality/main/res/sponsor/logo_cnfaster.png) | [https://cnfaster.com](https://cnfaster.com)|
| UCloud</br>优刻得 | ![ucloud_logo](https://raw.githubusercontent.com/xykt/IPQuality/main/res/sponsor/logo_ucloud.png) | [https://ucloud.cn](https://www.ucloud.cn/staticIPHost?ytag=uhost_ip_github)|
| AaITR | ![aaitr_logo](https://raw.githubusercontent.com/xykt/IPQuality/main/res/sponsor/logo_aaitr.png) | [https://aaitr.com](https://www.aaitr.com/link.php?id=5)| 
| VIRCS</br>威尔克斯 | ![vircs_logo](https://raw.githubusercontent.com/xykt/IPQuality/main/res/sponsor/logo_vircs.png) | [https://vircs.com](https://www.vircs.com/promotion?code=6)| 
| BestProxy</br>`原生IP` | ![bestproxy_logo](https://raw.githubusercontent.com/xykt/IPQuality/main/res/sponsor/logo_bestproxy.png) | [https://bestproxy.com](https://bestproxy.com/?keyword=nstdqben)| 
| RapidProxy</br>`原生IP` | ![rapidproxy_logo](https://raw.githubusercontent.com/xykt/IPQuality/main/res/sponsor/logo_rapidproxy.png) | [https://rapidproxy.io](https://www.rapidproxy.io/?ref=gitipquality)| 

##### *E-Mail: sponsor@check.place Telegram Bot: https://t.me/xythebot*
**Only accepting merchants with long-term stable operations and good reputation*

**Stars History:**

![Stargazers over time](https://starchart.cc/xykt/IPQuality.svg?background=%23FFFFFF&axis=%23333333&line=%2377dd77)

**Daily Runs History:**

![daily_runs_history](https://hits.xykt.de/history/ip.svg?days=46&chartType=bar&title=Daily%20Runs%20of%20Network%20Quality%20Script&width=1024&height=400&color=green)
