#!/opt/homebrew/bin/bash

adopt_pet() {
    local pets_file="./data/pets.txt"
    local adoption_file="./data/adoptions.txt"
    local pet_number
    local today_date=$(date +"%d/%m/%Y")

    if [ ! -f "$pets_file" ]; then
        echo "El archivo $pets_file no existe."
        return 1
    fi

    ./app/client/list_pets.sh

    echo -n "Ingrese el ID de la mascota que desea adoptar: "
    read pet_number

    if grep -q "^$pet_number:" "$pets_file"; then
        pet_info=$(grep "^$pet_number:" "$pets_file")

        echo "¿Está seguro de que desea adoptar a la mascota con ID $pet_number? (s/n): "
        read confirm
        if [ "$confirm" = "s" ]; then
            grep -v "^$pet_number:" "$pets_file" > temp_pets.txt && mv temp_pets.txt "$pets_file"
            echo "¡Felicidades! Ha adoptado a la mascota con ID $pet_number."

            echo "$pet_info:$today_date" >> "$adoption_file"
            echo "La adopción ha sido registrada en $adoption_file."
        else
            echo "Adopción cancelada."
        fi
    else
        echo "El ID de mascota ingresado no es válido."
    fi
}

adopt_pet
