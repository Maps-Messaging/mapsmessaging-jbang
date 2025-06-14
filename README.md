# MAPS Messaging JBang Wrapper

A JBang wrapper for the MAPS Messaging server that simplifies installation and usage.

## Installation

```bash
# Download and run the installer
curl -LO https://raw.githubusercontent.com/Maps-Messaging/mapsmessaging_server/main/install-maps.sh
chmod +x install-maps.sh
./install-maps.sh
```

## Usage

Start the server:
```bash
mapsmessaging
```

Start with a specific configuration:
```bash
mapsmessaging --config=prod.yaml
```

## Requirements

- Java 21 or higher
- JBang (installed automatically by the script)

## License

This project is licensed under the same terms as the MAPS Messaging server. 