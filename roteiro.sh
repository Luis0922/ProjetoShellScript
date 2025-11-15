#!/bin/bash

formatar_cidade() {
    local nome="$1"
    echo "$nome" | sed -E -e 's/[^a-zA-Z0-9 ]//g' -e 's/ /%20/g'
}

API_KEY="a2ea491890da4d74af02becbac7857f6"

if [ $# -ne 1 ]; then
        echo "Uso: ./roteiro <arquivo>"
        echo "O arquivo de entrada deve conter nomes de cidades."
        exit 1
fi

output="roteiro_pronto.txt"
[ -e "$output" ] && rm -f "$output"
file=$1
cidade=1
while read CITY; do
	CITY="${CITY:-Cidade não informada}"
	CITY_URL=$(formatar_cidade "$CITY")
	geo=$(curl -s "https://api.geoapify.com/v1/geocode/search?text=${CITY_URL}&apiKey=${API_KEY}") 
		: "${geo:?Falha ao obter dados da API}"
	country=$(echo "$geo" | grep -Eo '"country":"[^"]+"' | cut -d':' -f2 | tr -d '"')
	timeZone=$(echo "$geo" | grep -Eo '"timezone":\{"name":"[^"]+"' | sed 's/.*"name":"//' | tr -d '"')
	weather=$(curl -s "https://wttr.in/${CITY_URL}?format=3")
	lat=$(echo "$geo" | grep -Eo '"lat":[0-9.-]+' | head -n1 | cut -d':' -f2)
	lon=$(echo "$geo" | grep -Eo '"lon":[0-9.-]+' | head -n1 | cut -d':' -f2)
	localTime=$(TZ="$timeZone" date +"%Y-%m-%d %H:%M:%S")
	
	if [ "$CITY" = "Cidade não informada" ]; then
		echo ""
    		echo "⚠️  Cidade não informada / linha vazia" >> "$output"
		echo "⚠️  Cidade não informada / linha vazia"
	elif [ "$lat" = "" ] || [ "$lon" = "" ]; then
		echo ""
		echo "⚠️  A cidade $CITY não foi encontrada" >> "$output"
		echo "⚠️  A cidade $CITY não foi encontrada"
	else

		echo "==================== Cidade $cidade ====================" >> "$output"
		echo "📍 $weather, 🌎 $country" >> "$output"
		echo "⏰ $localTime, $timeZone" >> "$output"
		echo "==================================================" >> "$output"

		echo "🗺️  Pontos Turisticos" >> "$output"

		echo "- " | curl -s "https://api.geoapify.com/v2/places?categories=tourism.sights&filter=circle:${lon},${lat},3000&limit=10&apiKey=${API_KEY}" \
			| jq -r '.features[].properties.name' | sort >> "$output"
	fi
	(( cidade++ ))
done < "$file"

echo ""
echo "Resumo do roteiro:"
awk '
    /==================== Cidade/ { total++ }
    /⚠️  Cidade não informada/ { nao_informadas++ }
    /⚠️  A cidade/ { nao_encontradas++ }
    END {
        print "Total de cidades processadas: " total
        print "Cidades não informadas: " nao_informadas
        print "Cidades não encontradas: " nao_encontradas
    }
' "$output"


echo "O roteiro foi criado com SUCESSO no arquivo $output."
chmod 444 "$output"
