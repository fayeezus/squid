#!/bin/bash

install_env(){
    apt-get update && apt install squid apache2-utils 
    rm -f /etc/squid3/squid.conf
    cp squid.conf /etc/squid3/squid.conf
    touch /etc/squid3/squid_passwd
    touch /etc/squid3/squid_users
    squid3 -k reconfigure
}
    
create_user(){
    htpasswd  /etc/squid3/squid_passwd $NEW_USER
    squid3 -k reconfigure
    printf "\ndone...\n"
}

add_ip(){
    echo "$IP" >> /etc/squid3/squid_users
    squid3 -k reconfigure
    printf "\ndone...\n"
}

dell_ip(){
    sed -i -e "/^$IP/d" /etc/squid3/squid_users
    squid3 -k reconfigure
    printf "\ndone...\n"
}

dell_user(){
    sed -i -e "/^$NEW_USER/d" /etc/squid3/squid_passwd
    squid3 -k reconfigure
    printf "\ndone...\n"
}

add_proxy_port(){
    sed -i '1 ihttp_port '$PORT'' /etc/squid3/squid.conf
    squid3 -k reconfigure
    printf "\ndone...\n"
}

dell_proxy_port(){
    sed -i -e "/^http_port '$PORT'/d" /etc/squid3/squid.conf
    squid3 -k reconfigure
    printf "\ndone...\n"
}

while [ true ]

do

printf "[0]install and conf proxi\n[1]add user\n[2]add ip\n[3]dell ip\n[4]dell user\n[5]add port\n[6]dell port\n[7]exit\n";
read ANSWER;


case "$ANSWER" in
     
     0  )
    install_env
    ;;
    
    1  )
    printf "enter new user name: "
    read NEW_USER
    create_user
    ;;
    
    2  )
    printf "enter new IP: "
    read IP
    add_ip
    ;;
    
    3  )
    printf "enter IP to dell: "
    read IP
    dell_ip
    ;;
    
    4  )
    printf "enter name to dell: "
    read NEW_USER
    dell_user
    ;;
    
    5  )
    printf "port in use: \n$(grep port /etc/squid3/squid.conf)\n"
    printf "enter new port: "
    read PORT
    add_proxy_port 
    ;;
    
    6  )
    printf "port in use: \n$(grep port /etc/squid3/squid.conf)\n"
    printf "enter port to dell: "
    read PORT
    dell_proxy_port 
    ;;    
        
    7  )
    exit    
    ;;
    
    *  )
    printf "wrong input..."
    exit
    ;;
esac    
done
