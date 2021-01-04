#!/bin/bash
Green="\033[32m"
Font="\033[0m"
Red="\033[31m"
echo -e "${Red}系统正在初始化,请耐心等待,请确保您的系统为Centos7*${Font}"
echo -e "${Green}初始化内容包括:关闭系统SELINUX,关闭系统防火墙,更新YUM源为国内阿里云YUM源,优化命令行显示,安装常用软件,时间同步,Docker等.${Font}"
echo "export PS1='[\[\e[32;1m\]\h-\[\e[31;1m\]\A \[\e[36;1m\]\w\[\e[m\]]$ '" >> /etc/profile
source /etc/profile
rm -rf /etc/yum.repos.d/*
curl -so /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo >/dev/null
curl -so /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo >/dev/null
yum repolist &>/dev/null
yum install -y tree  wget bash-completion vim java  bash-completion-extras  lrzsz net-tools sysstat iotop iftop htop unzip  telnet  ntpdate >/dev/null
ntpdate time1.aliyun.com >/dev/null
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun &>>/dev/null
systemctl start docker 
cat >> /etc/docker/daemon.json << EOF
{
    "graph": "/data/docker",
    "storage-driver": "overlay2",
    "insecure-registries": ["registry.access.redhat.com","quay.io","harbor.kococ.cn"],
    "registry-mirrors": ["https://q2gr04ke.mirror.aliyuncs.com"],
    "exec-opts": ["native.cgroupdriver=systemd"],
    "live-restore": true
}
EOF
systemctl restart docker
echo -e "${Green}初始化完成,请正常使用${Font}"
