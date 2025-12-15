#!/bin/bash

install_nginx() {
    if [ -f /etc/nginx/nginx.conf ]; then
        echo -e "\e[32mNginx is already installed.\e[0m"
        echo -e "\e[32mStarting and enabling Nginx service...\e[0m"
        sudo systemctl start nginx
        sudo systemctl enable nginx
        echo -e "\e[32mNginx service started and enabled on boot.\e[0m"
    else
        echo -e "\e[32mInstalling Nginx...\e[0m"
        sudo apt update
        sudo apt install -y nginx
        echo -e "\e[32mNginx installed successfully.\e[0m"
        sudo systemctl start nginx
        sudo systemctl enable nginx
        echo -e "\e[32mNginx service started and enabled on boot.\e[0m"
    fi
}

create_server_block() {
    read -p "Enter your site domain (e.g., example.com): " site
    sudo mkdir -p /var/www/html/$site
    echo "<html><head><title>Welcome to $site!</title></head><body><h1>Success! The $site server block is working!</h1></body></html>" | sudo tee /var/www/html/$site/index.html
    sudo chown -R www-data:www-data /var/www/html/$site
    sudo chmod -R 755 /var/www/html/$site

    echo -e "\e[32mCreating Nginx block...\e[0m"

    sudo tee /etc/nginx/sites-available/$site > /dev/null <<EOF
server {
    listen 80;
    server_name $site www.$site;

    root /var/www/html/$site;

    index index.html index.htm;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

    echo -e "\e[32mEnabling site...\e[0m"
    sudo ln -sf /etc/nginx/sites-available/$site /etc/nginx/sites-enabled/
    echo -e "\e[32mSite enabled.\e[0m"

    echo -e "\e[32mDisabling default site...\e[0m"
    sudo rm -f /etc/nginx/sites-enabled/default
    echo -e "\e[32mDefault site disabled.\e[0m"

    echo -e "\e[32mTesting Nginx configuration...\e[0m"
    sudo nginx -t
    echo -e "\e[32mNginx configuration is valid.\e[0m"

    reload_nginx

    echo -e "\e[32mServer block for $site created successfully.\e[0m"
    echo -e "\e[31mDon't forget to add your content to /var/www/html/$site\e[0m"
}

remove_server_block() {
    read -p "Enter the site domain to remove (e.g., example.com): " site

    echo -e "\e[32mDisabling site...\e[0m"
    sudo rm -f /etc/nginx/sites-enabled/$site
    echo -e "\e[32mSite disabled.\e[0m"

    echo -e "\e[32mRemoving server block configuration...\e[0m"
    sudo rm -f /etc/nginx/sites-available/$site
    echo -e "\e[32mServer block configuration removed.\e[0m"

    echo -e "\e[32mTesting Nginx configuration...\e[0m"
    sudo nginx -t
    echo -e "\e[32mNginx configuration is valid.\e[0m"

    reload_nginx
}

show_server_blocks() {
    echo -e "\e[32mCurrent Nginx Server Blocks:\e[0m"
    ls -l /etc/nginx/sites-available/
}

reload_nginx() {
    echo -e "\e[32mReloading Nginx...\e[0m"
    sudo systemctl reload nginx
    echo -e "\e[32mNginx reloaded.\e[0m"
}

manage_menu() {
    while true
    do
        echo -e "\e[32mManage Nginx Server Blocks\e[0m"
        echo -e "\e[36m1) Create Server Block\e[0m"
        echo -e "\e[36m2) Remove Server Block\e[0m"
        echo -e "\e[36m3) Show Server Blocks:\e[0m"
        echo -e "\e[36m4) Back to Main Menu\e[0m"
        read -p "Choose an option: " manage_choice

        case $manage_choice in
            1) create_server_block ;;
            2) remove_server_block ;;
            3) show_server_blocks ;;
            4) break ;;
            *) echo -e "\e[31mInvalid option.\e[0m" ;;
        esac
    done
}

while true
do
    echo -e "\e[32mNginx Management Menu\e[0m"
    echo -e "\e[36m1) Install Nginx\e[0m"
    echo -e "\e[36m2) Manage Server Blocks\e[0m"
    echo -e "\e[36m3) Help\e[0m"
    echo -e "\e[36m4) Exit\e[0m"
    read -p "Choose an option: " choice

    case $choice in
        1) install_nginx ;;
        2) manage_menu ;;
        3) echo -e "\e[32mThis script helps you install and manage Nginx server blocks.\e[0m" ;;
        4) break ;;
        *) echo -e "\e[31mInvalid option.\e[0m" ;;
    esac
done

echo -e "\e[33mExiting Nginx Management Script.\e[0m"