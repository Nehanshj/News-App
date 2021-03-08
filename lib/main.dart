import 'package:flutter/material.dart';
import 'Screens/detail_screen.dart';
import 'Screens/home_screen.dart';
import 'package:news/Screens/home_screen.dart';
import 'package:news/utils/provider.dart';
import 'package:provider/provider.dart';

import 'Screens/search_screen.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => NewsProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: ThemeData(
        primaryColor: Color(0xFF0C54BE),
        cardColor: Color(0xFFF5F9FD),
        scaffoldBackgroundColor: Color(0xFFCED3DC),
        fontFamily: "Helvetica",
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => HomeScreen(),
        '/detail': (_) => DetailScreen(),
        '/search': (_) => SearchScreen()
      },
    );
  }
}
