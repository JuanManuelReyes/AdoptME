#!/bin/bash

clear

adoptions_file="./data/adoptions.txt"
stats_file="./data/adoption_statistics.txt"

echo "================================"
echo "=== Estadisticas de Adopcion ==="
echo "================================"
echo

if [[ ! -f "$adoptions_file" ]]; then
  echo "Aun no han habido adopciones, intentalo mas tarde."
  sleep 3
  ./app/admin/admin_menu.sh
  exit 0
fi

declare -A adoption_count
declare -A month_count
total_adopted=0
total_age=0
adopted_count=0

while IFS=":" read -r id tipo nombre sexo edad descripcion fecha_ingreso fecha_adopcion; do
  if [[ "$id" == "ID_Mascota" ]]; then
    continue
  fi

  ((adoption_count["$tipo"]++))
  ((total_adopted++))

  mes_adopcion=$(echo "$fecha_adopcion" | cut -d'/' -f2)
  ((month_count["$mes_adopcion"]++))

  if [[ "$edad" =~ ^[0-9]+$ ]]; then
    ((total_age+=edad))
    ((adopted_count++))
  fi
done < "$adoptions_file"

echo ""
echo "Estadísticas de Adopciones:"

echo ""
echo "Porcentaje de adopción por tipo de mascota:"
for tipo in "${!adoption_count[@]}"; do
  porcentaje=$(echo "scale=2; (${adoption_count[$tipo]} / $total_adopted) * 100" | bc)
  echo "Tipo: $tipo - $porcentaje%"
done

max_month=""
max_count=0
echo ""
echo "Adopciones por mes:"
for mes in "${!month_count[@]}"; do
  if (( month_count[$mes] > max_count )); then
    max_count=${month_count[$mes]}
    max_month=$mes
  fi
  echo "Mes: $mes - Adopciones: ${month_count[$mes]}"
done
echo ""
echo "Mes con más adopciones: $max_month con $max_count adopciones"

if [[ $adopted_count -gt 0 ]]; then
  average_age=$(echo "scale=2; $total_age / $adopted_count" | bc)
  echo ""
  echo "Edad promedio de los animales adoptados: $average_age años"
else
  echo ""
  echo "No hay datos suficientes para calcular la edad promedio de los animales adoptados."
fi

{
  echo "Estadísticas de Adopciones:"
  echo ""
  echo "Porcentaje de adopción por tipo de mascota:"
  for tipo in "${!adoption_count[@]}"; do
    porcentaje=$(echo "scale=2; (${adoption_count[$tipo]} / $total_adopted) * 100" | bc)
    echo "Tipo: $tipo - $porcentaje%"
  done

  echo ""
  echo "Adopciones por mes:"
  for mes in "${!month_count[@]}"; do
    echo "Mes: $mes - Adopciones: ${month_count[$mes]}"
  done
  echo ""
  echo "Mes con más adopciones: $max_month con $max_count adopciones"

  if [[ $adopted_count -gt 0 ]]; then
    echo ""
    echo "Edad promedio de los animales adoptados: $average_age años"
  else
    echo ""
    echo "No hay datos suficientes para calcular la edad promedio de los animales adoptados."
  fi
} > "$stats_file"

echo ""
echo "Las estadísticas se han guardado en $stats_file."

sleep 3
./app/admin/admin_menu.sh