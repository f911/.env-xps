#!/bin/bash

# =============================================================================
# Copyright (C) 2016 nick All Rights Reserved
# Maintainer:   nick
# Created:      2016-01-24
# LastModify:   2016-03-10
# Version:      v2.0
# Platform:     windows / macosx/ centos / ubuntu / kali
# usage:        bash %
# =============================================================================


REPO_NAME_LIST="highsea racaljk liuker0x007"
CUR_DIR='~/.env_xps'

repo_list=($REPO_NAME_LIST)

_put_info()
{   
    _msg="\n\033[31m\033[40;32m$1 \033[0m"
    echo -e ${_msg}
}
_put_warn()
{
    echo -e "\n\033[31m\033[40;36m$1 \033[0m"
}
_put_error()
{
    echo -e "\n\033[31m\033[40;33m$1 \033[0m"
}

#
# update_hosts_repo repo_name
# --------------------------------
update_single_hosts_repo()
{
    locdir="$1_hosts"
    urlstr="https://github.com/$1/hosts.git"
    echo -e "\n\033[31m\033[40;32m[+] Now updating the $1 hosts repository... \033[0m"
    #echo $locdir
    #echo $urlstr
    if [ ! -d $locdir ]
    then
        echo -e "\n\033[31m\033[40;32m[+] git clone $urlst $locdir \033[0m"
        git clone $urlstr ./$locdir
    else
        echo -e "\n\033[31m\033[40;32m[+] cd $locdir and git pull  \033[0m"
        cd ${CUR_DIR}/$locdir
        git pull
        cd $CUR_DIR
    fi
}


update_and_assemble_final_hosts()
{
    echo > _final_hosts_raw
    echo > _final_hosts

    headline=" 
    # ===========================================================================
    # Copyright (C) 2016 nick All Rights Reserved
    # Maintainer:   nick
    # Created:      2016-01-24
    # LastModify:   $(date +%F\ %r\ %a)
    # Version:      v1.0"
    echo -e "$headline" > _final_hosts_raw

    for i in `seq 1 ${#repo_list[@]}` 
    do
        update_single_hosts_repo ${repo_list[$i-1]}
        cat ${repo_list[$i-1]}_hosts/hosts >> _final_hosts_raw
        dos2unix _final_hosts_raw
    done
    sort -u _final_hosts_raw > _final_hosts
}


#
# 0x01 Detect os type
#
hosts_path=''

detect_ostype_and_load_hosts()
{
    ostype=''
    is_known=1
    hosts_line_count=0

    case "$OSTYPE" in
        linux*) 
            ostype='linux'; 
            hosts_path='/etc/hosts' 
            ;;
        msys*)  
            ostype='msys'  
            hosts_path='/c/Windows/System32/drivers/etc/hosts' 
            ;;
        *)      
        ostype='unknown' 
        is_known=0 
        ;;
    esac

    if [ $ostype=="linux" ]
    then
        _put_info "[+] Writing the system hosts file... "

        user=`whoami`
        if [ "$user" != "root" ]
        then
            _put_warn "[s] backup hosts file"
            su root -c "cat $hosts_path  > ${hosts_path}_bak"
            _put_warn "[s] write the fresh hosts file!"
            su root -c "cat _final_hosts > $hosts_path"
            _put_info "[+] remove temp files."
            rm _final_hosts*
        else
            _put_warn "[s] backup hosts file"
            cat $hosts_path  > ${hosts_path}_bak
            _put_warn "[s] write the fresh hosts file!"
            cat _final_hosts > $hosts_path
            _put_info "[+] remove temp files."
            rm _final_hosts*
        fi
    elif [ $ostype=="msys" ]
    then
        _put_warn "[s] backup hosts file"
        cat $hosts_path  > ${hosts_path}_bak
        _put_warn "[s] write the fresh hosts file!"
        cat _final_hosts > $hosts_path
        _put_info "[+] remove temp files."
        rm _final_hosts*
    else
        _put_error "[-] Unable to detect the OS type!"
        _put_error "[-] Will exit and leave hosts gundam!"
        exit
    fi
}

show_welcome_msg()
{
    _put_info "[*] Today is $(date +%F\ %r\ %a)"
}

show_leave_msg()
{
    _put_info "[O] Done! \n"
    _put_info "[K] The new hosts file have $(cat $hosts_path | wc -l) lines \n"
    _put_info "[!] Good Luck! :D \n"
    head $hosts_path
}

# begin the main procedure
# ========================
main()
{
    show_welcome_msg
    update_and_assemble_final_hosts
    detect_ostype_and_load_hosts
    show_leave_msg
}


main

# vim: se ai si et ts=4 sw=4 ft=sh :
# EOF
