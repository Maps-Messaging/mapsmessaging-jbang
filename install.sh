#!/bin/bash

# Exit on any error
set -e

echo "=== MAPS Messaging Installation ==="
echo "Current directory: $(pwd)"

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    SHELL_RC="$HOME/.zshrc"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
    SHELL_RC="$HOME/.bashrc"
else
    echo "Unsupported OS: $OSTYPE"
    exit 1
fi

echo "Detected OS: $OS"

# Clean up any existing installations
echo -e "\n=== Cleaning up existing installations ==="
rm -rf ~/.jbang
rm -rf ~/.sdkman/candidates/java/21*

# Start with a clean PATH
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

echo "=== Clean Environment ==="
echo "PATH: $PATH"
echo "Java version:"
java -version 2>&1 || echo "No Java installed (expected)"
echo "JBang version:"
jbang --version 2>&1 || echo "No JBang installed (expected)"

echo -e "\n=== Installing MAPS Messaging ==="

# Install JBang
echo "Installing JBang..."
curl -Ls https://sh.jbang.dev | bash -s - app setup

# Add JBang to PATH
export PATH="$HOME/.jbang/bin:$PATH"
if [[ ":$PATH:" != *":$HOME/.jbang/bin:"* ]]; then
    echo 'export PATH="$HOME/.jbang/bin:$PATH"' >> "$SHELL_RC"
    source "$SHELL_RC"
fi

# Trust the Maps-Messaging organization
echo "Trusting Maps-Messaging organization..."
jbang trust add https://github.com/Maps-Messaging/

# Install MAPS Messaging
echo "Installing MAPS Messaging..."
jbang app install --fresh --force https://github.com/Maps-Messaging/mapsmessaging-jbang/blob/main/MAPS_Messaging.java

# Create a symlink for the mapsmessaging command
echo "Creating mapsmessaging command..."
ln -sf "$HOME/.jbang/bin/MAPS_Messaging" "$HOME/.jbang/bin/mapsmessaging"
chmod +x "$HOME/.jbang/bin/mapsmessaging"

# Add mapsmessaging to PATH
if [[ ":$PATH:" != *":$HOME/.jbang/bin:"* ]]; then
    echo 'export PATH="$HOME/.jbang/bin:$PATH"' >> "$SHELL_RC"
    source "$SHELL_RC"
fi

# Verify installation
echo -e "\n=== Verifying installation ==="
echo "PATH: $PATH"
echo "Java version:"
java -version
echo "JBang version:"
jbang --version
echo "MAPS Messaging version:"
mapsmessaging --version || MAPS_Messaging --version

echo -e "\n=== Installation complete ==="
echo "MAPS Messaging has been installed successfully."
echo -e "\nTo start the server, run:"
echo "mapsmessaging"
echo -e "\nFor debug output, use:"
echo "mapsmessaging --debug"
echo -e "\nNote: If the 'mapsmessaging' command is not found, please run:"
echo "source $SHELL_RC" 