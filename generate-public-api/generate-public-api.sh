#!/bin/bash
set -euo pipefail

echo "copying fresh original openapi file"
cp /github/workspace/source-documentation/documentation.yaml openapi.yaml

echo "removing everything except PublicAPI"
yq 'del(
  .paths[] | select(
    (.get.tags // [] | contains(["PublicAPI"]) | not) and
    (.post.tags // [] | contains(["PublicAPI"]) | not) and
    (.put.tags // [] | contains(["PublicAPI"]) | not) and
    (.delete.tags // [] | contains(["PublicAPI"]) | not)
  )
)' -i openapi.yaml

echo "removing unused tags"
yq '.tags |= map(select(.name == "PublicAPI"))' -i openapi.yaml

echo "setting custom operationId for selected endpoints"
yq '.paths["/api/v1/public/organizations/projects"].post.operationId = "getProjectToken"' -i openapi.yaml
yq '.paths["/api/v1/public/organizations/users"].get.operationId = "getOrganizationUsers"' -i openapi.yaml

echo "calling redocly to remove all useless"
redocly bundle --config generate-public-api/redocly.yaml openapi.yaml -o openapi.yaml
