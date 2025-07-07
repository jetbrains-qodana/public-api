#!/bin/bash
set -e

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

echo "removing obsolete /v1/public/... paths"
yq '.paths |= with_entries(select(.key | test("^/v1/public") | not))' -i openapi.yaml

echo "removing unused tags"
yq '.tags |= map(select(.name == "PublicAPI"))' -i openapi.yaml

echo "calling redocly to remove all useless"
redocly bundle --config generate-public-api/redocly.yaml openapi.yaml -o openapi.yaml
