import 'package:docs_for_employees/ui/admin/AdminHome.dart';
import 'package:docs_for_employees/ui/DocumentPage.dart';
import 'package:docs_for_employees/ui/HomePage.dart';
import 'package:docs_for_employees/ui/LoginPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryTextTheme: const TextTheme(

        ),
      ),
      initialRoute: '/login',
      routes: {
        '/home': (context) => const HomePage(title: ""),
        '/login': (context) => LoginPage(),
        '/document': (context) => const DocumentPage(),
        '/admin/home': (context) => AdminHome(),
      },
    );
  }
}