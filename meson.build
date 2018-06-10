project(
    'io.elementary.vala-lint', 'vala', 'c',
    meson_version : '>= 0.43'
)

add_project_arguments('-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()), language:'c')

gee_dep = dependency('gee-0.8')
gio_dep = dependency('gio-2.0')
posix_dep = meson.get_compiler('vala').find_library('posix')

libvala_dep = dependency('libvala-0.40', required: false)
if not libvala_dep.found ()
    # We need libvala-X.XX library, but it changes depending on the version that is installed
    # Plus development versions are odd numbers registered as even
    vala_versions = meson.get_compiler('vala').version().split('.')
    vala_major = vala_versions[0]
    vala_minor_int = vala_versions[1].to_int()
    if vala_minor_int.is_odd()
        vala_minor_int = vala_minor_int + 1
    endif

    vala_name = 'libvala-@0@.@1@'.format(vala_major, vala_minor_int)
    libvala_dep = dependency(vala_name)
endif

subdir('lib')
subdir('src')
subdir('test')
