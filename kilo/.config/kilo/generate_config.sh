#!/usr/bin/env sh

jq --argjson models "$(curl -q http://localhost:12434/v1/models)" \
  '.provider.local.models = add(
    $models | .data[] | select(.capabilities.function_calling) | {
      (.id): {
        name: .id | split("/") | .[-1] | gsub("[\\s_-]+"; " "),
        tool_call: true,
        reasoning: true,
        modalities: {
          input: .architecture.input_modalities,
          output: .architecture.output_modalities,
        },
        limit: {
          context: .context_length,
          output: 16384,
        },
      },
    }
  )' \
  "$(dirname -- $(readlink -f -- "$0"))/kilo.jsonc"
