#!/bin/bash

# Exit on any error
set -e

echo "=== MAPS Messaging Installation ==="
echo "Current directory: $(pwd)"

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
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
export PATH="$HOME/.jbang/bin:$PATH"

# Trust the Maps-Messaging organization
echo "Trusting Maps-Messaging organization..."
jbang trust add https://github.com/Maps-Messaging/

# Install MAPS Messaging
echo "Installing MAPS Messaging..."
jbang app install --fresh --force https://github.com/Maps-Messaging/mapsmessaging-jbang/blob/main/MAPS_Messaging.java

# Verify installation
echo -e "\n=== Verifying installation ==="
echo "PATH: $PATH"
echo "Java version:"
java -version
echo "JBang version:"
jbang --version
echo "MAPS Messaging version:"
mapsmessaging --version

echo -e "\n=== Installation complete ==="
echo "You can now run MAPS Messaging using: mapsmessaging"
echo "For debug output, use: mapsmessaging --debug" 