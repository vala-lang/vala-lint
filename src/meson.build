ignore_matcher_library = static_library(
    'ignore-matcher',
    'IgnoreMatcher.vala',
    vala_vapi: 'ignore-matcher.vapi',
    dependencies: [
        vala_linter_dep,
        posix_dep
    ],
    install: false
)

ignore_matcher_dep = declare_dependency(
    link_with: ignore_matcher_library,
    dependencies: [
        vala_linter_dep,
        posix_dep
    ],
    include_directories: include_directories('.')
)

app_files = files (
    'Application.vala',
    'FileData.vala',
)

vala_lint = executable(
    meson.project_name(),
    app_files,
    dependencies: [
        vala_linter_dep,
        ignore_matcher_dep,
        posix_dep,
        json_dep
    ],
    install : true
)
