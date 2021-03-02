import 'package:flutter/material.dart';
import 'Screens/detail_screen.dart';
import 'Screens/home_screen.dart';
import 'package:news/Screens/home_screen.dart';
import 'package:news/utils/provider.dart';
import 'package:provider/provider.dart';

import 'Screens/search_screen.dart';

void main() {
  runApp( MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewsProvider()),
      ],
      child:MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    initialRoute: '/',
    routes: {
        '/':(_)=>HomeScreen(),
        '/detail':(_)=>DetailScreen(),
        '/search':(_)=>SearchScreen()
    },);
  }
}
