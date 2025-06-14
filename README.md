# MAPS Messaging JBang Wrapper

A JBang wrapper for the MAPS Messaging server that makes it easy to install and run the server with a single command.

## Prerequisites

- Java 21 or higher
- JBang (will be installed automatically if not present)

## Installation

### Option 1: One-Command Installation (Recommended)

If you don't have JBang installed or want a fresh installation:

```bash
curl -Ls https://github.com/Maps-Messaging/mapsmessaging-jbang/raw/main/install.sh | bash
```

After installation, source your shell configuration:
```bash
# For Linux
source ~/.bashrc
# For macOS
source ~/.zshrc
```

### Option 2: Manual Installation with Existing JBang

If you already have JBang installed:

1. Trust the Maps-Messaging organization:
```bash
jbang trust add https://github.com/Maps-Messaging/
```

2. Install MAPS Messaging:
```bash
jbang app install --fresh --force https://github.com/Maps-Messaging/mapsmessaging-jbang/blob/main/MAPS_Messaging.java
```

## Usage

Start the server:
```bash
mapsmessaging
```

For debug output:
```bash
mapsmessaging --debug
```

## Project Structure

The repository contains:
- `MAPS_Messaging.java`: The main JBang script that wraps the MAPS Messaging server
- `install.sh`: Installation script for setting up the environment
- `README.md`: This documentation file

Other files in the repository are for development and testing purposes only.

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
   chmod +x install.sh
   ```

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details. 