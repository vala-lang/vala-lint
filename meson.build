project(
    'io.elementary.vala-lint', 'vala', 'c',
    meson_version : '>= 0.43'
)

add_global_arguments('-DGETTEXT_PACKAGE="io.elementary.vala-lint"', language:'c')

libvala = shared_library(
    'vala-linter-1.0',
    'lib/Linter.vala',
    'lib/Check.vala',
    'lib/FormatMistake.vala',
    'lib/Checks/BlockOpeningBraceSpaceBeforeCheck.vala',
    'lib/Checks/EllipsisCheck.vala',
    'lib/Checks/TabCheck.vala',
    'lib/Checks/TrailingWhitespaceCheck.vala',
    dependencies : [
        dependency('gio-2.0'),
        dependency('gee-0.8'),
    ],
    install : true
)

executable(
    meson.project_name(),
    'src/Application.vala',
    dependencies: [
        dependency('gio-2.0'),
        dependency('gee-0.8'),
        meson.get_compiler('vala').find_library('posix')
    ],
    link_with : libvala,
    install : true
)
