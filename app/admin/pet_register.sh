#!/bin/bash

pets_file="./data/pets.txt"

validate_input() {
    local input="$1"
    while [[ -z "$input" || "$input" =~ ^[[:space:]]+$ ]]; do
        read -p "Entrada no válida. Por favor, ingrese nuevamente: " input
    done
    echo "$input"
}

validate_number() {
    local number="$1"
    while [[ ! "$number" =~ ^[0-9]+$ ]]; do
        read -p "Entrada no válida. Debe contener solo números. Ingrese nuevamente: " number
    done
    echo "$number"
}

validate_date() {
    local date="$1"
    while [[ ! "$date" =~ ^([0-9]{2})/([0-9]{2})/([0-9]{4})$ ]]; do
        read -p "Fecha no válida. Ingrese una fecha en formato dd/mm/yyyy: " date
    done
    echo "$date"
}


register_pet() {
    echo "Ingrese Numero de Identificador:"
    read id
    id=$(validate_number "$id")

    if grep -q "^$id" "$pets_file"; then
        echo "La mascota ya existe."
        exit 1
    fi

    echo "Ingrese tipo de mascota:"
    read type
    type=$(validate_input "$type")

    echo "Ingrese nombre:"
    read name
    name=$(validate_input "$name")

    echo "Ingrese sexo:"
    read sex
    sex=$(validate_input "$sex")

    echo "Ingrese edad:"
    read age
    age=$(validate_number "$age")

    echo "Ingrese descripcionn:"
    read desc
    desc=$(validate_input "$desc")

    echo "Ingrese fecha de ingreso (dd/mm/yyyy):"
    read doi
    doi=$(validate_date "$doi")

    echo "$id:$type:$name:$sex:$age:$desc:$doi" >> "$pets_file"
    echo "Mascota registrado."

}

register_pet
