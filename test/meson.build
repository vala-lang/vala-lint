conft = configuration_data()
configure_file (input:'config.vapi.in',
	output: 'config.vapi',
	configuration: conft
	)
confht = configuration_data()
confht.set_quoted ('TEST_SRC_DIR', meson.current_source_dir())
confht.set_quoted ('TEST_BUILD_DIR', meson.current_build_dir())
configure_file(output : 'config.h',
	configuration : confht)

file_test_files = files([
    'checks.vala',
    'FileTest.vala'
])
file_test = executable(
    'file-test',
    file_test_files,
    vala_args: [
        '--vapidir', meson.current_build_dir(),
		'--pkg', 'config'
    ],
    dependencies: [
        vala_linter_dep,
        posix_dep
    ]
)


content_test_files = files([
    'checks.vala',
    'ContentTest.vala'
])
content_test = executable(
    'content-test',
    content_test_files,
    vala_args: [
        '--vapidir', meson.current_build_dir(),
		'--pkg', 'config'
    ],
    dependencies: [
        vala_linter_dep,
        posix_dep
    ]
)

test_envars = [
    'G_DEBUG=fatal-warnings',
]

test('file', file_test, env: test_envars)
test('content', content_test, env: test_envars)

test('self', vala_lint, workdir: meson.source_root(), env: test_envars)
