#!/bin/bash 
#Put the location of where you want to log the actions
touch system_admin_dashboard.log
log_file="system_admin_dashboard.log"

# Function to log actions
log_action() {
    echo "$(date) ----> $1" >> $log_file
}

main_menu() {
    echo "============================================="
    echo "Welcome to the System Administation Dashboard"
    echo "============================================="
    echo "1. System Information"
    echo "2. User Management"
    echo "3. Process Management"
    echo "4. Service Management"
    echo "5. Network Information"
    echo "6. Log Analysis"
    echo "7. Backup Utility"
    echo "8. System Update"
    echo "9. Exit"
    echo "============================================="
    read -p "Enter your choice [1-9]: " choice

    case $choice in
        1) sys_info ;;
        2) user_management ;;
        3) process_management ;;
        4) service_management ;;
        5) network_info ;;
        6) log_analysis ;;
        7) backup_utility ;;
        8) system_update ;;
        9)
            echo "Exiting now. Bye bye."
            exit 1
            ;;
        *) echo "Invalid choice, try again." ; sleep 1 ; main_menu ;; 
    esac
}


sys_info() {
    clear
    echo "===== System Information ====="
    echo "OS Version: $(uname -o) $(lsb_release -d | cut -f2)"
    echo "Kernel Version: $(uname -r)"
    echo "CPU Information: $(lscpu | grep 'Model name')"
    echo "Memory Usage: $(free -h | grep 'Mem' | awk '{print $3 "/" $2}')"
    echo "Disk Usage: $(df -h | grep '^/dev')"
    log_action "Viewed system information"
    read -p "Press Enter to return to the main menu..."
    clear
    main_menu
}
user_management() {
    clear
    echo "===== User Management ====="
    echo "1. List all users"
    echo "2. Add a new user"
    echo "3. Delete a user"
    echo "4. Modify user properties"
    echo "5. Back to main menu"
    read -p "Choose an option: " choice
    case $choice in
        1) list_users ;;
        2) add_user ;;
        3) delete_user ;;
        4) modify_user ;;
        5) main_menu ;;
        *) echo "Invalid choice, try again." ; sleep 1; user_management ;;
    esac
}

#Function to list users 
list_users() {
    echo "Listing all users:"
    cat /etc/passwd | cut -d ':' -f1
    log_action "Listed all users"
    read -p "Press enter to return to the user management menu..."
    clear
    user_management
}

# Function to add a new user
add_user() {
    read -p "Enter the username of the user you want to add: " username
    read -p "Enter the password of the user: " password
    sudo useradd $username && sudo passwd $password
    log_action "Added user $username"
    echo "User $username added successfully!"
    read -p "Press Enter to return to the user management menu..."
    clear
    user_management
}

# Function to delete a user
delete_user() {
    read -p "Enter the username of the user that you want to delete: " username
    sudo userdel -r $username
    log_action "Deleted user $username"
    echo "User $username deleted successfully!"
    read -p "Press Enter to return to the user management menu..."
    clear
    user_management
}

#Function to modify user properties 
modify_user() {
    echo "1. Change password"
    echo "2. Add user to group"
    echo "3. Back"
    read -p "Choose an option: " choice
    case $choice in
        1) change_password ;;
        2) add_to_group ;;
        3) user_management ;;
        *) echo "Invalid choice" ; sleep 1; modify_user ;;
    esac
}

#Function to change user password
change_password() {
    read -p "Enter the username that you want to change password for: " username
    read -p "Enter the new password you want for the user: " password
    sudo passwd $password
    log_action "Changed password for user $username"
    read -p "Press Enter to return to the modify user menu..."
    clear
    modify_user
}

# Add user to a group
add_user_to_group() {
    read -p "Enter the username of the user: " username
    read -p "Enter the group: " group
    sudo usermod -a -G $group $username
    log_action "Added $username to group $group"
    read -p "Press Enter to return to the modify user menu..."
    clear
    modify_user
}
#Function for managing processes
process_management() {
    clear
    echo "===== Process Management ====="
    echo "1. List top CPU-consuming processes"
    echo "2. Kill a process by PID"
    echo "3. Back to main menu"
    read -p "Choose an option: " choice
    case $choice in
        1) top_processes ;;
        2) kill_process ;;
        3) main_menu ;;
        *) echo "Invalid choice, try again." ; sleep 1; process_management ;;
    esac
}

