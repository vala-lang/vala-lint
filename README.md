# Vala-Lint

[![Bountysource](https://www.bountysource.com/badge/tracker?tracker_id=45980444)](https://www.bountysource.com/trackers/45980444-elementary-Vala-lint)

Small command line tool and library for checking Vala code files for code-style errors.
Based on the [elementary Code-Style guidelines](https://elementary.io/docs/code/reference#code-style).

## Building, Testing, and Installation
You'll need the following dependencies:

    meson
    gio-2.0
    gee-0.8
    valac
    
Run meson build to configure the build environment. Change to the build directory and run ninja test to build and run automated tests

    meson build --prefix=/usr
    cd build
    ninja test
    
To install, use ninja install, then execute with `io.elementary.vala-lint`

    sudo ninja install
    io.elementary.vala-lint

## Usage
You can use the command-line tool to scan files or include the library into your own projects to scan single lines or whole files easily.

### Command-Line Example
Scan the vala-lint repository itself: `io.elementary.vala-lint ../**/*.vala`
Scan every vala file in the current directory: `io.elementary.vala-lint $(find . -type f -name "*.vala")`

### Command-Line Parameters
```
Usage:
  io.elementary.vala-lint [OPTION...] - vala-lint

Help Options:
  -h, --help        Show help options

Application Options:
  -v, --version     Display version
```
