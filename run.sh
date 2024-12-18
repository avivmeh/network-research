#!/bin/bash

#Student name - Aviv Feldvari
#Student code - s16
#Class Code - 7736/26
#Lecturer name - Erel Regev

echo "Welcome to Aviv Feldvari's NR Project"

# Installations - asking user if he wants to install packages, if yes, install the missing ones.
package_list=( "curl" "cpanminus" "git" "nmap" "whois" "geoip-bin" "sshpass" "tor")
function installations(){
function INSTALL_DEPENDENCIES(){
    for package_name in "${package_list[@]}"; do
        dpkg -s "$package_name" >/dev/null 2>&1 || 
        (echo -e "[*] installing $package_name..." &&
        sudo apt-get install "$package_name" -y >/dev/null 2>&1)
        echo "[#] $package_name installed on remote host."

    done
}
function INSTALL_NIPE(){
    if ! [ -d ./.nipe ]; then 
        echo '[*] installing NIPE...'
        git clone https://github.com/htrgouvea/nipe .nipe >/dev/null 2>&1 &&
        cd .nipe >/dev/null 2>&1 &&
        cpanm --installdeps . >/dev/null 2>&1 &&
        sudo perl nipe.pl install >/dev/null 2>&1
    fi
        echo '[#] NIPE installed on remote host.'
}
INSTALL_DEPENDENCIES
INSTALL_NIPE
}

echo -e "[?] Do you want to install packages? \nY - Yes\nN - No"
read install

case $install in
	Y)
	installations
	;;
	y)
	installations
	;;
	N)
	echo "[!] I sure hope you have everything installed"
	;;	
	n)
	echo "[!] I sure hope you have everything installed"
	;;
esac
sleep 1

# Anonymity - Printing local ip, starting nipe, if the ip has changed, Print new ip. if not, exit script
function anonymity(){
cd $(locate -n 1 nipe) || { echo "[-] Nipe wasn't installed correctly on this machine, exiting"; exit 1; }
sudo perl nipe.pl stop 
mainip=$(sudo perl nipe.pl status | grep "Ip"| awk '{print $3}')
echo "This is the local machine ip: $mainip"
echo "Trying to anonymize.."
# Start tor and nipe
# Tor
sudo service tor stop >/dev/null 2>&1 &&
sudo systemctl enable tor.service >/dev/null 2>&1 &&
sudo systemctl restart tor.service >/dev/null 2>&1 &&

# Nipe
cd $(locate -n 1 nipe) || exit 1
sudo perl nipe.pl start 

# New ip address into var
newip=$(sudo perl nipe.pl status | grep "Ip"| awk '{print $3}')

# Compare old and new ip's, if same, exit script, if not, Success, the script continues to run
if [ "$newip" == "$mainip" ];
then {echo "[-] Error, ip is still $newip, Exiting" && exit 1}
else echo "[+] Success, your new ip is: $newip"
	# Set country as a variable, and print 
	country=$(geoiplookup  $newip | awk -F ': ' '{print $2}')
	echo "Currnet ip country - $country"
fi
}

#Anonymity

echo -e "[?] Do you want to become anonymous? \nY - Yes\nN - No"
read anonymous

case $anonymous in
	Y)
	anonymity
	;;
	y)
	anonymity
	;;
	N)
	echo "[!] You won't be anonymous, Danger!"
	;;
	n)
	echo "[!] You won't be anonymous, Danger!"
	;;
esac
sleep 1

echo
echo "[Remote Machine Connection]"

echo "[+] Enter the remote server ip address"
read remip
echo "[+] Enter the remote user name"
read user
echo "[+] Enter the remote user password"
read -s pass
echo 
sleep 1

# Connect to the remote address and create a folder to
	echo "[*] Connecting to the remote server.."
	sleep 1
	echo

