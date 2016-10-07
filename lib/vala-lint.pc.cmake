prefix=@PREFIX@
exec_prefix=@DOLLAR@{prefix}
libdir=@DOLLAR@{prefix}/lib
includedir=@DOLLAR@{prefix}/include/

Name: Vala-Lint
Description: Vala-Lint headers
Version: 1.0
Libs: -lvala-lint-1.0
Cflags: -I@DOLLAR@{includedir}/vala-lint-1.0
Requires: glib-2.0
