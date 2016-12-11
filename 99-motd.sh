# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Process count
PROCCOUNT=$( ps -Afl | wc -l )
PROCCOUNT=$( expr $PROCCOUNT - 5 )

# Uptime
UPTIME=$(</proc/uptime)
UPTIME=${UPTIME%%.*}
SECONDS=$(( UPTIME%60 ))
MINUTES=$(( UPTIME/60%60 ))
HOURS=$(( UPTIME/60/60%24 ))
DAYS=$(( UPTIME/60/60/24 ))

# SYSTEM INFO
# Hostname (UPPERCASE)
HOSTNAME=$( echo $(hostname)  | tr '[a-z]' '[A-Z]' )
# IP Address (list all ip addresses)
IP_ADDRESS=$(echo $(ip address | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' |  sed ':a;N;$!ba;s/\n/ , /g') )
# System : Description of the distribution
SYSTEM=$(echo $(lsb_release -d | awk -F':' '{print $2}' | sed 's/^\s*//g') )
# Kernel release
KERNEL=$( echo $(uname -r) )
# CPU Info
CPU_INFO=$(echo $(more /proc/cpuinfo | grep processor | wc -l ) "x" $(more /proc/cpuinfo | grep 'model name' | uniq |awk -F":"  '{print $2}') )
# Total Memory
MEMORY=$(echo $(free -m |grep Mem: | awk -F " " '{print $2}') MO)
# Memory Used
MEMORY_USED=$(echo $(free -m |grep Mem: | awk -F " " '{print $3}') MO)


Green='\e[0;32m'
White='\e[0;37m'
BRed='\e[1;31m'
BCyan='\e[1;36m'
BWhite='\e[1;37m'
NC="\e[m"

echo -e "
${BCyan}+=================: ${BWhite}System Data${BCyan} :==================+
${BCyan}| ${White}   Hostname ${BRed}= ${Green}$HOSTNAME
${BCyan}| ${White}    Address ${BRed}= ${Green}$IP_ADDRESS
${BCyan}| ${White}     System ${BRed}= ${Green}$SYSTEM
${BCyan}| ${White}     Kernel ${BRed}= ${Green}$KERNEL
${BCyan}| ${White}     Uptime ${BRed}= ${Green}$DAYS days, $HOURS hours, $MINUTES minutes, $SECONDS seconds
${BCyan}| ${White}   CPU Info ${BRed}= ${Green}$CPU_INFO
${BCyan}| ${White}     Memory ${BRed}= ${Green}$MEMORY
${BCyan}| ${White}Memory Used ${BRed}= ${Green}$MEMORY_USED
${BCyan}+=================: ${BWhite}User Data${BCyan} :====================+
${BCyan}| ${White}   Username ${BRed}= ${Green}`whoami`
${BCyan}| ${White}  Processes ${BRed}= ${Green}$PROCCOUNT of `ulimit -u` MAX
${BCyan}+=================: ${BWhite}Information/Role${BCyan} :=============+
${BCyan}| ${White}     Server ${BRed}= ${Green}MerhylStudio Shark Server 01
${BCyan}| ${White}            ${BRed}  ${Green}- Docker Server
${BCyan}| ${White}            ${BRed}  ${Green}- SSH 1865, public key only
${BCyan}+==================================================+${NC}
"
