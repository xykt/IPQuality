#!/bin/bash
script_version="v2025-09-04"
check_bash(){
current_bash_version=$(bash --version|head -n 1|awk -F ' ' '{for (i=1; i<=NF; i++) if ($i ~ /^[0-9]+\.[0-9]+\.[0-9]+/) {print $i; exit}}'|cut -d . -f 1)
if [ "$current_bash_version" = "0" ]||[ "$current_bash_version" = "1" ]||[ "$current_bash_version" = "2" ]||[ "$current_bash_version" = "3" ];then
echo "ERROR: Bash version is lower than 4.0!"
echo "Tips: Run the following script to automatically upgrade Bash."
echo "bash <(curl -sL https://raw.githubusercontent.com/xykt/IPQuality/main/ref/upgrade_bash.sh)"
exit 0
fi
}
check_bash
Font_B="\033[1m"
Font_D="\033[2m"
Font_I="\033[3m"
Font_U="\033[4m"
Font_Black="\033[30m"
Font_Red="\033[31m"
Font_Green="\033[32m"
Font_Yellow="\033[33m"
Font_Blue="\033[34m"
Font_Purple="\033[35m"
Font_Cyan="\033[36m"
Font_White="\033[37m"
Back_Black="\033[40m"
Back_Red="\033[41m"
Back_Green="\033[42m"
Back_Yellow="\033[43m"
Back_Blue="\033[44m"
Back_Purple="\033[45m"
Back_Cyan="\033[46m"
Back_White="\033[47m"
Font_Suffix="\033[0m"
Font_LineClear="\033[2K"
Font_LineUp="\033[1A"
declare ADLines
declare -A aad
declare IP=""
declare IPhide
declare fullIP=0
declare YY="cn"
declare -A maxmind
declare -A ipinfo
declare -A scamalytics
declare -A ipregistry
declare -A ipapi
declare -A abuseipdb
declare -A ip2location
declare -A dbip
declare -A ipwhois
declare -A ipdata
declare -A ipqs
declare -A cloudflare
declare -A tiktok
declare -A disney
declare -A netflix
declare -A youtube
declare -A amazon
declare -A spotify
declare -A chatgpt
declare IPV4
declare IPV6
declare IPV4check=1
declare IPV6check=1
declare IPV4work=0
declare IPV6work=0
declare ERRORcode=0
declare shelp
declare -A swarn
declare -A sinfo
declare -A shead
declare -A sbasic
declare -A stype
declare -A sscore
declare -A sfactor
declare -A smedia
declare -A smail
declare -A smailstatus
declare -A stail
declare mode_no=0
declare mode_yes=0
declare mode_lite=0
declare mode_json=0
declare mode_menu=0
declare mode_output=0
declare mode_privacy=0
declare ipjson
declare ibar=0
declare bar_pid
declare ibar_step=0
declare main_pid=$$
declare PADDING=""
declare useNIC=""
declare usePROXY=""
declare CurlARG=""
declare UA_Browser
declare rawgithub
declare Media_Cookie
declare IATA_Database
shelp_lines=(
"IP QUALITY CHECK SCRIPT IP质量体检脚本"
"Interactive Interface:  bash <(curl -sL https://IP.Check.Place) -EM"
"交互界面：              bash <(curl -sL https://IP.Check.Place) -M"
"Parameters 参数运行: bash <(curl -sL https://IP.Check.Place) [-4] [-6] [-f] [-h] [-j] [-i iface] [-l language] [-n] [-x proxy] [-y] [-E] [-M]"
"            -4                             Test IPv4                                  测试IPv4"
"            -6                             Test IPv6                                  测试IPv6"
"            -f                             Show full IP on reports                    报告展示完整IP地址"
"            -h                             Help information                           帮助信息"
"            -j                             JSON output                                JSON输出"
"            -i eth0                        Specify network interface                  指定检测网卡"
"               ipaddress                   Specify outbound IP Address                指定检测出口IP"
"            -l cn|en|jp|es|de|fr|ru|pt     Specify script language                    指定报告语言"
"            -n                             No OS or dependencies check                跳过系统检测及依赖安装"
"            -o /path/to/file.ansi          Output ANSI report to file                 输出ANSI报告至文件"
"               /path/to/file.json          Output JSON result to file                 输出JSON结果至文件"
"               /path/to/file.anyother      Output plain text report to file           输出纯文本报告至文件"
"            -p                             Privacy mode - no generate report link     隐私模式：不生成报告链接"
"            -x http://usr:pwd@proxyurl:p   Specify http proxy                         指定http代理"
"               https://usr:pwd@proxyurl:p  Specify https proxy                        指定https代理"
"               socks5://usr:pwd@proxyurl:p Specify socks5 proxy                       指定socks5代理"
"            -y                             Install dependencies without interupt      自动安装依赖"
"            -E                             Specify English Output                     指定英文输出"
"            -M                             Run with Interactive Interface             交互界面方式运行")
shelp=$(printf "%s\n" "${shelp_lines[@]}")
set_language(){
case "$YY" in
"en"|"jp"|"es"|"de"|"fr"|"ru"|"pt")swarn[1]="ERROR: Unsupported parameters!"
swarn[2]="ERROR: IP address format error!"
swarn[3]="ERROR: Dependent programs are missing. Please run as root or install sudo!"
swarn[4]="ERROR: Parameter -4 conflicts with -i or -6!"
swarn[6]="ERROR: Parameter -6 conflicts with -i or -4!"
swarn[7]="ERROR: The specified network interface or outbound IP is invalid or does not exist!"
swarn[8]="ERROR: The specified proxy parameter is invalid or not working!"
swarn[10]="ERROR: Output file already exist!"
swarn[11]="ERROR: Output file is not writable!"
swarn[40]="ERROR: IPv4 is not available!"
swarn[60]="ERROR: IPv6 is not available!"
sinfo[database]="Checking IP database "
sinfo[media]="Checking stream media "
sinfo[ai]="Checking AI provider "
sinfo[mail]="Connecting Email server "
sinfo[dnsbl]="Checking Blacklist database "
sinfo[ldatabase]=21
sinfo[lmedia]=22
sinfo[lai]=21
sinfo[lmail]=24
sinfo[ldnsbl]=28
shead[title]="IP QUALITY CHECK REPORT: "
shead[title_lite]="IP QUALITY CHECK REPORT(LITE): "
shead[ver]="Version: $script_version"
shead[bash]="bash <(curl -sL https://Check.Place) -EI"
shead[git]="https://github.com/xykt/IPQuality"
shead[time]=$(date -u +"Report Time: %Y-%m-%d %H:%M:%S UTC")
shead[ltitle]=25
shead[ltitle_lite]=31
shead[ptime]=$(printf '%7s' '')
sbasic[title]="1. Basic Information (${Font_I}Maxmind Database$Font_Suffix)"
sbasic[title_lite]="1. Basic Information (${Font_I}IPinfo Database$Font_Suffix)"
sbasic[asn]="ASN:                    "
sbasic[noasn]="Not Assigned"
sbasic[org]="Organization:           "
sbasic[location]="Location:               "
sbasic[map]="Map:                    "
sbasic[city]="City:                   "
sbasic[country]="Actual Region:          "
sbasic[regcountry]="Registered Region:      "
sbasic[continent]="Continent:              "
sbasic[timezone]="Time Zone:              "
sbasic[type]="IP Type:                "
sbasic[type0]=" Geo-consistent "
sbasic[type1]=" Geo-discrepant "
stype[business]=" $Back_Yellow$Font_White$Font_B Business $Font_Suffix "
stype[isp]="   $Back_Green$Font_White$Font_B ISP $Font_Suffix    "
stype[hosting]=" $Back_Red$Font_White$Font_B Hosting $Font_Suffix  "
stype[education]="$Back_Yellow$Font_White$Font_B Education $Font_Suffix "
stype[government]="$Back_Yellow$Font_White$Font_B Government $Font_Suffix"
stype[banking]=" $Back_Yellow$Font_White$Font_B Banking $Font_Suffix  "
stype[organization]="$Back_Yellow$Font_White${Font_B}Organization$Font_Suffix"
stype[military]=" $Back_Yellow$Font_White$Font_B Military $Font_Suffix "
stype[library]=" $Back_Yellow$Font_White$Font_B Library $Font_Suffix  "
stype[cdn]="   $Back_Red$Font_White$Font_B CDN $Font_Suffix    "
stype[lineisp]=" $Back_Green$Font_White$Font_B Line ISP $Font_Suffix "
stype[mobile]="$Back_Green$Font_White$Font_B Mobile ISP $Font_Suffix"
stype[spider]="$Back_Red$Font_White$Font_B Web Spider $Font_Suffix"
stype[reserved]=" $Back_Yellow$Font_White$Font_B Reserved $Font_Suffix "
stype[other]="  $Back_Yellow$Font_White$Font_B Other $Font_Suffix   "
stype[title]="2. IP Type"
stype[db]="Database:  "
stype[usetype]="Usage:     "
stype[comtype]="Company:   "
sscore[verylow]="$Font_Green${Font_B}VeryLow$Font_Suffix"
sscore[low]="$Font_Green${Font_B}Low$Font_Suffix"
sscore[medium]="$Font_Yellow${Font_B}Medium$Font_Suffix"
sscore[high]="$Font_Red${Font_B}High$Font_Suffix"
sscore[veryhigh]="$Font_Red${Font_B}VeryHigh$Font_Suffix"
sscore[elevated]="$Font_Yellow${Font_B}Elevated$Font_Suffix"
sscore[suspicious]="$Font_Yellow${Font_B}Suspicious$Font_Suffix"
sscore[risky]="$Font_Red${Font_B}Risky$Font_Suffix"
sscore[highrisk]="$Font_Red${Font_B}HighRisk$Font_Suffix"
sscore[dos]="$Font_Red${Font_B}DoS$Font_Suffix"
sscore[colon]=": "
sscore[title]="3. Risk Score"
sscore[range]="${Font_Cyan}Levels:         $Font_I$Font_White${Back_Green}VeryLow     Low $Back_Yellow     Medium     $Back_Red High   VeryHigh$Font_Suffix"
sfactor[title]="4. Risk Factors"
sfactor[factor]="DB:  "
sfactor[countrycode]="Region: "
sfactor[proxy]="Proxy:  "
sfactor[tor]="Tor:    "
sfactor[vpn]="VPN:    "
sfactor[server]="Server: "
sfactor[abuser]="Abuser: "
sfactor[robot]="Robot:  "
sfactor[yes]="$Font_Red$Font_B Yes$Font_Suffix"
sfactor[no]="$Font_Green$Font_B No $Font_Suffix"
sfactor[na]="$Font_Green$Font_B N/A$Font_Suffix"
smedia[yes]="  $Back_Green$Font_White Yes $Font_Suffix  "
smedia[no]=" $Back_Red$Font_White Block $Font_Suffix "
smedia[bad]="$Back_Red$Font_White Failed $Font_Suffix "
smedia[pending]="$Back_Yellow$Font_White Pending $Font_Suffix"
smedia[cn]=" $Back_Red$Font_White China $Font_Suffix "
smedia[noprem]="$Back_Red$Font_White NoPrem. $Font_Suffix"
smedia[org]="$Back_Yellow$Font_White NF.Only $Font_Suffix"
smedia[web]="$Back_Yellow$Font_White WebOnly $Font_Suffix"
smedia[app]="$Back_Yellow$Font_White APPOnly $Font_Suffix"
smedia[idc]="  $Back_Yellow$Font_White IDC $Font_Suffix  "
smedia[native]="$Back_Green$Font_White Native $Font_Suffix "
smedia[dns]="$Back_Yellow$Font_White ViaDNS $Font_Suffix "
smedia[nodata]="         "
smedia[title]="5. Accessibility check for media and AI services"
smedia[meida]="Service: "
smedia[status]="Status:  "
smedia[region]="Region:  "
smedia[type]="Type:    "
smail[title]="6. Email service availability and blacklist detection"
smail[port]="Local Port 25 Outbound: "
smail[yes]="${Font_Green}Available$Font_Suffix"
smail[no]="${Font_Red}Blocked$Font_Suffix"
smail[occupied]="${Font_Yellow}Occupied$Font_Suffix"
smail[blocked]="${Font_Red}Remote Port 25 unreachable​$Font_Suffix"
smail[provider]="Conn: "
smail[dnsbl]="DNSBL database: "
smail[available]="$Font_Suffix${Font_Cyan}Active $Font_B"
smail[clean]="$Font_Suffix${Font_Green}Clean $Font_B"
smail[marked]="$Font_Suffix${Font_Yellow}Marked $Font_B"
smail[blacklisted]="$Font_Suffix${Font_Red}Blacklisted $Font_B"
stail[stoday]="IP Checks Today: "
stail[stotal]="; Total: "
stail[thanks]=". Thanks for running xy scripts!"
stail[link]="${Font_I}Report Link: $Font_U"
;;
"cn")swarn[1]="错误：不支持的参数！"
swarn[2]="错误：IP地址格式错误！"
swarn[3]="错误：未安装依赖程序，请以root执行此脚本，或者安装sudo命令！"
swarn[4]="错误：参数-4与-i/-6冲突！"
swarn[6]="错误：参数-6与-i/-4冲突！"
swarn[7]="错误：指定的网卡或出口IP不存在！"
swarn[8]="错误：指定的代理服务器不可用！"
swarn[10]="错误：输出文件已存在！"
swarn[11]="错误：输出文件不可写！"
swarn[40]="错误：IPV4不可用！"
swarn[60]="错误：IPV6不可用！"
sinfo[database]="正在检测IP数据库 "
sinfo[media]="正在检测流媒体服务商 "
sinfo[ai]="正在检测AI服务商 "
sinfo[mail]="正在连接邮件服务商 "
sinfo[dnsbl]="正在检测黑名单数据库 "
sinfo[ldatabase]=17
sinfo[lmedia]=21
sinfo[lai]=17
sinfo[lmail]=19
sinfo[ldnsbl]=21
shead[title]="IP质量体检报告："
shead[title_lite]="IP质量体检报告(Lite)："
shead[ver]="脚本版本：$script_version"
shead[bash]="bash <(curl -sL https://Check.Place) -I"
shead[git]="https://github.com/xykt/IPQuality"
shead[time]=$(TZ="Asia/Shanghai" date +"报告时间：%Y-%m-%d %H:%M:%S CST")
shead[ltitle]=16
shead[ltitle_lite]=22
shead[ptime]=$(printf '%8s' '')
sbasic[title]="一、基础信息（${Font_I}Maxmind 数据库$Font_Suffix）"
sbasic[title_lite]="一、基础信息（${Font_I}IPinfo 数据库$Font_Suffix）"
sbasic[asn]="自治系统号：            "
sbasic[noasn]="未分配"
sbasic[org]="组织：                  "
sbasic[location]="坐标：                  "
sbasic[map]="地图：                  "
sbasic[city]="城市：                  "
sbasic[country]="使用地：                "
sbasic[regcountry]="注册地：                "
sbasic[continent]="洲际：                  "
sbasic[timezone]="时区：                  "
sbasic[type]="IP类型：                "
sbasic[type0]=" 原生IP "
sbasic[type1]=" 广播IP "
stype[business]="   $Back_Yellow$Font_White$Font_B 商业 $Font_Suffix   "
stype[isp]="   $Back_Green$Font_White$Font_B 家宽 $Font_Suffix   "
stype[hosting]="   $Back_Red$Font_White$Font_B 机房 $Font_Suffix   "
stype[education]="   $Back_Yellow$Font_White$Font_B 教育 $Font_Suffix   "
stype[government]="   $Back_Yellow$Font_White$Font_B 政府 $Font_Suffix   "
stype[banking]="   $Back_Yellow$Font_White$Font_B 银行 $Font_Suffix   "
stype[organization]="   $Back_Yellow$Font_White$Font_B 组织 $Font_Suffix   "
stype[military]="   $Back_Yellow$Font_White$Font_B 军队 $Font_Suffix   "
stype[library]="  $Back_Yellow$Font_White$Font_B 图书馆 $Font_Suffix  "
stype[cdn]="   $Back_Red$Font_White$Font_B CDN $Font_Suffix    "
stype[lineisp]="   $Back_Green$Font_White$Font_B 家宽 $Font_Suffix   "
stype[mobile]="   $Back_Green$Font_White$Font_B 手机 $Font_Suffix   "
stype[spider]="   $Back_Red$Font_White$Font_B 蜘蛛 $Font_Suffix   "
stype[reserved]="   $Back_Yellow$Font_White$Font_B 保留 $Font_Suffix   "
stype[other]="   $Back_Yellow$Font_White$Font_B 其他 $Font_Suffix   "
stype[title]="二、IP类型属性"
stype[db]="数据库：   "
stype[usetype]="使用类型： "
stype[comtype]="公司类型： "
sscore[verylow]="$Font_Green$Font_B极低风险$Font_Suffix"
sscore[low]="$Font_Green$Font_B低风险$Font_Suffix"
sscore[medium]="$Font_Yellow$Font_B中风险$Font_Suffix"
sscore[high]="$Font_Red$Font_B高风险$Font_Suffix"
sscore[veryhigh]="$Font_Red$Font_B极高风险$Font_Suffix"
sscore[elevated]="$Font_Yellow$Font_B较高风险$Font_Suffix"
sscore[suspicious]="$Font_Yellow$Font_B可疑IP$Font_Suffix"
sscore[risky]="$Font_Red$Font_B存在风险$Font_Suffix"
sscore[highrisk]="$Font_Red$Font_B高风险$Font_Suffix"
sscore[dos]="$Font_Red$Font_B建议封禁$Font_Suffix"
sscore[colon]="："
sscore[title]="三、风险评分"
sscore[range]="$Font_Cyan风险等级：      $Font_I$Font_White$Back_Green极低         低 $Back_Yellow      中等      $Back_Red 高         极高$Font_Suffix"
sfactor[title]="四、风险因子"
sfactor[factor]="库： "
sfactor[countrycode]="地区：  "
sfactor[proxy]="代理：  "
sfactor[tor]="Tor：   "
sfactor[vpn]="VPN：   "
sfactor[server]="服务器："
sfactor[abuser]="滥用：  "
sfactor[robot]="机器人："
sfactor[yes]="$Font_Red$Font_B 是 $Font_Suffix"
sfactor[no]="$Font_Green$Font_B 否 $Font_Suffix"
sfactor[na]="$Font_Green$Font_B 无 $Font_Suffix"
smedia[yes]=" $Back_Green$Font_White 解锁 $Font_Suffix  "
smedia[no]=" $Back_Red$Font_White 屏蔽 $Font_Suffix  "
smedia[bad]=" $Back_Red$Font_White 失败 $Font_Suffix  "
smedia[pending]="$Back_Yellow$Font_White 待支持 $Font_Suffix "
smedia[cn]=" $Back_Red$Font_White 中国 $Font_Suffix  "
smedia[noprem]="$Back_Red$Font_White 禁会员 $Font_Suffix "
smedia[org]="$Back_Yellow$Font_White 仅自制 $Font_Suffix "
smedia[web]="$Back_Yellow$Font_White 仅网页 $Font_Suffix "
smedia[app]=" $Back_Yellow$Font_White 仅APP $Font_Suffix "
smedia[idc]=" $Back_Yellow$Font_White 机房 $Font_Suffix  "
smedia[native]=" $Back_Green$Font_White 原生 $Font_Suffix  "
smedia[dns]="  $Back_Yellow$Font_White DNS $Font_Suffix  "
smedia[nodata]="         "
smedia[title]="五、流媒体及AI服务解锁检测"
smedia[meida]="服务商： "
smedia[status]="状态：   "
smedia[region]="地区：   "
smedia[type]="方式：   "
smail[title]="六、邮局连通性及黑名单检测"
smail[port]="本地25端口出站："
smail[yes]="$Font_Green可用$Font_Suffix"
smail[no]="$Font_Red阻断$Font_Suffix"
smail[occupied]="$Font_Yellow占用$Font_Suffix"
smail[blocked]="$Font_Red远端25端口不可达​$Font_Suffix"
smail[provider]="通信："
smail[dnsbl]="IP地址黑名单数据库："
smail[available]="$Font_Suffix$Font_Cyan有效 $Font_B"
smail[clean]="$Font_Suffix$Font_Green正常 $Font_B"
smail[marked]="$Font_Suffix$Font_Yellow已标记 $Font_B"
smail[blacklisted]="$Font_Suffix$Font_Red黑名单 $Font_B"
stail[stoday]="今日IP检测量："
stail[stotal]="；总检测量："
stail[thanks]="。感谢使用xy系列脚本！"
stail[link]="$Font_I报告链接：$Font_U"
;;
*)echo -ne "ERROR: Language not supported!"
esac
}
countRunTimes(){
local RunTimes=$(curl $CurlARG -s --max-time 10 "https://hits.xykt.de/ip?action=hit" 2>&1)
stail[today]=$(echo "$RunTimes"|jq '.daily')
stail[total]=$(echo "$RunTimes"|jq '.total')
}
show_progress_bar(){
show_progress_bar_ "$@" 1>&2
}
show_progress_bar_(){
local bar="\u280B\u2819\u2839\u2838\u283C\u2834\u2826\u2827\u2807\u280F"
local n=${#bar}
while sleep 0.1;do
if ! kill -0 $main_pid 2>/dev/null;then
echo -ne ""
exit
fi
echo -ne "\r$Font_Cyan$Font_B[$IP]# $1$Font_Cyan$Font_B$(printf '%*s' "$2" ''|tr ' ' '.') ${bar:ibar++*6%n:6} $(printf '%02d%%' $ibar_step) $Font_Suffix"
done
}
kill_progress_bar(){
kill "$bar_pid" 2>/dev/null&&echo -ne "\r"
}
install_dependencies(){
if ! jq --version >/dev/null 2>&1||! curl --version >/dev/null 2>&1||! bc --version >/dev/null 2>&1||! nc -h >/dev/null 2>&1||! dig -v >/dev/null 2>&1;then
echo "Detecting operating system..."
if [ "$(uname)" == "Darwin" ];then
install_packages "brew" "brew install" "no_sudo"
elif [ -f /etc/os-release ];then
. /etc/os-release
if [ $(id -u) -ne 0 ]&&! command -v sudo >/dev/null 2>&1;then
ERRORcode=3
fi
case $ID in
ubuntu|debian|linuxmint)install_packages "apt" "apt-get install -y"
;;
rhel|centos|almalinux|rocky|anolis)if
[ "$(echo $VERSION_ID|cut -d '.' -f1)" -ge 8 ]
then
install_packages "dnf" "dnf install -y"
else
install_packages "yum" "yum install -y"
fi
;;
arch|manjaro)install_packages "pacman" "pacman -S --noconfirm"
;;
alpine)install_packages "apk" "apk add"
;;
fedora)install_packages "dnf" "dnf install -y"
;;
alinux)install_packages "yum" "yum install -y"
;;
suse|opensuse*)install_packages "zypper" "zypper install -y"
;;
void)install_packages "xbps" "xbps-install -Sy"
;;
*)echo "Unsupported distribution: $ID"
exit 1
esac
elif [ -n "$PREFIX" ];then
install_packages "pkg" "pkg install"
else
echo "Cannot detect distribution because /etc/os-release is missing."
exit 1
fi
fi
}
install_packages(){
local package_manager=$1
local install_command=$2
local no_sudo=$3
echo "Using package manager: $package_manager"
echo -e "Lacking necessary dependencies, $Font_I${Font_Cyan}jq curl bc netcat dnsutils iproute$Font_Suffix will be installed using $Font_I$Font_Cyan$package_manager$Font_Suffix."
if [[ $mode_yes -eq 0 ]];then
prompt=$(printf "Continue? (${Font_Green}y$Font_Suffix/${Font_Red}n$Font_Suffix): ")
read -p "$prompt" choice
case "$choice" in
y|Y|yes|Yes|YES)echo "Continue to execute script..."
;;
n|N|no|No|NO)echo "Script exited."
exit 0
;;
*)echo "Invalid input, script exited."
exit 1
esac
else
echo -e "Detected parameter $Font_Green-y$Font_Suffix. Continue installation..."
fi
if [ "$no_sudo" == "no_sudo" ]||[ $(id -u) -eq 0 ];then
local usesudo=""
else
local usesudo="sudo"
fi
case $package_manager in
apt)$usesudo apt update
$usesudo $install_command jq curl bc netcat-openbsd dnsutils iproute2
;;
dnf|yum)$usesudo $install_command epel-release
$usesudo $package_manager makecache
$usesudo $install_command jq curl bc nmap-ncat bind-utils iproute
;;
pacman)$usesudo pacman -Sy
$usesudo $install_command jq curl bc gnu-netcat bind-tools iproute2
;;
apk)$usesudo apk update
$usesudo $install_command jq curl bc netcat-openbsd grep bind-tools iproute2
;;
pkg)$usesudo $package_manager update
$usesudo $package_manager $install_command jq curl bc netcat dnsutils iproute
;;
brew)eval "$(/opt/homebrew/bin/brew shellenv)"
$install_command jq curl bc netcat bind
;;
zypper)$usesudo zypper refresh
$usesudo $install_command jq curl bc netcat bind-utils iproute2
;;
xbps)$usesudo xbps-install -Sy
$usesudo $install_command jq curl bc netcat bind-utils iproute2
esac
}
declare -A browsers=(
[Chrome]="139.0.7258.128 139.0.7258.67 138.0.7204.185 138.0.7204.170 138.0.7204.159 138.0.7204.102 138.0.7204.100 138.0.7204.51 138.0.7204.49 137.0.7151.122 138.0.7204.35 137.0.7151.121 137.0.7151.105 137.0.7151.104 137.0.7151.57 137.0.7151.55 136.0.7103.116 137.0.7151.40 136.0.7103.113 136.0.7103.92 135.0.7049.117 136.0.7103.48 135.0.7049.114 135.0.7049.86 135.0.7049.42 135.0.7049.41 134.0.6998.167 134.0.6998.119 134.0.6998.117 134.0.6998.37 134.0.6998.35 133.0.6943.128 133.0.6943.100 133.0.6943.59 133.0.6943.53 132.0.6834.162 133.0.6943.35 132.0.6834.160 132.0.6834.112 132.0.6834.110 131.0.6778.267 132.0.6834.83 131.0.6778.264 131.0.6778.204 131.0.6778.139 131.0.6778.109 131.0.6778.71 131.0.6778.69 130.0.6723.119 131.0.6778.33 130.0.6723.116 130.0.6723.71 130.0.6723.60 130.0.6723.58 129.0.6668.103 130.0.6723.44 129.0.6668.100 129.0.6668.72 129.0.6668.60 129.0.6668.42 128.0.6613.122 128.0.6613.121 128.0.6613.115 128.0.6613.113 127.0.6533.122 128.0.6613.36 127.0.6533.119 127.0.6533.100 127.0.6533.74 127.0.6533.72 126.0.6478.185 127.0.6533.57 126.0.6478.183 126.0.6478.128 126.0.6478.116 126.0.6478.114 126.0.6478.61 125.0.6422.176 126.0.6478.56 125.0.6422.144 126.0.6478.36 125.0.6422.142 125.0.6422.114 125.0.6422.77 125.0.6422.76 124.0.6367.210 125.0.6422.60 124.0.6367.208 124.0.6367.201 124.0.6367.156 125.0.6422.41 124.0.6367.155 124.0.6367.119 124.0.6367.92 124.0.6367.63 124.0.6367.61 123.0.6312.124 124.0.6367.60 123.0.6312.122 123.0.6312.106 123.0.6312.105 123.0.6312.60 123.0.6312.58 122.0.6261.131 123.0.6312.46 122.0.6261.129 122.0.6261.128 122.0.6261.112 122.0.6261.111 122.0.6261.71 122.0.6261.69 121.0.6167.189 122.0.6261.57 121.0.6167.187 121.0.6167.186 121.0.6167.162 121.0.6167.160 121.0.6167.140 121.0.6167.86 121.0.6167.85 120.0.6099.227 120.0.6099.225 121.0.6167.75 120.0.6099.224 120.0.6099.218 120.0.6099.216 120.0.6099.200 120.0.6099.199 120.0.6099.129 120.0.6099.110 120.0.6099.109 120.0.6099.62 120.0.6099.56"
[Firefox]="132.0 131.0 130.0 129.0 128.0 127.0 126.0 125.0 124.0 123.0 122.0 121.0 120.0")
generate_random_user_agent(){
local browsers_keys=(${!browsers[@]})
local random_browser_index=$((RANDOM%${#browsers_keys[@]}))
local browser=${browsers_keys[random_browser_index]}
case $browser in
Chrome)local versions=(${browsers[Chrome]})
local version=${versions[RANDOM%${#versions[@]}]}
UA_Browser="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/$version Safari/537.36"
;;
Firefox)local versions=(${browsers[Firefox]})
local version=${versions[RANDOM%${#versions[@]}]}
UA_Browser="Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:$version) Gecko/20100101 Firefox/$version"
esac
}
adapt_locale(){
local ifunicode=$(printf '\u2800')
[[ ${#ifunicode} -gt 3 ]]&&export LC_CTYPE=en_US.UTF-8 2>/dev/null
}
check_connectivity(){
local url="https://www.google.com/generate_204"
local timeout=2
local http_code
http_code=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout "$timeout" "$url" 2>/dev/null)
if [[ $http_code == "204" ]];then
rawgithub="https://github.com/xykt/IPQuality/raw/"
return 0
else
rawgithub="https://testingcf.jsdelivr.net/gh/xykt/IPQuality@"
return 1
fi
}
is_valid_ipv4(){
local ip=$1
if [[ $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]];then
IFS='.' read -r -a octets <<<"$ip"
for octet in "${octets[@]}";do
if ((octet<0||octet>255));then
IPV4work=0
return 1
fi
done
IPV4work=1
return 0
else
IPV4work=0
return 1
fi
}
is_private_ipv4(){
local ip_address=$1
if [[ -z $ip_address ]];then
return 0
fi
if [[ $ip_address =~ ^10\. ]]||[[ $ip_address =~ ^172\.(1[6-9]|2[0-9]|3[0-1])\. ]]||[[ $ip_address =~ ^192\.168\. ]]||[[ $ip_address =~ ^127\. ]]||[[ $ip_address =~ ^0\. ]]||[[ $ip_address =~ ^22[4-9]\. ]]||[[ $ip_address =~ ^23[0-9]\. ]];then
return 0
fi
return 1
}
get_ipv4(){
local response
IPV4=""
local API_NET=("myip.check.place" "ip.sb" "ping0.cc" "icanhazip.com" "api64.ipify.org" "ifconfig.co" "ident.me")
for p in "${API_NET[@]}";do
response=$(curl $CurlARG -s4 --max-time 2 "$p")
if [[ $? -eq 0 && ! $response =~ error && -n $response ]];then
IPV4="$response"
break
fi
done
}
hide_ipv4(){
if [[ -n $1 ]];then
IFS='.' read -r -a ip_parts <<<"$1"
IPhide="${ip_parts[0]}.${ip_parts[1]}.*.*"
else
IPhide=""
fi
}
is_valid_ipv6(){
local ip=$1
if [[ $ip =~ ^([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$ || $ip =~ ^([0-9a-fA-F]{1,4}:){1,7}:$ || $ip =~ ^:([0-9a-fA-F]{1,4}:){1,7}$ || $ip =~ ^([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}$ || $ip =~ ^([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}$ || $ip =~ ^([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}$ || $ip =~ ^([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}$ || $ip =~ ^([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}$ || $ip =~ ^[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})$ || $ip =~ ^:((:[0-9a-fA-F]{1,4}){1,7}|:)$ || $ip =~ ^fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}$ || $ip =~ ^::(ffff(:0{1,4}){0,1}:){0,1}(([0-9]{1,3}\.){3}[0-9]{1,3})$ || $ip =~ ^([0-9a-fA-F]{1,4}:){1,4}:(([0-9]{1,3}\.){3}[0-9]{1,3})$ ]];then
IPV6work=1
return 0
else
IPV6work=0
return 1
fi
}
is_private_ipv6(){
local address=$1
if [[ -z $address ]];then
return 0
fi
if [[ $address =~ ^fe80: ]]||[[ $address =~ ^fc00: ]]||[[ $address =~ ^fd00: ]]||[[ $address =~ ^2001:db8: ]]||[[ $address == ::1 ]]||[[ $address =~ ^::ffff: ]]||[[ $address =~ ^2002: ]]||[[ $address =~ ^2001: ]];then
return 0
fi
return 1
}
get_ipv6(){
local response
IPV6=""
local API_NET=("myip.check.place" "ip.sb" "ping0.cc" "icanhazip.com" "api64.ipify.org" "ifconfig.co" "ident.me")
for p in "${API_NET[@]}";do
response=$(curl $CurlARG -s6k --max-time 2 "$p")
if [[ $? -eq 0 && ! $response =~ error && -n $response ]];then
IPV6="$response"
break
fi
done
}
hide_ipv6(){
if [[ -n $1 ]];then
local expanded_ip=$(echo "$1"|sed 's/::/:0000:0000:0000:0000:0000:0000:0000:0000:/g'|cut -d ':' -f1-8)
IFS=':' read -r -a ip_parts <<<"$expanded_ip"
while [ ${#ip_parts[@]} -lt 8 ];do
ip_parts+=(0000)
done
IPhide="${ip_parts[0]:-0}:${ip_parts[1]:-0}:${ip_parts[2]:-0}:*:*:*:*:*"
IPhide=$(echo "$IPhide"|sed 's/:0\{1,\}/:/g'|sed 's/::\+/:/g')
else
IPhide=""
fi
}
calculate_display_width(){
local string="$1"
local length=0
local char
for ((i=0; i<${#string}; i++));do
char=$(echo "$string"|od -An -N1 -tx1 -j $((i))|tr -d ' ')
if [ "$(printf '%d\n' 0x$char)" -gt 127 ];then
length=$((length+2))
i=$((i+1))
else
length=$((length+1))
fi
done
echo "$length"
}
calc_padding(){
local input_text="$1"
local total_width=$2
local title_length=$(calculate_display_width "$input_text")
local left_padding=$(((total_width-title_length)/2))
if [[ $left_padding -gt 0 ]];then
PADDING=$(printf '%*s' $left_padding)
else
PADDING=""
fi
}
generate_dms(){
local lat=$1
local lon=$2
if [[ -z $lat || $lat == "null" || -z $lon || $lon == "null" ]];then
echo ""
return
fi
convert_single(){
local coord=$1
local direction=$2
local fixed_coord=$(echo "$coord"|sed 's/\.$/.0/')
local degrees=$(echo "$fixed_coord"|cut -d'.' -f1)
local fractional="0.$(echo "$fixed_coord"|cut -d'.' -f2)"
local minutes=$(echo "$fractional * 60"|bc -l|cut -d'.' -f1)
local seconds_fractional="0.$(echo "$fractional * 60"|bc -l|cut -d'.' -f2)"
local seconds=$(echo "$seconds_fractional * 60"|bc -l|awk '{printf "%.0f", $1}')
echo "$degrees°$minutes′$seconds″$direction"
}
local lat_dir='N'
if [[ $(echo "$lat < 0"|bc -l) -eq 1 ]];then
lat_dir='S'
lat=$(echo "$lat * -1"|bc -l)
fi
local lon_dir='E'
if [[ $(echo "$lon < 0"|bc -l) -eq 1 ]];then
lon_dir='W'
lon=$(echo "$lon * -1"|bc -l)
fi
local lat_dms=$(convert_single $lat $lat_dir)
local lon_dms=$(convert_single $lon $lon_dir)
echo "$lon_dms, $lat_dms"
}
generate_googlemap_url(){
local lat=$1
local lon=$2
local radius=$3
if [[ -z $lat || $lat == "null" || -z $lon || $lon == "null" || -z $radius || $radius == "null" ]];then
echo ""
return
fi
local zoom_level=15
if [[ $radius -gt 1000 ]];then
zoom_level=12
elif [[ $radius -gt 500 ]];then
zoom_level=13
elif [[ $radius -gt 250 ]];then
zoom_level=14
fi
echo "https://check.place/$lat,$lon,$zoom_level,$YY"
}
db_maxmind(){
local temp_info="$Font_Cyan$Font_B${sinfo[database]}${Font_I}Maxmind $Font_Suffix"
((ibar_step+=3))
show_progress_bar "$temp_info" $((40-8-${sinfo[ldatabase]}))&
bar_pid="$!"&&disown "$bar_pid"
trap "kill_progress_bar" RETURN
maxmind=()
local RESPONSE=$(curl $CurlARG -Ls -$1 -m 10 "https://ipinfo.check.place/$IP?lang=$YY")
echo "$RESPONSE"|jq . >/dev/null 2>&1||RESPONSE=""
if [[ -z $RESPONSE ]];then
mode_lite=1
else
mode_lite=0
fi
maxmind[asn]=$(echo "$RESPONSE"|jq -r '.ASN.AutonomousSystemNumber')
maxmind[org]=$(echo "$RESPONSE"|jq -r '.ASN.AutonomousSystemOrganization')
maxmind[city]=$(echo "$RESPONSE"|jq -r '.City.Name')
maxmind[post]=$(echo "$RESPONSE"|jq -r '.City.PostalCode')
maxmind[lat]=$(echo "$RESPONSE"|jq -r '.City.Latitude')
maxmind[lon]=$(echo "$RESPONSE"|jq -r '.City.Longitude')
maxmind[rad]=$(echo "$RESPONSE"|jq -r '.City.AccuracyRadius')
maxmind[continentcode]=$(echo "$RESPONSE"|jq -r '.City.Continent.Code')
maxmind[continent]=$(echo "$RESPONSE"|jq -r '.City.Continent.Name')
maxmind[citycountrycode]=$(echo "$RESPONSE"|jq -r '.City.Country.IsoCode')
maxmind[citycountry]=$(echo "$RESPONSE"|jq -r '.City.Country.Name')
maxmind[timezone]=$(echo "$RESPONSE"|jq -r '.City.Location.TimeZone')
maxmind[subcode]=$(echo "$RESPONSE"|jq -r 'if .City.Subdivisions | length > 0 then .City.Subdivisions[0].IsoCode else "N/A" end')
maxmind[sub]=$(echo "$RESPONSE"|jq -r 'if .City.Subdivisions | length > 0 then .City.Subdivisions[0].Name else "N/A" end')
maxmind[countrycode]=$(echo "$RESPONSE"|jq -r '.Country.IsoCode')
maxmind[country]=$(echo "$RESPONSE"|jq -r '.Country.Name')
maxmind[regcountrycode]=$(echo "$RESPONSE"|jq -r '.Country.RegisteredCountry.IsoCode')
maxmind[regcountry]=$(echo "$RESPONSE"|jq -r '.Country.RegisteredCountry.Name')
if [[ $YY != "en" ]];then
local backup_response=$(curl $CurlARG -s -$1 -m 10 "https://ipinfo.check.place/$IP?lang=en")
[[ ${maxmind[asn]} == "null" ]]&&maxmind[asn]=$(echo "$backup_response"|jq -r '.ASN.AutonomousSystemNumber')
[[ ${maxmind[org]} == "null" ]]&&maxmind[org]=$(echo "$backup_response"|jq -r '.ASN.AutonomousSystemOrganization')
[[ ${maxmind[city]} == "null" ]]&&maxmind[city]=$(echo "$backup_response"|jq -r '.City.Name')
[[ ${maxmind[post]} == "null" ]]&&maxmind[post]=$(echo "$backup_response"|jq -r '.City.PostalCode')
[[ ${maxmind[lat]} == "null" ]]&&maxmind[lat]=$(echo "$backup_response"|jq -r '.City.Latitude')
[[ ${maxmind[lon]} == "null" ]]&&maxmind[lon]=$(echo "$backup_response"|jq -r '.City.Longitude')
[[ ${maxmind[rad]} == "null" ]]&&maxmind[rad]=$(echo "$backup_response"|jq -r '.City.AccuracyRadius')
[[ ${maxmind[continentcode]} == "null" ]]&&maxmind[continentcode]=$(echo "$backup_response"|jq -r '.City.Continent.Code')
[[ ${maxmind[continent]} == "null" ]]&&maxmind[continent]=$(echo "$backup_response"|jq -r '.City.Continent.Name')
[[ ${maxmind[citycountrycode]} == "null" ]]&&maxmind[citycountrycode]=$(echo "$backup_response"|jq -r '.City.Country.IsoCode')
[[ ${maxmind[citycountry]} == "null" ]]&&maxmind[citycountry]=$(echo "$backup_response"|jq -r '.City.Country.Name')
[[ ${maxmind[timezone]} == "null" ]]&&maxmind[timezone]=$(echo "$backup_response"|jq -r '.City.Location.TimeZone')
[[ ${maxmind[subcode]} == "null" ]]&&maxmind[subcode]=$(echo "$backup_response"|jq -r 'if .City.Subdivisions | length > 0 then .City.Subdivisions[0].IsoCode else "N/A" end')
[[ ${maxmind[sub]} == "null" ]]&&maxmind[sub]=$(echo "$backup_response"|jq -r 'if .City.Subdivisions | length > 0 then .City.Subdivisions[0].Name else "N/A" end')
[[ ${maxmind[countrycode]} == "null" ]]&&maxmind[countrycode]=$(echo "$backup_response"|jq -r '.Country.IsoCode')
[[ ${maxmind[country]} == "null" ]]&&maxmind[country]=$(echo "$backup_response"|jq -r '.Country.Name')
[[ ${maxmind[regcountrycode]} == "null" ]]&&maxmind[regcountrycode]=$(echo "$backup_response"|jq -r '.Country.RegisteredCountry.IsoCode')
[[ ${maxmind[regcountry]} == "null" ]]&&maxmind[regcountry]=$(echo "$backup_response"|jq -r '.Country.RegisteredCountry.Name')
fi
if [[ ${maxmind[lat]} != "null" && ${maxmind[lon]} != "null" ]];then
maxmind[dms]=$(generate_dms "${maxmind[lat]}" "${maxmind[lon]}")
maxmind[map]=$(generate_googlemap_url "${maxmind[lat]}" "${maxmind[lon]}" "${maxmind[rad]}")
else
maxmind[dms]="null"
maxmind[map]="null"
fi
}
db_ipinfo(){
local temp_info="$Font_Cyan$Font_B${sinfo[database]}${Font_I}IPinfo $Font_Suffix"
((ibar_step+=3))
show_progress_bar "$temp_info" $((40-7-${sinfo[ldatabase]}))&
bar_pid="$!"&&disown "$bar_pid"
trap "kill_progress_bar" RETURN
ipinfo=()
local RESPONSE=$(curl $CurlARG -Ls -m 10 "https://ipinfo.io/widget/demo/$IP")
echo "$RESPONSE"|jq . >/dev/null 2>&1||RESPONSE=""
ipinfo[usetype]=$(echo "$RESPONSE"|jq -r '.data.asn.type')
ipinfo[comtype]=$(echo "$RESPONSE"|jq -r '.data.company.type')
shopt -s nocasematch
case ${ipinfo[usetype]} in
"business")ipinfo[susetype]="${stype[business]}"
;;
"isp")ipinfo[susetype]="${stype[isp]}"
;;
"hosting")ipinfo[susetype]="${stype[hosting]}"
;;
"education")ipinfo[susetype]="${stype[education]}"
;;
*)ipinfo[susetype]="${stype[other]}"
esac
case ${ipinfo[comtype]} in
"business")ipinfo[scomtype]="${stype[business]}"
;;
"isp")ipinfo[scomtype]="${stype[isp]}"
;;
"hosting")ipinfo[scomtype]="${stype[hosting]}"
;;
"education")ipinfo[scomtype]="${stype[education]}"
;;
*)ipinfo[scomtype]="${stype[other]}"
esac
shopt -u nocasematch
ipinfo[countrycode]=$(echo "$RESPONSE"|jq -r '.data.country')
ipinfo[proxy]=$(echo "$RESPONSE"|jq -r '.data.privacy.proxy')
ipinfo[tor]=$(echo "$RESPONSE"|jq -r '.data.privacy.tor')
ipinfo[vpn]=$(echo "$RESPONSE"|jq -r '.data.privacy.vpn')
ipinfo[server]=$(echo "$RESPONSE"|jq -r '.data.privacy.hosting')
local ISO3166=$(curl -sL -m 10 "${rawgithub}main/ref/iso3166.json")
ipinfo[asn]=$(echo "$RESPONSE"|jq -r '.data.asn.asn'|sed 's/^AS//')
ipinfo[org]=$(echo "$RESPONSE"|jq -r '.data.asn.name')
ipinfo[city]=$(echo "$RESPONSE"|jq -r '.data.city')
ipinfo[post]=$(echo "$RESPONSE"|jq -r '.data.postal')
ipinfo[timezone]=$(echo "$RESPONSE"|jq -r '.data.timezone')
local tmp_str=$(echo "$RESPONSE"|jq -r '.data.loc')
ipinfo[lat]=$(echo "$tmp_str"|cut -d',' -f1)
ipinfo[lon]=$(echo "$tmp_str"|cut -d',' -f2)
ipinfo[countrycode]=$(echo "$RESPONSE"|jq -r '.data.country')
ipinfo[country]=$(echo "$ISO3166"|jq --arg code "${ipinfo[countrycode]}" -r '.[] | select(.["alpha-2"] == $code) | .name')
ipinfo[continent]=$(echo "$ISO3166"|jq --arg code "${ipinfo[countrycode]}" -r '.[] | select(.["alpha-2"] == $code) | .region')
ipinfo[regcountrycode]=$(echo "$RESPONSE"|jq -r '.data.abuse.country')
ipinfo[regcountry]=$(echo "$ISO3166"|jq --arg code "${ipinfo[regcountrycode]}" -r '.[] | select(.["alpha-2"] == $code) | .name')
if [[ ${ipinfo[lat]} != "null" && ${ipinfo[lon]} != "null" ]];then
ipinfo[dms]=$(generate_dms "${ipinfo[lat]}" "${ipinfo[lon]}")
ipinfo[map]=$(generate_googlemap_url "${ipinfo[lat]}" "${ipinfo[lon]}" "1001")
else
ipinfo[dms]="null"
ipinfo[map]="null"
fi
}
db_scamalytics(){
local temp_info="$Font_Cyan$Font_B${sinfo[database]}${Font_I}SCAMALYTICS $Font_Suffix"
((ibar_step+=3))
show_progress_bar "$temp_info" $((40-12-${sinfo[ldatabase]}))&
bar_pid="$!"&&disown "$bar_pid"
trap "kill_progress_bar" RETURN
scamalytics=()
local RESPONSE=$(curl $CurlARG --user-agent "$UA_Browser" -sL -H "Referer: https://scamalytics.com" -m 10 "https://scamalytics.com/ip/$IP")
[[ -z $RESPONSE ]]&&return 1
local tmpscore=$(echo "$RESPONSE"|grep -oE 'Fraud Score: [0-9]+'|awk -F': ' '{print $2}')
scamalytics[score]=$(echo "$tmpscore"|bc)
if [[ ${scamalytics[score]} -lt 25 ]];then
scamalytics[risk]="${sscore[low]}"
elif [[ ${scamalytics[score]} -lt 50 ]];then
scamalytics[risk]="${sscore[medium]}"
elif [[ ${scamalytics[score]} -lt 75 ]];then
scamalytics[risk]="${sscore[high]}"
elif [[ ${scamalytics[score]} -ge 75 ]];then
scamalytics[risk]="${sscore[veryhigh]}"
fi
scamalytics[countrycode]=$(echo "$RESPONSE"|awk -F'</?td>' '/<th>Country Code<\/th>/ {getline; print $2}')
scamalytics[vpn]=$(echo "$RESPONSE"|awk '/<th>Anonymizing VPN<\/th>/ {getline; getline; if ($0 ~ /Yes/) print "true"; else print "false"}')
scamalytics[tor]=$(echo "$RESPONSE"|awk '/<th>Tor Exit Node<\/th>/ {getline; getline; if ($0 ~ /Yes/) print "true"; else print "false"}')
scamalytics[server]=$(echo "$RESPONSE"|awk '/<th>Server<\/th>/ {getline; getline; if ($0 ~ /Yes/) print "true"; else print "false"}')
scamalytics[proxy1]=$(echo "$RESPONSE"|awk '/<th>Public Proxy<\/th>/ {getline; getline; if ($0 ~ /Yes/) print "true"; else print "false"}')
scamalytics[proxy2]=$(echo "$RESPONSE"|awk '/<th>Web Proxy<\/th>/ {getline; getline; if ($0 ~ /Yes/) print "true"; else print "false"}')
[[ ${scamalytics[proxy1]} == "true" || ${scamalytics[proxy2]} == "true" ]]&&scamalytics[proxy]="true"
[[ ${scamalytics[proxy1]} == "false" && ${scamalytics[proxy2]} == "false" ]]&&scamalytics[proxy]="false"
scamalytics[robot]=$(echo "$RESPONSE"|awk '/<th>Search Engine Robot<\/th>/ {getline; getline; if ($0 ~ /Yes/) print "true"; else print "false"}')
}
db_ipregistry(){
local temp_info="$Font_Cyan$Font_B${sinfo[database]}${Font_I}ipregistry $Font_Suffix"
((ibar_step+=3))
show_progress_bar "$temp_info" $((40-11-${sinfo[ldatabase]}))&
bar_pid="$!"&&disown "$bar_pid"
trap "kill_progress_bar" RETURN
ipregistry=()
local RESPONSE=$(curl $CurlARG -sL -$1 -m 10 "https://ipinfo.check.place/$IP?db=ipregistry")
echo "$RESPONSE"|jq . >/dev/null 2>&1||RESPONSE=""
ipregistry[usetype]=$(echo "$RESPONSE"|jq -r '.connection.type')
ipregistry[comtype]=$(echo "$RESPONSE"|jq -r '.company.type')
shopt -s nocasematch
case ${ipregistry[usetype]} in
"business")ipregistry[susetype]="${stype[business]}"
;;
"isp")ipregistry[susetype]="${stype[isp]}"
;;
"hosting")ipregistry[susetype]="${stype[hosting]}"
;;
"education")ipregistry[susetype]="${stype[education]}"
;;
"government")ipregistry[susetype]="${stype[government]}"
;;
*)ipregistry[susetype]="${stype[other]}"
esac
case ${ipregistry[comtype]} in
"business")ipregistry[scomtype]="${stype[business]}"
;;
"isp")ipregistry[scomtype]="${stype[isp]}"
;;
"hosting")ipregistry[scomtype]="${stype[hosting]}"
;;
"education")ipregistry[scomtype]="${stype[education]}"
;;
"government")ipregistry[scomtype]="${stype[government]}"
;;
*)ipregistry[scomtype]="${stype[other]}"
esac
shopt -u nocasematch
ipregistry[countrycode]=$(echo "$RESPONSE"|jq -r '.location.country.code')
ipregistry[proxy]=$(echo "$RESPONSE"|jq -r '.security.is_proxy')
ipregistry[tor1]=$(echo "$RESPONSE"|jq -r '.security.is_tor')
ipregistry[tor2]=$(echo "$RESPONSE"|jq -r '.security.is_tor_exit')
[[ ${ipregistry[tor1]} == "true" || ${ipregistry[tor2]} == "true" ]]&&ipregistry[tor]="true"
[[ ${ipregistry[tor1]} == "false" && ${ipregistry[tor2]} == "false" ]]&&ipregistry[tor]="false"
ipregistry[vpn]=$(echo "$RESPONSE"|jq -r '.security.is_vpn')
ipregistry[server]=$(echo "$RESPONSE"|jq -r '.security.is_cloud_provider')
ipregistry[abuser]=$(echo "$RESPONSE"|jq -r '.security.is_abuser')
}
db_ipapi(){
local temp_info="$Font_Cyan$Font_B${sinfo[database]}${Font_I}ipapi $Font_Suffix"
((ibar_step+=3))
show_progress_bar "$temp_info" $((40-6-${sinfo[ldatabase]}))&
bar_pid="$!"&&disown "$bar_pid"
trap "kill_progress_bar" RETURN
ipapi=()
local RESPONSE=$(curl $CurlARG -sL -m 10 "https://api.ipapi.is/?q=$IP")
echo "$RESPONSE"|jq . >/dev/null 2>&1||RESPONSE=""
ipapi[usetype]=$(echo "$RESPONSE"|jq -r '.asn.type')
ipapi[comtype]=$(echo "$RESPONSE"|jq -r '.company.type')
shopt -s nocasematch
case ${ipapi[usetype]} in
"business")ipapi[susetype]="${stype[business]}"
;;
"isp")ipapi[susetype]="${stype[isp]}"
;;
"hosting")ipapi[susetype]="${stype[hosting]}"
;;
"education")ipapi[susetype]="${stype[education]}"
;;
"government")ipapi[susetype]="${stype[government]}"
;;
"banking")ipapi[susetype]="${stype[banking]}"
;;
*)ipapi[susetype]="${stype[other]}"
esac
case ${ipapi[comtype]} in
"business")ipapi[scomtype]="${stype[business]}"
;;
"isp")ipapi[scomtype]="${stype[isp]}"
;;
"hosting")ipapi[scomtype]="${stype[hosting]}"
;;
"education")ipapi[scomtype]="${stype[education]}"
;;
"government")ipapi[scomtype]="${stype[government]}"
;;
"banking")ipapi[scomtype]="${stype[banking]}"
;;
*)ipapi[scomtype]="${stype[other]}"
esac
[[ -z $RESPONSE ]]&&return 1
ipapi[scoretext]=$(echo "$RESPONSE"|jq -r '.company.abuser_score')
ipapi[scorenum]=$(echo "${ipapi[scoretext]}"|awk '{print $1}')
ipapi[risktext]=$(echo "${ipapi[scoretext]}"|awk -F'[()]' '{print $2}')
ipapi[score]=$(awk "BEGIN {printf \"%.2f%%\", ${ipapi[scorenum]} * 100}")
case ${ipapi[risktext]} in
"Very Low")ipapi[risk]="${sscore[verylow]}"
;;
"Low")ipapi[risk]="${sscore[low]}"
;;
"Elevated")ipapi[risk]="${sscore[elevated]}"
;;
"High")ipapi[risk]="${sscore[high]}"
;;
"Very High")ipapi[risk]="${sscore[veryhigh]}"
esac
shopt -u nocasematch
ipapi[countrycode]=$(echo "$RESPONSE"|jq -r '.location.country_code')
ipapi[proxy]=$(echo "$RESPONSE"|jq -r '.is_proxy')
ipapi[tor]=$(echo "$RESPONSE"|jq -r '.is_tor')
ipapi[vpn]=$(echo "$RESPONSE"|jq -r '.is_vpn')
ipapi[server]=$(echo "$RESPONSE"|jq -r '.is_datacenter')
ipapi[abuser]=$(echo "$RESPONSE"|jq -r '.is_abuser')
ipapi[robot]=$(echo "$RESPONSE"|jq -r '.is_crawler')
}
db_abuseipdb(){
local temp_info="$Font_Cyan$Font_B${sinfo[database]}${Font_I}AbuseIPDB $Font_Suffix"
((ibar_step+=3))
show_progress_bar "$temp_info" $((40-10-${sinfo[ldatabase]}))&
bar_pid="$!"&&disown "$bar_pid"
trap "kill_progress_bar" RETURN
abuseipdb=()
local RESPONSE=$(curl $CurlARG -sL -$1 -m 10 "https://ipinfo.check.place/$IP?db=abuseipdb")
echo "$RESPONSE"|jq . >/dev/null 2>&1||RESPONSE=""
abuseipdb[usetype]=$(echo "$RESPONSE"|jq -r '.data.usageType')
shopt -s nocasematch
case ${abuseipdb[usetype]} in
"Commercial")abuseipdb[susetype]="${stype[business]}"
;;
"Data Center/Web Hosting/Transit")abuseipdb[susetype]="${stype[hosting]}"
;;
"University/College/School")abuseipdb[susetype]="${stype[education]}"
;;
"Government")abuseipdb[susetype]="${stype[government]}"
;;
"banking")abuseipdb[susetype]="${stype[banking]}"
;;
"Organization")abuseipdb[susetype]="${stype[organization]}"
;;
"Military")abuseipdb[susetype]="${stype[military]}"
;;
"Library")abuseipdb[susetype]="${stype[library]}"
;;
"Content Delivery Network")abuseipdb[susetype]="${stype[cdn]}"
;;
"Fixed Line ISP")abuseipdb[susetype]="${stype[lineisp]}"
;;
"Mobile ISP")abuseipdb[susetype]="${stype[mobile]}"
;;
"Search Engine Spider")abuseipdb[susetype]="${stype[spider]}"
;;
"Reserved")abuseipdb[susetype]="${stype[reserved]}"
;;
*)abuseipdb[susetype]="${stype[other]}"
esac
shopt -u nocasematch
abuseipdb[score]=$(echo "$RESPONSE"|jq -r '.data.abuseConfidenceScore')
if [[ ${abuseipdb[score]} -lt 25 ]];then
abuseipdb[risk]="${sscore[low]}"
elif [[ ${abuseipdb[score]} -lt 75 ]];then
abuseipdb[risk]="${sscore[high]}"
elif [[ ${abuseipdb[score]} -ge 75 ]];then
abuseipdb[risk]="${sscore[dos]}"
fi
}
db_ip2location(){
local temp_info="$Font_Cyan$Font_B${sinfo[database]}${Font_I}IP2LOCATION $Font_Suffix"
((ibar_step+=3))
show_progress_bar "$temp_info" $((40-12-${sinfo[ldatabase]}))&
bar_pid="$!"&&disown "$bar_pid"
trap "kill_progress_bar" RETURN
ip2location=()
local RESPONSE=$(curl $CurlARG -sL -$1 -m 10 "https://ipinfo.check.place/$IP?db=ip2location")
echo "$RESPONSE"|jq . >/dev/null 2>&1||RESPONSE=""
ip2location[usetype]=$(echo "$RESPONSE"|jq -r '.usage_type')
ip2location[comtype]=$(echo "$RESPONSE"|jq -r '.as_info.as_usage_type')
shopt -s nocasematch
local first_use="${ip2location[usetype]%%/*}"
case $first_use in
"COM")ip2location[susetype]="${stype[business]}"
;;
"DCH")ip2location[susetype]="${stype[hosting]}"
;;
"EDU")ip2location[susetype]="${stype[education]}"
;;
"GOV")ip2location[susetype]="${stype[government]}"
;;
"ORG")ip2location[susetype]="${stype[organization]}"
;;
"MIL")ip2location[susetype]="${stype[military]}"
;;
"LIB")ip2location[susetype]="${stype[library]}"
;;
"CDN")ip2location[susetype]="${stype[cdn]}"
;;
"ISP")ip2location[susetype]="${stype[lineisp]}"
;;
"MOB")ip2location[susetype]="${stype[mobile]}"
;;
"SES")ip2location[susetype]="${stype[spider]}"
;;
"RSV")ip2location[susetype]="${stype[reserved]}"
;;
*)ip2location[susetype]="${stype[other]}"
esac
first_use="${ip2location[comtype]%%/*}"
case $first_use in
"COM")ip2location[scomtype]="${stype[business]}"
;;
"DCH")ip2location[scomtype]="${stype[hosting]}"
;;
"EDU")ip2location[scomtype]="${stype[education]}"
;;
"GOV")ip2location[scomtype]="${stype[government]}"
;;
"ORG")ip2location[scomtype]="${stype[organization]}"
;;
"MIL")ip2location[scomtype]="${stype[military]}"
;;
"LIB")ip2location[scomtype]="${stype[library]}"
;;
"CDN")ip2location[scomtype]="${stype[cdn]}"
;;
"ISP")ip2location[scomtype]="${stype[lineisp]}"
;;
"MOB")ip2location[scomtype]="${stype[mobile]}"
;;
"SES")ip2location[scomtype]="${stype[spider]}"
;;
"RSV")ip2location[scomtype]="${stype[reserved]}"
;;
*)ip2location[scomtype]="${stype[other]}"
esac
shopt -u nocasematch
ip2location[countrycode]=$(echo "$RESPONSE"|jq -r '.country_code')
ip2location[proxy0]=$(echo "$RESPONSE"|jq -r '.is_proxy')
ip2location[proxy1]=$(echo "$RESPONSE"|jq -r '.proxy.is_public_proxy')
ip2location[proxy2]=$(echo "$RESPONSE"|jq -r '.proxy.is_web_proxy')
[[ ${ip2location[proxy0]} == "true" || ${ip2location[proxy1]} == "true" || ${ip2location[proxy2]} == "true" ]]&&ip2location[proxy]="true"
[[ ${ip2location[proxy0]} == "false" && ${ip2location[proxy1]} == "false" && ${ip2location[proxy2]} == "false" ]]&&ip2location[proxy]="false"
ip2location[tor]=$(echo "$RESPONSE"|jq -r '.proxy.is_tor')
ip2location[vpn]=$(echo "$RESPONSE"|jq -r '.proxy.is_vpn')
ip2location[server]=$(echo "$RESPONSE"|jq -r '.proxy.is_data_center')
ip2location[abuser]=$(echo "$RESPONSE"|jq -r '.proxy.is_spammer')
ip2location[robot1]=$(echo "$RESPONSE"|jq -r '.proxy.is_web_crawler')
ip2location[robot2]=$(echo "$RESPONSE"|jq -r '.proxy.is_scanner')
ip2location[robot3]=$(echo "$RESPONSE"|jq -r '.proxy.is_botnet')
[[ ${ip2location[robot1]} == "true" || ${ip2location[robot2]} == "true" || ${ip2location[robot3]} == "true" ]]&&ip2location[robot]="true"
[[ ${ip2location[robot1]} == "false" && ${ip2location[robot2]} == "false" && ${ip2location[robot3]} == "false" ]]&&ip2location[robot]="false"
ip2location[score]=$(echo "$RESPONSE"|jq -r '.fraud_score')
if [[ ${ip2location[score]} -lt 33 ]];then
ip2location[risk]="${sscore[low]}"
elif [[ ${ip2location[score]} -lt 66 ]];then
ip2location[risk]="${sscore[medium]}"
elif [[ ${ip2location[score]} -ge 66 ]];then
ip2location[risk]="${sscore[high]}"
fi
}
db_dbip(){
local temp_info="$Font_Cyan$Font_B${sinfo[database]}${Font_I}DB-IP $Font_Suffix"
((ibar_step+=3))
show_progress_bar "$temp_info" $((40-6-${sinfo[ldatabase]}))&
bar_pid="$!"&&disown "$bar_pid"
trap "kill_progress_bar" RETURN
dbip=()
local RESPONSE=$(curl $CurlARG -sL -m 10 "https://db-ip.com/$IP")
mapfile -t results < <(echo "$RESPONSE"|awk '/<th class='\''text-center'\''>Crawler/ {flag=1; next}
             flag && /<span class="sr-only">/ {
                 if ($0 ~ /Yes/) print "true";
                 else if ($0 ~ /No/) print "false";
             }
             /<\/tr>/ && flag {flag=0}')
dbip[robot]="${results[0]}"
dbip[proxy]="${results[1]}"
dbip[abuser]="${results[2]}"
dbip[risktext]=$(echo "$RESPONSE"|sed -n 's/.*Estimated threat level for this IP address is[[:space:]]*<span[^>]*>\([^<]*\)<.*/\1/p')
dbip[countrycode]=$(echo "$RESPONSE"|sed -n '/<code class="language-json">/,/<\/code>/p'|sed -n 's/.*"countryCode"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
shopt -s nocasematch
case ${dbip[risktext]} in
"low")dbip[risk]="${sscore[low]}"
dbip[score]=0
;;
"medium")dbip[risk]="${sscore[medium]}"
dbip[score]=50
;;
"high")dbip[risk]="${sscore[high]}"
dbip[score]=100
esac
shopt -u nocasematch
}
db_ipwhois(){
local temp_info="$Font_Cyan$Font_B${sinfo[database]}${Font_I}IPWHOIS $Font_Suffix"
((ibar_step+=3))
show_progress_bar "$temp_info" $((40-8-${sinfo[ldatabase]}))&
bar_pid="$!"&&disown "$bar_pid"
trap "kill_progress_bar" RETURN
ipwhois=()
local RESPONSE=$(curl $CurlARG -sL -m 10 "https://ipwhois.io/widget?ip=$IP&lang=en" --compressed \
-H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:123.0) Gecko/20100101 Firefox/123.0" \
-H "Accept: */*" \
-H "Accept-Language: zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2" \
-H "Connection: keep-alive" \
-H "Referer: https://ipwhois.io/" \
-H "Sec-Fetch-Dest: empty" \
-H "Sec-Fetch-Mode: cors" \
-H "Sec-Fetch-Site: same-origin" \
-H "TE: trailers")
echo "$RESPONSE"|jq . >/dev/null 2>&1||RESPONSE=""
ipwhois[countrycode]=$(echo "$RESPONSE"|jq -r '.country_code')
ipwhois[proxy]=$(echo "$RESPONSE"|jq -r '.security.proxy')
ipwhois[tor]=$(echo "$RESPONSE"|jq -r '.security.tor')
ipwhois[vpn]=$(echo "$RESPONSE"|jq -r '.security.vpn')
ipwhois[server]=$(echo "$RESPONSE"|jq -r '.security.hosting')
}
db_ipdata(){
local temp_info="$Font_Cyan$Font_B${sinfo[database]}${Font_I}ipdata $Font_Suffix"
((ibar_step+=3))
show_progress_bar "$temp_info" $((40-7-${sinfo[ldatabase]}))&
bar_pid="$!"&&disown "$bar_pid"
trap "kill_progress_bar" RETURN
ipdata=()
local RESPONSE=$(curl $CurlARG -sL -$1 -m 10 "https://ipinfo.check.place/$IP?db=ipdata")
echo "$RESPONSE"|jq . >/dev/null 2>&1||RESPONSE=""
ipdata[countrycode]=$(echo "$RESPONSE"|jq -r '.country_code')
ipdata[proxy]=$(echo "$RESPONSE"|jq -r '.threat.is_proxy')
ipdata[tor]=$(echo "$RESPONSE"|jq -r '.threat.is_tor')
ipdata[server]=$(echo "$RESPONSE"|jq -r '.threat.is_datacenter')
ipdata[abuser1]=$(echo "$RESPONSE"|jq -r '.threat.is_threat')
ipdata[abuser2]=$(echo "$RESPONSE"|jq -r '.threat.is_known_abuser')
ipdata[abuser3]=$(echo "$RESPONSE"|jq -r '.threat.is_known_attacker')
[[ ${ipdata[abuser1]} == "true" || ${ipdata[abuser2]} == "true" || ${ipdata[abuser3]} == "true" ]]&&ipdata[abuser]="true"
[[ ${ipdata[abuser1]} == "false" && ${ipdata[abuser2]} == "false" && ${ipdata[abuser3]} == "false" ]]&&ipdata[abuser]="false"
}
db_ipqs(){
local temp_info="$Font_Cyan$Font_B${sinfo[database]}${Font_I}IPQS $Font_Suffix"
((ibar_step+=3))
show_progress_bar "$temp_info" $((40-5-${sinfo[ldatabase]}))&
bar_pid="$!"&&disown "$bar_pid"
trap "kill_progress_bar" RETURN
ipqs=()
local RESPONSE=$(curl $CurlARG -sL -$1 -m 10 "https://ipinfo.check.place/$IP?db=ipqualityscore")
echo "$RESPONSE"|jq . >/dev/null 2>&1||RESPONSE=""
ipqs[score]=$(echo "$RESPONSE"|jq -r '.fraud_score')
if [[ ${ipqs[score]} -lt 75 ]];then
ipqs[risk]="${sscore[low]}"
elif [[ ${ipqs[score]} -lt 85 ]];then
ipqs[risk]="${sscore[suspicious]}"
elif [[ ${ipqs[score]} -lt 90 ]];then
ipqs[risk]="${sscore[risky]}"
elif [[ ${ipqs[score]} -ge 90 ]];then
ipqs[risk]="${sscore[highrisk]}"
fi
ipqs[countrycode]=$(echo "$RESPONSE"|jq -r '.country_code')
ipqs[proxy]=$(echo "$RESPONSE"|jq -r '.proxy')
ipqs[tor]=$(echo "$RESPONSE"|jq -r '.tor')
ipqs[vpn]=$(echo "$RESPONSE"|jq -r '.vpn')
ipqs[abuser]=$(echo "$RESPONSE"|jq -r '.recent_abuse')
ipqs[robot]=$(echo "$RESPONSE"|jq -r '.bot_status')
}
db_cloudflare(){
local temp_info="$Font_Cyan$Font_B${sinfo[database]}${Font_I}Cloudflare $Font_Suffix"
((ibar_step+=3))
show_progress_bar "$temp_info" $((40-11-${sinfo[ldatabase]}))&
bar_pid="$!"&&disown "$bar_pid"
trap "kill_progress_bar" RETURN
cloudflare=()
local RESPONSE=$(curl $CurlARG -sL -$1 -m 10 "https://ip.nodeget.com/json")
echo "$RESPONSE"|jq . >/dev/null 2>&1||RESPONSE=""
cloudflare[score]=$(echo "$RESPONSE"|jq -r '.ip.riskScore')
if [[ ${cloudflare[score]} -lt 10 ]];then
cloudflare[risk]="${sscore[low]}"
elif [[ ${cloudflare[score]} -lt 15 ]];then
cloudflare[risk]="${sscore[medium]}"
elif [[ ${cloudflare[score]} -lt 25 ]];then
cloudflare[risk]="${sscore[risky]}"
elif [[ ${cloudflare[score]} -ge 50 ]];then
cloudflare[risk]="${sscore[veryhigh]}"
fi
}
function check_ip_valide(){
local IPPattern='^(\<([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\>\.){3}\<([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\>$'
IP="$1"
if [[ $IP =~ $IPPattern ]];then
return 0
else
return 1
fi
}
function calc_ip_net(){
sip="$1"
snetmask="$2"
check_ip_valide "$sip"
if [ $? -ne 0 ];then
echo ""
return 1
fi
local ipFIELD1=$(echo "$sip"|cut -d. -f1)
local ipFIELD2=$(echo "$sip"|cut -d. -f2)
local ipFIELD3=$(echo "$sip"|cut -d. -f3)
local ipFIELD4=$(echo "$sip"|cut -d. -f4)
local netmaskFIELD1=$(echo "$snetmask"|cut -d. -f1)
local netmaskFIELD2=$(echo "$snetmask"|cut -d. -f2)
local netmaskFIELD3=$(echo "$snetmask"|cut -d. -f3)
local netmaskFIELD4=$(echo "$snetmask"|cut -d. -f4)
local tmpret1=$((ipFIELD1&netmaskFIELD1))
local tmpret2=$((ipFIELD2&netmaskFIELD2))
local tmpret3=$((ipFIELD3&netmaskFIELD3))
local tmpret4=$((ipFIELD4&netmaskFIELD4))
echo "$tmpret1.$tmpret2.$tmpret3.$tmpret4"
}
function Check_DNS_IP(){
if [ "$1" != "${1#*[0-9].[0-9]}" ];then
if [ "$(calc_ip_net "$1" 255.0.0.0)" == "10.0.0.0" ];then
echo 0
elif [ "$(calc_ip_net "$1" 255.240.0.0)" == "172.16.0.0" ];then
echo 0
elif [ "$(calc_ip_net "$1" 255.255.0.0)" == "169.254.0.0" ];then
echo 0
elif [ "$(calc_ip_net "$1" 255.255.0.0)" == "192.168.0.0" ];then
echo 0
elif [ "$(calc_ip_net "$1" 255.255.255.0)" == "$(calc_ip_net "$2" 255.255.255.0)" ];then
echo 0
else
echo 1
fi
elif [ "$1" != "${1#*[0-9a-fA-F]:*}" ];then
if [ "${1:0:3}" == "fe8" ];then
echo 0
elif [ "${1:0:3}" == "FE8" ];then
echo 0
elif [ "${1:0:2}" == "fc" ];then
echo 0
elif [ "${1:0:2}" == "FC" ];then
echo 0
elif [ "${1:0:2}" == "fd" ];then
echo 0
elif [ "${1:0:2}" == "FD" ];then
echo 0
elif [ "${1:0:2}" == "ff" ];then
echo 0
elif [ "${1:0:2}" == "FF" ];then
echo 0
else
echo 1
fi
else
echo 0
fi
}
function Check_DNS_1(){
local resultdns=$(nslookup $1)
local resultinlines=(${resultdns//$'\n'/ })
for i in ${resultinlines[*]};do
if [[ $i == "Name:" ]];then
local resultdnsindex=$((resultindex+3))
break
fi
local resultindex=$((resultindex+1))
done
echo $(Check_DNS_IP ${resultinlines[$resultdnsindex]} ${resultinlines[1]})
}
function Check_DNS_2(){
local resultdnstext=$(dig $1|grep "ANSWER:")
local resultdnstext=${resultdnstext#*"ANSWER: "}
local resultdnstext=${resultdnstext%", AUTHORITY:"*}
if [ "$resultdnstext" == "0" ]||[ "$resultdnstext" == "1" ]||[ "$resultdnstext" == "2" ];then
echo 0
else
echo 1
fi
}
function Check_DNS_3(){
local resultdnstext=$(dig "test$RANDOM$RANDOM.$1"|grep "ANSWER:")
echo "test$RANDOM$RANDOM.$1"
local resultdnstext=${resultdnstext#*"ANSWER: "}
local resultdnstext=${resultdnstext%", AUTHORITY:"*}
if [ "$resultdnstext" == "0" ];then
echo 1
else
echo 0
fi
}
function Get_Unlock_Type(){
while [ $# -ne 0 ];do
if [ "$1" = "0" ];then
echo "${smedia[dns]}"
return
fi
shift
done
echo "${smedia[native]}"
}
function MediaUnlockTest_TikTok(){
local temp_info="$Font_Cyan$Font_B${sinfo[media]}${Font_I}TikTok $Font_Suffix"
((ibar_step+=3))
show_progress_bar "$temp_info" $((40-7-${sinfo[lmedia]}))&
bar_pid="$!"&&disown "$bar_pid"
trap "kill_progress_bar" RETURN
tiktok=()
local checkunlockurl="tiktok.com"
local result1=$(Check_DNS_1 $checkunlockurl)
local result3=$(Check_DNS_3 $checkunlockurl)
local resultunlocktype=$(Get_Unlock_Type $result1 $result3)
local Ftmpresult=$(curl $CurlARG -$1 --user-agent "$UA_Browser" -sL -m 10 "https://www.tiktok.com/")
if [[ $Ftmpresult == "curl"* ]];then
tiktok[ustatus]="${smedia[no]}"
tiktok[uregion]="${smedia[nodata]}"
tiktok[utype]="${smedia[nodata]}"
return
fi
local FRegion=$(echo $Ftmpresult|grep '"region":'|sed 's/.*"region"//'|cut -f2 -d'"')
if [ -n "$FRegion" ];then
tiktok[ustatus]="${smedia[yes]}"
tiktok[uregion]="  [$FRegion]   "
tiktok[utype]="$resultunlocktype"
return
fi
local STmpresult=$(curl $CurlARG -$1 --user-agent "$UA_Browser" -sL -m 10 -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9" -H "Accept-Encoding: gzip" -H "Accept-Language: en" "https://www.tiktok.com"|gunzip 2>/dev/null)
local SRegion=$(echo $STmpresult|grep '"region":'|sed 's/.*"region"//'|cut -f2 -d'"')
if [ -n "$SRegion" ];then
tiktok[ustatus]="${smedia[idc]}"
tiktok[uregion]="  [$SRegion]   "
tiktok[utype]="$resultunlocktype"
return
else
tiktok[ustatus]="${smedia[bad]}"
tiktok[uregion]="${smedia[nodata]}"
tiktok[utype]="${smedia[nodata]}"
return
fi
}
function MediaUnlockTest_DisneyPlus(){
local temp_info="$Font_Cyan$Font_B${sinfo[media]}${Font_I}Disney+ $Font_Suffix"
((ibar_step+=3))
show_progress_bar "$temp_info" $((40-8-${sinfo[lmedia]}))&
bar_pid="$!"&&disown "$bar_pid"
trap "kill_progress_bar" RETURN
disney=()
local checkunlockurl="disneyplus.com"
local result1=$(Check_DNS_1 $checkunlockurl)
local result3=$(Check_DNS_3 $checkunlockurl)
local resultunlocktype=$(Get_Unlock_Type $result1 $result3)
local PreAssertion=$(curl $CurlARG -$1 --user-agent "$UA_Browser" -s --max-time 10 -X POST "https://disney.api.edge.bamgrid.com/devices" -H "authorization: Bearer ZGlzbmV5JmJyb3dzZXImMS4wLjA.Cu56AgSfBTDag5NiRA81oLHkDZfu5L3CKadnefEAY84" -H "content-type: application/json; charset=UTF-8" -d '{"deviceFamily":"browser","applicationRuntime":"chrome","deviceProfile":"windows","attributes":{}}' 2>&1)
if [[ $PreAssertion == "curl"* ]]&&[[ $1 == "6" ]];then
disney[ustatus]="${smedia[bad]}"
disney[uregion]="${smedia[nodata]}"
disney[utype]="${smedia[nodata]}"
return
elif [[ $PreAssertion == "curl"* ]];then
disney[ustatus]="${smedia[bad]}"
disney[uregion]="${smedia[nodata]}"
disney[utype]="${smedia[nodata]}"
return
fi
if ! (echo "$PreAssertion"|jq . >/dev/null 2>&1&&echo "$TokenContent"|jq . >/dev/null 2>&1);then
disney[ustatus]="${smedia[bad]}"
disney[uregion]="${smedia[nodata]}"
disney[utype]="${smedia[nodata]}"
return
fi
local assertion=$(echo $PreAssertion|jq -r '.assertion')
local PreDisneyCookie=$(echo "$Media_Cookie"|sed -n '1p')
local disneycookie=$(echo $PreDisneyCookie|sed "s/DISNEYASSERTION/$assertion/g")
local TokenContent=$(curl $CurlARG -$1 --user-agent "$UA_Browser" -s --max-time 10 -X POST "https://disney.api.edge.bamgrid.com/token" -H "authorization: Bearer ZGlzbmV5JmJyb3dzZXImMS4wLjA.Cu56AgSfBTDag5NiRA81oLHkDZfu5L3CKadnefEAY84" -d "$disneycookie" 2>&1)
local isBanned=$(echo $TokenContent|jq -r 'select(.error_description == "forbidden-location") | .error_description')
local is403=$(echo $TokenContent|grep '403 ERROR')
if [ -n "$isBanned" ]||[ -n "$is403" ];then
disney[ustatus]="${smedia[no]}"
disney[uregion]="${smedia[nodata]}"
disney[utype]="${smedia[nodata]}"
return
fi
local fakecontent=$(echo "$Media_Cookie"|sed -n '8p')
local refreshToken=$(echo $TokenContent|jq -r '.refresh_token')
local disneycontent=$(echo $fakecontent|sed "s/ILOVEDISNEY/$refreshToken/g")
local tmpresult=$(curl $CurlARG -$1 --user-agent "$UA_Browser" -X POST -sSL --max-time 10 "https://disney.api.edge.bamgrid.com/graph/v1/device/graphql" -H "authorization: ZGlzbmV5JmJyb3dzZXImMS4wLjA.Cu56AgSfBTDag5NiRA81oLHkDZfu5L3CKadnefEAY84" -d "$disneycontent" 2>&1)
if ! (echo "$tmpresult"|jq . >/dev/null 2>&1);then
disney[ustatus]="${smedia[bad]}"
disney[uregion]="${smedia[nodata]}"
disney[utype]="${smedia[nodata]}"
return
fi
local previewcheck=$(curl $CurlARG -$1 -s -o /dev/null -L --max-time 10 -w '%{url_effective}\n' "https://disneyplus.com"|grep preview)
local isUnavailable=$(echo $previewcheck|grep 'unavailable')
local region=$(echo $tmpresult|jq -r '.extensions.sdk.session.location.countryCode')
local inSupportedLocation=$(echo $tmpresult|jq -r '.extensions.sdk.session.inSupportedLocation')
if [[ $region == "JP" ]];then
disney[ustatus]="${smedia[yes]}"
disney[uregion]="  [JP]   "
disney[utype]="$resultunlocktype"
return
elif [ -n "$region" ]&&[[ $inSupportedLocation == "false" ]]&&[ -z "$isUnavailable" ];then
disney[ustatus]="${smedia[pending]}"
disney[uregion]="  [$region]   "
disney[utype]="$resultunlocktype"
return
elif [ -n "$region" ]&&[ -n "$isUnavailable" ];then
disney[ustatus]="${smedia[no]}"
disney[uregion]="${smedia[nodata]}"
disney[utype]="${smedia[nodata]}"
return
elif [ -n "$region" ]&&[[ $inSupportedLocation == "true" ]];then
disney[ustatus]="${smedia[yes]}"
disney[uregion]="  [$region]   "
disney[utype]="$resultunlocktype"
return
elif [ -z "$region" ];then
disney[ustatus]="${smedia[no]}"
disney[uregion]="${smedia[nodata]}"
disney[utype]="${smedia[nodata]}"
return
else
disney[ustatus]="${smedia[bad]}"
disney[uregion]="${smedia[nodata]}"
disney[utype]="${smedia[nodata]}"
return
fi
}
function MediaUnlockTest_Netflix(){
local temp_info="$Font_Cyan$Font_B${sinfo[media]}${Font_I}Netflix $Font_Suffix"
((ibar_step+=3))
show_progress_bar "$temp_info" $((40-8-${sinfo[lmedia]}))&
bar_pid="$!"&&disown "$bar_pid"
trap "kill_progress_bar" RETURN
netflix=()
local checkunlockurl="netflix.com"
local result1=$(Check_DNS_1 $checkunlockurl)
local result2=$(Check_DNS_2 $checkunlockurl)
local result3=$(Check_DNS_3 $checkunlockurl)
local resultunlocktype=$(Get_Unlock_Type $result1 $result2 $result3)
local result1=$(curl $CurlARG -$1 --user-agent "$UA_Browser" -fsL -X GET --max-time 10 --tlsv1.3 "https://www.netflix.com/title/81280792" 2>&1)
local result2=$(curl $CurlARG -$1 --user-agent "$UA_Browser" -fsL -X GET --max-time 10 --tlsv1.3 "https://www.netflix.com/title/70143836" 2>&1)
if [ -z "$result1" ]||[ -z "$result2" ];then
netflix[ustatus]="${smedia[bad]}"
netflix[uregion]="${smedia[nodata]}"
netflix[utype]="${smedia[nodata]}"
return
fi
local region=$(echo "$result1"|grep -o 'data-country="[A-Z]*"'|sed 's/.*="\([A-Z]*\)"/\1/'|head -n1)
[[ -n $region ]]&&region=$(echo "$result2"|grep -o 'data-country="[A-Z]*"'|sed 's/.*="\([A-Z]*\)"/\1/'|head -n1)
result1=$(echo $result1|grep 'Oh no!')
result2=$(echo $result1|grep 'Oh no!')
if [ -n "$result1" ]&&[ -n "$result2" ];then
netflix[ustatus]="${smedia[org]}"
netflix[uregion]="  [$region]   "
netflix[utype]="$resultunlocktype"
return
fi
if [ -z "$result1" ]||[ -z "$result2" ];then
netflix[ustatus]="${smedia[yes]}"
netflix[uregion]="  [$region]   "
netflix[utype]="$resultunlocktype"
return
fi
netflix[ustatus]="${smedia[no]}"
netflix[uregion]="${smedia[nodata]}"
netflix[utype]="${smedia[nodata]}"
}
function MediaUnlockTest_YouTube_Premium(){
local temp_info="$Font_Cyan$Font_B${sinfo[media]}${Font_I}Youtube $Font_Suffix"
((ibar_step+=3))
show_progress_bar "$temp_info" $((40-8-${sinfo[lmedia]}))&
bar_pid="$!"&&disown "$bar_pid"
trap "kill_progress_bar" RETURN
youtube=()
local checkunlockurl="www.youtube.com"
local result1=$(Check_DNS_1 $checkunlockurl)
local result3=$(Check_DNS_3 $checkunlockurl)
local resultunlocktype=$(Get_Unlock_Type $result1 $result3)
local tmpresult=$(curl $CurlARG -$1 --max-time 10 -sSL -H "Accept-Language: en" -b "YSC=BiCUU3-5Gdk; CONSENT=YES+cb.20220301-11-p0.en+FX+700; GPS=1; VISITOR_INFO1_LIVE=4VwPMkB7W5A; PREF=tz=Asia.Shanghai; _gcl_au=1.1.1809531354.1646633279" "https://www.youtube.com/premium" 2>&1)
if [[ $tmpresult == "curl"* ]];then
youtube[ustatus]="${smedia[bad]}"
youtube[uregion]="${smedia[nodata]}"
youtube[utype]="${smedia[nodata]}"
return
fi
local isCN=$(echo $tmpresult|grep 'www.google.cn')
if [ -n "$isCN" ];then
youtube[ustatus]="${smedia[cn]}"
youtube[uregion]="  $Font_Red[CN]$Font_Green   "
youtube[utype]="${smedia[nodata]}"
return
fi
local isNotAvailable=$(echo $tmpresult|grep 'Premium is not available in your country')
local region=$(echo $tmpresult|sed -n 's/.*"contentRegion":"\([^"]*\)".*/\1/p')
local isAvailable=$(echo $tmpresult|grep 'ad-free')
if [ -n "$isNotAvailable" ];then
youtube[ustatus]="${smedia[noprem]}"
youtube[uregion]="${smedia[nodata]}"
youtube[utype]="${smedia[nodata]}"
return
elif [ -n "$isAvailable" ]&&[ -n "$region" ];then
youtube[ustatus]="${smedia[yes]}"
youtube[uregion]="  [$region]   "
youtube[utype]="$resultunlocktype"
return
elif [ -z "$region" ]&&[ -n "$isAvailable" ];then
youtube[ustatus]="${smedia[yes]}"
youtube[uregion]="${smedia[nodata]}"
youtube[utype]="$resultunlocktype"
return
else
youtube[ustatus]="${smedia[bad]}"
youtube[uregion]="${smedia[nodata]}"
youtube[utype]="${smedia[nodata]}"
fi
}
function MediaUnlockTest_PrimeVideo_Region(){
local temp_info="$Font_Cyan$Font_B${sinfo[media]}${Font_I}Amazon $Font_Suffix"
((ibar_step+=3))
show_progress_bar "$temp_info" $((40-7-${sinfo[lmedia]}))&
bar_pid="$!"&&disown "$bar_pid"
trap "kill_progress_bar" RETURN
amazon=()
local checkunlockurl="www.primevideo.com"
local result1=$(Check_DNS_1 $checkunlockurl)
local result3=$(Check_DNS_3 $checkunlockurl)
local resultunlocktype=$(Get_Unlock_Type $result1 $result3)
local tmpresult=$(curl $CurlARG -$1 --user-agent "$UA_Browser" -sL --max-time 10 "https://www.primevideo.com" 2>&1)
if [[ $tmpresult == "curl"* ]];then
amazon[ustatus]="${smedia[bad]}"
amazon[uregion]="${smedia[nodata]}"
amazon[utype]="${smedia[nodata]}"
return
fi
local result=$(echo $tmpresult|grep '"currentTerritory":'|sed 's/.*currentTerritory//'|cut -f3 -d'"'|head -n 1)
if [ -n "$result" ];then
amazon[ustatus]="${smedia[yes]}"
amazon[uregion]="  [$result]   "
amazon[utype]="$resultunlocktype"
return
else
amazon[ustatus]="${smedia[no]}"
amazon[uregion]="${smedia[nodata]}"
amazon[utype]="${smedia[nodata]}"
return
fi
}
function MediaUnlockTest_Spotify(){
local temp_info="$Font_Cyan$Font_B${sinfo[media]}${Font_I}Spotify $Font_Suffix"
((ibar_step+=3))
show_progress_bar "$temp_info" $((40-8-${sinfo[lmedia]}))&
bar_pid="$!"&&disown "$bar_pid"
trap "kill_progress_bar" RETURN
spotify=()
local checkunlockurl="spclient.wg.spotify.com"
local result1=$(Check_DNS_1 $checkunlockurl)
local result3=$(Check_DNS_3 $checkunlockurl)
local resultunlocktype=$(Get_Unlock_Type $result1 $result3)
local tmpresult=$(curl $CurlARG -$1 --user-agent "$UA_Browser" -s --max-time 10 -X POST "https://spclient.wg.spotify.com/signup/public/v1/account" -d "birth_day=11&birth_month=11&birth_year=2000&collect_personal_info=undefined&creation_flow=&creation_point=https%3A%2F%2Fwww.spotify.com%2Fhk-en%2F&displayname=Gay%20Lord&gender=male&iagree=1&key=a1e486e2729f46d6bb368d6b2bcda326&platform=www&referrer=&send-email=0&thirdpartyemail=0&identifier_token=AgE6YTvEzkReHNfJpO114514" -H "Accept-Language: en" 2>&1)
if echo "$tmpresult"|jq . >/dev/null 2>&1;then
local region=$(echo $tmpresult|jq -r '.country')
local isLaunched=$(echo $tmpresult|jq -r '.is_country_launched')
local StatusCode=$(echo $tmpresult|jq -r '.status')
if [ "$tmpresult" = "000" ];then
spotify[ustatus]="${smedia[bad]}"
spotify[uregion]="${smedia[nodata]}"
spotify[utype]="${smedia[nodata]}"
return
elif [ "$StatusCode" = "320" ]||[ "$StatusCode" = "120" ];then
spotify[ustatus]="${smedia[no]}"
spotify[uregion]="${smedia[nodata]}"
spotify[utype]="${smedia[nodata]}"
return
elif [ "$StatusCode" = "311" ]&&[ "$isLaunched" = "true" ];then
spotify[ustatus]="${smedia[yes]}"
spotify[uregion]="  [$region]   "
spotify[utype]="$resultunlocktype"
return
else
spotify[ustatus]="${smedia[bad]}"
spotify[uregion]="${smedia[nodata]}"
spotify[utype]="${smedia[nodata]}"
return
fi
else
spotify[ustatus]="${smedia[bad]}"
spotify[uregion]="${smedia[nodata]}"
spotify[utype]="${smedia[nodata]}"
return
fi
}
function OpenAITest(){
local temp_info="$Font_Cyan$Font_B${sinfo[ai]}${Font_I}ChatGPT $Font_Suffix"
((ibar_step+=3))
show_progress_bar "$temp_info" $((40-8-${sinfo[lai]}))&
bar_pid="$!"&&disown "$bar_pid"
trap "kill_progress_bar" RETURN
chatgpt=()
local checkunlockurl="chat.openai.com"
local result1=$(Check_DNS_1 $checkunlockurl)
local result2=$(Check_DNS_2 $checkunlockurl)
local result3=$(Check_DNS_3 $checkunlockurl)
local checkunlockurl="ios.chat.openai.com"
local result4=$(Check_DNS_1 $checkunlockurl)
local result5=$(Check_DNS_2 $checkunlockurl)
local result6=$(Check_DNS_3 $checkunlockurl)
local checkunlockurl="api.openai.com"
local result7=$(Check_DNS_1 $checkunlockurl)
local result8=$(Check_DNS_3 $checkunlockurl)
local resultunlocktype=$(Get_Unlock_Type $result1 $result2 $result3 $result4 $result5 $result6 $result7 $result8)
local tmpresult1=$(curl $CurlARG -$1 -sS --max-time 10 'https://api.openai.com/compliance/cookie_requirements' -H 'authority: api.openai.com' -H 'accept: */*' -H 'accept-language: zh-CN,zh;q=0.9' -H 'authorization: Bearer null' -H 'content-type: application/json' -H 'origin: https://platform.openai.com' -H 'referer: https://platform.openai.com/' -H 'sec-ch-ua: "Microsoft Edge";v="119", "Chromium";v="119", "Not?A_Brand";v="24"' -H 'sec-ch-ua-mobile: ?0' -H 'sec-ch-ua-platform: "Windows"' -H 'sec-fetch-dest: empty' -H 'sec-fetch-mode: cors' -H 'sec-fetch-site: same-site' -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36 Edg/119.0.0.0' 2>&1)
local tmpresult2=$(curl $CurlARG -$1 -sS --max-time 10 'https://ios.chat.openai.com/' -H 'authority: ios.chat.openai.com' -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' -H 'accept-language: zh-CN,zh;q=0.9' -H 'sec-ch-ua: "Microsoft Edge";v="119", "Chromium";v="119", "Not?A_Brand";v="24"' -H 'sec-ch-ua-mobile: ?0' -H 'sec-ch-ua-platform: "Windows"' -H 'sec-fetch-dest: document' -H 'sec-fetch-mode: navigate' -H 'sec-fetch-site: none' -H 'sec-fetch-user: ?1' -H 'upgrade-insecure-requests: 1' -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36 Edg/119.0.0.0' 2>&1)
local result1=$(echo $tmpresult1|grep unsupported_country)
local result2=$(echo $tmpresult2|grep VPN)
local countryCode="$(curl $CurlARG --max-time 10 -sS https://chat.openai.com/cdn-cgi/trace 2>&1|grep "loc="|awk -F= '{print $2}')"
if [ -z "$result2" ]&&[ -z "$result1" ]&&[[ $tmpresult1 != "curl"* ]]&&[[ $tmpresult2 != "curl"* ]];then
chatgpt[ustatus]="${smedia[yes]}"
chatgpt[uregion]="  [$countryCode]   "
chatgpt[utype]="$resultunlocktype"
elif [ -n "$result2" ]&&[ -n "$result1" ];then
chatgpt[ustatus]="${smedia[no]}"
chatgpt[uregion]="${smedia[nodata]}"
chatgpt[utype]="${smedia[nodata]}"
elif [ -z "$result1" ]&&[ -n "$result2" ]&&[[ $tmpresult1 != "curl"* ]];then
chatgpt[ustatus]="${smedia[web]}"
chatgpt[uregion]="  [$countryCode]   "
chatgpt[utype]="$resultunlocktype"
elif [ -n "$result1" ]&&[ -z "$result2" ];then
chatgpt[ustatus]="${smedia[app]}"
chatgpt[uregion]="  [$countryCode]   "
chatgpt[utype]="$resultunlocktype"
elif [[ $tmpresult1 == "curl"* ]]&&[ -n "$result2" ];then
chatgpt[ustatus]="${smedia[no]}"
chatgpt[uregion]="${smedia[nodata]}"
chatgpt[utype]="${smedia[nodata]}"
elif [[ $1 -eq 6 ]]&&[ -z "$result2" ]&&[[ $tmpresult2 != "curl"* ]];then
chatgpt[ustatus]="${smedia[yes]}"
chatgpt[uregion]="  [$countryCode]   "
chatgpt[utype]="$resultunlocktype"
else
chatgpt[ustatus]="${smedia[bad]}"
chatgpt[uregion]="${smedia[nodata]}"
chatgpt[utype]="${smedia[nodata]}"
fi
}
get_sorted_mx_records(){
local domain=$1
dig +short MX $domain|sort -n|head -1|awk '{print $2}'
}
check_email_service(){
local service=$1
local port=25
local expected_response="220"
local domain=""
local host=""
local response=""
local success="false"
case $service in
"Gmail")domain="gmail.com";;
"Outlook")domain="outlook.com";;
"Yahoo")domain="yahoo.com";;
"Apple")domain="me.com";;
"MailRU")domain="mail.ru";;
"AOL")domain="aol.com";;
"GMX")domain="gmx.com";;
"MailCOM")domain="mail.com";;
"163")domain="163.com";;
"Sohu")domain="sohu.com";;
"Sina")domain="sina.com";;
"QQ")domain="qq.com";;
*)return
esac
if [[ -z $host ]];then
local mx_hosts=($(get_sorted_mx_records $domain))
for host in "${mx_hosts[@]}";do
response=$(timeout 5 bash -c "echo -e 'QUIT\r\n' | nc -s $IP -w4 $host $port 2>&1")
smail_response[$service]=$response
if [[ $response == *"$expected_response"* ]];then
success="true"
smail[$service]="$Font_Black+$Font_Suffix$Back_Green$Font_White$Font_B$service$Font_Suffix"
smailstatus[$service]="true"
smail[remote]=1
break
fi
done
else
response=$(timeout 5 bash -c "echo -e 'QUIT\r\n' | nc -s $IP -w4 $host $port 2>&1")
if [[ $response == *"$expected_response"* ]];then
success="true"
smail[$service]="$Font_Black+$Font_Suffix$Back_Green$Font_White$Font_B$service$Font_Suffix"
smailstatus[$service]="true"
smail[remote]=1
fi
fi
if [[ $success == "false" ]];then
smail[$service]="$Font_Black-$Font_Suffix$Back_Red$Font_White$Font_B$service$Font_Suffix"
smailstatus[$service]="false"
fi
}
check_mail(){
ss -tano|grep -q ":25\b"&&smail[local]=2||smail[local]=0
if [[ smail[local] -ne 2 && -z $usePROXY ]];then
local response=$(timeout 10 bash -c "echo -e 'QUIT\r\n' | nc -s $IP -p25 -w9 smtp.mailgun.org 25 2>&1")
[[ $response == *"220"* ]]&&smail[local]=1
fi
[[ -n $usePROXY ]]&&smail[local]=0
smail[remote]=0
services=("Gmail" "Outlook" "Yahoo" "Apple" "QQ" "MailRU" "AOL" "GMX" "MailCOM" "163" "Sohu" "Sina")
for service in "${services[@]}";do
local temp_info="$Font_Cyan$Font_B${sinfo[mail]}$Font_I$service$Font_Suffix "
((ibar_step+=3))
show_progress_bar "$temp_info" $((40-1-${#service}-${sinfo[lmail]}))&
bar_pid="$!"&&disown "$bar_pid"
check_email_service $service
kill_progress_bar
done
}
check_dnsbl_parallel(){
ip_to_check=$1
parallel_jobs=$2
smail[t]=0
smail[c]=0
smail[m]=0
smail[b]=0
reversed_ip=$(echo "$ip_to_check"|awk -F. '{print $4"."$3"."$2"."$1}')
local total=0
local clean=0
local blacklisted=0
local other=0
curl $CurlARG -sL "${rawgithub}main/ref/dnsbl.list"|sort -u|xargs -P "$parallel_jobs" -I {} bash -c "result=\$(dig +short \"$reversed_ip.{}\" A); if [[ -z \"\$result\" ]]; then echo 'Clean'; elif [[ \"\$result\" == '127.0.0.2' ]]; then echo 'Blacklisted'; else echo 'Other'; fi"|{
while IFS= read -r line;do
((total++))
case "$line" in
"Clean")((clean++));;
"Blacklisted")((blacklisted++));;
*)((other++))
esac
done
smail[t]="$total"
smail[c]="$clean"
smail[m]="$other"
smail[b]="$blacklisted"
echo "${smail[t]} ${smail[c]} ${smail[m]} ${smail[b]}"
}
}
check_dnsbl(){
local temp_info="$Font_Cyan$Font_B${sinfo[dnsbl]} $Font_Suffix"
((ibar_step=95))
show_progress_bar "$temp_info" $((40-1-${sinfo[ldnsbl]}))&
bar_pid="$!"&&disown "$bar_pid"
trap "kill_progress_bar" RETURN
local num_array=($(check_dnsbl_parallel "$IP" 50))
smail[t]=${num_array[0]:-0}
smail[c]=${num_array[1]:-0}
smail[m]=${num_array[2]:-0}
smail[b]=${num_array[3]:-0}
smail[sdnsbl]="$Font_Cyan${smail[dnsbl]}  ${smail[available]}${smail[t]}   ${smail[clean]}${smail[c]}   ${smail[marked]}${smail[m]}   ${smail[blacklisted]}${smail[b]}$Font_Suffix"
}
show_head(){
echo -ne "\r$(printf '%72s'|tr ' ' '#')\n"
if [[ $mode_lite -eq 0 ]];then
if [ $fullIP -eq 1 ];then
calc_padding "$(printf '%*s' "${shead[ltitle]}" '')$IP" 72
echo -ne "\r$PADDING$Font_B${shead[title]}$Font_Cyan$IP$Font_Suffix\n"
else
calc_padding "$(printf '%*s' "${shead[ltitle]}" '')$IPhide" 72
echo -ne "\r$PADDING$Font_B${shead[title]}$Font_Cyan$IPhide$Font_Suffix\n"
fi
else
if [ $fullIP -eq 1 ];then
calc_padding "$(printf '%*s' "${shead[ltitle_lite]}" '')$IP" 72
echo -ne "\r$PADDING$Font_B${shead[title_lite]}$Font_Cyan$IP$Font_Suffix\n"
else
calc_padding "$(printf '%*s' "${shead[ltitle_lite]}" '')$IPhide" 72
echo -ne "\r$PADDING$Font_B${shead[title_lite]}$Font_Cyan$IPhide$Font_Suffix\n"
fi
fi
calc_padding "${shead[git]}" 72
echo -ne "\r$PADDING$Font_U${shead[git]}$Font_Suffix\n"
calc_padding "${shead[bash]}" 72
echo -ne "\r$PADDING${shead[bash]}\n"
echo -ne "\r${shead[ptime]}${shead[time]}  ${shead[ver]}\n"
echo -ne "\r$(printf '%72s'|tr ' ' '#')\n"
}
show_basic(){
echo -ne "\r${sbasic[title]}\n"
if [[ -n ${maxmind[asn]} && ${maxmind[asn]} != "null" ]];then
echo -ne "\r$Font_Cyan${sbasic[asn]}${Font_Green}AS${maxmind[asn]}$Font_Suffix\n"
echo -ne "\r$Font_Cyan${sbasic[org]}$Font_Green${maxmind[org]}$Font_Suffix\n"
else
echo -ne "\r$Font_Cyan${sbasic[asn]}${sbasic[noasn]}$Font_Suffix\n"
fi
if [[ ${maxmind[dms]} != "null" && ${maxmind[map]} != "null" ]];then
echo -ne "\r$Font_Cyan${sbasic[location]}$Font_Green${maxmind[dms]}$Font_Suffix\n"
echo -ne "\r$Font_Cyan${sbasic[map]}$Font_U$Font_Green${maxmind[map]}$Font_Suffix\n"
fi
local city_info=""
if [[ -n ${maxmind[sub]} && ${maxmind[sub]} != "null" ]];then
city_info+="${maxmind[sub]}"
fi
if [[ -n ${maxmind[city]} && ${maxmind[city]} != "null" ]];then
[[ -n $city_info ]]&&city_info+=", "
city_info+="${maxmind[city]}"
fi
if [[ -n ${maxmind[post]} && ${maxmind[post]} != "null" ]];then
[[ -n $city_info ]]&&city_info+=", "
city_info+="${maxmind[post]}"
fi
if [[ -n $city_info ]];then
echo -ne "\r$Font_Cyan${sbasic[city]}$Font_Green$city_info$Font_Suffix\n"
fi
if [[ -n ${maxmind[countrycode]} && ${maxmind[countrycode]} != "null" ]];then
echo -ne "\r$Font_Cyan${sbasic[country]}$Font_Green[${maxmind[countrycode]}]${maxmind[country]}$Font_Suffix"
if [[ -n ${maxmind[continentcode]} && ${maxmind[continentcode]} != "null" ]];then
echo -ne "$Font_Green, [${maxmind[continentcode]}]${maxmind[continent]}$Font_Suffix\n"
else
echo -ne "\n"
fi
elif [[ -n ${maxmind[continentcode]} && ${maxmind[continentcode]} != "null" ]];then
echo -ne "\r$Font_Cyan${sbasic[continent]}$Font_Green[${maxmind[continentcode]}]${maxmind[continent]}$Font_Suffix\n"
fi
if [[ -n ${maxmind[regcountrycode]} && ${maxmind[regcountrycode]} != "null" ]];then
echo -ne "\r$Font_Cyan${sbasic[regcountry]}$Font_Green[${maxmind[regcountrycode]}]${maxmind[regcountry]}$Font_Suffix\n"
fi
if [[ -n ${maxmind[timezone]} && ${maxmind[timezone]} != "null" ]];then
echo -ne "\r$Font_Cyan${sbasic[timezone]}$Font_Green${maxmind[timezone]}$Font_Suffix\n"
fi
if [[ -n ${maxmind[countrycode]} && ${maxmind[countrycode]} != "null" ]];then
if [ "${maxmind[countrycode]}" == "${maxmind[regcountrycode]}" ];then
echo -ne "\r$Font_Cyan${sbasic[type]}$Back_Green$Font_B$Font_White${sbasic[type0]}$Font_Suffix\n"
else
echo -ne "\r$Font_Cyan${sbasic[type]}$Back_Red$Font_B$Font_White${sbasic[type1]}$Font_Suffix\n"
fi
fi
}
show_basic_lite(){
echo -ne "\r${sbasic[title_lite]}\n"
if [[ -n ${ipinfo[asn]} && ${ipinfo[asn]} != "null" ]];then
echo -ne "\r$Font_Cyan${sbasic[asn]}${Font_Green}AS${ipinfo[asn]}$Font_Suffix\n"
echo -ne "\r$Font_Cyan${sbasic[org]}$Font_Green${ipinfo[org]}$Font_Suffix\n"
else
echo -ne "\r$Font_Cyan${sbasic[asn]}${sbasic[noasn]}$Font_Suffix\n"
fi
if [[ ${ipinfo[dms]} != "null" && ${ipinfo[map]} != "null" ]];then
echo -ne "\r$Font_Cyan${sbasic[location]}$Font_Green${ipinfo[dms]}$Font_Suffix\n"
echo -ne "\r$Font_Cyan${sbasic[map]}$Font_U$Font_Green${ipinfo[map]}$Font_Suffix\n"
fi
local city_info=""
if [[ -n ${ipinfo[sub]} && ${ipinfo[sub]} != "null" ]];then
city_info+="${ipinfo[sub]}"
fi
if [[ -n ${ipinfo[city]} && ${ipinfo[city]} != "null" ]];then
[[ -n $city_info ]]&&city_info+=", "
city_info+="${ipinfo[city]}"
fi
if [[ -n ${ipinfo[post]} && ${ipinfo[post]} != "null" ]];then
[[ -n $city_info ]]&&city_info+=", "
city_info+="${ipinfo[post]}"
fi
if [[ -n $city_info ]];then
echo -ne "\r$Font_Cyan${sbasic[city]}$Font_Green$city_info$Font_Suffix\n"
fi
if [[ -n ${ipinfo[countrycode]} && ${ipinfo[countrycode]} != "null" ]];then
echo -ne "\r$Font_Cyan${sbasic[country]}$Font_Green[${ipinfo[countrycode]}]${ipinfo[country]}$Font_Suffix"
if [[ -n ${ipinfo[continent]} && ${ipinfo[continent]} != "null" ]];then
echo -ne "$Font_Green, ${ipinfo[continent]}$Font_Suffix\n"
else
echo -ne "\n"
fi
elif [[ -n ${ipinfo[continent]} && ${ipinfo[continent]} != "null" ]];then
echo -ne "\r$Font_Cyan${sbasic[continent]}$Font_Green${ipinfo[continent]}$Font_Suffix\n"
fi
if [[ -n ${ipinfo[regcountrycode]} && ${ipinfo[regcountrycode]} != "null" ]];then
echo -ne "\r$Font_Cyan${sbasic[regcountry]}$Font_Green[${ipinfo[regcountrycode]}]${ipinfo[regcountry]}$Font_Suffix\n"
fi
if [[ -n ${ipinfo[timezone]} && ${ipinfo[timezone]} != "null" ]];then
echo -ne "\r$Font_Cyan${sbasic[timezone]}$Font_Green${ipinfo[timezone]}$Font_Suffix\n"
fi
if [[ -n ${ipinfo[countrycode]} && ${ipinfo[countrycode]} != "null" ]];then
if [ "${ipinfo[countrycode]}" == "${ipinfo[regcountrycode]}" ];then
echo -ne "\r$Font_Cyan${sbasic[type]}$Back_Green$Font_B$Font_White${sbasic[type0]}$Font_Suffix\n"
else
echo -ne "\r$Font_Cyan${sbasic[type]}$Back_Red$Font_B$Font_White${sbasic[type1]}$Font_Suffix\n"
fi
fi
}
show_type(){
echo -ne "\r${stype[title]}\n"
echo -ne "\r$Font_Cyan${stype[db]}$Font_I   IPinfo    ipregistry    ipapi    IP2Location   AbuseIPDB $Font_Suffix\n"
echo -ne "\r$Font_Cyan${stype[usetype]}$Font_Suffix${ipinfo[susetype]}${ipregistry[susetype]}${ipapi[susetype]}${ip2location[susetype]}${abuseipdb[susetype]}\n"
echo -ne "\r$Font_Cyan${stype[comtype]}$Font_Suffix${ipinfo[scomtype]}${ipregistry[scomtype]}${ipapi[scomtype]}${ip2location[scomtype]}\n"
}
show_type_lite(){
echo -ne "\r${stype[title]}\n"
echo -ne "\r$Font_Cyan${stype[db]}$Font_I   IPinfo      ipapi $Font_Suffix\n"
echo -ne "\r$Font_Cyan${stype[usetype]}$Font_Suffix${ipinfo[susetype]}${ipapi[susetype]}\n"
echo -ne "\r$Font_Cyan${stype[comtype]}$Font_Suffix${ipinfo[scomtype]}${ipapi[scomtype]}\n"
}
sscore_text(){
local text="$1"
local p2=$2
local p3=$3
local p4=$4
local p5=$5
local p6=$6
local tmplen
local tmp
if ((p2>=p4));then
tmplen=$((49+15*(p2-p4)/(p5-p4)-p6))
elif ((p2>=p3));then
tmplen=$((33+16*(p2-p3)/(p4-p3)-p6))
elif ((p2>=0));then
tmplen=$((17+16*p2/p3-p6))
else
tmplen=0
fi
tmp=$(printf '%*s' $tmplen '')
local total_length=${#tmp}
local text_length=${#text}
local tmp1="${tmp:1:total_length-text_length}$text|"
sscore[text1]="${tmp1:1:16-p6}"
sscore[text2]="${tmp1:17-p6:16}"
sscore[text3]="${tmp1:33-p6:16}"
sscore[text4]="${tmp1:49-p6}"
}
show_score(){
echo -ne "\r${sscore[title]}\n"
echo -ne "\r${sscore[range]}\n"
if [[ -n ${ip2location[score]} && $mode_lite -eq 0 ]];then
sscore_text "${ip2location[score]}" ${ip2location[score]} 33 66 99 13
echo -ne "\r${Font_Cyan}IP2Location${sscore[colon]}$Font_White$Font_B${sscore[text1]}$Back_Green${sscore[text2]}$Back_Yellow${sscore[text3]}$Back_Red${sscore[text4]}$Font_Suffix${ip2location[risk]}\n"
fi
if [[ -n ${scamalytics[score]} ]];then
sscore_text "${scamalytics[score]}" ${scamalytics[score]} 25 50 100 13
echo -ne "\r${Font_Cyan}SCAMALYTICS${sscore[colon]}$Font_White$Font_B${sscore[text1]}$Back_Green${sscore[text2]}$Back_Yellow${sscore[text3]}$Back_Red${sscore[text4]}$Font_Suffix${scamalytics[risk]}\n"
fi
if [[ -n ${ipapi[score]} ]];then
local tmp_score=$(echo "${ipapi[scorenum]} * 10000 / 1"|bc)
sscore_text "${ipapi[score]}" $tmp_score 85 300 10000 7
echo -ne "\r${Font_Cyan}ipapi${sscore[colon]}$Font_White$Font_B${sscore[text1]}$Back_Green${sscore[text2]}$Back_Yellow${sscore[text3]}$Back_Red${sscore[text4]}$Font_Suffix${ipapi[risk]}\n"
fi
if [[ $mode_lite -eq 0 ]];then
sscore_text "${abuseipdb[score]}" ${abuseipdb[score]} 25 25 100 11
[[ -n ${abuseipdb[score]} ]]&&echo -ne "\r${Font_Cyan}AbuseIPDB${sscore[colon]}$Font_White$Font_B${sscore[text1]}$Back_Green${sscore[text2]}$Back_Yellow${sscore[text3]}$Back_Red${sscore[text4]}$Font_Suffix${abuseipdb[risk]}\n"
if [ -n "${ipqs[score]}" ]&&[ "${ipqs[score]}" != "null" ];then
sscore_text "${ipqs[score]}" ${ipqs[score]} 75 85 100 6
echo -ne "\r${Font_Cyan}IPQS${sscore[colon]}$Font_White$Font_B${sscore[text1]}$Back_Green${sscore[text2]}$Back_Yellow${sscore[text3]}$Back_Red${sscore[text4]}$Font_Suffix${ipqs[risk]}\n"
fi
fi
if [ -n "${cloudflare[score]}" ]&&[ "${cloudflare[score]}" != "null" ];then
sscore_text "${cloudflare[score]}" ${cloudflare[score]} 75 85 100 12
echo -ne "\r${Font_Cyan}Cloudflare${sscore[colon]}$Font_White$Font_B${sscore[text1]}$Back_Green${sscore[text2]}$Back_Yellow${sscore[text3]}$Back_Red${sscore[text4]}$Font_Suffix${cloudflare[risk]}\n"
fi
sscore_text " " ${dbip[score]} 33 66 100 7
[[ -n ${dbip[risk]} ]]&&echo -ne "\r${Font_Cyan}DB-IP${sscore[colon]}$Font_White$Font_B${sscore[text1]}$Back_Green${sscore[text2]}$Back_Yellow${sscore[text3]}$Back_Red${sscore[text4]}$Font_Suffix${dbip[risk]}\n"
}
format_factor(){
local tmp_txt="  "
if [[ $1 == "true" ]];then
tmp_txt+="${sfactor[yes]}"
elif [[ $1 == "false" ]];then
tmp_txt+="${sfactor[no]}"
elif [ ${#1} -eq 2 ];then
tmp_txt+="$Font_Green[$1]$Font_Suffix"
else
tmp_txt+="${sfactor[na]}"
fi
tmp_txt+="    "
if [[ $2 == "true" ]];then
tmp_txt+="${sfactor[yes]}"
elif [[ $2 == "false" ]];then
tmp_txt+="${sfactor[no]}"
elif [ ${#2} -eq 2 ];then
tmp_txt+="$Font_Green[$2]$Font_Suffix"
else
tmp_txt+="${sfactor[na]}"
fi
tmp_txt+="    "
if [[ $3 == "true" ]];then
tmp_txt+="${sfactor[yes]}"
elif [[ $3 == "false" ]];then
tmp_txt+="${sfactor[no]}"
elif [ ${#3} -eq 2 ];then
tmp_txt+="$Font_Green[$3]$Font_Suffix"
else
tmp_txt+="${sfactor[na]}"
fi
tmp_txt+="    "
if [[ $4 == "true" ]];then
tmp_txt+="${sfactor[yes]}"
elif [[ $4 == "false" ]];then
tmp_txt+="${sfactor[no]}"
elif [ ${#4} -eq 2 ];then
tmp_txt+="$Font_Green[$4]$Font_Suffix"
else
tmp_txt+="${sfactor[na]}"
fi
tmp_txt+="    "
if [[ $5 == "true" ]];then
tmp_txt+="${sfactor[yes]}"
elif [[ $5 == "false" ]];then
tmp_txt+="${sfactor[no]}"
elif [ ${#5} -eq 2 ];then
tmp_txt+="$Font_Green[$5]$Font_Suffix"
else
tmp_txt+="${sfactor[na]}"
fi
if [[ $mode_lite -eq 0 ]];then
tmp_txt+="    "
if [[ $6 == "true" ]];then
tmp_txt+="${sfactor[yes]}"
elif [[ $6 == "false" ]];then
tmp_txt+="${sfactor[no]}"
elif [ ${#6} -eq 2 ];then
tmp_txt+="$Font_Green[$6]$Font_Suffix"
else
tmp_txt+="${sfactor[na]}"
fi
tmp_txt+="    "
if [[ $7 == "true" ]];then
tmp_txt+="${sfactor[yes]}"
elif [[ $7 == "false" ]];then
tmp_txt+="${sfactor[no]}"
elif [ ${#7} -eq 2 ];then
tmp_txt+="$Font_Green[$7]$Font_Suffix"
else
tmp_txt+="${sfactor[na]}"
fi
tmp_txt+="    "
if [[ $8 == "true" ]];then
tmp_txt+="${sfactor[yes]}"
elif [[ $8 == "false" ]];then
tmp_txt+="${sfactor[no]}"
elif [ ${#8} -eq 2 ];then
tmp_txt+="$Font_Green[$8]$Font_Suffix"
else
tmp_txt+="${sfactor[na]}"
fi
fi
echo "$tmp_txt"
}
show_factor(){
local tmp_factor=""
echo -ne "\r${sfactor[title]}\n"
echo -ne "\r$Font_Cyan${sfactor[factor]}${Font_I}IP2Location ipapi ipregistry IPQS SCAMALYTICS ipdata IPinfo IPWHOIS$Font_Suffix\n"
tmp_factor=$(format_factor "${ip2location[countrycode]}" "${ipapi[countrycode]}" "${ipregistry[countrycode]}" "${ipqs[countrycode]}" "${scamalytics[countrycode]}" "${ipdata[countrycode]}" "${ipinfo[countrycode]}" "${ipwhois[countrycode]}")
echo -ne "\r$Font_Cyan${sfactor[countrycode]}$Font_Suffix$tmp_factor\n"
tmp_factor=$(format_factor "${ip2location[proxy]}" "${ipapi[proxy]}" "${ipregistry[proxy]}" "${ipqs[proxy]}" "${scamalytics[proxy]}" "${ipdata[proxy]}" "${ipinfo[proxy]}" "${ipwhois[proxy]}")
echo -ne "\r$Font_Cyan${sfactor[proxy]}$Font_Suffix$tmp_factor\n"
tmp_factor=$(format_factor "${ip2location[tor]}" "${ipapi[tor]}" "${ipregistry[tor]}" "${ipqs[tor]}" "${scamalytics[tor]}" "${ipdata[tor]}" "${ipinfo[tor]}" "${ipwhois[tor]}")
echo -ne "\r$Font_Cyan${sfactor[tor]}$Font_Suffix$tmp_factor\n"
tmp_factor=$(format_factor "${ip2location[vpn]}" "${ipapi[vpn]}" "${ipregistry[vpn]}" "${ipqs[vpn]}" "${scamalytics[vpn]}" "${ipdata[vpn]}" "${ipinfo[vpn]}" "${ipwhois[vpn]}")
echo -ne "\r$Font_Cyan${sfactor[vpn]}$Font_Suffix$tmp_factor\n"
tmp_factor=$(format_factor "${ip2location[server]}" "${ipapi[server]}" "${ipregistry[server]}" "${ipqs[server]}" "${scamalytics[server]}" "${ipdata[server]}" "${ipinfo[server]}" "${ipwhois[server]}")
echo -ne "\r$Font_Cyan${sfactor[server]}$Font_Suffix$tmp_factor\n"
tmp_factor=$(format_factor "${ip2location[abuser]}" "${ipapi[abuser]}" "${ipregistry[abuser]}" "${ipqs[abuser]}" "${scamalytics[abuser]}" "${ipdata[abuser]}" "${ipinfo[abuser]}" "${ipwhois[abuser]}")
echo -ne "\r$Font_Cyan${sfactor[abuser]}$Font_Suffix$tmp_factor\n"
tmp_factor=$(format_factor "${ip2location[robot]}" "${ipapi[robot]}" "${ipregistry[robot]}" "${ipqs[robot]}" "${scamalytics[robot]}" "${ipdata[robot]}" "${ipinfo[robot]}" "${ipwhois[robot]}")
echo -ne "\r$Font_Cyan${sfactor[robot]}$Font_Suffix$tmp_factor\n"
}
show_factor_lite(){
local tmp_factor=""
echo -ne "\r${sfactor[title]}\n"
echo -ne "\r$Font_Cyan${sfactor[factor]}$Font_I    ipapi SCAMALYTICS IPinfo IPWHOIS DB-IP$Font_Suffix\n"
tmp_factor=$(format_factor "${ipapi[countrycode]}" "${scamalytics[countrycode]}" "${ipinfo[countrycode]}" "${ipwhois[countrycode]}" "${dbip[countrycode]}")
echo -ne "\r$Font_Cyan${sfactor[countrycode]}$Font_Suffix$tmp_factor\n"
tmp_factor=$(format_factor "${ipapi[proxy]}" "${scamalytics[proxy]}" "${ipinfo[proxy]}" "${ipwhois[proxy]}" "${dbip[proxy]}")
echo -ne "\r$Font_Cyan${sfactor[proxy]}$Font_Suffix$tmp_factor\n"
tmp_factor=$(format_factor "${ipapi[tor]}" "${scamalytics[tor]}" "${ipinfo[tor]}" "${ipwhois[tor]}" "${dbip[tor]}")
echo -ne "\r$Font_Cyan${sfactor[tor]}$Font_Suffix$tmp_factor\n"
tmp_factor=$(format_factor "${ipapi[vpn]}" "${scamalytics[vpn]}" "${ipinfo[vpn]}" "${ipwhois[vpn]}" "${dbip[vpn]}")
echo -ne "\r$Font_Cyan${sfactor[vpn]}$Font_Suffix$tmp_factor\n"
tmp_factor=$(format_factor "${ipapi[server]}" "${scamalytics[server]}" "${ipinfo[server]}" "${ipwhois[server]}" "${dbip[server]}")
echo -ne "\r$Font_Cyan${sfactor[server]}$Font_Suffix$tmp_factor\n"
tmp_factor=$(format_factor "${ipapi[abuser]}" "${scamalytics[abuser]}" "${ipinfo[abuser]}" "${ipwhois[abuser]}" "${dbip[abuser]}")
echo -ne "\r$Font_Cyan${sfactor[abuser]}$Font_Suffix$tmp_factor\n"
tmp_factor=$(format_factor "${ipapi[robot]}" "${scamalytics[robot]}" "${ipinfo[robot]}" "${ipwhois[robot]}" "${dbip[robot]}")
echo -ne "\r$Font_Cyan${sfactor[robot]}$Font_Suffix$tmp_factor\n"
}
show_media(){
echo -ne "\r${smedia[title]}\n"
echo -ne "\r$Font_Cyan${smedia[meida]}$Font_I TikTok   Disney+  Netflix Youtube  AmazonPV  Spotify  ChatGPT $Font_Suffix\n"
echo -ne "\r$Font_Cyan${smedia[status]}${tiktok[ustatus]}${disney[ustatus]}${netflix[ustatus]}${youtube[ustatus]}${amazon[ustatus]}${spotify[ustatus]}${chatgpt[ustatus]}$Font_Suffix\n"
echo -ne "\r$Font_Cyan${smedia[region]}$Font_Green${tiktok[uregion]}${disney[uregion]}${netflix[uregion]}${youtube[uregion]}${amazon[uregion]}${spotify[uregion]}${chatgpt[uregion]}$Font_Suffix\n"
echo -ne "\r$Font_Cyan${smedia[type]}${tiktok[utype]}${disney[utype]}${netflix[utype]}${youtube[utype]}${amazon[utype]}${spotify[utype]}${chatgpt[utype]}$Font_Suffix\n"
}
show_mail(){
echo -ne "\r${smail[title]}\n"
if [ ${smail[local]} -eq 1 ];then
echo -ne "\r$Font_Cyan${smail[port]}$Font_Suffix${smail[yes]}\n"
elif [ ${smail[local]} -eq 2 ];then
echo -ne "\r$Font_Cyan${smail[port]}$Font_Suffix${smail[occupied]}\n"
else
echo -ne "\r$Font_Cyan${smail[port]}$Font_Suffix${smail[no]}\n"
fi
if [ ${smail[remote]} -eq 1 ];then
echo -ne "\r$Font_Cyan${smail[provider]}$Font_Suffix"
for service in "${services[@]}";do
echo -ne "${smail[$service]}"
done
echo ""
else
echo -ne "\r$Font_Cyan${smail[provider]}${smail[blocked]}$Font_Suffix\n"
fi
[[ $1 -eq 4 ]]&&echo -ne "\r${smail[sdnsbl]}\n"
}
show_tail(){
echo -ne "\r$(printf '%72s'|tr ' ' '=')\n"
echo -ne "\r$Font_I${stail[stoday]}${stail[today]}${stail[stotal]}${stail[total]}${stail[thanks]} $Font_Suffix\n"
echo -e ""
}
get_opts(){
while getopts "i:l:o:x:fhjnpyEM46" opt;do
case $opt in
4)if
[[ IPV4check -ne 0 ]]
then
IPV6check=0
else
ERRORcode=4
fi
;;
6)if
[[ IPV6check -ne 0 ]]
then
IPV4check=0
else
ERRORcode=6
fi
;;
f)fullIP=1
;;
h)show_help
;;
i)iface="$OPTARG"
useNIC=" --interface $iface"
CurlARG+="$useNIC"
get_ipv4
get_ipv6
is_valid_ipv4 $IPV4
is_valid_ipv6 $IPV6
[[ $IPV4work -eq 0 && $IPV6work -eq 0 ]]&&ERRORcode=7
;;
j)mode_json=1
;;
l)YY=$(echo "$OPTARG"|tr '[:upper:]' '[:lower:]')
;;
n)mode_no=1
;;
o)mode_output=1
outputfile="$OPTARG"
[[ -z $outputfile ]]&&{
ERRORcode=1
break
}
[[ -e $outputfile ]]&&{
ERRORcode=10
break
}
touch "$outputfile" 2>/dev/null||{
ERRORcode=11
break
}
;;
p)mode_privacy=1
;;
x)xproxy="$OPTARG"
usePROXY=" -x $xproxy"
CurlARG+="$usePROXY"
get_ipv4
get_ipv6
is_valid_ipv4 $IPV4
is_valid_ipv6 $IPV6
[[ $IPV4work -eq 0 && $IPV6work -eq 0 ]]&&ERRORcode=8
;;
y)mode_yes=1
;;
E)YY="en"
;;
M)mode_menu=1
;;
\?)ERRORcode=1
esac
done
if [[ $mode_menu -eq 1 ]];then
if [[ $YY == "cn" ]];then
eval "bash <(curl -sL https://Check.Place) -I"
else
eval "bash <(curl -sL https://Check.Place) -EI"
fi
exit 0
fi
[[ $IPV4check -eq 1 && $IPV6check -eq 0 && $IPV4work -eq 0 ]]&&ERRORcode=40
[[ $IPV4check -eq 0 && $IPV6check -eq 1 && $IPV6work -eq 0 ]]&&ERRORcode=60
CurlARG="$useNIC$usePROXY"
}
show_help(){
echo -ne "\r$shelp\n"
exit 0
}
show_ad(){
RANDOM=$(date +%s)
local -a ads=()
local i=1
while :;do
local content
content=$(curl -fsL --max-time 5 "${rawgithub}main/ref/ad$i.ans")||break
ads+=("$content")
((i++))
done
local adCount=${#ads[@]}
local -a indices=()
for ((i=1; i<=adCount; i++));do indices+=("$i");done
for ((i=adCount-1; i>0; i--));do
local j=$((RANDOM%(i+1)))
local tmp=${indices[i]}
indices[i]=${indices[j]}
indices[j]=$tmp
done
local -a aad
aad[0]=$(curl -sL --max-time 5 "${rawgithub}main/ref/sponsor.ans")
for ((i=0; i<adCount; i++));do
aad[${indices[i]}]="${ads[i]}"
done
local rows cols
if ! read rows cols < <(stty size 2>/dev/null);then cols=0;fi
ADLines=0
print_pair(){
local left="$1" right="$2"
local -a L R
mapfile -t L <<<"$left"
mapfile -t R <<<"$right"
local i
for ((i=0; i<12; i++));do
printf "%-72s$Font_Suffix     %-72s\n" "${L[i]}" "${R[i]}" 1>&2
done
ADLines=$((ADLines+12))
}
print_block(){
echo "$1" 1>&2
ADLines=$((ADLines+12))
}
if [[ $cols -ge 150 ]];then
if ((adCount==0));then
print_block "${aad[0]}"
elif ((adCount%2==1));then
print_pair "${aad[0]}" "${aad[1]}"
local k
for ((k=2; k<=adCount; k+=2));do
print_pair "${aad[$k]}" "${aad[$((k+1))]}"
done
else
print_block "${aad[0]}"
local k
for ((k=1; k<=adCount; k+=2));do
print_pair "${aad[$k]}" "${aad[$((k+1))]}"
done
fi
else
echo "${aad[0]}" 1>&2
for ((i=1; i<=adCount; i++));do
echo "${aad[$i]}" 1>&2
done
ADLines=$(((adCount+1)*12))
fi
}
read_ref(){
Media_Cookie=$(curl $CurlARG -sL --retry 3 --max-time 10 "${rawgithub}main/ref/cookies.txt")
IATA_Database="${rawgithub}main/ref/iata-icao.csv"
}
clean_ansi(){
local input="$1"
input=$(echo "$input"|sed 's/\\033/\x1b/g')
input=$(echo "$input"|sed 's/\x1b\[[0-9;]*m//g')
input=$(echo "$input"|sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
echo -n "$input"
}
factor_bool(){
local tmp_txt=""
if [[ $1 == "true" ]];then
tmp_txt+=".Factor |= map(. * { $3: { $2: true } }) | "
elif [[ $1 == "false" ]];then
tmp_txt+=".Factor |= map(. * { $3: { $2: false } }) | "
elif [ ${#1} -eq 2 ];then
tmp_txt+=".Factor |= map(. * { $3: { $2: \"$1\" } }) | "
else
tmp_txt+=".Factor |= map(. * { $3: { $2: null } }) | "
fi
[[ -z $tmp_txt ]]&&tmp_txt="null"
echo "$tmp_txt"
}
save_json(){
local head_updates=""
local basic_updates=""
local type_updates=""
local score_updates=""
local factor_updates=""
local media_updates=""
local mail_updates=""
if [ $fullIP -eq 1 ];then
head_updates+=".Head |= map(. + { IP: \"${IP:-null}\" }) | "
else
head_updates+=".Head |= map(. + { IP: \"${IPhide:-null}\" }) | "
fi
head_updates+=".Head |= map(. + { Command: \"${shead[bash]:-null}\" }) | "
head_updates+=".Head |= map(. + { GitHub: \"${shead[git]:-null}\" }) | "
head_updates+=".Head |= map(. + { Time: \"${shead[time]:-null}\" }) | "
head_updates+=".Head |= map(. + { Version: \"${shead[ver]:-null}\" }) | "
if [ $mode_lite -eq 0 ];then
basic_updates+=".Info |= map(. + { ASN: \"${maxmind[asn]:-null}\" }) | "
basic_updates+=".Info |= map(. + { Organization: \"${maxmind[org]:-null}\" }) | "
basic_updates+=".Info |= map(. + { Latitude: \"${maxmind[lat]:-null}\" }) | "
basic_updates+=".Info |= map(. + { Longitude: \"${maxmind[lon]:-null}\" }) | "
basic_updates+=".Info |= map(. + { DMS: \"${maxmind[dms]:-null}\" }) | "
basic_updates+=".Info |= map(. + { Map: \"${maxmind[map]:-null}\" }) | "
basic_updates+=".Info |= map(. + { TimeZone: \"${maxmind[timezone]:-null}\" }) | "
basic_updates+=".Info |= map(. * { City: { Name: \"${maxmind[city]:-null}\" } }) | "
basic_updates+=".Info |= map(. * { City: { PostalCode: \"${maxmind[post]:-null}\" } }) | "
basic_updates+=".Info |= map(. * { City: { SubCode: \"${maxmind[subcode]:-null}\" } }) | "
basic_updates+=".Info |= map(. * { City: { Subdivisions: \"${maxmind[sub]:-null}\" } }) | "
basic_updates+=".Info |= map(. * { Region: { Code: \"${maxmind[countrycode]:-null}\" } }) | "
basic_updates+=".Info |= map(. * { Region: { Name: \"${maxmind[country]:-null}\" } }) | "
basic_updates+=".Info |= map(. * { Continent: { Code: \"${maxmind[continentcode]:-null}\" } }) | "
basic_updates+=".Info |= map(. * { Continent: { Name: \"${maxmind[continent]:-null}\" } }) | "
basic_updates+=".Info |= map(. * { RegisteredRegion: { Code: \"${maxmind[regcountrycode]:-null}\" } }) | "
basic_updates+=".Info |= map(. * { RegisteredRegion: { Name: \"${maxmind[regcountry]:-null}\" } }) | "
if [[ -n ${maxmind[countrycode]} && ${maxmind[countrycode]} != "null" ]];then
if [ "${maxmind[countrycode]}" == "${maxmind[regcountrycode]}" ];then
basic_updates+=".Info |= map(. + { Type: \"$(clean_ansi "${sbasic[type0]:-null}")\" }) | "
else
basic_updates+=".Info |= map(. + { Type: \"$(clean_ansi "${sbasic[type1]:-null}")\" }) | "
fi
else
basic_updates+='.Info |= map(. + { Type: "null" }) | '
fi
else
basic_updates+=".Info |= map(. + { ASN: \"${ipinfo[asn]:-null}\" }) | "
basic_updates+=".Info |= map(. + { Organization: \"${ipinfo[org]:-null}\" }) | "
basic_updates+=".Info |= map(. + { Latitude: \"${ipinfo[lat]:-null}\" }) | "
basic_updates+=".Info |= map(. + { Longitude: \"${ipinfo[lon]:-null}\" }) | "
basic_updates+=".Info |= map(. + { DMS: \"${ipinfo[dms]:-null}\" }) | "
basic_updates+=".Info |= map(. + { Map: \"${ipinfo[map]:-null}\" }) | "
basic_updates+=".Info |= map(. + { TimeZone: \"${ipinfo[timezone]:-null}\" }) | "
basic_updates+=".Info |= map(. * { City: { Name: \"${ipinfo[city]:-null}\" } }) | "
basic_updates+=".Info |= map(. * { City: { PostalCode: \"${ipinfo[post]:-null}\" } }) | "
basic_updates+='.Info |= map(. * { City: { SubCode: "null" } }) | '
basic_updates+='.Info |= map(. * { City: { Subdivisions: "null" } }) | '
basic_updates+=".Info |= map(. * { Region: { Code: \"${ipinfo[countrycode]:-null}\" } }) | "
basic_updates+=".Info |= map(. * { Region: { Name: \"${ipinfo[country]:-null}\" } }) | "
basic_updates+='.Info |= map(. * { Continent: { Code: "null" } }) | '
basic_updates+=".Info |= map(. * { Continent: { Name: \"${ipinfo[continent]:-null}\" } }) | "
basic_updates+=".Info |= map(. * { RegisteredRegion: { Code: \"${ipinfo[regcountrycode]:-null}\" } }) | "
basic_updates+=".Info |= map(. * { RegisteredRegion: { Name: \"${ipinfo[regcountry]:-null}\" } }) | "
if [[ -n ${ipinfo[countrycode]} && ${ipinfo[countrycode]} != "null" ]];then
if [ "${ipinfo[countrycode]}" == "${ipinfo[regcountrycode]}" ];then
basic_updates+=".Info |= map(. + { Type: \"$(clean_ansi "${sbasic[type0]:-null}")\" }) | "
else
basic_updates+=".Info |= map(. + { Type: \"$(clean_ansi "${sbasic[type1]:-null}")\" }) | "
fi
else
basic_updates+='.Info |= map(. + { Type: "null" }) | '
fi
fi
type_updates+=".Type |= map(. * { Usage: { IPinfo: \"$(clean_ansi "${ipinfo[susetype]:-null}")\" } }) | "
type_updates+=".Type |= map(. * { Usage: { ipregistry: \"$(clean_ansi "${ipregistry[susetype]:-null}")\" } }) | "
type_updates+=".Type |= map(. * { Usage: { ipapi: \"$(clean_ansi "${ipapi[susetype]:-null}")\" } }) | "
type_updates+=".Type |= map(. * { Usage: { AbuseIPDB: \"$(clean_ansi "${abuseipdb[susetype]:-null}")\" } }) | "
type_updates+=".Type |= map(. * { Usage: { IP2LOCATION: \"$(clean_ansi "${ip2location[susetype]:-null}")\" } }) | "
type_updates+=".Type |= map(. * { Company: { IPinfo: \"$(clean_ansi "${ipinfo[scomtype]:-null}")\" } }) | "
type_updates+=".Type |= map(. * { Company: { ipregistry: \"$(clean_ansi "${ipregistry[scomtype]:-null}")\" } }) | "
type_updates+=".Type |= map(. * { Company: { ipapi: \"$(clean_ansi "${ipapi[scomtype]:-null}")\" } }) | "
score_updates+=".Score |= map(. + { IP2LOCATION: \"${ip2location[score]:-null}\" }) | "
score_updates+=".Score |= map(. + { SCAMALYTICS: \"${scamalytics[score]:-null}\" }) | "
score_updates+=".Score |= map(. + { ipapi: \"${ipapi[score]:-null}\" }) | "
score_updates+=".Score |= map(. + { AbuseIPDB: \"${abuseipdb[score]:-null}\" }) | "
score_updates+=".Score |= map(. + { IPQS: \"${ipapi[ipqs]:-null}\" }) | "
score_updates+=".Score |= map(. + { Cloudflare: \"${cloudflare[score]:-null}\" }) | "
score_updates+=".Score |= map(. + { DBIP: \"${dbip[score]:-null}\" }) | "
factor_updates+=$(factor_bool "${ip2location[countrycode]}" "IP2LOCATION" "CountryCode")
factor_updates+=$(factor_bool "${ipapi[countrycode]}" "ipapi" "CountryCode")
factor_updates+=$(factor_bool "${ipregistry[countrycode]}" "ipregistry" "CountryCode")
factor_updates+=$(factor_bool "${ipqs[countrycode]}" "IPQS" "CountryCode")
factor_updates+=$(factor_bool "${scamalytics[countrycode]}" "SCAMALYTICS" "CountryCode")
factor_updates+=$(factor_bool "${ipdata[countrycode]}" "ipdata" "CountryCode")
factor_updates+=$(factor_bool "${ipinfo[countrycode]}" "IPinfo" "CountryCode")
factor_updates+=$(factor_bool "${ipwhois[countrycode]}" "IPWHOIS" "CountryCode")
factor_updates+=$(factor_bool "${dbip[countrycode]}" "DBIP" "CountryCode")
factor_updates+=$(factor_bool "${ip2location[proxy]}" "IP2LOCATION" "Proxy")
factor_updates+=$(factor_bool "${ipapi[proxy]}" "ipapi" "Proxy")
factor_updates+=$(factor_bool "${ipregistry[proxy]}" "ipregistry" "Proxy")
factor_updates+=$(factor_bool "${ipqs[proxy]}" "IPQS" "Proxy")
factor_updates+=$(factor_bool "${scamalytics[proxy]}" "SCAMALYTICS" "Proxy")
factor_updates+=$(factor_bool "${ipdata[proxy]}" "ipdata" "Proxy")
factor_updates+=$(factor_bool "${ipinfo[proxy]}" "IPinfo" "Proxy")
factor_updates+=$(factor_bool "${ipwhois[proxy]}" "IPWHOIS" "Proxy")
factor_updates+=$(factor_bool "${dbip[proxy]}" "DBIP" "Proxy")
factor_updates+=$(factor_bool "${ip2location[tor]}" "IP2LOCATION" "Tor")
factor_updates+=$(factor_bool "${ipapi[tor]}" "ipapi" "Tor")
factor_updates+=$(factor_bool "${ipregistry[tor]}" "ipregistry" "Tor")
factor_updates+=$(factor_bool "${ipqs[tor]}" "IPQS" "Tor")
factor_updates+=$(factor_bool "${scamalytics[tor]}" "SCAMALYTICS" "Tor")
factor_updates+=$(factor_bool "${ipdata[tor]}" "ipdata" "Tor")
factor_updates+=$(factor_bool "${ipinfo[tor]}" "IPinfo" "Tor")
factor_updates+=$(factor_bool "${ipwhois[tor]}" "IPWHOIS" "Tor")
factor_updates+=$(factor_bool "${dbip[tor]}" "DBIP" "Tor")
factor_updates+=$(factor_bool "${ip2location[vpn]}" "IP2LOCATION" "VPN")
factor_updates+=$(factor_bool "${ipapi[vpn]}" "ipapi" "VPN")
factor_updates+=$(factor_bool "${ipregistry[vpn]}" "ipregistry" "VPN")
factor_updates+=$(factor_bool "${ipqs[vpn]}" "IPQS" "VPN")
factor_updates+=$(factor_bool "${scamalytics[vpn]}" "SCAMALYTICS" "VPN")
factor_updates+=$(factor_bool "${ipdata[vpn]}" "ipdata" "VPN")
factor_updates+=$(factor_bool "${ipinfo[vpn]}" "IPinfo" "VPN")
factor_updates+=$(factor_bool "${ipwhois[vpn]}" "IPWHOIS" "VPN")
factor_updates+=$(factor_bool "${dbip[vpn]}" "DBIP" "VPN")
factor_updates+=$(factor_bool "${ip2location[server]}" "IP2LOCATION" "Server")
factor_updates+=$(factor_bool "${ipapi[server]}" "ipapi" "Server")
factor_updates+=$(factor_bool "${ipregistry[server]}" "ipregistry" "Server")
factor_updates+=$(factor_bool "${ipqs[server]}" "IPQS" "Server")
factor_updates+=$(factor_bool "${scamalytics[server]}" "SCAMALYTICS" "Server")
factor_updates+=$(factor_bool "${ipdata[server]}" "ipdata" "Server")
factor_updates+=$(factor_bool "${ipinfo[server]}" "IPinfo" "Server")
factor_updates+=$(factor_bool "${ipwhois[server]}" "IPWHOIS" "Server")
factor_updates+=$(factor_bool "${dbip[server]}" "DBIP" "Server")
factor_updates+=$(factor_bool "${ip2location[abuser]}" "IP2LOCATION" "Abuser")
factor_updates+=$(factor_bool "${ipapi[abuser]}" "ipapi" "Abuser")
factor_updates+=$(factor_bool "${ipregistry[abuser]}" "ipregistry" "Abuser")
factor_updates+=$(factor_bool "${ipqs[abuser]}" "IPQS" "Abuser")
factor_updates+=$(factor_bool "${scamalytics[abuser]}" "SCAMALYTICS" "Abuser")
factor_updates+=$(factor_bool "${ipdata[abuser]}" "ipdata" "Abuser")
factor_updates+=$(factor_bool "${ipinfo[abuser]}" "IPinfo" "Abuser")
factor_updates+=$(factor_bool "${ipwhois[abuser]}" "IPWHOIS" "Abuser")
factor_updates+=$(factor_bool "${dbip[abuser]}" "DBIP" "Abuser")
factor_updates+=$(factor_bool "${ip2location[robot]}" "IP2LOCATION" "Robot")
factor_updates+=$(factor_bool "${ipapi[robot]}" "ipapi" "Robot")
factor_updates+=$(factor_bool "${ipregistry[robot]}" "ipregistry" "Robot")
factor_updates+=$(factor_bool "${ipqs[robot]}" "IPQS" "Robot")
factor_updates+=$(factor_bool "${scamalytics[robot]}" "SCAMALYTICS" "Robot")
factor_updates+=$(factor_bool "${ipdata[robot]}" "ipdata" "Robot")
factor_updates+=$(factor_bool "${ipinfo[robot]}" "IPinfo" "Robot")
factor_updates+=$(factor_bool "${ipwhois[robot]}" "IPWHOIS" "Robot")
factor_updates+=$(factor_bool "${dbip[robot]}" "DBIP" "Robot")
media_updates+=".Media |= map(. * { TikTok: { Status: \"$(clean_ansi "${tiktok[ustatus]:-null}")\" } }) | "
media_updates+=".Media |= map(. * { DisneyPlus: { Status: \"$(clean_ansi "${disney[ustatus]:-null}")\" } }) | "
media_updates+=".Media |= map(. * { Netflix: { Status: \"$(clean_ansi "${netflix[ustatus]:-null}")\" } }) | "
media_updates+=".Media |= map(. * { Youtube: { Status: \"$(clean_ansi "${youtube[ustatus]:-null}")\" } }) | "
media_updates+=".Media |= map(. * { AmazonPrimeVideo: { Status: \"$(clean_ansi "${amazon[ustatus]:-null}")\" } }) | "
media_updates+=".Media |= map(. * { Spotify: { Status: \"$(clean_ansi "${spotify[ustatus]:-null}")\" } }) | "
media_updates+=".Media |= map(. * { ChatGPT: { Status: \"$(clean_ansi "${chatgpt[ustatus]:-null}")\" } }) | "
media_updates+=".Media |= map(. * { TikTok: { Region: \"$(clean_ansi "${tiktok[uregion]//[][]/}")\" } }) | "
media_updates+=".Media |= map(. * { DisneyPlus: { Region: \"$(clean_ansi "${disney[uregion]//[][]/}")\" } }) | "
media_updates+=".Media |= map(. * { Netflix: { Region: \"$(clean_ansi "${netflix[uregion]//[][]/}")\" } }) | "
media_updates+=".Media |= map(. * { Youtube: { Region: \"$(clean_ansi "${youtube[uregion]//[][]/}")\" } }) | "
media_updates+=".Media |= map(. * { AmazonPrimeVideo: { Region: \"$(clean_ansi "${amazon[uregion]//[][]/}")\" } }) | "
media_updates+=".Media |= map(. * { Spotify: { Region: \"$(clean_ansi "${spotify[uregion]//[][]/}")\" } }) | "
media_updates+=".Media |= map(. * { ChatGPT: { Region: \"$(clean_ansi "${chatgpt[uregion]//[][]/}")\" } }) | "
media_updates+=".Media |= map(. * { TikTok: { Type: \"$(clean_ansi "${tiktok[utype]:-null}")\" } }) | "
media_updates+=".Media |= map(. * { DisneyPlus: { Type: \"$(clean_ansi "${disney[utype]:-null}")\" } }) | "
media_updates+=".Media |= map(. * { Netflix: { Type: \"$(clean_ansi "${netflix[utype]:-null}")\" } }) | "
media_updates+=".Media |= map(. * { Youtube: { Type: \"$(clean_ansi "${youtube[utype]:-null}")\" } }) | "
media_updates+=".Media |= map(. * { AmazonPrimeVideo: { Type: \"$(clean_ansi "${amazon[utype]:-null}")\" } }) | "
media_updates+=".Media |= map(. * { Spotify: { Type: \"$(clean_ansi "${spotify[utype]:-null}")\" } }) | "
media_updates+=".Media |= map(. * { ChatGPT: { Type: \"$(clean_ansi "${chatgpt[utype]:-null}")\" } }) | "
if [[ ${smail[local]} -eq 1 ]];then
mail_updates+=".Mail |= map(. + { Port25: true }) | "
for service in "${services[@]}";do
if [[ ${smailstatus[$service]} == "true" ]];then
mail_updates+=".Mail |= map(. + { \"$service\": true }) | "
else
mail_updates+=".Mail |= map(. + { \"$service\": false }) | "
fi
done
elif [[ ${smail[local]} -eq 2 ]];then
mail_updates+=".Mail |= map(. + { Port25: null }) | "
for service in "${services[@]}";do
mail_updates+=".Mail |= map(. + { \"$service\": null }) | "
done
else
mail_updates+=".Mail |= map(. + { Port25: false }) | "
for service in "${services[@]}";do
mail_updates+=".Mail |= map(. + { \"$service\": false }) | "
done
fi
mail_updates+=".Mail |= map(. * { DNSBlacklist: { Total: ${smail[t]:-null} } }) | "
mail_updates+=".Mail |= map(. * { DNSBlacklist: { Clean: ${smail[c]:-null} } }) | "
mail_updates+=".Mail |= map(. * { DNSBlacklist: { Marked: ${smail[m]:-null} } }) | "
mail_updates+=".Mail |= map(. * { DNSBlacklist: { Blacklisted: ${smail[b]:-null} } }) | "
ipjson=$(echo "$ipjson"|jq "$head_updates$basic_updates$type_updates$score_updates$factor_updates$media_updates$mail_updates.")
}
check_IP(){
IP=$1
ibar_step=0
ipjson='{
      "Head": [{}],
      "Info": [{}],
      "Type": [{}],
      "Score": [{}],
      "Factor": [{}],
      "Media": [{}],
      "Mail": [{}]
    }'
[[ $2 -eq 4 ]]&&hide_ipv4 $IP
[[ $2 -eq 6 ]]&&hide_ipv6 $IP
countRunTimes
db_maxmind $2
db_ipinfo
db_scamalytics
[[ $mode_lite -eq 0 ]]&&db_ipregistry $2||ipregistry=()
db_ipapi
[[ $mode_lite -eq 0 ]]&&db_abuseipdb $2||abuseipdb=()
[[ $mode_lite -eq 0 ]]&&db_ip2location $2||ip2location=()
db_dbip
db_ipwhois
[[ $mode_lite -eq 0 ]]&&db_ipdata $2||ipdata=()
[[ $mode_lite -eq 0 ]]&&db_ipqs $2||ipqs=()
db_cloudflare $2
MediaUnlockTest_TikTok $2
MediaUnlockTest_DisneyPlus $2
MediaUnlockTest_Netflix $2
MediaUnlockTest_YouTube_Premium $2
MediaUnlockTest_PrimeVideo_Region $2
MediaUnlockTest_Spotify $2
OpenAITest $2
check_mail
[[ $2 -eq 4 ]]&&check_dnsbl "$IP" 50
echo -ne "$Font_LineClear" 1>&2
if [ $2 -eq 4 ]||[[ $IPV4work -eq 0 || $IPV4check -eq 0 ]];then
for ((i=0; i<ADLines; i++));do
echo -ne "$Font_LineUp" 1>&2
echo -ne "$Font_LineClear" 1>&2
done
fi
if [[ $mode_lite -eq 0 ]];then
local ip_report=$(show_head
show_basic
show_type
show_score
show_factor
show_media
show_mail $2
show_tail)
else
local ip_report=$(show_head
show_basic_lite
show_type_lite
show_score
show_factor_lite
show_media
show_mail $2
show_tail)
fi
local report_link=""
[[ mode_json -eq 1 || mode_output -eq 1 || mode_privacy -eq 0 ]]&&save_json
[[ $mode_lite -eq 0 && mode_privacy -eq 0 ]]&&report_link=$(curl -$2 -s -X POST https://upload.check.place -d "type=ip" --data-urlencode "json=$ipjson" --data-urlencode "content=$ip_report")
[[ mode_json -eq 0 ]]&&echo -ne "\r$ip_report\n"
[[ mode_json -eq 0 && mode_privacy -eq 0 && $report_link == *"https://Report.Check.Place/"* ]]&&echo -ne "\r${stail[link]}$report_link$Font_Suffix\n"
[[ mode_json -eq 1 ]]&&echo -ne "\r$ipjson\n"
echo -ne "\r\n"
if [[ mode_output -eq 1 ]];then
case "$outputfile" in
*.[aA][nN][sS][iI])echo "$ip_report" >>"$outputfile" 2>/dev/null
;;
*.[jJ][sS][oO][nN])echo "$ipjson" >>"$outputfile" 2>/dev/null
;;
*)echo -e "$ip_report"|sed 's/\x1b\[[0-9;]*[mGKHF]//g' >>"$outputfile" 2>/dev/null
esac
fi
}
generate_random_user_agent
adapt_locale
check_connectivity
read_ref
get_ipv4
get_ipv6
is_valid_ipv4 $IPV4
is_valid_ipv6 $IPV6
get_opts "$@"
[[ mode_no -eq 0 ]]&&install_dependencies
set_language
if [[ $ERRORcode -ne 0 ]];then
echo -ne "\r$Font_B$Font_Red${swarn[$ERRORcode]}$Font_Suffix\n"
exit $ERRORcode
fi
clear
show_ad
[[ $IPV4work -ne 0 && $IPV4check -ne 0 ]]&&check_IP "$IPV4" 4
[[ $IPV6work -ne 0 && $IPV6check -ne 0 ]]&&check_IP "$IPV6" 6
