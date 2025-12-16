#!/bin/bash

# ==========================
# CONFIG
# ==========================
API_KEY="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"  # Remplacez par votre clé API OpenRouter
API_URL="https://api.openrouter.ai/v1/chat/completions"
MODEL="orca-mini-1"  # modèle gratuit disponible

WIDTH=60

# ==========================
# CHECKS
# ==========================
if [[ -z "$API_KEY" ]]; then
  echo "❌ OPENROUTER_API_KEY non défini"
  exit 1
fi

if [[ -z "$*" ]]; then
  echo "Usage: $0 <description>"
  exit 1
fi

PROMPT="Draw this in ASCII art:
$*
Rules:
- ASCII only
- max width $WIDTH
- no explanation
- no markdown
"

# ==========================
# API CALL
# ==========================
RESPONSE=$(curl -s "$API_URL" \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  -d "{
    \"model\": \"$MODEL\",
    \"messages\": [
      {\"role\": \"user\", \"content\": \"$PROMPT\"}
    ]
  }")

# ==========================
# EXTRACTION DU TEXTE
# ==========================
ASCII=$(echo "$RESPONSE" | jq -r '
  if .choices != null and .choices[0].message.content != null then
    .choices[0].message.content
  elif .response_text != null then
    .response_text
  else
    "⚠️ API returned nothing"
  end
')


echo "$ASCII"
