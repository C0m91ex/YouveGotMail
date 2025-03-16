!/bin/bash

# Path to your LÖVE app and the .love file
LOVE_APP_PATH="/Applications/Love.app"
GAME_LOVE_FILE="/Users/ishachury/YouveGotMail.love"  # Replace with your actual .love file path

# Create the app bundle
mkdir -p MyGame.app/Contents/MacOS
mkdir -p MyGame.app/Contents/Resources

# Copy LÖVE binary into the app bundle
cp -R "$LOVE_APP_PATH/Contents/MacOS/love" MyGame.app/Contents/MacOS/

# Copy the .love file into the Resources folder
cp "$GAME_LOVE_FILE" MyGame.app/Contents/Resources/

# Create Info.plist (app metadata)
cat > MyGame.app/Contents/Info.plist <<EOL
<?xml version="1.0" encoding="UTF-8"?>
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>love</string>
    <key>CFBundleIdentifier</key>
    <string>com.mygame</string>
    <key>CFBundleName</key>
    <string>MyGame</string>
    <key>CFBundleVersion</key>
    <string>1.0</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
</dict>
</plist>
EOL	

# Done! Now you can test the .app

