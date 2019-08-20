unit_test = executable(
    'unit-test',
    'UnitTest.vala',
    dependencies: [
        vala_linter_dep,
        posix_dep
    ]
)

file_test = executable(
    'file-test',
    'FileTest.vala',
    dependencies: [
        vala_linter_dep,
        posix_dep
    ]
)

test('vala lint unit test', unit_test)
test('vala lint file test', file_test)
