#!/bin/sh

# Choose a theme
theme="$HOME/.config/rofi/configs/ai.rasi"

# Rofi config options
list_col="1"
list_row="1"

# LLM Settings
model="claude-3-7-sonnet-20250219"
version="2023-06-01"
modelName="null"
history_file="/tmp/rofi_ai_history.txt"

# Get Anthropic Model Name
anth_model_name() {
  json=$(curl -s https://api.anthropic.com/v1/models/${model} \
    --header "x-api-key: $(pass show api_keys/anthropic)" \
    --header "anthropic-version: $version")

  name=$(echo "$json" | jq .display_name)
  modelName=$(echo "$name" | sed -e 's/"//g')
}

# Anthropic AI API
get_ai_response() {
  local user_prompt="$1"

  jsonResponse=$(
    curl -s https://api.anthropic.com/v1/messages \
      --header "x-api-key: $(pass show anthropic)" \
      --header "anthropic-version: $version" \
      --header "content-type: application/json" \
      --data @- <<EOF
{
  "model": "$model",
  "max_tokens": 1024,
  "messages": [
      {"role": "user", "content": "$user_prompt"}
  ]
}
EOF
  )

  echo "$jsonResponse" | jq -r '.content[0].text'
}

# Initialize or clear history file
>"$history_file"

# Main conversation loop
conversation() {
  anth_model_name
  local prompt_text=""
  local response=""

  while true; do
    # Display current history and get new prompt
    prompt_text=$(cat "$history_file" | rofi -dmenu \
      -theme-str "listview {columns: $list_col; lines: $list_row;}" \
      -p "$modelName:" \
      -markup-rows \
      -theme "${theme}" \
      -mesg "${response}")

    # Exit if user cancels
    if [ -z "$prompt_text" ]; then
      break
    fi

    # Get AI response
    response=$(get_ai_response "$prompt_text")

    # Update history file with conversation
    echo "You: $prompt_text" >"$history_file"
    echo "AI: $response" >>"$history_file"
  done
}

# Start conversation
conversation
