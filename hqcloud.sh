#! /bin/bash
###############################################
##
##  Copyright (2022, ) Huaqingcloud
##
###############################################

nic="eth0"

ntpd="127.0.0.1"

ports=""  #example: "179/tcp 5138/tcp 2379-2380/tcp 2375/tcp "

repo="127.0.0.1"

get-ip()
{
  echo $(ifconfig eth0 | grep "inet " | awk '{print$ 2}')
}

function set-zone()
{
  if [[ -f /etc/localtime ]]
  then
    rm -rf /etc/localtime
  fi

  ln -s /usr/share/zoneinfo/GMT /etc/localtime
}

function set-ntpd
{
  yum install ntp -y
  output=$(cat /etc/crontab | grep $ntpd)
  if [[ -z $output ]]
  then
     echo "0 * * * * /usr/sbin/ntpdate $ntpd  && /sbin/hwclock --systohc > /dev/null 2>&1" >> /etc/crontab 
  fi
}

function set-charset
{
  output=$(cat /etc/profile | grep zh_CN.UTF-8)
  if [[ -z $output ]]
  then
    echo "export LANG="zh_CN.UTF-8" " >> /etc/profile 
    echo "export PATH=/opt/kube/bin:$PATH" >> /etc/profile
    source /etc/profile
  fi
}

function set-firewalld
{
  systemctl start firewalld
  systemctl enable firewalld

  if [[ -n $ports ]]
  then
    for i in $ports
    do
      echo "firewall-cmd --zone=public --add-port=$i --permanent"
    done
    firewall-cmd --reload
  fi
}

function set-repo
{
  echo "[yum]" > /etc/yum.repos.d/ll.repo
  echo "name=yum local" >> /etc/yum.repos.d/ll.repo
  echo "baseurl=ftp://$repo/pub" >> /etc/yum.repos.d/ll.repo 
  echo "enabled=1" >> /etc/yum.repos.d/ll.repo
  echo "gpgcheck=0" >> /etc/yum.repos.d/ll.repo
}

function help()
{
  echo -e "Commands:"
  echo -e "  set-zone             :\t(Setting): zone"
  echo -e "  set-ntpd             :\t(Setting): ntpd"
  echo -e "  set-charset          :\t(Setting): charset"
  echo -e "  set-firewalld        :\t(Setting): firewalld"
  echo -e "  set-repo             :\t(Setting): repo"
}

case $1 in
  "set-zone")
    set-zone $*
    ;;
  "set-ntpd")
    set-ntpd $*
    ;;
  "set-charset")
    set-charset $*
    ;;
  "set-firewalld")
    set-firewalld $*
    ;;
  "set-repo")
    set-repo $*
    ;;
  *)
  help
  ;;
esac



