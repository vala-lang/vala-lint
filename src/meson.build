app_files = files (
    'Application.vala',
    'FileData.vala'
)

vala_lint = executable(
    meson.project_name(),
    app_files,
    dependencies: [
        vala_linter_dep,
        posix_dep,
        json_dep
    ],
    install : true
)
