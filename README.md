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

### Changing user@host color
Not really needed but you can try to coloring your terminal
Put this into .profile or .bashrc
```
PS1="\n\[\e[01;33m\]\u\[\e[0m\]\[\e[00;37m\]@\[\e[0m\]\[\e[01;36m\]\h\[\e[0m\]\[\e[00;37m\] \t \[\e[0m\]\[\e[01;35m\]\w\[\e[0m\]\[\e[01;37m\] \[\e[0m\]\n$ "
```
