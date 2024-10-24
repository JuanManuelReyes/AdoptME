#!/bin/bash

client_menu() {
    clear
    echo "===== Menú de Cliente ====="
    echo "1. Listar mascotas"
    echo "2. Adoptar mascota"
    echo "3. Salir"
    echo "================================="
    echo -n "Seleccione una opción: "
    read option
    case $option in
        1)
            ./app/client/list_pets.sh
            ;;
        2)
            pwd
            ./app/client/pet_adoption.sh
            ;;
        3)
            exit 0
            ;;
        *)
            echo "Opción no válida. Intente de nuevo."
            client_menu
            ;;
    esac
}

client_menu
