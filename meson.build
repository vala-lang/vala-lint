project(
    'io.elementary.vala-lint', 'vala', 'c',
    meson_version : '>= 0.43'
)

add_project_arguments('-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()), language:'c')

gee_dep = dependency('gee-0.8')
gio_dep = dependency('gio-2.0')
posix_dep = meson.get_compiler('vala').find_library('posix')

if dependency('libvala-0.40', required: false).found()
    libvala_dep = dependency('libvala-0.40')
elif dependency('libvala-0.36', required: false).found()
    libvala_dep = dependency('libvala-0.36')
endif

subdir('lib')
subdir('src')
subdir('test')
