# Rebase Labs

Uma app web para listagem de exames médicos.

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

2. Inicie o banco de dados e a aplicação.

```shell
docker compose up
```

3. Importe os dados do arquivo CSV para o banco de dados.

```shell
docker exec -t rebase-labs-api-1 sh -c "rake db:import"
```

4. Execute os testes.

```shell
docker exec rebase-labs-api-1 rspec
```

## Endpoints

```http
GET /tests
```

```json
[
    {
        "id": "1",
        "cpf": "048.973.170-88",
        "nome_paciente": "Emilly Batista Neto",
        "email_paciente": "gerald.crona@ebert-quigley.com",
        "data_nascimento_paciente": "2001-03-11",
        "endereco_rua_paciente": "165 Rua Rafaela",
        "cidade_paciente": "Ituverava",
        "estado_paciente": "Alagoas",
        "crm_medico": "B000BJ20J4",
        "crm_medico_estado": "PI",
        "nome_medico": "Maria Luiza Pires",
        "email_medico": "denna@wisozk.biz",
        "token_resultado_exame": "IQCZ17",
        "data_exame": "2021-08-05",
        "tipo_exame": "hemácias",
        "limites_tipo_exame": "45-52",
        "resultado_tipo_exame": "97"
    }
    "..."
]
```
