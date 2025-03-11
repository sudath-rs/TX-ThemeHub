#!/bin/bash

# Define the API URL and target directory
API_URL="https://api.github.com/repos/aghayecoder/tx-themehub/contents/themes"
TARGET_DIR="/etc/x-ui/html"

# Fetch the list of theme names
themes=($(curl -s "$API_URL" | jq -r '.[].name'))

# Check if themes were retrieved successfully
if [ ${#themes[@]} -eq 0 ]; then
    echo "No themes found or failed to fetch data."
    exit 1
fi

# Display the themes as a selectable menu
echo "Select a theme:"
select theme in "${themes[@]}"; do
    if [ -n "$theme" ]; then
        echo "You selected: $theme"

        # Download the selected theme file
        FILE_URL="https://raw.githubusercontent.com/aghayecoder/tx-themehub/main/themes/$theme"
        TEMP_FILE="/tmp/$theme"

        echo "Downloading $theme..."
        curl -s -o "$TEMP_FILE" "$FILE_URL"

        # Check if the file was downloaded successfully
        if [ ! -s "$TEMP_FILE" ]; then
            echo "Failed to download $theme. Please check the file URL."
            exit 1
        fi

        # Rename and move the file
        sudo mv "$TEMP_FILE" "$TARGET_DIR/sub.html"

        # Set appropriate permissions
        sudo chmod 644 "$TARGET_DIR/sub.html"

        echo "Theme successfully renamed to 'sub.html' and moved to $TARGET_DIR."
        break
    else
        echo "Invalid selection. Please try again."
    fi
done
