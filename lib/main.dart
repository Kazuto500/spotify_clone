import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/data/controllers/favorites_controller.dart';
import 'package:spotify_clone/data/controllers/navigator_controller.dart';
import 'package:spotify_clone/data/controllers/recommendations_controller.dart';
import 'package:spotify_clone/data/controllers/search_media_controller.dart';
import 'package:spotify_clone/data/controllers/session_controller.dart';
import 'package:spotify_clone/data/controllers/user_controller.dart';
import 'package:spotify_clone/ui/pages/error/error_page.dart';
import 'package:spotify_clone/ui/pages/home/home.dart';
import 'package:spotify_clone/ui/pages/login/login_page.dart';
import 'package:spotify_clone/ui/pages/splash/splash_page.dart';


void main(){  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.black,
    ),
  );    
  runApp(const MyApp());  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => NavigatorController(),
        ),
        ChangeNotifierProvider(
          create: (context) => SessionController(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserController(),
        ),
        ChangeNotifierProvider(
          create: (context) => FavoritesController(),
        ),
        ChangeNotifierProvider(
          create: (context) => SearchMediaController(),
        ),
        ChangeNotifierProvider(
          create: (context) => RecommendationsController(),
        ),
      ],
      child: GetMaterialApp(
        title: 'Spotify Clone',
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          scaffoldBackgroundColor: Colors.black,
          useMaterial3: true,
          textTheme: const TextTheme(
            titleLarge: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1,
              color: Colors.white,
            ),
            titleMedium: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              height: 1,
              color: Colors.white,
            ),
            titleSmall: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1,
              color: Colors.white,
            ),
            labelLarge: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1,
              color: Colors.white,
              overflow: TextOverflow.ellipsis,
            ),
            labelMedium: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 1,
              color: Colors.white,
              overflow: TextOverflow.ellipsis,
            ),
            labelSmall: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 11,
              fontWeight: FontWeight.w500,
              height: 1,
              color: Color(0xffa7a7a7),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        themeMode: ThemeMode.dark,
        routes: {
          "splash": (context) => const SplashPage(),
          "error": (context) => const ErrorPage(),
          "login": (context) => const LoginPage(),
          "home": (context) => const HomePage(),
        },
        initialRoute: "splash",
      ),
    );
  }
}
