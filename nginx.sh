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

reload_nginx() {
    echo "Reloading Nginx..."
    sudo systemctl reload nginx
    echo "Nginx reloaded."
}
