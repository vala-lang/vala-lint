# Configure precompile
vala_precompile (LIB_VALA_C
    Linter.vala
    Check.vala
    FormatMistake.vala
    Checks/EllipsisCheck.vala
    Checks/TrailingWhitespaceCheck.vala
PACKAGES
    gio-2.0
    gee-0.8
OPTIONS
    --thread
    --target-glib 2.32
    --vapi-comments
GENERATE_VAPI
    ${LIB_NAME}
GENERATE_HEADER
    ${CMAKE_PROJECT_NAME}
)

# Add executable
add_library (${LIB_NAME} SHARED ${LIB_VALA_C})

# Set library properties
set_target_properties (${LIB_NAME} PROPERTIES
    OUTPUT_NAME ${LIB_NAME}
    VERSION ${LIB_SOVERSION}.${LIB_VERSION}
    SOVERSION ${LIB_SOVERSION}
)

# Installation
install (TARGETS ${LIB_NAME} DESTINATION ${CMAKE_INSTALL_FULL_LIBDIR}/)
install (FILES ${CMAKE_CURRENT_BINARY_DIR}/${LIB_NAME}.pc DESTINATION ${CMAKE_INSTALL_FULL_LIBDIR}/pkgconfig/)
install (FILES ${CMAKE_CURRENT_BINARY_DIR}/${LIB_NAME}.vapi DESTINATION ${CMAKE_INSTALL_FULL_DATAROOTDIR}/vala/vapi/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/${LIB_NAME}.deps DESTINATION ${CMAKE_INSTALL_FULL_DATAROOTDIR}/vala/vapi/)
install (FILES ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_PROJECT_NAME}.h DESTINATION ${CMAKE_INSTALL_FULL_INCLUDEDIR}/${LIB_NAME}/)
