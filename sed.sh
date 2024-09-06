nmap -sn 172.17.2.0/24 | grep Nmap | awk '{print $5, $6}' | grep "\-c-"| awk '{print $2}' | sed 's/[()]//g' | sed '$!s/$/,/'
