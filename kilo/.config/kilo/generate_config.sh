#!/usr/bin/env sh

jq --argjson models "$(curl -q http://localhost:12434/v1/models)" '.
  | .provider.local.models = add(
      $models | .data[] | select(.meta.llamaswap.embedding // false | not) | {
        (.id): {
          name: .id | split("/") | .[-1] | gsub("[\\s_-]+"; " "),
          tool_call: .capabilities.function_calling,
          reasoning: .meta.llamaswap.reasoning,
          modalities: {
            input: .architecture.input_modalities,
            output: .architecture.output_modalities,
          },
        } * (.meta.llamaswap.kilo // {}),
      }
    )
  | .indexing |= . * (
      $models | .data[] | select(.meta.llamaswap.embedding // false) | {
        model: .id,
      } * (.meta.llamaswap.kilo // {})
    )
' "$(dirname -- $(readlink -f -- "$0"))/kilo.jsonc"
