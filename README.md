# Dewmii Modernized Shared App Files

Updated files:

- `main.dart` - initializes Flutter binding and theme controller before app start.
- `app.dart` - adds app string title, bounded text scaling, and smooth scrolling behavior.
- `theme_controller.dart` - keeps the same static API with cleaner labels and toggle helpers.
- `common_app_header.dart` - glass/blur header, animated title, animated icon buttons, theme toggle, notification badge, support action.
- `common_bottom_nav.dart` - floating glass bottom navigation, sliding active indicator, badge animation, haptics.
- `main_navigation_shell.dart` - animated tab switching, state preservation with PageStorage, back-to-home behavior.
- `routes.dart` - route transition helpers and tab routes opening the main shell with the correct selected tab.
- `app_toast.dart` - now follows the app theme controller instead of only platform brightness.

Replace the matching files in your project path. Keep your existing folder structure and imports.
