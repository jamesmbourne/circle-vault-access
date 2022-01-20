#!/usr/bin/env bash
set -euo pipefail
export VAULT_FORMAT=json
role_id=$(vault read auth/approle/role/my-role/role-id | jq -r '.data.role_id')

secret_id=$(vault write -f auth/approle/role/my-role/secret-id | jq -r '.data.secret_id')

echo $role_id
echo $secret_id

envvar_endpoint="https://circleci.com/api/v1.1/project/gh/jamesmbourne/circle-vault-access/envvar"

curl \
    -X POST \
    --header "Content-Type: application/json" \
    -d "$(jo -p name=VAULT_ADDR value="$VAULT_ADDR")" \
    "$envvar_endpoint" \
    -H "Circle-Token: $CIRCLE_TOKEN"

curl \
    -X POST \
    --header "Content-Type: application/json" \
    -d "$(jo -p name=VAULT_ROLE_ID value="$role_id")" \
    "$envvar_endpoint" \
    -H "Circle-Token: $CIRCLE_TOKEN"

curl \
    -X POST \
    --header "Content-Type: application/json" \
    -d "$(jo -p name=VAULT_SECRET_ID value="$secret_id")" \
    "$envvar_endpoint" \
    -H "Circle-Token: $CIRCLE_TOKEN"
