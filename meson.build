project(
    'io.elementary.vala-lint', 'vala', 'c',
    meson_version : '>= 0.43'
)

add_project_arguments('-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()), language:'c')

valac = meson.get_compiler('vala')
libvala_version = run_command(valac.cmd_array()[0], '--api-version').stdout().strip()

gio_dep = dependency('gio-2.0')
posix_dep = valac.find_library('posix')
libvala_dep = dependency('libvala-@0@'.format(libvala_version))

subdir('lib')
subdir('src')
subdir('test')