# List top CPU-consuming processes
top_processes() {
    ps -eo pid,comm,%cpu --sort=-%cpu | head -n 10
    log_action "Listed top CPU-consuming processes"
    read -p "Press Enter to return to the process management menu..."
    clear
    process_management
}

# Kill process by PID
kill_process() {
    read -p "Enter PID of the process you want to kill: " pid
    sudo kill -9 $pid
    log_action "Killed process with PID $pid"
    echo "Process $pid killed!"
    read -p "Press Enter to return to the process management menu..."
    clear
    process_management
}

#Function for service management
service_management() {
    clear
    echo "===== Service Management ====="
    echo "1. List all services"
    echo "2. Start a service"
    echo "3. Stop a service"
    echo "4. Restart a service"
    echo "5. Back to main menu"
    read -p "Choose an option: " choice
    case $choice in
        1) list_services ;;
        2) start_service ;;
        3) stop_service ;;
        4) restart_service ;;
        5) main_menu ;;
        *) echo "Invalid choice, try again." ; sleep 2; service_management ;;
    esac
}

# List all services
list_services() {
    systemctl list-units --type=service
    log_action "Listed all services"
    read -p "Press Enter to return to the service management menu..."
    clear
    service_management
}

# Start a service
start_service() {
    read -p "Enter the name of the service to start: " service
    sudo systemctl start $service
    log_action "Started service $service"
    echo "Service $service started!"
    read -p "Press Enter to return to the service management menu..."
    clear
    service_management
}

# Stop a service
stop_service() {
    read -p "Enter the name of the service you want to stop: " service
    sudo systemctl stop $service
    log_action "Stopped service $service"
    echo "Service $service stopped!"
    read -p "Press Enter to return to the service management menu..."
    clear
    service_management
}

# Restart a service
restart_service() {
    read -p "Enter the name of the service you want to restart: " service
    sudo systemctl restart $service
    log_action "Restarted service $service"
    echo "Service $service restarted!"
    read -p "Press Enter to return to the service management menu..."
    clear
    service_management
}

#Function to display the network information
network_info() {
    clear
    echo "===== Network Information ====="
    echo "IP Configuration:"
    ip addr
    echo "Active network connections:"
    netstat -tuln
    log_action "Viewed network information"
    read -p "Press Enter to return to the main menu..."
    clear
    main_menu
}

log_analysis() {
    clear
    echo "===== Log Analysis ====="
    echo "1. View recent logs"
    echo "2. Back to main menu"
    read -p "Choose an option: " choice
    case $choice in
        1) view_logs ;;
        2) main_menu ;;
        *) echo "Invalid choice, try again." ; sleep 1; log_analysis ;;
    esac
}
view_logs() {
    tail -n 50 /var/log/syslog
    log_action "Viewed recent system logs"
}
#Functon for backup utility
backup_utility() {
    clear
    echo "===== Backup Utility ====="
    echo "1. Create backup"
    echo "2. Restore from a backup"
    echo "3. Go back to main menu"
    read -p "Choose an option: " choice
    case $choice in
        1) create_backup ;;
        2) restore_backup ;;
        3) main_menu ;;
        *) echo "Invalid choice, try again." ; sleep 1; backup_utility ;;
    esac
}
# Function to create a backup of specified directories
create_backup() {
    read -p "Enter directory to back up: " dir
    read -p "Enter the location where you want to backup the directory: " backup_location
    sudo tar -czf "$backup_location/backup_$(date).tar.gz" $dir
    log_action "Created backup of $dir"
}

# Function to restore from a backup
restore_backup() {
    read -p "Enter the name of the backup file that you want restore: " backup_file
    read -p "Enter the destination directory: " destination
    sudo tar -xzf "$backup_file" -C "$destination"
    log_action "Restored backup from $backup_file"
}

#Function to check for updates and update packages
system_update() {
    # Check for update
    echo "$(date): Checking for updates..."
    # Update the package list
    sudo apt update
    if [ $? -eq 0 ]; then
       echo "$(date): Updates installed successfully."
    else
       echo "$(date): There was an error during the update."
    fi

}
#Call the main menu function 
main_menu
