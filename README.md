<p align="center">
<img src="https://hits.xykt.de/ip.svg?action=view&count_bg=%2379C83D&title_bg=%23555555&title=Runs&edge_flat=false"/> 
<img src="https://hits.xykt.de/ip_github.svg?action=hit&count_bg=%233DC8C0&title_bg=%23555555&title=Visits&edge_flat=false"/> 
<a href="/LICENSE"><img src="https://img.shields.io/badge/License-AGPL%20v3-blue.svg" alt="license" /></a>  
</p>

## IP质量体检脚本  -  [IP Quality Check Script (EN)](https://github.com/xykt/IPQuality/blob/main/README_EN.md)

**支持OS/Platform：Ubuntu | Debian | Linux Mint | Fedora | Red Hat Enterprise Linux (RHEL) | CentOS | Arch Linux | Manjaro | Alpine Linux | AlmaLinux | Rocky Linux | macOS | Anolis OS | Alibaba Cloud Linux | SUSE Linux | openSUSE | Void Linux | Windows (via Docker)**

- 中英文双语言支持
- 支持IPv4/IPv6双栈查询
- 精美排版，直观显示，多终端单屏优化展示，便于截图分享
- 基础信息、IP类型、风险评分、风险因子、流媒体解锁、邮局检测六大模块
- 基础数据源自*Maxmind*数据库
- 风险信息 *IPinfo / ipregistry / ipapi / AbuseIPDB / IP2LOCATION / IPQS / DB-IP / SCAMALYTICS / IPWHOIS / Cloudflare* 多数据库整合
- 流媒体及AI多个服务商 *TikTok / Disney+ / Netflix / Youtube / AmazonPrimeVideo / Spotify / ChatGPT* 解锁及解锁类型检测
- 多邮局服务商 *Gmail / Outlook / Yahoo / Apple / QQ / Mail.ru / AOL / GMX / Mail.com / 163 / Sohu / Sina* 连通性检测
- IP地址黑名单400+数据库检测

