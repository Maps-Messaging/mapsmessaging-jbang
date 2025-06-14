#!/bin/bash

echo "=== Testing MAPS Messaging Installation on Linux ==="
echo "Current directory: $(pwd)"

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
# Download and run the installer
curl -Ls https://github.com/Maps-Messaging/mapsmessaging-jbang/raw/main/install-maps.sh > install-maps.sh
chmod +x install-maps.sh
./install-maps.sh

# Source the new environment
if [ -f ~/.jbang/bin/jbang ]; then
    export PATH="$HOME/.jbang/bin:$PATH"
    source ~/.jbang/bin/jbang
fi

echo -e "\n=== Verifying installation ==="
echo "PATH: $PATH"
echo "Java version:"
java -version
echo "JBang version:"
jbang --version
echo "MAPS Messaging version:"
mapsmessaging --version

echo -e "\n=== Test complete ===" 