# 🗺️ Roteiro de Viagem Automático — Shell Script

Este projeto é um **script em Shell** que automatiza a criação de um **roteiro de viagem completo**, utilizando nomes de cidades fornecidos em um arquivo de texto.  
Para cada cidade, o script obtém:

- 🌎 País  
- ⏰ Horário local (com base no fuso-horário real)  
- ☁️ Clima atual  
- 📍 Pontos turísticos próximos  
- ⚠️ Aviso para cidades inválidas ou não informadas  

Tudo é salvo em `roteiro_pronto.txt`, e no final é mostrado um **resumo estatístico** usando AWK.

## 📦 Requisitos

- `curl`
- `jq`
- `awk`
- `sed`
- Bash 4+

---

## 🚀 Funcionalidades

- Leitura automática de cidades a partir de arquivo  
- Consultas às APIs:  
  - **Geoapify** (geolocalização e país)  
  - **WTTR.in** (clima)  
- Tratamento inteligente de erros e entradas vazias  
- Criação de arquivo de saída formatado  
- Ordenação dos pontos turísticos com `sort`  
- Resumo com AWK  
- Função de formatação da cidade com regex e SED  
- Proteção final do arquivo com `chmod 444`  

---

## 📌 Como executar

1. Coloque as cidades dentro de um arquivo, por exemplo:
```
Belo Horizonte
São Paulo
Curitiba
Nova York
Boston
```

2. Execute:

`./roteiro destinos.txt`

3. Veja o arquivo gerado:

`roteiro_pronto.txt`


4. Consulte o resumo final no terminal.

