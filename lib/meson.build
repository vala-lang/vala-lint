vala_linter_files = files(
    'Check.vala',
    'Disabler.vala',
    'FormatMistake.vala',
    'Linter.vala',
    'Parser.vala',
    'ParseResult.vala',
    'Utils.vala',
    'ValaReporter.vala',
    'ValaVisitor.vala',
    'Checks/BlockOpeningBraceSpaceBeforeCheck.vala',
    'Checks/DoubleSemicolonCheck.vala',
    'Checks/DoubleSpacesCheck.vala',
    'Checks/EllipsisCheck.vala',
    'Checks/LineLengthCheck.vala',
    'Checks/NamingAllCapsCheck.vala',
    'Checks/NamingCamelCaseCheck.vala',
    'Checks/NamingUnderscoreCheck.vala',
    'Checks/NoSpaceCheck.vala',
    'Checks/NoteCheck.vala',
    'Checks/SpaceBeforeParenCheck.vala',
    'Checks/TabCheck.vala',
    'Checks/TrailingNewlinesCheck.vala',
    'Checks/TrailingWhitespaceCheck.vala',
    'Checks/UnnecessaryStringTemplateCheck.vala',
)

vala_linter_deps = [
    gio_dep,
    libvala_dep,
]

vala_linter_library = shared_library(
    'vala-linter-1.0',
    vala_linter_files,
    dependencies : vala_linter_deps,
    install : true
)

vala_linter_dep = declare_dependency(
    dependencies: vala_linter_deps,
    link_with : vala_linter_library,
    include_directories: include_directories('.')
)
