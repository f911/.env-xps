#!/bin/bash

# =============================================================================
# Copyright (C) 2016 nick All Rights Reserved
# Maintainer:   nick
# Created:      2016-01-24
# LastModify:   2016-02-29
# Version:      v1.0
# Platform:     windows / macosx/ centos / ubuntu / kali
# usage:        bash %
# =============================================================================


REPO_NAME_LIST="highsea racaljk liuker0x007"
repo_list=($REPO_NAME_LIST)
repo_loc_arr=()
repo_url_arr=()

gen_loc_and_url_arr()
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
update_hosts_repo()
{
    echo -e "\n\033[31m\033[40;32m[+] Now updating the $1 hosts repository... \033[0m"
    if [ ! -d "$1"_hosts ];
    then
        git clone $2 ./$1
    fi
    cd $1
    git fetch --all
    git pull -f
    cd ..
}


assemble_hosts()
{
    touch _final_hosts_raw
    touch _final_hosts
    for i in `seq 1 ${#repo_list[@]}` 
    do
        update_hosts_repo ${repo_loc_arr[$i-1]} ${repo_url_arr[$i-1]}
        cat ${repo_loc_arr[$i-1]}/hosts >> _final_hosts_raw
    done
    sort -u _final_hosts_raw > _final_hosts
}


#
# 0x01 Detect os type
#
detect_os_type()
{
    ostype=''
    hosts_path=''
    is_known=1
    case "$OSTYPE" in
        linux*) ostype='linux'; hosts_path='/etc/hosts' ;;
        msys*)  ostype='msys' ; hosts_path='/c/Windows/System32/drivers/etc/hosts' ;;
        *)      ostype='unknown'; is_known=0 ;;
    esac

    if $is_known
    then
        echo -e "\n\033[31m\033[40;33m[.] Detect the OS type is $ostyp \033[0m"
        echo -e "\n\033[31m\033[40;33m[+] Writing the system hosts file... \033[0m"
        cat _final_hosts > $hosts_path
    else
        echo -e "\n\033[31m\033[40;33m[.] Detect the OS type is $ostyp \033[0m"
}


# begin the main procedure
# ========================

echo -e "\n\033[31m\033[40;36m[*] Today is $(date +%F\ %r\ %a)\033[0m"

gen_loc_and_url_arr
update_




# vim: se ai si et ts=4 sw=4 ft=sh :
# EOF
