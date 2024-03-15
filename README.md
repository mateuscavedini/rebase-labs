# Rebase Labs

Uma app web para listagem de exames médicos, sem utilizar Rails.

## Tech Stack

- Docker
- Ruby
- Javascript
- HTML
- CSS

## Como executar

1. Clone este repositório e navegue para o diretório.

```shell
git clone git@github.com:mateuscavedini/rebase-labs.git
cd rebase-labs/
```

2. Inicie os containers.

```shell
docker compose up -d
```

3. Inicialize o banco de dados e importe os dados iniciais.

```shell
docker compose exec api rake db:import
```

4. Execute os testes.

```shell
docker compose exec api rspec
```

5. Quando finalizado, pare os containers.

```shell
docker compose down
```

## Endpoints

```http
GET /exams
```

```json
[
    {
        "token": "IQCZ17",
        "date": "2021-08-05",
        "patient": {
            "cpf": "048.973.170-88",
            "name": "Emilly Batista Neto"
        },
        "doctor": {
            "name": "Maria Luiza Pires",
            "crm": "B000BJ20J4",
            "crm_state": "PI",
        }
    }
    "..."
]
```

Lista todos os exames cadatrados, assim como seus respectivos pacientes e médicos.

---

```http
GET /exams/:token
```

```json
{
    "token": "LN6KN2",
    "date": "2024-03-10",
    "patient": {
        "name": "Thaís Martins Costa",
        "cpf": "741.560.520-95"
    },
    "doctor": {
        "name": "Sarah Cardoso Dias",
        "crm": "B000JDT2K4",
        "crm_state": "MS"
    },
    "tests": [
        {
            "type": "glicemia",
            "limits": "25-83",
            "result": "25"
        },
        {
            "type": "hdl",
            "limits": "19-75",
            "result": "83"
        }
        "..."
    ]
}
```

Exibe mais detalhes de um exame.

---

```http
POST /import
```

Recebe um arquivo .csv para importar os dados de forma assíncrona para o banco de dados.

> Obs: Um arquivo para testar o upload se encontra em spec/support/csv.

## Frontend

```http
GET /hello
```

Exibe um texto plano para indicar o funcionamento do servidor.

---

```http
GET /
```

Esta rota serve os arquivos do frontend, implementando os endpoints anteriores.

> Obs: Até o momento, a aplicação não foi dividida em frontend/backend. Portanto, o mesmo servidor que serve os endpoints é o mesmo que serve o html.

> Obs2: O frontend se encontra sem testes. :(
