# Vala-Lint

[![Build Status](https://github.com/vala-lang/vala-lint/workflows/Vala%20CI/badge.svg)](https://github.com/elementary/vala-lint/actions)
[![Deploy Status](https://github.com/vala-lang/vala-lint/workflows/Publish%20Docker%20Image/badge.svg)](https://github.com/elementary/vala-lint/actions)
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
You can use vala-lint or its library to scan your files and projects easily. By default, you can lint every Vala file in the current directory and all subdirectories by

    io.elementary.vala-lint

Additionally, vala-lint uses [globs](https://en.wikipedia.org/wiki/Glob_%28programming%29) to match files or directories. For example, you can lint every file in a given directory by

    io.elementary.vala-lint ../my-project/test

or specify particular files via

    io.elementary.vala-lint ../my-project/test/unit-test.vala
    io.elementary.vala-lint ../my-project/test/*-test.vala

To list all options, type `io.elementary.vala-lint -h`. Additional command line flags are: `--print-end` for printing not only the start but also the end of a mistake, and `--exit-zero` to always return a 0 (non-error) status code, even if lint mistakes are found.

### Configuration
Using a configuration file, you can overwrite the default settings of vala-lint. It can be included via the `config`-option

    io.elementary.vala-lint -c vala-lint.conf

A file of the default configuration can be generated and saved by

    io.elementary.vala-lint --generate-config >> vala-lint.conf

The generated file will look like

```Ini
[Checks]
block-opening-brace-space-before=error
double-semicolon=error
double-spaces=error
ellipsis=error
line-length=error
naming-convention=error
no-space=error
note=error
space-before-paren=error
use-of-tabs=error
trailing-newlines=error
trailing-whitespace=error
unnecessary-string-template=error

[Disabler]
disable-by-inline-comments=true

[line-length]
max-line-length=120
ignore-comments=true

[note]
keywords=TODO,FIXME
```

As this is the default configuration, you only need to specifiy differing settings. In the *Checks* group, each check can have three states. Using *error* (the default), the rule is displayes in output and triggers an exit code, for *warn* it is shown in output without an exit code and for *off* the rule is completely silent. The *Disabler* group allows for disabling a single check at a specific line using an inline comment (see Disabling Errors below). Furthermore, each check can have individual, hopefully self-explanatory, settings, which are also listed in the [wiki](https://github.com/elementary/vala-lint/wiki/Vala-Lint-Checks).


### Disabling Errors
You can disable a single or multiple errors on a given line by adding an inline comment like

```vala
if(...) { // vala-lint=space-before-paren, line-length
```

If you want to skip an entire file, you can use

```vala
// vala-lint=skip-file
```

at the beginning of the file.


### Docker and Continuous Integration
Vala-Lint is primarily intended to be used in Continuous Integration (CI). It's available in a convenient, always up-to-date Docker container `valalang/lint:latest` hosted on Docker Hub.

    docker run -v "$PWD":/app valalang/lint:latest
