app_files = files (
    'Application.vala',
    'FileData.vala'
)

executable(
    meson.project_name(),
    app_files,
    dependencies: [
        vala_linter_dep,
        posix_dep
    ],
    install : true
)
