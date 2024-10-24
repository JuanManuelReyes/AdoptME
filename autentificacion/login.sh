#!/bin/bash

admin_file="./data/admins.txt"
client_file="./data/clients.txt"

validate_password() {
    local stored_password="$1"
    local input_password="$2"

    if [ "$input_password" == "$stored_password" ]; then
        return 0
    else
        return 1
    fi
}

login_user() {
    echo "Ingrese su cédula:"
    read id
    echo "Ingrese su contraseña:"
    read -s password

    user_info_admin=$(grep "^$id:" "$admin_file")
    user_info_client=$(grep "^$id:" "$client_file")

    if [ -n "$user_info_admin" ]; then
        stored_password=$(echo "$user_info_admin" | awk -F':' '{print $5}')
        if validate_password "$stored_password" "$password"; then
            echo "Bienvenido administrador."
            ./app/admin/admin_menu.sh
        else
            echo "Credenciales incorrectas."
            exit 1
        fi
    elif [ -n "$user_info_client" ]; then
        stored_password=$(echo "$user_info_client" | awk -F':' '{print $5}')
        if validate_password "$stored_password" "$password"; then
            echo "Bienvenido cliente."
            ./app/client/client_menu.sh
        else
            echo "Credenciales incorrectas."
            exit 1
        fi
    else
        echo "Usuario no encontrado."
        exit 1
    fi
}

login_user
