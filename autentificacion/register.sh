#!/opt/homebrew/bin/bash

admin_file="./data/admins.txt"
client_file="./data/clients.txt"

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

get_and_confirm_password() {
    while true; do
        read -s -p "Ingrese una contraseña: " password
        read -s -p "Confirme la contraseña: " confirm_password

        if [ "$password" != "$confirm_password" ]; then
            echo "Las contraseñas no coinciden. Inténtelo de nuevo."
        else
            echo "$password"
            break
        fi
    done
}

validate_admin_option() {
    local option
    while true; do
        read -p "¿Desea registrar un usuario administrador? (S/N): " option
        option=$(echo "$option" | tr '[:lower:]' '[:upper:]')

        if [[ "$option" == "S" || "$option" == "N" ]]; then
            echo "$option"
            break
        else
            echo "Entrada no válida. Ingrese 'S' para sí o 'N' para no."
        fi
    done
}

register_user() {
    if [ $(wc -l < "$admin_file") -le 1 ]; then
        echo "No hay ningún administrador registrado. Debe registrar el usuario 'admin' con la contraseña 'admin'."

        echo "Ingrese cédula (sin puntos ni guiones):"
        read id
        id=$(validate_number "$id")

        echo "Ingrese teléfono:"
        read phone
        phone=$(validate_number "$phone")

        echo "Ingrese fecha de nacimiento (dd/mm/yyyy):"
        read dob
        dob=$(validate_date "$dob")

        name="admin"
        password="admin"

        user_data="$id:$name:$phone:$dob:$password"

        echo "$user_data" >> "$admin_file"
        echo "Primer usuario admin registrado exitosamente."
    else
        echo "Ingrese cédula (sin puntos ni guiones):"
        read id
        id=$(validate_number "$id")

        if grep -q "^$id" "$admin_file" || grep -q "^$id" "$client_file"; then
            echo "El usuario ya existe."
            exit 1
        fi

        echo "Ingrese nombre:"
        read name
        name=$(validate_input "$name")

        echo "Ingrese teléfono:"
        read phone
        phone=$(validate_number "$phone")

        echo "Ingrese fecha de nacimiento (dd/mm/yyyy):"
        read dob
        dob=$(validate_date "$dob")

        password=$(get_and_confirm_password)

        user_type=$(validate_admin_option)

        if [ "$user_type" == "S" ]; then
            echo "$id:$name:$phone:$dob:$password" >> "$admin_file"
            echo "Usuario administrador registrado."
        elif [ "$user_type" == "N" ]; then
            echo "$id:$name:$phone:$dob:$password" >> "$client_file"
            echo "Usuario cliente registrado."
        fi
    fi
}

register_user
