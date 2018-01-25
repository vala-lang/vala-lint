project(
    'io.elementary.vala-lint', 'vala', 'c',
    meson_version : '>= 0.43'
)

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()), language:'c')

posix_dep = meson.get_compiler('vala').find_library('posix')

libvala = shared_library(
    'vala-linter-1.0',
    'lib/Check.vala',
    'lib/FormatMistake.vala',
    'lib/Linter.vala',
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
        posix_dep
    ],
    link_with : libvala,
    install : true
)

unit_test = executable(
    'unit-test',
    'test/UnitTest.vala',
    dependencies: [
        dependency('gio-2.0'),
        dependency('gee-0.8'),
        posix_dep
    ],
    link_with : libvala,
    install : true
)
test('vala lint unit test', unit_test)
