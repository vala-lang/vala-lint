# Vala-Lint
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
### Command-Line Parameters
```
Usage:
  vala-lint [OPTION...] - Vala-Lint

Help Options:
  -h, --help        Show help options

Application Options:
  -v, --version     Display version
```
