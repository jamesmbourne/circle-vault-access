#!/usr/bin/env bash
export VAULT_FORMAT=json
export VAULT_TOKEN=$(vault write auth/approle/login role_id=$VAULT_ROLE_ID secret_id=$VAULT_SECRET_ID | jq -r '.auth.client_token')

gh_token_data=$(vault write -f github/token)
lease_id=$(echo $gh_token_data | jq -r '.lease_id')

echo "export GITHUB_TOKEN='$(echo $gh_token_data | jq -r '.data.token')'" >> $BASH_ENV
