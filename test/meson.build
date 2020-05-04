file_test = executable(
    'file-test',
    'FileTest.vala',
    dependencies: [
        vala_linter_dep,
        posix_dep
    ]
)

test_envars = [
    'G_DEBUG=fatal-warnings',
]

test('vala lint file test', file_test, env: test_envars)

test('vala lint self test', vala_lint, workdir: meson.source_root(), env: test_envars)
