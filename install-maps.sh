#!/bin/bash

set -e

echo "Starting MAPS Messaging installation..."

# Function to get the latest version from GitHub
get_latest_version() {
    # Get the latest version by parsing the releases page HTML
    local version=$(curl -s https://github.com/Maps-Messaging/mapsmessaging_server/releases/latest | grep -o 'releases/tag/[^"]*' | cut -d'/' -f3)
    if [ -z "$version" ]; then
        echo "ml-3.3.7-SNAPSHOT"  # Fallback version
    else
        echo "$version"
    fi
}

# Function to download and extract the release
download_release() {
    echo "Downloading release..."
    # Download the file directly using the known version
    curl -LO "https://github.com/Maps-Messaging/mapsmessaging_server/releases/download/ml-3.3.7-SNAPSHOT/maps-ml-3.3.7-SNAPSHOT-install.tar.gz"
    
    # Validate the downloaded file
    if [ ! -f "maps-ml-3.3.7-SNAPSHOT-install.tar.gz" ]; then
        echo "Error: Failed to download release"
        exit 1
    fi

    # Check if it's a valid gzip archive
    if ! file "maps-ml-3.3.7-SNAPSHOT-install.tar.gz" | grep -q "gzip compressed data"; then
        echo "Error: Downloaded file is not a valid gzip archive"
        rm "maps-ml-3.3.7-SNAPSHOT-install.tar.gz"
        exit 1
    fi

    # Try to list contents to validate archive integrity
    if ! tar -tvf "maps-ml-3.3.7-SNAPSHOT-install.tar.gz" > /dev/null 2>&1; then
        echo "Error: Downloaded archive is corrupted"
        rm "maps-ml-3.3.7-SNAPSHOT-install.tar.gz"
        exit 1
    fi

    echo "Downloaded and validated archive successfully"
    
    # Extract the archive
    echo "Extracting archive..."
    tar xzf "maps-ml-3.3.7-SNAPSHOT-install.tar.gz"
    rm "maps-ml-3.3.7-SNAPSHOT-install.tar.gz"
}

# Main installation process
echo "Starting MAPS Messaging installation..."

# Install JBang if not present
if ! command -v jbang >/dev/null 2>&1; then
    echo "Installing JBang..."
    curl -Ls https://sh.jbang.dev | bash -s - app setup
fi

# Install Java 21 using JBang
echo "Installing Java 21 using JBang..."
jbang jdk install 21

# Download and extract the release
download_release

# Create jbang-catalog.json
cat > jbang-catalog.json << EOF
{
  "aliases": {
    "mapsmessaging": {
      "script-ref": "MAPS_Messaging.java",
      "description": "MAPS Messaging Server"
    }
  }
}
EOF

# Create MAPS_Messaging.java
cat > MAPS_Messaging.java << EOF
//usr/bin/env jbang "\$0" "\$@" ; exit \$?
//JAVA 21+

import java.io.File;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class MAPS_Messaging {
    private static final Logger logger = Logger.getLogger(MAPS_Messaging.class.getName());

    public static void main(String[] args) {
        try {
            // Set up the installation directory
            String homeDir = System.getProperty("user.dir");
            String mapsHome = homeDir + File.separator + "maps-ml-3.3.7-SNAPSHOT";
            System.setProperty("MAPS_HOME", mapsHome);
            System.out.println("Using MAPS_HOME: " + mapsHome);
            
            // Create necessary directories
            new File(mapsHome).mkdirs();
            new File(mapsHome + File.separator + "config").mkdirs();
            new File(mapsHome + File.separator + "logs").mkdirs();
            
            // Copy JDK to maps-ml directory
            String javaHome = System.getProperty("java.home");
            String jdkDir = mapsHome + File.separator + "jdk";
            new File(jdkDir).mkdirs();
            
            // Build classpath with conf, main JAR, and all lib/*.jar
            StringBuilder cp = new StringBuilder(mapsHome + File.separator + "conf");
            cp.append(File.pathSeparator).append(mapsHome + File.separator + "lib" + File.separator + "maps-ml-3.3.7-SNAPSHOT.jar");
            cp.append(File.pathSeparator).append(mapsHome + File.separator + "lib" + File.separator + "*");
            
            // Prepare environment for the subprocess
            Map<String, String> env = new HashMap<>();
            env.put("MAPS_HOME", mapsHome);
            env.put("MAPS_DATA", mapsHome + File.separator + "data");
            env.put("MAPS_LIB", mapsHome + File.separator + "lib");
            env.put("MAPS_CONF", mapsHome + File.separator + "conf");
            
            // Build the command to launch MessageDaemon
            List<String> cmd = new ArrayList<>();
            cmd.add("java");
            cmd.add("-classpath");
            cmd.add(cp.toString());
            cmd.add("-DUSE_UUID=false");
            cmd.add("-Djava.security.auth.login.config=" + mapsHome + File.separator + "conf/jaasAuth.config");
            cmd.add("-DMAPS_HOME=" + mapsHome);
            cmd.add("io.mapsmessaging.MessageDaemon");
            cmd.addAll(List.of(args));
            
            // Start the process
            ProcessBuilder pb = new ProcessBuilder(cmd)
                .directory(new File(mapsHome));
            pb.environment().putAll(env);
            pb.inheritIO();
            
            Process proc = pb.start();
            proc.waitFor();
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error starting server", e);
            System.exit(1);
        }
    }
}
EOF

# Install the mapsmessaging command
echo "Installing mapsmessaging command..."
jbang app install --force --name mapsmessaging MAPS_Messaging.java

echo "Installation complete! You can now run 'mapsmessaging' to start the server." 