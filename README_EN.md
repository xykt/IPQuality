<p align="center">
<img src="https://hits.seeyoufarm.com/api/count/keep/badge.svg?url=https%3A%2F%2Fip.check.place&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=Runs&edge_flat=false"/> 
<img src="https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Fxykt%2FIPQuality&count_bg=%233DC8C0&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=Visits&edge_flat=false"/> 
<a href="/LICENSE"><img src="https://img.shields.io/badge/License-AGPL%20v3-blue.svg" alt="license" /></a>  
</p>

## IP Quality Check Script  -  [IP质量体检脚本 (中文)](https://github.com/xykt/IPQuality/blob/main/README.md)

**Supported OS/Platform: Ubuntu | Debian | Linux Mint | Fedora | Red Hat Enterprise Linux (RHEL) | CentOS | Arch Linux | Manjaro | Alpine Linux | AlmaLinux | Rocky Linux | macOS | Anolis OS | Alibaba Cloud Linux | SUSE Linux | openSUSE | Void Linux**

- Bilingual support in English and Chinese
- Supports dual-stack queries for IPv4/IPv6
- Beautifully formatted, intuitive display, optimized for single-screen multi-terminal display, facilitating screenshot sharing
- Six modules: Basic Information, IP Type, Risk Score, Risk Factors, Streaming Media Unlocking, and Post Office Check
- Basic data sourced from the *Maxmind* database
- Risk information integrated from multiple databases: *IPinfo / ipregistry / ipapi / AbuseIPDB / IP2LOCATION / IPQS / DB-IP / SCAMALYTICS / IPWHOIS*
- Streaming and AI service providers' unlocking and type detection: *TikTok / Disney+ / Netflix / Youtube / AmazonPrimeVideo / Spotify / ChatGPT*
- Connectivity tests for multiple email providers: *Gmail / Outlook / Yahoo / Apple / QQ / Mail.ru / AOL / GMX / Mail.com / 163 / Sohu / Sina*
- Over 400 IP address blacklist database checks

##### Screenshots
![Screenshot](https://raw.githubusercontent.com/xykt/IPQuality/main/img/en_IPv4.svg)

## How to Use

##### English version of dual-stack test:
````bash
bash <(curl -Ls IP.Check.Place) -l en
````

##### IPv4 only test:
````bash
bash <(curl -Ls IP.Check.Place) -l en -4
````

##### IPv6 only test:
````bash
bash <(curl -Ls IP.Check.Place) -l en -6
````

##### Specify network interface:
````bash
bash <(curl -Ls IP.Check.Place) -l en -i eth0
````

##### Specify proxy server:
````bash
bash <(curl -Ls IP.Check.Place) -l en -x http://username:password@proxyserver:port
bash <(curl -Ls IP.Check.Place) -l en -x https://username:password@proxyserver:port
bash <(curl -Ls IP.Check.Place) -l en -x socks5://username:password@socksproxy:port
````

##### Show full IP on report:
````bash
bash <(curl -Ls IP.Check.Place) -l en -f
````

##### Basic information multi-language support:
````bash
bash <(curl -Ls IP.Check.Place) -l jp|es|de|fr|ru|pt
````

## Script Updates

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

- Thanks to [lmc999](https://github.com/lmc999/RegionRestrictionCheck) for portions of the original streaming media unlocking script referenced in this script.

- Thanks to [spiritLHLS](https://github.com/spiritLHLS/ecs) for portions of the integration monster review script referenced in this script.

**Stars History:**

![Stargazers over time](https://starchart.cc/xykt/IPQuality.svg?background=%23FFFFFF&axis=%23333333&line=%2377dd77)

**History of daily runs:**

![History of daily runs](https://hits.seeyoufarm.com/api/count/graph/dailyhits.svg?url=https://ip.check.place&date=20241017)