##### 屏幕截图
![截图](https://raw.githubusercontent.com/xykt/IPQuality/main/res/cn_IPv4.svg)

## 使用方法

### 便捷模式：交互界面

![Net](https://github.com/xykt/ScriptMenu/raw/main/res/IP_CN.png)

##### Bash：
````bash
bash <(curl -Ls https://Check.Place) -I
````

##### Docker：
- Linux
````bash
docker run --rm --net=host -it xykt/check -I && docker rmi xykt/check > /dev/null 2>&1
````

- Windows (CMD)
````bash
docker run --rm --net=host -it xykt/check -I & docker rmi xykt/check > NUL 2>&1
````

### 高级模式：参数运行

![Help](https://github.com/xykt/IPQuality/raw/main/res/help.png)

##### 默认双栈检测：
````bash
bash <(curl -Ls https://IP.Check.Place)
````

##### 只检测IPv4结果：
````bash
bash <(curl -Ls https://IP.Check.Place) -4
````

##### 只检测IPv6结果：
````bash
bash <(curl -Ls https://IP.Check.Place) -6
````

##### 指定检测网卡：
````bash
bash <(curl -Ls https://IP.Check.Place) -i eth0
````

##### 指定代理服务器：
````bash
bash <(curl -Ls https://IP.Check.Place) -x http://username:password@proxyserver:port
bash <(curl -Ls https://IP.Check.Place) -x https://username:password@proxyserver:port
bash <(curl -Ls https://IP.Check.Place) -x socks5://username:password@socksproxy:port
````

##### 选择脚本语言为英文（任选其一）：
````bash
bash <(curl -Ls https://IP.Check.Place) -E
bash <(curl -Ls https://IP.Check.Place) -l en
````

##### 跳过检测系统及安装依赖：
````bash
bash <(curl -Ls https://IP.Check.Place) -n
````

##### 自动安装依赖：
````bash
bash <(curl -Ls https://IP.Check.Place) -y
````

##### 报告展示完整IP地址：
````bash
bash <(curl -Ls https://IP.Check.Place) -f
````

##### 输出JSON结果：
````bash
bash <(curl -Ls https://IP.Check.Place) -j
````

##### 输出报告ANSI/JSON/纯文本至文件：
````bash
bash <(curl -Ls https://IP.Check.Place) -o /path/to/file.ansi
bash <(curl -Ls https://IP.Check.Place) -o /path/to/file.json
bash <(curl -Ls https://IP.Check.Place) -o /path/to/file.txtoranyother
````

##### 基础信息多语言支持：
````bash
bash <(curl -Ls https://IP.Check.Place) -l jp|es|de|fr|ru|pt
````

##### 隐私模式——禁用在线报告生成功能：
````bash
bash <(curl -Ls https://IP.Check.Place) -p
````

##### Docker（支持运行参数，须在```&```前插入）：
- Linux
````bash
docker run --rm --net=host -it xykt/ipquality && docker rmi xykt/ipquality > /dev/null 2>&1
````

- Windows (CMD)
````cmd
docker run --rm --net=host -it xykt/ipquality & docker rmi xykt/ipquality > NUL 2>&1
````

## 脚本更新

2025/08/03 00:00 增加Docker运行方式

2025/08/01 16:15 增加-p隐私模式，禁用在线报告生成功能

2025/07/30 16:30 将所有HTTP请求替换为HTTPS以提升脚本安全性

2025/06/02 21:25 修复25端口检测的错误逻辑，规范化邮件服务商连通性检测方法

2025/04/23 18:00 增加-o输出报告ANSI/JSON/纯文本至文件

2025/04/19 21:00 增加-j的JSON输出模式

2025/03/13 23:15 增加-y自动安装依赖，-n跳过操作系统及依赖检查

2024/11/09 00:30 增加Cloudflare风险评分，修复IP2Location偶发IP类型判断BUG

2024/10/06 01:15 修复极个别运行脚本报错问题

2024/07/23 23:50 增加运行参数-f使报告显示完整IP地址

2024/07/22 01:50 安装依赖包前增加询问，修复Disney+解锁类型错误

2024/06/27 01:00 增加Anolis OS | Alibaba Cloud Linux | SUSE Linux | openSUSE系统支持

2024/05/30 01:15 增加macOS系统支持

2024/05/28 18:00 修复了指定网卡/代理服务器仍然检测默认IP的bug

2024/05/17 00:45 增加报告svg图片分享链接，修复一些排版问题

2024/05/11 23:20 修复因网关阻断25端口导致的邮件检测时间过长的问题，修复Tiktok IPv6结果不准确的bug

2024/05/10 17:50 修复未安装sudo系统无法正常安装依赖的bug

2024/05/10 11:00 增加指定网卡及代理服务器检测支持

2024/05/09 15:00 修正不规范内网IP导致的错误，修正其他若干bug

2024/05/08 23:00 修正Netflix澳洲检测结果不正确的bug

2024/05/08 18:10 更新依赖程序dig检测及安装

2024/05/08 00:00 脚本发布

## 脚本贡献

**Acknowledgments:**

| 赞助商 | 商标 | 网址 | 
| - | - | - | 
| IP2Location | ![ip2location_logo](https://raw.githubusercontent.com/xykt/IPQuality/main/res/sponsor/logo_ip2location.png) | [https://ip2location.io](https://ip2location.io)</br>[https://ip2location.com](https://ip2location.com) | 

- 衷心感谢主流IP风险数据库[AbuseIPDB](https://www.abuseipdb.com/)/[Cloudflare](https://cloudflare.com/)/[DB-IP](https://db-ip.com/)/[IP2Location](https://www.ip2location.io/)/[ipapi](https://ipapi.is/)/[IPinfo](https://ipinfo.io/)/[IPQS](https://www.ipqualityscore.com/)/[ipregistry](https://ipregistry.co/)/[IPWHOIS](https://ipwhois.io/)/[SCAMALYTICS](https://scamalytics.com/)提供的风险数据（排名不分先后）

- 感谢[lmc999](https://github.com/lmc999/RegionRestrictionCheck)，本脚本局部代码参考原版流媒体解锁检测脚本

- 感谢[spiritLHLS](https://github.com/spiritLHLS/ecs)，本脚本局部代码参考融合怪测评脚本

**服务器赞助商（排名不分先后）**

| 赞助商 | 商标 | 网址 | 
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
**仅接受长期稳定运营，信誉良好的商家*

**Stars History:**

![Stargazers over time](https://starchart.cc/xykt/IPQuality.svg?background=%23FFFFFF&axis=%23333333&line=%2377ff77)

**Daily Runs History:**

![daily_runs_history](https://hits.xykt.de/history/ip.svg?days=46&chartType=bar&title=IP%E8%B4%A8%E9%87%8F%E4%BD%93%E6%A3%80%E8%84%9A%E6%9C%AC%E6%AF%8F%E6%97%A5%E8%BF%90%E8%A1%8C%E9%87%8F%E7%BB%9F%E8%AE%A1&width=1024&height=400&color=green)
