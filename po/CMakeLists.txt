# Include translations package
include (Translations)

# Configure translations
add_translations_directory ("vala-lint")
add_translations_catalog ("vala-lint"
    ../vala-lint
    ../lib
)
