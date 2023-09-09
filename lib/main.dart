import 'package:classinsights/providers/theme_provider.dart';
import 'package:classinsights/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

const _lightColorScheme = ColorScheme.light(
  primary: Color.fromRGBO(44, 99, 241, 1),
  primaryContainer: Color.fromRGBO(44, 99, 241, 1),
  secondary: Color.fromRGBO(197, 210, 244, 1),
  secondaryContainer: Color.fromRGBO(100, 121, 175, 1),
  tertiary: Color.fromRGBO(161, 177, 219, 1),
  background: Color.fromRGBO(245, 245, 245, 1),
  onBackground: Color.fromRGBO(10, 10, 10, 1),
  error: Color.fromRGBO(195, 0, 0, 1),
);

const _darkColorScheme = ColorScheme.dark(
  primary: Color.fromRGBO(72, 123, 255, 1),
  primaryContainer: Color.fromRGBO(44, 99, 241, 1),
  secondary: Color.fromRGBO(5, 12, 31, 1),
  secondaryContainer: Color.fromRGBO(53, 88, 179, 1),
  tertiary: Color.fromRGBO(12, 22, 49, 1),
  background: Color.fromRGBO(2, 5, 15, 1),
  onBackground: Color.fromRGBO(245, 245, 245, 1),
  error: Color.fromRGBO(216, 35, 37, 1),
);

TextTheme _textTheme = const TextTheme().copyWith(
  titleLarge: const TextStyle(
    fontSize: 26.0,
    fontWeight: FontWeight.bold,
  ),
  titleMedium: const TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.bold,
  ),
  titleSmall: const TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
  ),
  bodyLarge: const TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
  ),
  bodyMedium: const TextStyle(
    fontSize: 14.0,
  ),
  labelLarge: const TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.bold,
  ),
  labelMedium: const TextStyle(
    fontSize: 10.0,
  ),
);

class App extends ConsumerStatefulWidget {
  const App({super.key});

  static const defaultPadding = 12.0;
  static const smallPadding = 10.0;

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  Widget build(BuildContext context) {
    var themeMode = ref.read(themeProvider.notifier).theme;
    ref.listen(themeProvider, (_, newTheme) => setState(() => themeMode = newTheme));

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        statusBarIconBrightness: themeMode == ThemeMode.light ? Brightness.dark : Brightness.light,
      ),
    );

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        useMaterial3: false,
        brightness: Brightness.light,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        scaffoldBackgroundColor: _lightColorScheme.background,
        colorScheme: _lightColorScheme,
        textTheme: _textTheme.apply(
          bodyColor: _lightColorScheme.onBackground,
          displayColor: _lightColorScheme.onBackground,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        brightness: Brightness.dark,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        scaffoldBackgroundColor: _darkColorScheme.background,
        colorScheme: _darkColorScheme,
        textTheme: _textTheme.apply(
          bodyColor: _darkColorScheme.onBackground,
          displayColor: _darkColorScheme.onBackground,
        ),
      ),
      themeMode: themeMode,
      home: const SplashScreen(),
    );
  }
}
