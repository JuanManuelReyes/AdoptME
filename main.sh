#!/bin/bash

touch ./data/admins.txt
touch ./data/clients.txt

add_header_if_empty() {
    local file="$1"
    if [ ! -s "$file" ]; then
        echo "Cedula:Nombre:Telefono:Fecha_de_Nacimiento:Contraseña_Encriptada" >> "$file"
    fi
}

add_header_if_empty "./data/admins.txt"
add_header_if_empty "./data/clients.txt"

show_menu() {
    echo "Seleccione una opción:"
    echo "1. Iniciar sesión"
    echo "2. Registrar usuario"
    echo "3. Salir"
    read -p "Opción: " option

    case $option in
        1) ./autentificacion/login.sh ;;
        2) ./autentificacion/register.sh ;;
        3) exit 0 ;;
        *) echo "Opción no válida"; show_menu ;;
    esac
}

show_menu
