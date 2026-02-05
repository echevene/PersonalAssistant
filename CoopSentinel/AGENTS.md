# CoopSentinel Agents Guide

## Build/Lint/Test Commands
- **Build**: `python -m pip install -r requirements.txt` (Raspberry Pi) / `arduino-cli compile` (ESP32)
- **Lint**: `ruff check .` (Python) / `clang-format -i *.cpp *.h` (C++)
- **Test**: `python -m pytest tests/ -v` (run all) / `python -m pytest tests/test_specific.py::TestClass::test_method -v` (single test)
- **Run**: `python main.py` (Raspberry Pi) / `arduino-cli upload` (ESP32)

## Code Style Guidelines

### Python (Raspberry Pi)
- **Imports**: Standard library first, then third-party, then local. Use absolute imports.
- **Formatting**: Black formatter with 88 char line length
- **Types**: Use type hints for all function parameters and return values
- **Naming**: snake_case for variables/functions, PascalCase for classes
- **Error Handling**: Use specific exceptions, log errors with context

### C++ (ESP32)
- **Includes**: Group by type (standard, external, local), alphabetical within groups
- **Formatting**: clang-format with WebKit style
- **Naming**: camelCase for variables/functions, PascalCase for classes/types
- **Error Handling**: Return error codes or use exceptions sparingly

### General
- **MQTT Topics**: `coopsentinel/{component}/{action}` format
- **Logging**: Structured logging with levels, include timestamps and context
- **Documentation**: Docstrings for all public functions, inline comments for complex logic</content>
<parameter name="filePath">AGENTS.md