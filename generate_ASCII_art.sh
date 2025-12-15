#!/bin/bash

API_KEY="your_api_key_here"
PROMPT="Crée un dessin ASCII de : $*.
Contraintes :
- uniquement ASCII
- largeur max 60 caractères
- fond transparent
- pas de texte explicatif"

curl -s https://api.openai.com/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d "{
    \"model\": \"gpt-4.1-mini\",
    \"messages\": [
      {\"role\": \"user\", \"content\": \"$PROMPT\"}
    ]
  }" | jq -r '.choices[0].message.content'