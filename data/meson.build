# Library
conf = configuration_data()
conf.set('prefix', get_option ('prefix'))
conf.set('libdir', '${exec_prefix}/'+get_option ('libdir'))
conf.set('PROJECT_NAME', meson.project_name())
conf.set('VERSION', meson.project_version())
conf.set('LIBVALA', 'libvala-@0@ '.format(libvala_version)+libvala_required_version)


vala_linter_pc = configure_file(input : 'vala-linter-1.pc.in',
	output : 'vala-linter-1.pc',
	configuration : conf
	)
install_data(vala_linter_pc,
	install_dir : join_paths(get_option('libdir'), 'pkgconfig')
	)

