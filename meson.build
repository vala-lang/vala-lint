project(
    'io.elementary.vala-lint', 'vala', 'c',
    meson_version : '>= 0.43'
)

add_global_arguments('-DGETTEXT_PACKAGE="io.elementary.vala-lint"', language:'c')

libvala = shared_library(
    'vala-linter-1.0',
    'lib/Check.vala',
    'lib/FormatMistake.vala',
    'lib/Linter.vala',
    'lib/Parser.vala',
    'lib/ParseResult.vala',
    'lib/Utils.vala',
    'lib/Checks/BlockOpeningBraceSpaceBeforeCheck.vala',
    'lib/Checks/DoubleSpacesCheck.vala',
    'lib/Checks/EllipsisCheck.vala',
    'lib/Checks/LineLengthCheck.vala',
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

checks_unit_tests = executable(
    'checks-unit-test',
    'test/ChecksUnitTests.vala',
    dependencies: [
        dependency('gio-2.0'),
        dependency('gee-0.8'),
        meson.get_compiler('vala').find_library('posix')
    ],
    link_with : libvala,
    install : false
)

files_tests = executable(
    'files-test',
    'test/FilesTests.vala',
    dependencies: [
        dependency('gio-2.0'),
        dependency('gee-0.8'),
        meson.get_compiler('vala').find_library('posix')
    ],
    link_with : libvala,
    install : false
)

parser_unit_tests = executable(
    'parser-unit-test',
    'test/ParserUnitTests.vala',
    dependencies: [
        dependency('gio-2.0'),
        dependency('gee-0.8'),
        meson.get_compiler('vala').find_library('posix')
    ],
    link_with : libvala,
    install : false
)

test('checks-unit-tests', checks_unit_tests)
test('files-tests', files_tests)
test('parser-unit-tests', parser_unit_tests)
