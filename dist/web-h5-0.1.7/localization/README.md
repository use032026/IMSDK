# 35-language resource update

Catalog 0.3.15, 35 locales, and 1044 ARB keys per locale. Original six-language values are retained. SDK/Web exclusive missing translations explicitly fall back to English; see sdk_coverage.json. Legal bodies keep their existing resources and fallback.

Hosts can select locale at initialization or call updatePresentation with locale and/or themeMode. pt-BR and pt-PT are distinct. The SDK changes its own presentation without resetting the account or route.

Build, resource integrity and independent-consumer results are in MANIFEST.json. Current-version real-backend, physical-device and all-screen visual acceptance are not claimed.
