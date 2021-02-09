#!/bin/bash
Green="\033[32m"
Font="\033[0m"
Red="\033[31m"
echo -e "${Red}安装选项${Font}"
echo -e "${Green}1.安装SSR服务端${Font}"
echo -e "${Green}2.安装SSR客户端${Font}"
echo -e "${Green}3.帮助信息${Font}"
echo -e "${Green}4.退出程序${Font}"
read -p  "请输入需要安装程序的数字："  opt
 
case $opt in
    1)
echo -e "${Green}系统正在安装SSR服务端,请耐心等待${Font}"
echo -e "${Red}请确保您的系统镜像为Centos7.*及外网机器，并且已安装Python，否则程序将会自动退出${Font}"
python –version &>/dev/null
[ $? == 0 ] && echo  系统已安装Python || echo   "系统为安装Python,正在为您安装Python"
yum -y install python python-setuptools &>/dev/null && easy_install pip &>/dev/null
[ $? == 0 ] && echo  安装成功，正在进行配置 || exit 1
pip install shadowsocks &>/dev/null
cat >> /etc/shadowsocks.json << EOF
{
"server":"0.0.0.0",
"local_address": "127.0.0.1",
"local_port":1080,
"port_password": {
"10000": "123",
"10001": "ceshi",
"10002": "ceshi",
"10003": "ceshi",
"10004": "ceshi",
"10005": "ceshi"
},
"timeout":300,
"method":"aes-256-cfb",
"fast_open": false
}
EOF
ssserver -c /etc/shadowsocks.json -d start &>/dev/null
[ $? == 0 ] && echo  -e ${Green}SSR服务端已启用${Font} ||  exit 1
echo -e "${Green}配置文件地址：/etc/shadowsocks.json${Font}"
echo -e "${Red}启动方式：ssserver -c /etc/shadowsocks.json -d start${Font}"
echo -e "${Red}关闭方式：ssserver -d stop${Font}"
        ;;
    2)
echo -e "${Red}正在为您的Centos7服务器设置SSR客户端,请确保系统已经安装Python,请稍后${Font}"
sudo yum -y install python-pip >/dev/null && sudo pip install shadowsocks >/dev/null
sudo mkdir /etc/shadowsocks
echo '{"server":"8.210.224.199","server_port":10004,"local_address": "127.0.0.1","local_port":1080,"password":"ceshi","timeout":300,"method":"aes-256-cfb","fast_open": false,"workers": 1}' >/etc/shadowsocks/shadowsocks.json
cat >/etc/systemd/system/shadowsocks.service <<eof
[Unit]
Description=Shadowsocks
[Service]
TimeoutStartSec=0
ExecStart=/usr/bin/sslocal -c /etc/shadowsocks/shadowsocks.json
[Install]
WantedBy=multi-user.target
eof
systemctl enable shadowsocks.service >/dev/null
systemctl start shadowsocks.service
sudo yum -y install privoxy >/dev/null
systemctl enable privoxy >/dev/null

echo -e "forward-socks5t / 127.0.0.1:1080 ." >> /etc/privoxy/config
systemctl start privoxy
echo -e "export http_proxy=http://127.0.0.1:8118" >>/etc/profile
echo -e "export https_proxy=http://127.0.0.1:8118" >>/etc/profile
source /etc/profile
echo -e "${Red}请开始你的niubi之旅${Font}"
        ;;
    3)
        echo "使用说明: bash $0 {1|2|4}."
        ;;
    4)
        exit 1
        ;;     
    *)
        echo -e "${Red}别不识好歹，我他妈直接捶死你，都写的这么明白了，你还不知道怎么操作，找个班上吧求你了，实在不行，找个牢做吧。${Font}"
esac 
 


