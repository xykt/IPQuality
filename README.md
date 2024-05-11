<p align="center">
<img src="https://hits.seeyoufarm.com/api/count/keep/badge.svg?url=https%3A%2F%2Fip.check.place&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=runs&edge_flat=false"/> 
<img src="https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Fxykt%2FIPQuality&count_bg=%233DC8C0&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=visits&edge_flat=false"/> 
<a href="/LICENSE"><img src="https://img.shields.io/badge/License-AGPL%20v3-blue.svg" alt="license" /></a>  
</p>

## IP质量体检脚本  -  [IP Quality Check Script (EN)](https://github.com/xykt/IPQuality/blob/main/README_EN.md)

**支持OS/Platform：Ubuntu | Debian | Linux Mint | Fedora | Red Hat Enterprise Linux (RHEL) | CentOS | Arch Linux | Manjaro | Alpine Linux**

- 中英文双语言支持
- 支持IPv4/IPv6双栈查询
- 精美排版，直观显示，多终端单屏优化展示，便于截图分享
- 基础信息、IP类型、风险评分、风险因子、流媒体解锁、邮局检测六大模块
- 基础数据源自*Maxmind*数据库
- 风险信息 *IPinfo / ipregistry / ipapi / AbuseIPDB / IP2LOCATION / IPQS / DB-IP / SCAMALYTICS / IPWHOIS* 多数据库整合
- 流媒体及AI多个服务商 *TikTok / Disney+ / Netflix / Youtube / AmazonPrimeVideo / Spotify / ChatGPT* 解锁及解锁类型检测
- 多邮局服务商 *Gmail / Outlook / Yahoo / Apple / QQ / Mail.ru / AOL / GMX / Mail.com / 163 / Sohu / Sina* 连通性检测
- IP地址黑名单400+数据库检测

##### 屏幕截图
![截图](https://raw.githubusercontent.com/xykt/IPQuality/main/img/cn_ipv4.png)

## 使用方法

##### 默认双栈检测：
````bash
bash <(curl -Ls IP.Check.Place)
````

##### 只检测IPv4结果：
````bash
bash <(curl -Ls IP.Check.Place) -4
````

##### 只检测IPv6结果：
````bash
bash <(curl -Ls IP.Check.Place) -6
````

##### 指定检测网卡：
````bash
bash <(curl -Ls IP.Check.Place) -i eth0
````

##### 指定代理服务器：
````bash
bash <(curl -Ls IP.Check.Place) -x http://username:password@proxyserver:port
bash <(curl -Ls IP.Check.Place) -x https://username:password@proxyserver:port
bash <(curl -Ls IP.Check.Place) -x socks5://username:password@socksproxy:port
````

##### 选择脚本语言为英文：
````bash
bash <(curl -Ls IP.Check.Place) -l en
````

##### 基础信息多语言支持：
````bash
bash <(curl -Ls IP.Check.Place) -l jp|es|de|fr|ru|pt
````

## 脚本更新

2024/05/11 23:20 修复因网关阻断25端口导致的邮件检测时间过长的问题，修复Tiktok IPv6结果不准确的bug

2024/05/10 17:50 修复未安装sudo系统无法正常安装依赖的bug

2024/05/10 11:00 增加指定网卡及代理服务器检测支持

2024/05/09 15:00 修正不规范内网IP导致的错误，修正其他若干bug

2024/05/08 23:00 修正Netflix澳洲检测结果不正确的bug

2024/05/08 18:10 更新依赖程序dig检测及安装

2024/05/08 00:00 脚本发布

## 脚本贡献

**Acknowledgments:**

- 感谢[lmc999](https://github.com/lmc999/RegionRestrictionCheck)，本脚本局部代码参考原版流媒体解锁检测脚本

- 感谢[spiritLHLS](https://github.com/spiritLHLS/ecs)，本脚本局部代码参考融合怪测评脚本

**Contributors:**

<a href="https://github.com/xykt"><img src="https://avatars.githubusercontent.com/u/152045469?v=4" alt="@xykt" size="48" height="48" width="48" data-view-component="true"></img></a>

**Stars History:**
![Stargazers over time](https://starchart.cc/xykt/IPQuality.svg?background=%23FFFFFF&axis=%23333333&line=%2377ff77)
