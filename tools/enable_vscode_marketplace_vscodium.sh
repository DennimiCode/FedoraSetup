#!/bin/bash

# Define path to VSCodium's product.json
PRODUCT_JSON="/usr/share/codium/resources/app/product.json"

# Check if file exists
if [ ! -f "$PRODUCT_JSON" ]; then
  echo "Error: product.json not found at $PRODUCT_JSON"
  echo "Make sure VSCodium is installed and the path is correct."
  exit 1
fi

# Backup the original product.json
sudo cp "$PRODUCT_JSON" "$PRODUCT_JSON.bak"
echo "Backup of product.json created at $PRODUCT_JSON.bak"

# Insert extensionsGallery config
sudo jq '.extensionsGallery = {
  "serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery",
  "itemUrl": "https://marketplace.visualstudio.com/items",
  "cacheUrl": "https://vscode.blob.core.windows.net/gallery/index",
  "controlUrl": "",
  "recommendationsUrl": ""
}' "$PRODUCT_JSON.bak" | sudo tee "$PRODUCT_JSON" > /dev/null

echo "VSCode Marketplace has been enabled in VSCodium."

# Optional: restart VSCodium if running
if pgrep codium > /dev/null; then
  echo "Restarting VSCodium..."
  sudo kill $(pidof codium)
  codium &
  disown %1
fi

echo "Done."