# Print remote address information
	echo "[~] Remote address information:"
	sshpass -p "$pass" ssh -o StrictHostKeyChecking=no $user@$remip "echo \"Remote ip address is - \$(curl -s ifconfig.io)\"" #echo ip address
	country=$(sshpass -p "$pass" ssh -o StrictHostKeyChecking=no $user@$remip "geoiplookup \$(curl -s ifconfig.io) | awk -F ':' '{print \$2}'")
	echo "Remote country is -$country" #echo country
	sshpass -p "$pass" ssh -o StrictHostKeyChecking=no $user@$remip "echo 'Remote uptime:$(uptime)'"	#echo uptime
	echo
	sleep 1
	
	echo "[+] Creating folders to save output files"
	sudo rm -rf ~/Desktop/proutput/	>/dev/null 2>&1
	sshpass -p "$pass" ssh -o StrictHostKeyChecking=no $user@$remip "sudo -S rm -rf ~/Desktop/prfiles"
	sleep 1
	sshpass -p "$pass" ssh -o StrictHostKeyChecking=no $user@$remip "mkdir -p ~/Desktop/prfiles"	#make files directory
	echo
	sleep 1
# Scan target's info with whois
function whois(){
	echo "[*] Scanning target's whois information"
	sshpass -p "$pass" ssh -o StrictHostKeyChecking=no $user@$remip "whois $scantar > ~/Desktop/prfiles/whois.txt  && echo '[@] Scan target whois information was saved to $HOME/Desktop/prfiles/whois.txt'"
	#Log the scan into nr.log
	sudo echo -e $(date) "- [*] Whois data collected for: $scantar" >> /var/log/nr.log
	echo "[@] Scan logged into /var/log/nr.log"
}
# Scan target with nmap
function nmap(){
	echo "[*] Scanning target's address with nmap"
	
	sshpass -p "$pass" ssh -o StrictHostKeyChecking=no $user@$remip "nmap $scantar -sV -oG ~/Desktop/prfiles/nmapscan.txt >/dev/null 2>&1 && echo '[@] Scan target whois information was saved to $HOME/Desktop/prfiles/nmapscan.txt'"
	#Log the scan into nr.log
	echo $(date) "- [*] Nmap data collected for: $scantar" >> /var/log/nr.log
	echo "[@] Scan logged into /var/log/nr.log"
}

# Get scan target info from user
echo "[+] Enter the scan target address"
read scantar

echo -e "[?] What do you want to scan?\n 1 - Whois\n 2 - Nmap\n 3 - Both"
read scan
case $scan in
	1)
	whois
	;;
	"Whois")
	whois
	;;
	2)
	nmap
	;;
	"Nmap")
	nmap
	;;
	3)
	nmap
	whois
	;;
	"Both")
	echo ""
	nmap
	whois
	;;
esac

# Local file output folder
echo
echo "[@] File saving"
echo -e "[?] Do you want to use default folder location, or custom?\n 1 - Default\n 2 - Custom "
read outlocation
case $outlocation in
	1)
	folocation="/home/kali/Desktop/output/"
	;;
	2)
	echo "Type full folder location"
	read folocation
	;;
	esac
	

mkdir $folocation	>/dev/null 2>&1
# Copy output files to local machine
sshpass -p "$pass" scp $user@$remip:/home/kali/Desktop/prfiles/* $folocation	>/dev/null 2>&1
echo "[@] Output files saved to $folocation"

# Log file
echo -e "[?] Do you want to copy auth.log file before erasing?\n Y - Yes\n N - No"
read auth
case $auth in
	Y)
	echo "[@] Saving auth.log file from remote server"
	sudo sshpass -p "$pass" scp $user@$remip:/var/log/auth.log* $folocation
	;;
	y)
	echo "[@] Saving auth.log file from remote server"
	sudo sshpass -p "$pass" scp $user@$remip:/var/log/auth.log* $folocation
	;;
	N)
	echo "Sure, moving on.."
	;;
	n)
	echo "Sure, moving on.."
	;;
esac


# Deleting auth.log contents
	echo "Erasing auth.log file contents from remote machine"
	sshpass -p "$pass" ssh -o StrictHostKeyChecking=no -t $user@$remip "sudo sh -c 'nohup truncate -s 0 /var/log/auth.log*'"	
# Stopping nipe
cd $(locate -n 1 nipe)
sudo perl nipe.pl stop
 
 
# Ending
echo -e "Do you want to start again or exit?\n	[1] - Start Again\n	[2] - Exit"
read end
case $end in
1)
sudo bash $(find / -type f -name re.sh 2>/dev/null)
;;
2)
echo "Goodbye!"
;;
esac





