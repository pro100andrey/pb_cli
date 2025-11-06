# pb_cli

A command line interface (CLI) for PocketBase that helps you manage schemas, configurations, and data synchronization between local and remote PocketBase instances.

## Features

- **Setup Management**: Interactive setup for configuring your PocketBase connection and managed collections
- **Schema Synchronization**: Push and pull PocketBase schemas between local JSON files and remote instances
- **Data Seeding**: Batch import/export of collection data with truncation options
- **Credential Management**: Support for both environment variables (.env) and interactive prompts
- **Batch Processing**: Efficient handling of large datasets with configurable batch sizes
- **Validation**: Schema comparison and validation before synchronization

## Installation

### Global Installation

To install the CLI globally, run:

```bash
dart pub global activate pb_cli
```

### Local Development

Clone the repository and install dependencies:

```bash
git clone <repository-url>
cd pb_cli
dart pub get
```

## Usage

After installation, you can run the CLI using:

```bash
pb_cli [command] [options]
```

### Available Commands

#### Setup Command

Configure your local environment for managing PocketBase schema and data:

```bash
pb_cli setup --dir ./pb_data
```

This command will:

- Prompt for PocketBase connection details
- Allow you to select collections to manage
- Create necessary configuration files
- Set up credential storage preferences

#### Push Command

Push local schema and data to the remote PocketBase instance:

```bash
# Basic push
pb_cli push --dir ./pb_data

# Push with truncation (clears existing data)
pb_cli push --dir ./pb_data --truncate

# Custom batch size
pb_cli push --dir ./pb_data --batch-size 50
```

Options:

- `--dir, -d`: Directory containing your PocketBase data files
- `--truncate, -t`: Truncate collections before importing data
- `--batch-size, -b`: Number of records to process per batch (1-50, default: 20)

#### Pull Command

Pull schema and data from remote PocketBase to local files:

```bash
pb_cli pull --dir ./pb_data --batch-size 100
```

Options:

- `--dir, -d`: Directory to save PocketBase data files
- `--batch-size, -b`: Number of records to fetch per batch (max: 500, default: 100)

### Global Options

- `--verbose, -v`: Enable verbose logging for detailed output
- `--help`: Display help information

## Configuration

### Directory Structure

The CLI creates and manages the following structure in your specified directory:

```sh
pb_data/
├── config.json          # CLI configuration
├── .env                 # Environment variables (if using dotenv)
├── pb_schema.json       # PocketBase schema definition
└── collections/         # Collection data files
    ├── users.json
    ├── posts.json
    └── ...
```

### Configuration File (config.json)

```json
{
  "managedCollections": ["users", "posts", "comments"],
  "credentialsSource": "dotenv"
}
```

### Environment Variables (.env)

When using dotenv credential source:

```env
PB_HOST=http://localhost:8090
PB_USERNAME=admin@example.com
PB_PASSWORD=your_password
PB_TOKEN=optional_auth_token
```

## Examples

### Complete Workflow

1. **Initial Setup**:

   ```bash
   pb_cli setup --dir ./pb_data
   ```

2. **Pull Current Schema and Data**:

   ```bash
   pb_cli pull --dir ./pb_data
   ```

3. **Modify Data Locally** (edit JSON files)

4. **Push Changes Back**:

   ```bash
   pb_cli push --dir ./pb_data --truncate
   ```

### Development Workflow

```bash
# Setup with verbose logging
pb_cli setup --dir ./pb_data --verbose

# Push with confirmation prompt for truncation
pb_cli push --dir ./pb_data

# Pull with larger batch size for performance
pb_cli pull --dir ./pb_data --batch-size 500
```

## Error Handling

The CLI uses semantic exit codes based on BSD sysexits.h standards:

- `0`: Success
- `1`: Generic error
- `64`: Usage error (invalid arguments)
- `65`: Data format error
- `66`: Input file missing
- `68`: Host unreachable
- `69`: Service unavailable
- `70`: Internal software error
- `74`: I/O error
- `75`: Temporary failure (retry recommended)
- `77`: Permission denied
- `78`: Configuration error

## Development

### Project Structure

```sh
lib/
├── src/
│   ├── client/          # PocketBase client wrapper
│   ├── commands/        # CLI command implementations
│   ├── extensions/      # Utility extensions
│   ├── inputs/          # User input handling
│   ├── models/          # Data models and types
│   ├── repositories/    # Data persistence layer
│   ├── runner/          # Command runner
│   └── utils/           # Utility functions
└── pb_cli.dart         # Main library export
```

### Running Tests

```bash
dart test
```

### Code Analysis

```bash
dart analyze
```

### Formatting

```bash
dart format .
```

## Dependencies

- **args**: Command line argument parsing
- **dotenv**: Environment variable management
- **http**: HTTP client for API requests
- **io**: I/O utilities
- **mason_logger**: Beautiful console logging
- **meta**: Metadata annotations
- **path**: Cross-platform path manipulation
- **pocketbase**: Official PocketBase Dart SDK

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

## License

This project is licensed under the MIT License.

## Support

For issues, questions, or contributions, please visit the project repository.
