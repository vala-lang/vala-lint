project(
    'io.elementary.vala-lint', 'vala', 'c',
    meson_version : '>= 0.43'
)

add_project_arguments('-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()), language:'c')

gee_dep = dependency('gee-0.8')
gio_dep = dependency('gio-2.0')
libvala_dep = dependency('libvala-0.40')
posix_dep = meson.get_compiler('vala').find_library('posix')

subdir('lib')
subdir('src')
subdir('test')
