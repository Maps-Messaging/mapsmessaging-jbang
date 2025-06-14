# MAPS Messaging JBang Wrapper

A JBang wrapper for the MAPS Messaging server that makes it easy to install and run the server with a single command.

## Quick Start

The fastest way to get started:

```bash
# Install MAPS Messaging
jbang app install --fresh --force https://github.com/Maps-Messaging/mapsmessaging-jbang/blob/main/MAPS_Messaging.java

# Start the server
mapsmessaging
```

## Prerequisites

- Java 21 or higher
- JBang (will be installed automatically if not present)

## Installation Options

### Option 1: Direct JBang Command (Recommended)

This is the simplest way to install MAPS Messaging:

```bash
jbang app install --fresh --force https://github.com/Maps-Messaging/mapsmessaging-jbang/blob/main/MAPS_Messaging.java
```

The `--fresh` flag ensures you get the latest version, and `--force` overwrites any existing installation.

### Option 2: Manual Installation

If you prefer more control over the installation process:

1. Clone this repository:
```bash
git clone https://github.com/Maps-Messaging/mapsmessaging-jbang.git
cd mapsmessaging-jbang
```

2. Run the installation script:
```bash
./install-maps.sh
```

## Usage

### Starting the Server

Basic startup:
```bash
mapsmessaging
```

With debug output:
```bash
mapsmessaging --debug
```

### Verifying Installation

To verify your installation:
```bash
# Check the version
mapsmessaging --version

# Check if the server is running
mapsmessaging --status
```

## Features

- Automatic Java 21 installation if not present
- Automatic JBang installation if not present
- Simple one-command installation
- Easy server startup
- Debug mode support
- Version checking
- Server status monitoring

## Troubleshooting

If you encounter any issues:

1. **Command not found**: Make sure JBang is in your PATH
   ```bash
   # Add JBang to PATH (if needed)
   export PATH="$HOME/.jbang/bin:$PATH"
   ```

2. **Java version issues**: Ensure Java 21 is installed
   ```bash
   # Check Java version
   java -version
   ```

3. **Permission denied**: Make the script executable
   ```bash
   chmod +x install-maps.sh
   ```

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details. 