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

file_test = executable(
    'file-test',
    'FileTest.vala',
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

test('vala lint file test', file_test, env: test_envars)

test('vala lint self test', vala_lint, workdir: meson.source_root(), env: test_envars)
