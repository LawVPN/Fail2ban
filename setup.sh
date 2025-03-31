#!/bin/bash
clear
apt update
apt install fail2ban ufw -y
echo -e "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓"
echo -e "┃                   FAIL2BAN MENU                   ┃"
echo -e "┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫"
if [ ! -f /etc/fail2ban/jail.local ]; then
    isPortAvailable=$(grep "^Port " /etc/ssh/sshd_config)
    if [ -z "$isPortAvailable" ]; then
        sed -i '/^#Port /s/^#//' /etc/ssh/sshd_config
    fi
    currentPort=$(grep "^Port " /etc/ssh/sshd_config | awk '{print $2}')
    wget -qO /etc/fail2ban/jail.local https://raw.githubusercontent.com/LawVPN/Noobz/refs/heads/main/fail2ban/jail
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
    cd; clear
    echo -e "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓"
    echo -e "┃                   FAIL2BAN MENU                   ┃"
    echo -e "┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫"
    echo -e "┃ Fail2ban is ready to use!"
    echo -e "┃ Type ./log to see the result"
    echo -e "┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫"
    rm /tmp/fail2ban.sh
else
    clear
    echo -e "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓"
    echo -e "┃                   FAIL2BAN MENU                   ┃"
    echo -e "┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫"
    echo -e "┃ [WARN] Fail2ban is configured"
    echo -e "┃ [WARN] Want to re-configure?"
    echo -e "┃ [NOTE] [Y/y] to accept"
    echo -e "┃ [NOTE] [N/n] to decline"
    echo -e "┃ [NOTE] [S/s] to stop Fail2ban and UFW"
    echo -e ""
    echo -ne "Choose: "; read isReConfigure
    if [[ "$isReConfigure" == "Y" || "$isReConfigure" == "y" ]]; then
        systemctl disable fail2ban
        systemctl stop fail2ban
        ufw disable
        rm /etc/fail2ban/jail.local
        wget -O /tmp/fail2ban.sh https://raw.githubusercontent.com/LawVPN/Fail2ban/refs/heads/main/setup.sh
        bash /tmp/fail2ban.sh
    elif [[ "$isReConfigure" == "S" || "$isReConfigure" == "s" ]]; then
        systemctl disable fail2ban
        systemctl stop fail2ban
        ufw disable
    fi
fi
