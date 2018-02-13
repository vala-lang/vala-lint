project(
    'io.elementary.vala-lint', 'vala', 'c',
    meson_version : '>= 0.43'
)

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()), language:'c')

gee_dep = dependency('gee-0.8')
gio_dep = dependency('gio-2.0')
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
        gio_dep,
        gee_dep,
    ],
    install : true
)

executable(
    meson.project_name(),
    'src/Application.vala',
    dependencies: [
        gio_dep,
        gee_dep,
        posix_dep
    ],
    link_with : libvala,
    install : true
)

files_test = executable(
    'files-test',
    'test/FilesTests.vala',
    dependencies: [
        gio_dep,
        gee_dep
    ],
    link_with : libvala
)
unit_test = executable(
    'unit-test',
    'test/UnitTest.vala',
    dependencies: [
        gio_dep,
        gee_dep
    ],
    link_with : libvala
)

test('files test', files_test)
test('checks unit test', unit_test)
