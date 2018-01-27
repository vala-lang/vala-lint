project(
    'io.elementary.vala-lint', 'vala', 'c',
    meson_version : '>= 0.43'
)

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()), language:'c')

default_deps = [dependency('gio-2.0'), dependency('gee-0.8')]

libvala = shared_library(
    'vala-lint-1.0',
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
    'lib/Checks/SpaceBeforeBracketCheck.vala',
    'lib/Checks/TabCheck.vala',
    'lib/Checks/TrailingWhitespaceCheck.vala',
    dependencies : default_deps,
    install : true
)

executable(
    meson.project_name(),
    'src/Application.vala',
    dependencies : [
        default_deps,
        meson.get_compiler('vala').find_library('posix')
    ],
    link_with : libvala,
    install : true
)

checks_test = executable('checks-test', 'test/ChecksUnitTests.vala', dependencies : default_deps, link_with : libvala)
files_test = executable('files-test', 'test/FilesTests.vala', dependencies : default_deps, link_with : libvala)
parser_test = executable('parser-test', 'test/ParserUnitTests.vala', dependencies : default_deps, link_with : libvala)
utils_test = executable('utils-test', 'test/UtilsUnitTests.vala', dependencies : default_deps, link_with : libvala)

test('checks-test', checks_test)
test('files-test', files_test)
test('parser-test', parser_test)
test('utils-test', utils_test)
