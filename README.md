## To install
```
apt update && apt install -y fail2ban ufw
```
## To configure
```
wget -O /tmp/fail2ban.sh https://raw.githubusercontent.com/LawVPN/Fail2ban/refs/heads/main/setup.sh && bash /tmp/fail2ban.sh
```

## IMPORTANT
Since this configuration using several ports `ssh, http, https`, if you are about to change the SSH port, make sure to install this script again!
