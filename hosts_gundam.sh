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
repo_loc_arr=()
repo_url_arr=()
gen_locdir_and_urlstr_arrays()
{
    for i in `seq 1 ${#repo_list[@]}`
    do
        repo_loc_arr[$i-1]="${repo_list[$i-1]}_hosts"
        repo_url_arr[$i-1]="https://github.com/${repo_list[$i-1]}/hosts.git"
        # for debug
        echo ${repo_loc_arr[$i-1]}
        echo ${repo_url_arr[$i-1]}
    done
    
}


#
# update_hosts_repo loc_dir git_url
# --------------------------------
update_single_hosts_repo()
{
    echo -e "\n\033[31m\033[40;32m[+] Now updating the $1 hosts repository... \033[0m"
    if [ ! -d $1 ]
    then
        git clone $2 ./$1
    else
        cd ${CUR_DIR}/$1
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
        update_single_hosts_repo ${repo_loc_arr[$i-1]} ${repo_url_arr[$i-1]}
        cat ${repo_loc_arr[$i-1]}/hosts >> _final_hosts_raw
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
        linux*) ostype='linux'; hosts_path='/etc/hosts' ;;
        msys*)  ostype='msys' ; hosts_path='/c/Windows/System32/drivers/etc/hosts' ;;
        *)      ostype='unknown'; is_known=0 ;;
    esac
    echo $ostype
    echo $is_known
    echo $hosts_path
    if [ $is_known -eq 1 ]
    then
        echo -e "\n\033[31m\033[40;36m[.] Detect the OS type is $ostype \033[0m"
        echo -e "\n\033[31m\033[40;33m[+] Writing the system hosts file... \033[0m"

        user=`whoami`
        if [ "$user" != "root" ]
        then
            su root -c "cat _final_hosts > $hosts_path"
        fi
    else
        echo -e "\n\033[31m\033[40;33m[-] Unable to detect the OS type! \033[0m"
        echo -e "\n\033[31m\033[40;33m[-] Will exit and leave hosts gundam! \033[0m"
    fi
}


# begin the main procedure
# ========================
main()
{
    echo -e "\n\033[31m\033[40;36m[*] Today is $(date +%F\ %r\ %a)\033[0m"
    
    gen_locdir_and_urlstr_arrays
    update_and_assemble_final_hosts
    detect_ostype_and_load_hosts
    
    echo -e "\n\033[31m\033[40;36m[*] Done! the new hosts file have $(cat $hosts_path | wc -l) lines, Good Luck! :D \033[0m\n"
    head $hosts_path
}


main

# vim: se ai si et ts=4 sw=4 ft=sh :
# EOF
