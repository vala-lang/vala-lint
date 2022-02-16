conft = configuration_data()
configure_file (
    input: 'config.vapi.in',
	output: 'config.vapi',
	configuration: conft
)
confht = configuration_data()
confht.set_quoted ('TEST_SRC_DIR', meson.current_source_dir())
confht.set_quoted ('TEST_BUILD_DIR', meson.current_build_dir())
configure_file(output : 'config.h',
	configuration : confht)

vala_args = [
    '--vapidir', meson.current_build_dir(),
    '--pkg', 'config'
]

test_deps = [
    vala_linter_dep,
    posix_dep
]

file_test = executable(
    'file-test',
    'FileTest.vala',
    vala_args: vala_args,
    dependencies: test_deps
)

auto_fix_test = executable(
    'auto-fix-test',
    'AutoFixTest.vala',
    vala_args: vala_args,
    dependencies: test_deps
)

test_envars = [
    'G_DEBUG=fatal-warnings',
]

test('file', file_test, env: test_envars)
test('auto-fix', auto_fix_test, env: test_envars)

test('self', vala_lint, workdir: meson.source_root(), env: test_envars)
