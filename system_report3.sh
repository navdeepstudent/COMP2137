#!/bin/bash

# Get hostname from /etc/hostname file
HOSTNAME=$(cat /etc/hostname)
USER=$(whoami)

#starting of the report with the current date & time
echo -e "\nSystem Report generated by $USER, $(date +"%Y-%m-%d %H:%M")\n"

echo "System Information"
echo "------------------"
echo "Hostname: $HOSTNAME"
echo "OS: Ubuntu 24"
#tells the uptime of the operation of server 
echo "Uptime: $(uptime -p)"

# Function to get CPU information
hardware_info() {
  #grep - sets line for patterns matching expression
   #awk- used for text extraction and processing 
    cpu_info=$(lshw -class processor 2>/dev/null | grep 'configuration: ' | head -n 1 | awk '{print $3 " / " $5}')
   #lscpu - diplays information about cpu  
    cpu_speed=$(lscpu | grep "CPU MHz" | awk '{print $3}')
    max_cpu_speed=$(lscpu | grep "CPU max MHz" | awk '{print $4}')

    # Function to get RAM information
    ram_info=$(free -h | awk '/^Mem:/{print "Total: " $2 ", Used: " $3 ", Free: " $4 ", Available: " $7}')

    # Function to get disk information
    disk_info=$(lsblk | grep disk | awk '{print $1, $4}')

    # Function to get video card information
    video_info=$(lshw -class video 2>/dev/null | grep 'product: ' | head -n 1 | awk '{print $3}')

    echo -e "\nHardware Information"
    echo "--------------------"
    echo "CPU: $cpu_info"
    echo "Speed: $cpu_speed MHz (Max: $max_cpu_speed MHz)"
    echo "RAM: $ram_info"
    echo "Disk(s): $disk_info"
    echo "Video: $video_info"
}

# Function to get network information
network_info() {
    fqdn=$(hostname)
    host_ip=$(hostname -I)
    gateway_ip=$(ip route | grep default | awk '{print $3}')
    dns_server=$(awk '/nameserver/{print $2}' /etc/resolv.conf)
    #ifconfig- install from net-tools
    interface_name=$(ifconfig | awk '/UP/ && /RUNNING/ {print $1}')
    ip_address=$(ip a show | awk '/inet /{print $2}')

    echo -e "\nNetwork Information"
    echo "-------------------"
    echo "FQDN: $fqdn"
    echo "Host Address: $host_ip"
    echo "Gateway IP: $gateway_ip"
    echo "DNS Server: $dns_server"
    echo "Interface Name: $interface_name"
    echo "IP Address: $ip_address"
}

# Function to get system status information
system_status() {
    users_logged_in=$(who)
    #df - displays all the hard drive or the selected disk related info
    disk_space=$(df -h)
    #ps -e : shows info for all processors
    #wc -l; counts the lines
    process_count=$(ps -e | wc -l)
    load_averages=$(awk '{print $1, $2, $3}' /proc/loadavg)
    #free- displays storage info 
    memory_allocation=$(free -h)
    listening_ports=$(netstat -tuln | awk '/^tcp/ {print $4}' | awk -F: '{print $NF}')
    ufw_rules=$(sudo ufw status numbered)

    echo -e "\nSystem Status"
    echo "-------------"
    echo "Users Logged In: $users_logged_in"
    echo "Disk Space: $disk_space"
    echo "Process Count: $process_count"
    echo "Load Averages: $load_averages"
    echo "Memory Allocation: $memory_allocation"
    echo "Listening Network Ports: $listening_ports"
    echo -e "UFW Rules:\n$ufw_rules"
}

# Main function to generate the report
generate_report() {
    hardware_info
    network_info
    system_status
}

generate_report