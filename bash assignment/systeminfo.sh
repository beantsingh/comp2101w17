#!/bin/bash
#my Bash assignment

function mysysname ()
{
    echo ''
    echo "The system name is: $(hostname -s)"
    return 0
    
}
function mydname ()
{
    echo ''
    if [ -z $(hostname -d) ];
    then 
       echo "This computer has no any domain"
    else
        echo "The domain name for this computer is $(hostname -d)"
    fi
    return 0
}
function myipaddress ()
{
    echo ''
    if [ -n $(dpkg-query -l | grep ii | awk '{print  $2}' | grep net-tools) ]
    then
    echo "This is the IP Address $(ifconfig | grep "inet addr" | head -n1 | cut -d: -f2 | cut -d" " -f1) for this device"
    return 0
    else
    echo "To run this command system must have net-tools installed" >&2
    exit 0
    fi
    
}
function myosversion ()
{
    echo''
    if [ -n $(ls /etc/os-release ) ]
    then
    echo "The OS VERSION of this computer is $(cat /etc/os-release | grep "VERSION_ID" | cut -d\" -f2)"
    return 0
    else
    echo "To run this command system must have /etc/os-release file" >&2
    exit 0
    fi
    
}
function myosname ()
{
    echo ''
    if [ -n $(ls /etc/os-release ) ]
    then
    echo "The OS NAME of this computer is $(cat /etc/os-release | grep "NAME" | head -n1 | cut -d\" -f2)"
    return 0
    else
    echo "To run this command system must have /etc/os-release file" >&2
    exit 0
    fi
        
}
function mycpuinfo ()
{
    echo ''
    echo "The CPU MODEL NAME of this device is $(cat /proc/cpuinfo | grep "model name" | head -n1 | cut -d: -f2 | cut -d" " -f2-6)"
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
    echo "The disk ${ndisk[$i]} has total of ${disks[$i]} space available"
    i=$((i+1))
    done 
    return 0
    
}
function myprinters ()
{
    echo ''
    #Check if cups are installed
    if [ -z $(dpkg-query -l | grep ii | awk '{print  $2}' | grep "^cups" | sort -n |head -1) ]
    then
        echo "cups are not installed" >&2
    else
        service cups status > /dev/null 2>&1
        if [ $? -eq 3 ]
        then
            echo "cups are not running" >&2
            echo "Please start cups to run this command" >&2
        else
            lpstat -a > /dev/null 2>&1
            if [ $? -eq 0 ]
            then
                echo "List of Printers Available"
                echo "=========================="
               echo $(lpstat -a | awk '{print $1}' )
            else
                echo "This computer has no printer" >&2
            fi
        fi
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
function myerror ()
{
    params=0
    while [ $params -lt ${#arg[@]} ]
    do
        case ${arg[$params]} in
        
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
            
            -mymem)         mysysmemory
            ;;
            
            -myds)          mydiskspace
            ;;
            
            -mylp)          myprinters
            ;;
            
            -mysoft)        mysoftwares
            ;;
            
            -help|--h)      myhelp
            ;;
            
            *)              echo "$0: invalid ${arg[$params]}" >&2
                            echo "Try $0 -help or --h"
            ;;
            
        esac
        params=$((params+1))
    done
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
arg=($(echo "$@"))
if [[ -n ${arg[0]} ]]
then
    myerror
else
    mysysname
    mydname
    myipaddress
    myosversion
    myosname
    mycpuinfo
    mydiskspace
    myprinters
    mysoftwares
fi