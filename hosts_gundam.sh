<<<<<<< HEAD
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


echo -e "\n\033[31m\033[40;36m[*] Today is $(date +%F\ %r\ %a)\033[0m"




#
# 0x01 Detect os type
#
detect_os_type()
{
    case "$OSTYPE" in
        linux*) echo "linux" ;;
        msys*)  echo "msys"  ;;
    esac

}

#
# update_hosts_repo loc_dir git_url
#
update_hosts_repo()
{
    echo -e "\n\033[31m\033[40;36m[+] Now updating the $1 hosts repository... \033[0m"
    if [ ! -d "$1"_hosts ];
    then
        git clone $2 ./$1
    fi
    cd $1
    git pull -f
    cd ..
}
REPO_NAME_LIST="highsea racaljk liuker0x007"
repo_list=($REPO_NAME_LIST)
repo_loc_arr=(1 2 3)
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




detect_os_type

gen_loc_and_url_arr



# vim: se ai si et ts=4 sw=4 ft=sh :
# EOF
=======
#!/bin/bashfunction detect_os_type{    case "$OSTYPE"    esac}# $1=loc_dir $2=git_urlfunction update_hosts_repo{     }function # vim: se ai si et ts=4 sw=4 ft=sh :# EOF
>>>>>>> ec4e8931ce57110ae3f8d12a82e86d5ba399a5ac
