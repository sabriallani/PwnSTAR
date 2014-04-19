#!/bin/bash

warn="\e[1;31m"      # warning           red
info="\e[1;34m"      # info              blue
q="\e[1;32m"         # questions         green
inp="\e[1;36m"       # input variables   magenta

echo -e "$info\n      PwnSTAR INSTALLER"
echo -e "$info\n      =================\n"
echo -e "$warn\nRun this installer from the same directory as the git clone\n"
echo -e "$q\nWhere are we installing PwnSTAR? e.g. /opt"
read var
if [[ ! $var =~ ^/ ]];then  # if "/" is ommitted eg "opt"
    var="/""$var"           # then add it
fi
if [[ ! -d $var/PwnSTAR/ ]];then
    mkdir $var/PwnSTAR/
fi
chmod 744 PwnSTAR && cp -bi --preserve PwnSTAR $var/PwnSTAR/
cp How_to_use.txt $var/PwnSTAR/
if [[ -x $var/PwnSTAR ]];then
    echo -e "$info\nPwnSTAR installed to $var\n"
else
    echo-e "$warn\nFailed to install PwnSTAR!\n"
fi

if [[ ! -x /usr/sbin/dhcpd ]];then
    echo -e "$q\nInstall isc-dhcp-server? (y/n)"
    read var
    if [[ $var == y ]];then
        apt-get install isc-dhcp-server
    fi
else
  echo -e "$info\nIsc-dhcp-server already present"
fi

if [[ ! -e /usr/sbin/incrond ]];then 
    echo -e "$q\nInstall incron?"
    read var
    if [[ $var == y ]];then
        apt-get install incron
    fi
else
    echo -e "$info\nIncron already present\n"
fi

echo -e "$info\nSetting web page permissions"
for folder in $(find $PWD -maxdepth 1 -mindepth 1 -type d); do 
    chgrp -R www-data $folder
    chmod -f 774 $folder/*.php
    chmod -f 664 $folder/formdata.txt
    cp -Rb --preserve $folder /var/www/
    if [[ $? == 0 ]];then
        echo -e "$info\n$folder moved successfully"
    else
        echo -e "$warn\nError moving $folder!\nPlease check manually"
    fi
done

echo -e "$info\nFinished. If there were no error messages, you can safely delete the git clone"

exit 0
