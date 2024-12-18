NR Project

Author: Aviv Feldvari

Project Description:
The NR Project is a comprehensive script designed to:
- Install the necessary packages to enable its functionality on any computer.

- Establish an anonymous connection to a remote address.

- Perform a detailed scan of a user-inputted target address to gather information and identify open ports.

- Minimize the footprint left on the remote address after execution.

This project provides tools for effective scanning while ensuring anonymity and securing local and remote data.

Functionality:
Project's Mission:
The mission of this project is to:
Install required dependencies automatically.
Connect to remote addresses anonymously.
Scan target addresses and retrieve detailed information.
Save the data securely with minimal traces left on the remote machine.

Script Sections:
Installations:
The script checks for and installs essential packages required for the project. These include:
curl
cpanminus
git
nmap
whois
geoip-bin
sshpass
tor

If any package is missing, the script automatically installs it to ensure seamless functionality.

Anonymity:

The script retrieves and displays the local IP address.
It starts Nipe to enable anonymous browsing.
After activation, the script compares the new IP address with the original local IP.
If the IPs are the same, Nipe isn’t functioning correctly, and the script alerts the user before exiting.
If the IPs differ, Nipe is successfully running, ensuring anonymity.
Remote Machine Connection:
The script prompts the user to input:
Remote address
Username
Password

Once connected to the remote machine, it displays:
IP address
Country
System uptime

Scanning:

The script asks the user to specify a target address for scanning.
Scanning options include:
Nmap Scan
Whois Lookup
Both
The scan results are saved to the remote machine for review.
Additionally, the script logs the scan information and timestamps into a local log file for record-keeping.

File Saving:

The script provides flexibility in saving files:
Use the default location.
Specify a custom location.

Log File Management:

Optionally, the script can copy the auth.log file from the remote server to the local machine.
For enhanced security, the script automatically clears the contents of the auth.log file on the remote machine after copying.

How to Run the Script:

Ensure the script has executable permissions:
chmod +x script.sh

Run the script:
./script.sh

Follow the on-screen prompts to:

Install required packages.
Enable anonymity.
Connect to remote machines.
Perform scans and manage files/logs.

Requirements:

Operating System: Linux-based distribution.
Installed dependencies (if not, the script installs them automatically).
Internet connection for package installation and remote connection.
Access credentials for the remote machine.

Notes:

Ensure you have the appropriate permissions to connect to the remote machine.
Use this script responsibly and within the boundaries of the law.

Acknowledgments:
Thank you for reviewing this project. For any questions or feedback, feel free to reach out!

