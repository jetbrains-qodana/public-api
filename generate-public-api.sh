#!/bin/bash
set -e

# copying fresh original openapi file
cp /github/workspace/source-documentation/documentation.yaml /github/workspace/public-api-redocly.yaml

# removing everything except PublicAPI
yq eval '
  .paths |= with_entries(
    select(
      ((.value.get.tags // []) | contains(["PublicAPI"])) or
      ((.value.post.tags // []) | contains(["PublicAPI"])) or
      ((.value.put.tags // []) | contains(["PublicAPI"])) or
      ((.value.delete.tags // []) | contains(["PublicAPI"]))
    )
  )
' -i /github/workspace/public-api-redocly.yaml

# removing obsolete /v1/public/... paths
yq eval 'del(.paths."/v1/public")' -i /github/workspace/public-api-redocly.yaml

# removing unused tags
yq eval '.tags |= map(select(.name == "PublicAPI"))' -i /github/workspace/public-api-redocly.yaml

# calling redocly to remove all useless
redocly bundle --config /github/workspace/redocly.yaml /github/workspace/public-api-redocly.yaml -o /github/workspace/public-api-redocly.yaml
