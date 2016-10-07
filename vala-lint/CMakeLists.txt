# Configure precompile
vala_precompile (VALA_C
    config.vala
    Application.vala
PACKAGES
    gio-2.0
    gee-0.8
    vala-lint-1.0
    posix
OPTIONS
    --thread
    --target-glib 2.32
)

# Add executable
add_executable (vala-lint ${VALA_C})

# Installation
install (TARGETS vala-lint RUNTIME DESTINATION bin)
