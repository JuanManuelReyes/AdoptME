#!/bin/bash

signup() {
    local admin=$1

    clear
    echo "Ingrese nombre de usuario:"
    read user
    echo "Ingrese contraseña:"
    read -s pass
    repetido=0
    while IFS=: read -r u p; do
        if [[ $user == $u ]]; then
            repetido=1
            break
        fi
    done <"admins.txt"
    if [[ $repetido -eq 1 ]]; then
        read -p "Usuario ya registrado."
    else
        if [ -z $user ] || [ -z $pass ]; then
            read -p "Datos incorrectos, presione enter para continuar"
        else
            # si es admin el valor es = 1 (se crea en admins.txt) - si es 0 es cliete (se crea en clients.txt)
            if [[ $admin -eq 1 ]]; then
                echo "$user:$pass" >>admins.txt
                echo "Administrador registrado correctamente."
            else
                echo "$user:$pass" >>clients.txt
                echo "Usuario registrado correctamente."
            fi
            read -p "Presione ENTER para continuar..."
            ./login.sh
        fi
    fi
}

existeAdmin=0

while IFS=: read -r u p f; do
    if [[ "$u" == "admin" && "$p" == "admin" ]]; then
        existeAdmin=1
        break
    else
        existeAdmin=0
        break
    fi
done <"admins.txt"

if [[ $existeAdmin -eq 0 ]]; then
    echo "Se debe registrar un administrador"
    read -p "Presione ENTER para continuar"

    # signup 1 para registrar un administrador - 0 para clientes
    signup 1
fi
