files_test = executable(
    'files-test',
    'FilesTests.vala',
    dependencies: vala_linter_dep
)

unit_test = executable(
    'unit-test',
    'UnitTest.vala',
    dependencies: vala_linter_dep
)

test('files test', files_test)
test('unit test', unit_test)
