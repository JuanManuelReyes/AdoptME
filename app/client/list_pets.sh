#!/opt/homebrew/bin/bash

list_pets() {
    local file="./data/pets.txt"

    if [ ! -f "$file" ]; then
        echo "El archivo $file no existe."
        return 1
    fi

    echo -e "\nListado de mascotas:\n"
    echo -e "ID\tTipo\tNombre\t\tSexo\t\tEdad\tDescripción\t\tFecha de Ingreso"
    echo "-------------------------------------------------------------------------------------"

    tail -n +2 "$file" | while IFS=: read -r id tipo nombre sexo edad descripcion fecha; do
        printf "%-8s %-8s %-16s %-16s %-8s %-24s %-16s\n" "$id" "$tipo" "$nombre" "$sexo" "$edad" "$descripcion" "$fecha"
    done
}

list_pets
