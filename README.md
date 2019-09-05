# Vala-Lint

[![Bountysource](https://www.bountysource.com/badge/tracker?tracker_id=45980444)](https://www.bountysource.com/trackers/45980444-elementary-Vala-lint)

Small command line tool and library for checking Vala code files for code-style errors.
Based on the [elementary Code-Style guidelines](https://elementary.io/docs/code/reference#code-style).

## Building, Testing, and Installation
You'll need the following dependencies:

    meson
    gio-2.0
    valac

Run meson build to configure the build environment. Change to the build directory and run ninja test to build and run automated tests

    meson build --prefix=/usr
    cd build
    ninja test

To install, use ninja install, then execute with `io.elementary.vala-lint`

    sudo ninja install
    io.elementary.vala-lint

## Usage
You can use the command-line tool to scan files or include the library into your own projects to scan single lines or whole files easily. By default, the command-line tool uses [globs](https://en.wikipedia.org/wiki/Glob_%28programming%29) to match files. For example, by

    io.elementary.vala-lint *.vala

you can lint every file in the current directory. Using the directory `d`-flag, you can lint every Vala file in a given directory and all subdirectories by

    io.elementary.vala-lint -d ../my-project

For all options, type `io.elementary.vala-lint -h`.

### Disabling Errors

You can disable a single or multiple errors on a given line by adding an inline comment like

```vala
if(...) { // vala-lint=space-before-paren, line-length
```

### Docker and Continuous Integration
Vala-Lint is primarily intended to be used in Continuous Integration (CI). It's available in a convenient, always up-to-date Docker container `elementary/docker:vala-lint` hosted on Docker Hub.

    docker run -v "$PWD":/app valalang/lint:latest
