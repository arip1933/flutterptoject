import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tokoonline/helper/utils/user_preferences.dart';
import 'package:flutter_tokoonline/launcher.dart';
import 'package:flutter_tokoonline/thema.dart';
import 'package:flutter_tokoonline/users/landingpage.dart' as users;



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
await UserPreferences.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final user = UserPreferences.getUser();

   return ThemeProvider(
      initTheme: user.isDarkMode ? MyThemes.darkTheme : MyThemes.lightTheme,
      child: Builder(
        builder: (context) => MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeProvider.of(context),
      title: 'Flutter Demo',
      home: LauncherPage(),
      routes: <String, WidgetBuilder>{
        // '/landingusers': (BuildContext context) => new users.LandingPage(),
        '/keranjangusers': (BuildContext context) => new users.LandingPage(nav: '1'),
        // '/signup' : (BuildContext context) => new SignupPage(),
        // '/forgot' : (BuildContext context) => new ForgotPage(),

      },
        )
      )
    );
  }
}
