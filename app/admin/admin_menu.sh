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
            pwd
            ./app/admin/pet_register.sh
            ;;
        3)
            ./app/admin/adoption_stats.sh
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

admin_menu
