#!/bin/bash
clear
echo -e "$BC┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓"
echo -e "┃$GB1                   ${BW}FAIL2BAN MENU                   $RR$BC┃"
echo -e "$BC┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫"
if [ ! -f /etc/fail2ban/jail.local ]; then
    isPortAvailable=$(grep "^Port " /etc/ssh/sshd_config)
    if [ -z "$isPortAvailable" ]; then
        sed -i '/^#Port /s/^#//' /etc/ssh/sshd_config
    fi
    currentPort=$(grep "^Port " /etc/ssh/sshd_config | awk '{print $2}')
    wget -qO /etc/fail2ban/jail.local https://github.com/LawVPN/Noobz/raw/refs/heads/main/fail2ban/jail
    sed -i 's/^port =.*/port = '"$currentPort"'/' /etc/fail2ban/jail.local
    ufwConf=$(cat /etc/fail2ban/action.d/ufw.conf | grep "blocktype = " | awk '{print $3}')
    if [[ "$ufwConf" == "reject" ]]; then
        sed -i "s/^blocktype = reject/blocktype = deny/" /etc/fail2ban/action.d/ufw.conf
    fi
    ufw default deny
    ufw allow 443
    ufw allow 80
    ufw allow $currentPort
    ufw enable
    systemctl enable fail2ban
    systemctl restart fail2ban
    rm /root/log
    echo -e '#!/bin/bash' > /root/log
    echo -e "clear" >> /root/log
    echo -e "fail2ban-client status sshd" >> /root/log
    echo -e "tail -f /var/log/fail2ban.log" >> /root/log
    chmod +x /root/log
else
    echo -e "$BC┃ $BY[WARN]$BW Fail2ban is configured"
    echo -e "$BC┃ $BY[WARN]$BW Want to re-configure?"
    echo -e "$BC┃ $BB1[NOTE]$BW [Y/y] to accept"
    echo -e "$BC┃ $BB1[NOTE]$BW [N/n] to decline"
    echo -e "$BC┃ $BB1[NOTE]$BW [S/s] to stop Fail2ban and UFW"
    echo -e ""
    echo -ne "Choose: "; read isReConfigure
    if [[ "$isReConfigure" == "Y" || "$isReConfigure" == "y" ]]; then
        systemctl disable fail2ban
        systemctl stop fail2ban
        ufw disable
        rm /etc/fail2ban/jail.local
        fail2banMenu
    elif [[ "$isReConfigure" == "S" || "$isReConfigure" == "s" ]]; then
        systemctl disable fail2ban
        systemctl stop fail2ban
        ufw disable
    fi
fi
