#!/bin/bash

install_nginx() {
    if [ -f /etc/nginx/nginx.conf ]; then
        echo "Nginx is already installed."
        echo "Starting and enabling Nginx service..."
        sudo systemctl start nginx
        sudo systemctl enable nginx
        echo "Nginx service started and enabled on boot."
    else
        echo "Installing Nginx..."
        sudo apt update
        sudo apt install -y nginx
        echo "Nginx installed successfully."
        sudo systemctl start nginx
        sudo systemctl enable nginx
        echo "Nginx service started and enabled on boot."
    fi
}

create_server_block() {
    read -p "Enter your site domain (e.g., example.com): " site
    sudo mkdir -p /var/www/html/$site
    echo "<html><head><title>Welcome to $site!</title></head><body><h1>Success! The $site server block is working!</h1></body></html>" | sudo tee /var/www/html/$site/index.html
    sudo chown -R www-data:www-data /var/www/html/$site
    sudo chmod -R 755 /var/www/html/$site

    echo "Creating Nginx block..."

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

    echo "Enabling site..."
    sudo ln -sf /etc/nginx/sites-available/$site /etc/nginx/sites-enabled/
    echo "Site enabled."

    echo "Disabling default site..."
    sudo rm -f /etc/nginx/sites-enabled/default
    echo "Default site disabled."

    echo "Testing Nginx configuration..."
    sudo nginx -t
    echo "Nginx configuration is valid."

    reload_nginx

    echo "Server block for $site created successfully."
    echo "Don't forget to add your content to /var/www/html/$site"
}

reload_nginx() {
    echo "Reloading Nginx..."
    sudo systemctl reload nginx
    echo "Nginx reloaded."
}

while true
do
    echo "Nginx Management Menu"
    echo "1) Install Nginx"
    echo "2) Create Server Block"
    echo "3) Help"
    echo "4) Exit"
    read -p "Choose an option: " choice

    case $choice in
        1) install_nginx ;;
        2) create_server_block ;;
        3) echo "This script helps you install and create Nginx server blocks." ;;
        4) break ;;
        *) echo "Invalid option." ;;
    esac
done