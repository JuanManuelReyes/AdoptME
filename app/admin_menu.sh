#!/bin/bash

admin_menu() {
    clear
    echo "===== Menú de Administrador ====="
    echo "1. Registrar usuario"
    echo "2. Registrar mascota"
    echo "3. Estadísticas de adopción"
    echo "4. Salir"
    echo "================================="
    echo -n "Seleccione una opción: "
    read option
    case $option in
        1)
            ./autentificacion/register.sh
            ;;
        2)
            register_pet
            ;;
        3)
            adoption_statistics
            ;;
        4)
            exit 0
            ;;
        *)
            echo "Opción no válida. Intente de nuevo."
            admin_menu
            ;;
    esac
}

register_pet() {
    echo "Registrar mascota: "
    admin_menu
}

adoption_statistics() {
    echo "Estadísticas de adopción: "
    admin_menu
}

admin_menu
