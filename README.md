# Vala-Lint

[![Build Status](https://action-badges.now.sh/elementary/vala-lint)](https://github.com/elementary/vala-lint/actions)
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

### Configuration
Using a configuration file, you can overwrite the default settings of vala-lint. It can be included via the `config`-option

    io.elementary.vala-lint -c vala-lint.conf

A file of the default configuration can be generated and saved by

    io.elementary.vala-lint --generate-config >> vala-lint.conf

The generated file will look like

```Ini
[Checks]
block-opening-brace-space-before=true
double-semicolon=true
double-spaces=true
ellipsis=true
line-length=true
naming-convention=true
no-space=true
note=true
space-before-paren=true
use-of-tabs=true
trailing-newlines=true
trailing-whitespace=true

[Disabler]
disable-by-inline-comments=true

[line-length]
max-line-length=120

[note]
keywords=TODO,FIXME
```

In the *Checks* group, each check can be enabled/disabled individually. The *Disabler* group allows for disabling a single check at a specific line using an inline comment (see Disabling Errors below). Furthermore, each check can have individual, hopefully self-explanatory, settings, which are also listed in the [wiki](https://github.com/elementary/vala-lint/wiki/Vala-Lint-Checks).


### Disabling Errors
You can disable a single or multiple errors on a given line by adding an inline comment like

```vala
if(...) { // vala-lint=space-before-paren, line-length
```

### Docker and Continuous Integration
Vala-Lint is primarily intended to be used in Continuous Integration (CI). It's available in a convenient, always up-to-date Docker container `valalang/lint:latest` hosted on Docker Hub.

    docker run -v "$PWD":/app valalang/lint:latest
