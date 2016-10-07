# Vala-Lint

[![Bountysource](https://www.bountysource.com/badge/tracker?tracker_id=45980444)](https://www.bountysource.com/trackers/45980444-elementary-Vala-lint)

Small command line tool and library for checking Vala code files for code-style errors.
Based on the [elementary Code-Style guidelines](https://elementary.io/en/docs/code/reference#code-style).

## Installation
Create a build-directory where you can run the following commands in:
```
mkdir build
cd build
```

### Library
If the library isn't already installed on your system, you need to build it first:
```
cmake -DCMAKE_INSTALL_PREFIX=/usr -DLIBRARY_ONLY=ON ..
make
sudo make install
```

### Command-Line Tool
```
cmake -DCMAKE_INSTALL_PREFIX=/usr ..
make
sudo make install
```

## Usage
You can use the command-line tool to scan files or include the library into your own projects to scan single lines
or whole files easily.

### Command-Line Example
Scan the Vala-Lint repository itself: `vala-lint Vala-Lint/*/{,*/}*.vala`

### Command-Line Parameters
```
Usage:
  vala-lint [OPTION...] - Vala-Lint

Help Options:
  -h, --help        Show help options

Application Options:
  -v, --version     Display version
```
