#!/bin/bash

echo "=== Testing MAPS Messaging Installation in Clean Environment ==="
echo "Current directory: $(pwd)"

# Remove any existing JBang and JDK installations
echo -e "\n=== Cleaning up existing installations ==="
rm -rf ~/.jbang
rm -rf ~/.sdkman/candidates/java/21*

# Create a clean shell environment
echo -e "\n=== Creating clean shell environment ==="
CLEAN_SHELL=$(mktemp)
cat > "$CLEAN_SHELL" << 'EOF'
#!/bin/bash
set -e  # Exit on any error

# Start with a minimal PATH
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
# Remove any existing Java/JBang from PATH
export PATH=$(echo $PATH | tr ':' '\n' | grep -v "jbang" | grep -v "java" | tr '\n' ':')

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
EOF

chmod +x "$CLEAN_SHELL"
bash "$CLEAN_SHELL"
rm "$CLEAN_SHELL" 