#!/bin/bash
#my Bash assignment

function mysysname ()
{
    echo ''
    hostname -s
    return 0
    
}
function mydname ()
{
    echo ''
    if [ -z $(hostname -d) ];
    then 
       echo "This computer has not any domain "
    else
        echo "The domain name for this computer is $(hostname -d)"
    fi
    return 0
}
function myipaddress ()
{
    echo ''
    echo "This is my IP Address $(ifconfig | grep "inet addr" | head -n1 | cut -d: -f2 | cut -d" " -f1) for my device"
    return 0
}
function myosversion ()
{
    echo''
    echo "This is my os VERSION $(cat /etc/os-release | grep "VERSION_ID" | cut -d\" -f2)"
    return 0
    
}
function myosname ()
{
    echo ''
    echo "This is my os NAME $(cat /etc/os-release | grep "NAME" | head -n1 | cut -d\" -f2)"
        
}
function mycpuinfo ()
{
    echo ''
    echo "This is CPU MODEL NAME $(cat /proc/cpuinfo | grep "model name" | head -n1 | cut -d: -f2 | cut -d" " -f2-6) for my device"
    echo "This CPU has $(lscpu | grep "^CPU(s):" | awk '{print $2}')" cores
    echo "This CPU can operate $(lscpu | grep "CPU op-mode(s):" | awk '{print $3,$4}') modes"
    return 0
    
}
function mysysmemory ()
{
    echo ''
    echo "This computer has $(free -h | grep "Mem" | awk '{print $2}') of memory"
    return 0
    
}
function mydiskspace ()
{
    echo ''
    disks=($(df -Th | grep "^/" | awk '{print $5}'))
    ndisk=($(df -Th | grep "^/" | awk '{print $1}'))
    i=0
    while [ $i -lt ${#disks[@]} ]
    do 
    echo "The disk ${ndisk[$i]} has total of ${disks[$i]} available"
    i=$((i+1))
    done 
    return 0
    
}
function myprinters ()
{
    echo ''
    if [ -z "$(lpstat -a)" ];
    then
        echo "This computer has no printers"
    else
        echo "List of Printers Available"
        echo "=========================="
        lpstat -a | awk '{print $1}'
    fi
    return 0
    
}
function mysoftwares ()
{
    #check if the script is running in a Linux based debian distribution.
    if [ $(cat /etc/os-release | grep ID_LIKE | cut -d= -f2) != "debian" ]
    then
        echo ""
        echo "This option just can run in a Debian based distribution.">&2
        exit 1
    else
        echo ''
        echo "Name of the Version" | awk '{printf "%-50s %-80s\n", $1, $2}'
        echo "=========================================================="
        dpkg-query -l | grep ii | awk '{printf "%-50s %-80s\n", $2, $3}' | more
        return 0
    fi
}
function myerorr ()
{
    return 0
}
function myhelp ()
{
    echo ""
    echo "                              HELP                                    "
    echo "======================================================================"
    echo "warning: this script will only works on debian based system"
    echo "___________________________________________________________"
    echo "This script will show some system and hardware configuration"
    echo "usage:"
    echo    "systeminfo.sh [options]"
    echo ""
    echo "Options:"
    echo "-mysys        show system name"
    echo "-mydn         show the domain name"
    echo "-myip         show the ip address of device"
    echo "-myosv        show the operating system version"
    echo "-myosn        show the operating system name"
    echo "-mycpu        show the cpu model, how many cores and modes your cpu has"
    echo "-myds         show the total available disk space"
    echo "-mylp         show the list of printers"
    echo "-mysoft       show the softwares with version"
    echo "-help, --h    show this help"
    echo "Thanks for using help"
    echo ""
    exit 0
}

params=1

while [ $params -le $# ]
do 
    case $1 in
    
        -mysys)         mysysname
        ;;
        
        -mydn)          mydname
        ;;
        
        -myip)          myipaddress
        ;;
        
        -myosv)         myosversion
        ;;
        
        -myosn)         myosname
        ;;
        
        -mycpu)         mycpuinfo
        ;;
        
        -myds)          mydiskspace
        ;;
        
        -mylp)          myprinters
        ;;
        
        -mysoft)        mysoftwares
        ;;
    
        -error)         myerorr
        ;;
        
        -help|--h)      myhelp
        ;;
        
        *)              error
                        myhelp
        ;;
        
    esac
    shift
done
