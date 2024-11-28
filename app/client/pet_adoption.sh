#!/bin/bash

clear

echo "============================"
echo "=== Adopción de Mascotas ==="
echo "============================"
echo

pets_file="./data/pets.txt"
adoption_file="./data/adoptions.txt"

touch "$adoption_file"

add_header_if_empty() {
    local file="$1"
    local type="$2"
    if [[ ! -s "$file" && "$type" == "adoptions" ]]; then
        echo "ID_Mascota:Tipo:Nombre:Sexo:Edad:Descripcion:Fecha_de_Ingreso:Fecha_de_Adopcion" >> "$file"
    fi
}

add_header_if_empty "$adoption_file" adoptions

list_pets() {
    if [ ! -f "$pets_file" ]; then
        echo "Aún no se han registrado mascotas, vuelve más tarde."
        return 1
    fi

    local hay_pets=0

    echo -e "ID\tTipo\tNombre\t\tSexo\t\tEdad\tDescripción\t\tFecha de Ingreso\tEstado"
    echo "------------------------------------------------------------------------------------------------------------------"

    while IFS=: read -r id tipo nombre sexo edad descripcion fecha estado; do
        if [ "$estado" == "No Adoptada" ]; then
            printf "%-8s %-8s %-16s %-16s %-8s %-24s %-16s\n" \
                "$id" "$tipo" "$nombre" "$sexo" "$edad" "$descripcion" "$fecha"
            hay_pets=1
        fi
    done < <(tail -n +2 "$pets_file")

    if [ "$hay_pets" -eq 0 ]; then
        return 1
    else
        return 0
    fi
}

validate_pet_id() {
    while true; do
        read -p "Ingrese el ID de la mascota que desea adoptar: " pet_id

        if grep -q "^$pet_id:" "$pets_file"; then
            local pet_info=$(grep "^$pet_id:" "$pets_file")
            local pet_state=$(echo "$pet_info" | awk -F: '{print $NF}')
            if [ "$pet_state" == "No Adoptada" ]; then
                echo "$pet_info"
                return 0
            else
                echo "La mascota con ID $pet_id ya ha sido adoptada. Intente con otro ID."
            fi
        else
            echo "El ID ingresado no es válido. Inténtelo de nuevo."
            continue
        fi
    done
}

adopt_pet() {
    if [ ! -f "$pets_file" ]; then
        echo "Aún no se han registrado mascotas, vuelve más tarde."
        sleep 3
        ./app/client/client_menu.sh
        exit 0
    fi

    if ! list_pets; then
        echo "No hay mascotas para adoptar."
        sleep 3
        ./app/client/client_menu.sh
        exit 0
    fi

    local pet_info
    pet_info=$(validate_pet_id)

    if [[ -z "$pet_info" ]]; then
        echo "No se pudo obtener la información de la mascota. Adopción cancelada."
        sleep 3
        ./app/client/client_menu.sh
        exit 0
    fi

    echo "¿Está seguro de que desea adoptar a la mascota seleccionada? (s/n): "
    read confirm
    if [ "$confirm" = "s" ]; then
        local pet_id=$(echo "$pet_info" | awk -F: '{print $1}')
        local today_date=$(date +"%d/%m/%Y")

        sed -i "/^$pet_id:/ s/No Adoptada/Adoptada/" "$pets_file"

        local pet_info_clean=$(echo "$pet_info" | sed 's/:No Adoptada//')
        echo "$pet_info_clean:$today_date" >> "$adoption_file"

        echo "¡Felicidades! Ha adoptado a la mascota con ID $pet_id."
        echo "La adopción ha sido registrada en $adoption_file."
    else
        echo "Adopción cancelada."
        sleep 3
        ./app/client/client_menu.sh
        exit 0
    fi
}

adopt_pet
sleep 3
./app/client/client_menu.sh
