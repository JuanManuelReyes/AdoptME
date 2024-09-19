#!/bin/bash

login(){
    clear
    echo "¡Bienvenido a AdoptME!"
    echo "Por favor ingrese su usuario:"
    read user 
    echo "Contraseña:"
    read -s pass 

    encontrado=0

    while IFS=: read -r u p f; do
        if [ -z $user ] || [ -z $pass ]; then
            encontrado=0
            break
        fi
        if [[ $user == $u && $pass == $p ]]; then
            encontrado=1
            break
        fi
    done < "admins.txt"

    if [[ encontrado -eq 0 ]]; then
        while IFS=: read -r u p f; do
            if [ -z $user ] || [ -z $pass ]; then
                encontrado=0
                break
            fi
            if [[ $user == $u && $pass == $p ]]; then
                encontrado=2
                break
            fi
        done < "clients.txt"
    fi

    # si es 1 es admin - 2 si es cliente

    if [[ $encontrado -eq 1 ]]; then
        echo "Acceso de admin concedido."
        # Menu admin
        sleep 3
    elif [[ $encontrado -eq 2 ]]; then
        echo "Acceso de cliente concedido."
        # Menu cliente
        sleep 3

    else
        echo "Usuario o contraseña incorrectos."
        read -p "Presione enter para continuar o 1 para salir: " opcion
        if [[ $opcion -eq 1 ]]; then
            exit=1
        fi
    fi
}


if ! [[ -e admins.txt ]]; then
  touch admins.txt
fi

if ! [[ -e clients.txt ]]; then
  touch clients.txt
fi

exit=0
while [ $exit -eq 0 ];
do
  login
done