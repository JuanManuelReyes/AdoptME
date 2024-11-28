#!/bin/bash

clear

echo "==========================="
echo "=== Listado de Mascotas ==="
echo "==========================="
echo

list_pets() {
    local pets_file="./data/pets.txt"

    if [ ! -f "$pets_file" ]; then
        echo "Aún no se han registrado mascotas, vuelve más tarde."
        return 1
    fi

    echo -e "ID\tTipo\tNombre\t\tSexo\t\tEdad\tDescripción\t\tFecha de Ingreso\tEstado"
    echo "------------------------------------------------------------------------------------------------------------------"

    tail -n +2 "$pets_file" | while IFS=: read -r id tipo nombre sexo edad descripcion fecha estado; do
        printf "%-8s %-8s %-16s %-16s %-8s %-24s %-16s %-12s\n" \
            "$id" "$tipo" "$nombre" "$sexo" "$edad" "$descripcion" "$fecha" "$estado"
    done
}

list_pets

echo -e "\nPresiona cualquier tecla para volver al menú..."
read -n 1 -s

./app/client/client_menu.sh
