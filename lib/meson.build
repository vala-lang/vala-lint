vapidir = join_paths (get_option('datadir'),'vala','vapi')

vala_linter_files = files(
    'Check.vala',
    'Config.vala',
    'Disabler.vala',
    'Fixer.vala',
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
    'Checks/NamingConventionCheck.vala',
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

# LT_VERSION for ABI related changes
# From: https://autotools.io/libtool/version.html
# This rules applies to Meson 0.43
# Increase the current value whenever an interface has been added, removed or changed.
# Always increase revision value whenever an interface has been added, removed or changed.
# Increase the age value only if the changes made to the ABI are backward compatible.
# Set version to the value of subtract age from current
# Reset current and version to 1 and, age and version to 0 if library's name is changed
LT_CURRENT='1'
LT_REVISION='0'
LT_AGE='0'
LT_VERSION='1'
vala_linter_library = shared_library(
    'vala-linter-1.0',
    vala_linter_files,
    version : LT_VERSION,
	soversion : LT_VERSION+'.'+LT_AGE+'.'+LT_REVISION,
	vala_header : 'vala-linter.h',
	vala_vapi : 'vala-linter-1.vapi',
    dependencies : vala_linter_deps,
    install : true,
	install_dir : [
		get_option('libdir'),
		join_paths (get_option('includedir'),'vala-linter-1.0'),
		vapidir,
	]
)

vala_linter_source_dir = meson.current_source_dir ()
vala_linter_build_dir = meson.current_build_dir ()
vala_linter_dep = declare_dependency(
    dependencies: vala_linter_deps,
    link_with : vala_linter_library,
    include_directories: include_directories('.')
)

vlint_files = files(
    'vlint-linter.vala'
)

vlint_deps = [
    gio_dep,
    libvala_dep,
]

# LT_VERSION for ABI related changes
# From: https://autotools.io/libtool/version.html
# This rules applies to Meson 0.43
# Increase the current value whenever an interface has been added, removed or changed.
# Always increase revision value whenever an interface has been added, removed or changed.
# Increase the age value only if the changes made to the ABI are backward compatible.
# Set version to the value of subtract age from current
# Reset current and version to 1 and, age and version to 0 if library's name is changed
LT_CURRENT='1'
LT_REVISION='0'
LT_AGE='0'
LT_VERSION='1'
vlint_library = shared_library(
    'vlint-1',
    vlint_files,
    version : LT_VERSION,
	soversion : LT_VERSION+'.'+LT_AGE+'.'+LT_REVISION,
	vala_header : 'vlint.h',
	vala_vapi : 'vlint-1.vapi',
	vala_gir : 'Vlint-1.gir',
    dependencies : vlint_deps,
    link_with: [vala_linter_library],
    install : true,
	install_dir : [
		get_option('libdir'),
		join_paths (get_option('includedir'),'vlint-1'),
		vapidir,
		get_option('introspection')
	]
)

vlint_source_dir = meson.current_source_dir ()
vlint_build_dir = meson.current_build_dir ()
vlint_dep = declare_dependency(
    dependencies: vlint_deps,
    link_with : vlint_library,
    include_directories: include_directories('.')
)

if get_option('introspection')
if g_ir_compiler.found()
command = [
	g_ir_compiler,
	'--shared-library', 'lib@0@-@1@.so'.format ('vlint', 1),
	'--includedir', vlint_build_dir,
	'--output', '@OUTPUT@'
]
command += [ join_paths(meson.current_build_dir(), 'Vlint-1.gir') ]
custom_target('typelib-vlint',
	command: command,
	output: 'Vlint-1.typelib',
	depends: [vala_linter_library, vlint_library],
	install: true,
	install_dir: join_paths(get_option('libdir'), 'girepository-1.0'))
endif
endif
