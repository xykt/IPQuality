#!/bin/bash
script_version="v2024-07-29"
ADLines=25
check_bash(){
current_bash_version=$(bash --version|head -n 1|awk '{print $4}'|cut -d'.' -f1)
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
declare IP=""
declare IPhide
declare fullIP=0
declare LANG="cn"
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
declare asponsor
declare aad1
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
declare -A stail
declare ibar=0
declare bar_pid
declare ibar_step=0
declare main_pid=$$
declare PADDING=""
declare useNIC=""
declare usePROXY=""
declare CurlARG=""
declare UA_Browser
declare Media_Cookie=$(curl $CurlARG -s --retry 3 --max-time 10 "https://raw.githubusercontent.com/xykt/IPQuality/main/ref/cookies.txt")
declare IATA_Database="https://raw.githubusercontent.com/xykt/IPQuality/main/ref/iata-icao.csv"
shelp_lines=(
"IP QUALITY CHECK SCRIPT"
"Usage: bash <(curl -sL IP.Check.Place) [-4] [-6] [-f] [-h] [-i eth0] [-l cn|en|jp|es|de|fr|ru|pt] [-x http://usr:pwd@proxyurl:p]"
"            -4                             Test IPv4"
"            -6                             Test IPv6"
"            -f                             Show full IP on reports"
"            -h                             Help information"
"            -i eth0                        Specify network interface"
"            -l cn|en|jp|es|de|fr|ru|pt     Specify script language"
"            -x http://usr:pwd@proxyurl:p   Specify http proxy"
"            -x https://usr:pwd@proxyurl:p  Specify https proxy"
"            -x socks5://usr:pwd@proxyurl:p Specify socks5 proxy")
shelp=$(printf "%s\n" "${shelp_lines[@]}")
set_language(){
case "$LANG" in
"en"|"jp"|"es"|"de"|"fr"|"ru"|"pt")swarn[1]="ERROR: Unsupported parameters!"
swarn[2]="ERROR: IP address format error!"
swarn[3]="ERROR: Dependent programs are missing. Please run as root or install sudo!"
swarn[4]="ERROR: Parameter -4 conflicts with -i or -6!"
swarn[6]="ERROR: Parameter -6 conflicts with -i or -4!"
swarn[7]="ERROR: The specified network interface is invalid or does not exist!"
swarn[8]="ERROR: The specified proxy parameter is invalid or not working!"
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
shead[ver]="Version: $script_version"
shead[bash]="bash <(curl -sL IP.Check.Place)"
shead[git]="https://github.com/xykt/IPQuality"
shead[time]=$(date -u +"Report Time: %Y-%m-%d %H:%M:%S UTC")
shead[ltitle]=25
shead[ptime]=$(printf '%7s' '')
sbasic[title]="1. Basic Information (${Font_I}Maxmind Database$Font_Suffix)"
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
smail[port]="Local Port 25: "
smail[yes]="${Font_Green}Available$Font_Suffix"
smail[no]="${Font_Red}Blocked$Font_Suffix"
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
swarn[7]="错误：指定的网卡不存在！"
swarn[8]="错误: 指定的代理服务器不可用！"
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
shead[ver]="脚本版本：$script_version"
shead[bash]="bash <(curl -sL IP.Check.Place)"
shead[git]="https://github.com/xykt/IPQuality"
shead[time]=$(TZ="Asia/Shanghai" date +"报告时间：%Y-%m-%d %H:%M:%S CST")
shead[ltitle]=16
shead[ptime]=$(printf '%8s' '')
sbasic[title]="一、基础信息（${Font_I}Maxmind 数据库$Font_Suffix）"
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
smail[port]="本地25端口："
smail[yes]="$Font_Green可用$Font_Suffix"
smail[no]="$Font_Red阻断$Font_Suffix"
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
if ! mktemp -u --suffix=RRC &>/dev/null;then
count_file=$(mktemp)
else
count_file=$(mktemp --suffix=RRC)
fi
RunTimes=$(curl $CurlARG -s --max-time 10 "https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fip.check.place&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=false" >"$count_file")
stail[today]=$(cat "$count_file"|tail -3|head -n 1|awk '{print $5}')
stail[total]=$(cat "$count_file"|tail -3|head -n 1|awk '{print $7}')
}
show_progress_bar(){
local bar="⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
local n="${#bar}"
while sleep 0.1;do
if ! kill -0 $main_pid 2>/dev/null;then
echo -ne ""
exit
fi
echo -ne "\r$Font_Cyan$Font_B[$IP]# $1$Font_Cyan$Font_B$(printf '%*s' "$2" ''|tr ' ' '.') ${bar:ibar++%n:1} $(printf '%02d%%' $ibar_step) $Font_Suffix"
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
if [ "$no_sudo" == "no_sudo" ]||[ $(id -u) -eq 0 ];then
local usesudo=""
else
local usesudo="sudo"
fi
case $package_manager in
apt)$usesudo apt update
$usesudo $install_command jq curl bc netcat-openbsd dnsutils iproute2
;;
dnf)$usesudo dnf install epel-release -y
$usesudo $package_manager makecache
$usesudo $install_command jq curl bc nmap-ncat bind-utils iproute
;;
yum)$usesudo yum install epel-release -y
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
[Chrome]="87.0.4280.66 88.0.4324.150 89.0.4389.82"
[Firefox]="83.0 84.0 85.0"
[Edge]="88.0.705.50 89.0.774.57")
generate_random_user_agent(){
local browsers_keys=(${!browsers[@]})
local random_browser_index=$((RANDOM%${#browsers_keys[@]}))
local browser=${browsers_keys[random_browser_index]}
local versions=(${browsers[$browser]})
local random_version_index=$((RANDOM%${#versions[@]}))
local version=${versions[random_version_index]}
case $browser in
Chrome)UA_Browser="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/$version Safari/537.36"
;;
Firefox)UA_Browser="Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:${version%%.*}) Gecko/20100101 Firefox/$version"
;;
Edge)UA_Browser="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/${version%.*}.0.0 Safari/537.36 Edg/$version"
esac
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
local API_NET=("myip.check.place" "ip.sb" "ping0.cc" "icanhazip.com" "api64.ipify.org" "ifconfig.co" "ident.me")
for p in "${API_NET[@]}";do
response=$(curl $CurlARG -s4 --max-time 8 "$p")
if [[ $? -eq 0 && ! $response =~ error ]];then
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
local API_NET=("myip.check.place" "ip.sb" "ping0.cc" "icanhazip.com" "api64.ipify.org" "ifconfig.co" "ident.me")
for p in "${API_NET[@]}";do
response=$(curl $CurlARG -s6k --max-time 8 "$p")
if [[ $? -eq 0 && ! $response =~ error ]];then
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
echo "https://check.place/$lat,$lon,$zoom_level,$LANG"
}
db_maxmind(){
local temp_info="$Font_Cyan$Font_B${sinfo[database]}${Font_I}Maxmind $Font_Suffix"
((ibar_step+=3))
show_progress_bar "$temp_info" $((40-8-${sinfo[ldatabase]}))&
bar_pid="$!"&&disown "$bar_pid"
trap "kill_progress_bar" RETURN
maxmind=()
local RESPONSE=$(curl $CurlARG -Ls -$1 -m 10 "https://ipinfo.check.place/$IP?lang=$LANG")
echo "$RESPONSE"|jq . >/dev/null 2>&1||RESPONSE=""
maxmind[asn]=$(echo "$RESPONSE"|jq -r '.ASN.AutonomousSystemNumber')
maxmind[org]=$(echo "$RESPONSE"|jq -r '.ASN.AutonomousSystemOrganization')
maxmind[city]=$(echo "$RESPONSE"|jq -r '.City.Name')
maxmind[post]=$(echo "$RESPONSE"|jq -r '.City.PostalCode')
maxmind[lat]=$(echo "$RESPONSE"|jq -r '.City.Latitude')
maxmind[lon]=$(echo "$RESPONSE"|jq -r '.City.Longitude')
maxmind[rad]=$(echo "$RESPONSE"|jq -r '.City.AccuracyRadius')
maxmind[dms]=$(generate_dms "${maxmind[lat]}" "${maxmind[lon]}")
maxmind[map]=$(generate_googlemap_url "${maxmind[lat]}" "${maxmind[lon]}" "${maxmind[rad]}")
maxmind[continentcode]=$(echo "$RESPONSE"|jq -r '.City.Continent.Code')
maxmind[continent]=$(echo "$RESPONSE"|jq -r '.City.Continent.Name')
maxmind[citycountrycoad]=$(echo "$RESPONSE"|jq -r '.City.Country.IsoCode')
maxmind[citycountry]=$(echo "$RESPONSE"|jq -r '.City.Country.Name')
maxmind[timezone]=$(echo "$RESPONSE"|jq -r '.City.Location.TimeZone')
maxmind[subcode]=$(echo "$RESPONSE"|jq -r 'if .City.Subdivisions | length > 0 then .City.Subdivisions[0].IsoCode else "N/A" end')
maxmind[sub]=$(echo "$RESPONSE"|jq -r 'if .City.Subdivisions | length > 0 then .City.Subdivisions[0].Name else "N/A" end')
maxmind[countrycode]=$(echo "$RESPONSE"|jq -r '.Country.IsoCode')
maxmind[country]=$(echo "$RESPONSE"|jq -r '.Country.Name')
maxmind[regcountrycode]=$(echo "$RESPONSE"|jq -r '.Country.RegisteredCountry.IsoCode')
maxmind[regcountry]=$(echo "$RESPONSE"|jq -r '.Country.RegisteredCountry.Name')
if [[ $LANG != "en" ]];then
local backup_response=$(curl $CurlARG -s -$1 -m 10 "http://ipinfo.check.place/$IP?lang=en")
[[ ${maxmind[asn]} == "null" ]]&&maxmind[asn]=$(echo "$backup_response"|jq -r '.ASN.AutonomousSystemNumber')
[[ ${maxmind[org]} == "null" ]]&&maxmind[org]=$(echo "$backup_response"|jq -r '.ASN.AutonomousSystemOrganization')
[[ ${maxmind[city]} == "null" ]]&&maxmind[city]=$(echo "$backup_response"|jq -r '.City.Name')
[[ ${maxmind[post]} == "null" ]]&&maxmind[post]=$(echo "$backup_response"|jq -r '.City.PostalCode')
[[ ${maxmind[lat]} == "null" ]]&&maxmind[lat]=$(echo "$backup_response"|jq -r '.City.Latitude')
[[ ${maxmind[lon]} == "null" ]]&&maxmind[lon]=$(echo "$backup_response"|jq -r '.City.Longitude')
[[ ${maxmind[rad]} == "null" ]]&&maxmind[rad]=$(echo "$backup_response"|jq -r '.City.AccuracyRadius')
[[ ${maxmind[continentcode]} == "null" ]]&&maxmind[continentcode]=$(echo "$backup_response"|jq -r '.City.Continent.Code')
[[ ${maxmind[continent]} == "null" ]]&&maxmind[continent]=$(echo "$backup_response"|jq -r '.City.Continent.Name')
[[ ${maxmind[citycountrycoad]} == "null" ]]&&maxmind[citycountrycoad]=$(echo "$backup_response"|jq -r '.City.Country.IsoCode')
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
}
db_scamalytics(){
local temp_info="$Font_Cyan$Font_B${sinfo[database]}${Font_I}SCAMALYTICS $Font_Suffix"
((ibar_step+=3))
show_progress_bar "$temp_info" $((40-12-${sinfo[ldatabase]}))&
bar_pid="$!"&&disown "$bar_pid"
trap "kill_progress_bar" RETURN
scamalytics=()
local RESPONSE=$(curl $CurlARG -sL -H "Referer: https://scamalytics.com" -m 10 "https://scamalytics.com/ip/$IP")
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
scamalytics[proxy]="true"
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
ipregistry[tor]="true"
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
local RESPONSE=$(curl $CurlARG -sL -m 10 -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.82 Safari/537.36" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9" -H "Accept-Language: en-US,en;q=0.9" "https://www.ip2location.io/$IP"|sed -n '/<code/,/<\/code>/p'|sed -e 's/<[^>]*>//g'|sed 's/^[\t]*//')
echo "$RESPONSE"|jq . >/dev/null 2>&1||RESPONSE=""
ip2location[usetype]=$(echo "$RESPONSE"|jq -r '.usage_type')
shopt -s nocasematch
case ${ip2location[usetype]} in
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
shopt -u nocasematch
ip2location[countrycode]=$(echo "$RESPONSE"|jq -r '.country_code')
ip2location[proxy1]=$(echo "$RESPONSE"|jq -r '.proxy.is_public_proxy')
ip2location[proxy2]=$(echo "$RESPONSE"|jq -r '.proxy.is_web_proxy')
ip2location[proxy]="true"
[[ ${ip2location[proxy1]} == "false" && ${ip2location[proxy2]} == "false" ]]&&ip2location[proxy]="false"
ip2location[tor]=$(echo "$RESPONSE"|jq -r '.proxy.is_tor')
ip2location[vpn]=$(echo "$RESPONSE"|jq -r '.proxy.is_vpn')
ip2location[server]=$(echo "$RESPONSE"|jq -r '.proxy.is_data_center')
ip2location[abuser]=$(echo "$RESPONSE"|jq -r '.proxy.is_spammer')
ip2location[robot1]=$(echo "$RESPONSE"|jq -r '.proxy.is_web_crawler')
ip2location[robot2]=$(echo "$RESPONSE"|jq -r '.proxy.is_scanner')
ip2location[robot3]=$(echo "$RESPONSE"|jq -r '.proxy.is_botnet')
ip2location[robot]="true"
[[ ${ip2location[robot1]} == "false" && ${ip2location[robot2]} == "false" && ${ip2location[robot3]} == "false" ]]&&ip2location[robot]="false"
}
db_dbip(){
local temp_info="$Font_Cyan$Font_B${sinfo[database]}${Font_I}DB-IP $Font_Suffix"
((ibar_step+=3))
show_progress_bar "$temp_info" $((40-6-${sinfo[ldatabase]}))&
bar_pid="$!"&&disown "$bar_pid"
trap "kill_progress_bar" RETURN
dbip=()
local RESPONSE=$(curl $CurlARG -sL -m 10 "https://db-ip.com/demo/home.php?s=$IP")
echo "$RESPONSE"|jq . >/dev/null 2>&1||RESPONSE=""
dbip[risktext]=$(echo "$RESPONSE"|jq -r '.demoInfo.threatLevel')
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
ipdata[abuser]="true"
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
local isUnabailable=$(echo $previewcheck|grep 'unavailable')
local region=$(echo $tmpresult|jq -r '.extensions.sdk.session.location.countryCode')
local inSupportedLocation=$(echo $tmpresult|jq -r '.extensions.sdk.session.inSupportedLocation')
if [[ $region == "JP" ]];then
disney[ustatus]="${smedia[yes]}"
disney[uregion]="  [JP]   "
disney[utype]="$resultunlocktype"
return
elif [ -n "$region" ]&&[[ $inSupportedLocation == "false" ]]&&[ -z "$isUnabailable" ];then
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
local result1=$(curl $CurlARG -$1 --user-agent "$UA_Browser" -fsLI -X GET --write-out %{http_code} --output /dev/null --max-time 10 --tlsv1.3 "https://www.netflix.com/title/81280792" 2>&1)
local result2=$(curl $CurlARG -$1 --user-agent "$UA_Browser" -fsLI -X GET --write-out %{http_code} --output /dev/null --max-time 10 --tlsv1.3 "https://www.netflix.com/title/70143836" 2>&1)
local regiontmp=$(curl $CurlARG -$1 --user-agent "$UA_Browser" -fSsI -X GET --max-time 10 --write-out %{redirect_url} --output /dev/null --tlsv1.3 "https://www.netflix.com/login" 2>&1)
if [[ $regiontmp == "curl"* ]];then
netflix[ustatus]="${smedia[bad]}"
netflix[uregion]="${smedia[nodata]}"
netflix[utype]="${smedia[nodata]}"
return
fi
local region=$(echo $regiontmp|cut -d '/' -f4|cut -d '-' -f1|tr [:lower:] [:upper:])
if [[ -z $region ]];then
region="US"
fi
if [[ $result1 == "404" ]]&&[[ $result2 == "404" ]];then
netflix[ustatus]="${smedia[org]}"
netflix[uregion]="  [$region]   "
netflix[utype]="$resultunlocktype"
return
elif [[ $result1 == "403" ]]&&[[ $result2 == "403" ]];then
netflix[ustatus]="${smedia[no]}"
netflix[uregion]="${smedia[nodata]}"
netflix[utype]="${smedia[nodata]}"
return
elif [[ $result1 == "200" ]]||[[ $result2 == "200" ]];then
netflix[ustatus]="${smedia[yes]}"
netflix[uregion]="  [$region]   "
netflix[utype]="$resultunlocktype"
return
elif [[ $result1 == "000" ]];then
netflix[ustatus]="${smedia[bad]}"
netflix[uregion]="${smedia[nodata]}"
netflix[utype]="${smedia[nodata]}"
return
fi
netflix[ustatus]="${smedia[bad]}"
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
return
elif [ -n "$result2" ]&&[ -n "$result1" ];then
chatgpt[ustatus]="${smedia[no]}"
chatgpt[uregion]="${smedia[nodata]}"
chatgpt[utype]="${smedia[nodata]}"
return
elif [ -z "$result1" ]&&[ -n "$result2" ]&&[[ $tmpresult1 != "curl"* ]];then
chatgpt[ustatus]="${smedia[web]}"
chatgpt[uregion]="  [$countryCode]   "
chatgpt[utype]="$resultunlocktype"
return
elif [ -n "$result1" ]&&[ -z "$result2" ];then
chatgpt[ustatus]="${smedia[app]}"
chatgpt[uregion]="  [$countryCode]   "
chatgpt[utype]="$resultunlocktype"
return
elif [[ $tmpresult1 == "curl"* ]]&&[ -n "$result2" ];then
chatgpt[ustatus]="${smedia[no]}"
chatgpt[uregion]="${smedia[nodata]}"
chatgpt[utype]="${smedia[nodata]}"
return
else
chatgpt[ustatus]="${smedia[bad]}"
chatgpt[uregion]="${smedia[nodata]}"
chatgpt[utype]="${smedia[nodata]}"
return
fi
}
check_local_port_25(){
local host=$1
local port=$2
nc -s "$IP" -z -w5 $host $port >/dev/null 2>&1
if [ $? -eq 0 ]&&[ -z "$usePROXY" ];then
smail[local]=1
else
smail[local]=0
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
"QQ")domain="qq.com";;
"MailRU")domain="mail.ru";;
"AOL")domain="aol.com";;
"GMX")domain="gmx.com";;
"MailCOM")domain="mail.com";;
"163")domain="163.com";;
"Sohu")domain="sohu.com";;
"Sina")domain="sina.com";;
*)return
esac
if [[ -z $host ]];then
local mx_hosts=($(get_sorted_mx_records $domain))
for host in "${mx_hosts[@]}";do
response=$(timeout 4 bash -c "echo -e 'QUIT\r\n' | nc -s $IP -w4 $host $port 2>&1")
smail_response[$service]=$response
if [[ $response == *"$expected_response"* ]];then
success="true"
smail[$service]="$Back_Green$Font_White$Font_B$service$Font_Suffix"
break
fi
done
else
response=$(timeout 4 bash -c "echo -e 'QUIT\r\n' | nc -s $IP -w4 $host $port 2>&1")
if [[ $response == *"$expected_response"* ]];then
success="true"
smail[$service]="$Back_Green$Font_White$Font_B$service$Font_Suffix"
fi
fi
if [[ $success == "false" ]];then
smail[$service]="$Back_Red$Font_White$Font_B$service$Font_Suffix"
fi
}
check_mail(){
check_local_port_25 "localhost" 25
if [ ${smail[local]} -eq 1 ];then
services=("Gmail" "Outlook" "Yahoo" "Apple" "QQ" "MailRU" "AOL" "GMX" "MailCOM" "163" "Sohu" "Sina")
for service in "${services[@]}";do
local temp_info="$Font_Cyan$Font_B${sinfo[mail]}$Font_I$service $Font_Suffix"
((ibar_step+=3))
show_progress_bar "$temp_info" $((40-1-${#service}-${sinfo[lmail]}))&
bar_pid="$!"&&disown "$bar_pid"
check_email_service $service
kill_progress_bar
done
fi
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
curl $CurlARG -s "https://raw.githubusercontent.com/xykt/IPQuality/main/ref/dnsbl.list"|sort -u|xargs -P "$parallel_jobs" -I {} bash -c "result=\$(dig +short \"$reversed_ip.{}\" A); if [[ -z \"\$result\" ]]; then echo 'Clean'; elif [[ \"\$result\" == '127.0.0.2' ]]; then echo 'Blacklisted'; else echo 'Other'; fi"|{
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
echo "$Font_Cyan${smail[dnsbl]}  ${smail[available]}${smail[t]}   ${smail[clean]}${smail[c]}   ${smail[marked]}${smail[m]}   ${smail[blacklisted]}${smail[b]}$Font_Suffix"
}
}
check_dnsbl(){
local temp_info="$Font_Cyan$Font_B${sinfo[dnsbl]} $Font_Suffix"
((ibar_step=95))
show_progress_bar "$temp_info" $((40-1-${sinfo[ldnsbl]}))&
bar_pid="$!"&&disown "$bar_pid"
trap "kill_progress_bar" RETURN
smail[sdnsbl]=$(check_dnsbl_parallel "$IP" 50)
}
show_head(){
echo -ne "\r$(printf '%72s'|tr ' ' '#')\n"
if [ $fullIP -eq 1 ];then
calc_padding "$(printf '%*s' "${shead[ltitle]}" '')$IP" 72
echo -ne "\r$PADDING$Font_B${shead[title]}$Font_Cyan$IP$Font_Suffix\n"
else
calc_padding "$(printf '%*s' "${shead[ltitle]}" '')$IPhide" 72
echo -ne "\r$PADDING$Font_B${shead[title]}$Font_Cyan$IPhide$Font_Suffix\n"
fi
calc_padding "${shead[bash]}" 72
echo -ne "\r$PADDING${shead[bash]}\n"
calc_padding "${shead[git]}" 72
echo -ne "\r$PADDING$Font_U${shead[git]}$Font_Suffix\n"
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
show_type(){
echo -ne "\r${stype[title]}\n"
echo -ne "\r$Font_Cyan${stype[db]}$Font_I   IPinfo    ipregistry    ipapi     AbuseIPDB  IP2LOCATION $Font_Suffix\n"
echo -ne "\r$Font_Cyan${stype[usetype]}$Font_Suffix${ipinfo[susetype]}${ipregistry[susetype]}${ipapi[susetype]}${abuseipdb[susetype]}${ip2location[susetype]}\n"
echo -ne "\r$Font_Cyan${stype[comtype]}$Font_Suffix${ipinfo[scomtype]}${ipregistry[susetype]}${ipapi[susetype]}\n"
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
if [[ -n ${scamalytics[score]} ]];then
sscore_text "${scamalytics[score]}" ${scamalytics[score]} 25 50 100 13
echo -ne "\r${Font_Cyan}SCAMALYTICS${sscore[colon]}$Font_White$Font_B${sscore[text1]}$Back_Green${sscore[text2]}$Back_Yellow${sscore[text3]}$Back_Red${sscore[text4]}$Font_Suffix${scamalytics[risk]}\n"
fi
if [[ -n ${ipapi[score]} ]];then
local tmp_score=$(echo "${ipapi[scorenum]} * 10000 / 1"|bc)
sscore_text "${ipapi[score]}" $tmp_score 85 300 10000 7
echo -ne "\r${Font_Cyan}ipapi${sscore[colon]}$Font_White$Font_B${sscore[text1]}$Back_Green${sscore[text2]}$Back_Yellow${sscore[text3]}$Back_Red${sscore[text4]}$Font_Suffix${ipapi[risk]}\n"
fi
sscore_text "${abuseipdb[score]}" ${abuseipdb[score]} 25 25 100 11
echo -ne "\r${Font_Cyan}AbuseIPDB${sscore[colon]}$Font_White$Font_B${sscore[text1]}$Back_Green${sscore[text2]}$Back_Yellow${sscore[text3]}$Back_Red${sscore[text4]}$Font_Suffix${abuseipdb[risk]}\n"
if [ -n "${ipqs[score]}" ]&&[ "${ipqs[score]}" != "null" ];then
sscore_text "${ipqs[score]}" ${ipqs[score]} 75 85 100 6
echo -ne "\r${Font_Cyan}IPQS${sscore[colon]}$Font_White$Font_B${sscore[text1]}$Back_Green${sscore[text2]}$Back_Yellow${sscore[text3]}$Back_Red${sscore[text4]}$Font_Suffix${ipqs[risk]}\n"
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
echo "$tmp_txt"
}
show_factor(){
local tmp_factor=""
echo -ne "\r${sfactor[title]}\n"
echo -ne "\r$Font_Cyan${sfactor[factor]}${Font_I}IP2LOCATION ipapi ipregistry IPQS SCAMALYTICS ipdata IPinfo IPWHOIS$Font_Suffix\n"
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
echo -ne "\r$Font_Cyan${smail[provider]}$Font_Suffix"
for service in "${services[@]}";do
echo -ne "${smail[$service]} "
done
echo ""
else
echo -ne "\r$Font_Cyan${smail[port]}$Font_Suffix${smail[no]}\n"
fi
[[ $1 -eq 4 ]]&&echo -ne "\r${smail[sdnsbl]}\n"
}
show_tail(){
echo -ne "\r$(printf '%72s'|tr ' ' '=')\n"
echo -ne "\r$Font_I${stail[stoday]}${stail[today]}${stail[stotal]}${stail[total]}${stail[thanks]} $Font_Suffix\n"
echo -e ""
}
get_opts(){
while getopts "i:l:x:fh46" opt;do
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
if [[ -n $iface && -d "/sys/class/net/$iface" ]];then
useNIC=" --interface $iface"
CurlARG="$useNIC"
get_ipv4
get_ipv6
is_valid_ipv4 $IPV4
is_valid_ipv6 $IPV6
else
ERRORcode=7
fi
;;
l)LANG=$OPTARG
;;
x)xproxy="$OPTARG"
if [[ -z $xproxy ]]||! curl -sL -x "$xproxy" --connect-timeout 5 --max-time 10 https://myip.check.place -o /dev/null;then
ERRORcode=8
else
usePROXY=" -x $xproxy"
CurlARG="$usePROXY"
get_ipv4
get_ipv6
is_valid_ipv4 $IPV4
is_valid_ipv6 $IPV6
fi
;;
\?)ERRORcode=1
esac
done
[[ $IPV4check -eq 1 && $IPV6check -eq 0 && $IPV4work -eq 0 ]]&&ERRORcode=40
[[ $IPV4check -eq 0 && $IPV6check -eq 1 && $IPV6work -eq 0 ]]&&ERRORcode=60
CurlARG="$useNIC$usePROXY"
}
show_help(){
echo -ne "\r$shelp\n"
exit 0
}
show_ad(){
asponsor=$(curl -sL --max-time 5 "https://cdn.jsdelivr.net/gh/xykt/IPQuality@main/ref/sponsor.ans")
aad1=$(curl -sL --max-time 5 "https://cdn.jsdelivr.net/gh/xykt/IPQuality@main/ref/ad1.ans")
echo -e "$asponsor"
echo -e "$aad1"
}
check_IP(){
IP=$1
ibar_step=0
[[ $2 -eq 4 ]]&&hide_ipv4 $IP
[[ $2 -eq 6 ]]&&hide_ipv6 $IP
countRunTimes
db_maxmind $2
db_ipinfo
db_scamalytics
db_ipregistry $2
db_ipapi
db_abuseipdb $2
db_ip2location
db_dbip
db_ipwhois
db_ipdata $2
db_ipqs $2
MediaUnlockTest_TikTok $2
MediaUnlockTest_DisneyPlus $2
MediaUnlockTest_Netflix $2
MediaUnlockTest_YouTube_Premium $2
MediaUnlockTest_PrimeVideo_Region $2
MediaUnlockTest_Spotify $2
OpenAITest $2
check_mail
[[ $2 -eq 4 ]]&&check_dnsbl "$IP" 50
echo -ne "$Font_LineClear"
if [ $2 -eq 4 ]||[[ $IPV4work -eq 0 || $IPV4check -eq 0 ]];then
for ((i=0; i<ADLines; i++));do
echo -ne "$Font_LineUp"
echo -ne "$Font_LineClear"
done
fi
local ip_report=$(show_head
show_basic
show_type
show_score
show_factor
show_media
show_mail $2
show_tail)
local report_link=$(curl -$2 -s -X POST http://upload.check.place -d "type=ip" --data-urlencode "content=$ip_report")
echo -ne "\r$ip_report\n"
[[ $report_link == *"https"* ]]&&echo -ne "\r${stail[link]}$report_link$Font_Suffix\n"
echo -ne "\r\n"
}
install_dependencies
generate_random_user_agent
get_ipv4
get_ipv6
is_valid_ipv4 $IPV4
is_valid_ipv6 $IPV6
get_opts "$@"
set_language
if [[ $ERRORcode -ne 0 ]];then
echo -ne "\r$Font_B$Font_Red${swarn[$ERRORcode]}$Font_Suffix\n"
exit $ERRORcode
fi
clear
show_ad
[[ $IPV4work -ne 0 && $IPV4check -ne 0 ]]&&check_IP "$IPV4" 4
[[ $IPV6work -ne 0 && $IPV6check -ne 0 ]]&&check_IP "$IPV6" 6
