# Vala-Lint

[![Bountysource](https://www.bountysource.com/badge/tracker?tracker_id=45980444)](https://www.bountysource.com/trackers/45980444-elementary-Vala-lint)

Small command line tool and library for checking Vala code files for code-style errors.
Based on the [elementary Code-Style guidelines](https://elementary.io/docs/code/reference#code-style).

## Installation
Create a build-directory where you can run the following commands in:
```
meson build --prefix=/usr
cd build
ninja test
```

## Usage
You can use the command-line tool to scan files or include the library into your own projects to scan single lines or whole files easily.

### Command-Line Example
Scan the vala-lint repository itself: `io.elementary.vala-lint ../**/*.vala`
Scan every vala file in the current directory: `io.elementary.vala-lint *.vala`

### Command-Line Parameters
```
Usage:
  io.elementary.vala-lint [OPTION...] - vala-lint

Help Options:
  -h, --help        Show help options

Application Options:
  -v, --version     Display version
```
