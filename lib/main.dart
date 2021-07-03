import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/screens/Homeview.dart';
import 'package:newsapp/screens/home.dart';
import 'package:newsapp/screens/viewnews.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => HomeView(),
      '/home': (context) => home(),
      '/news': (context) => Newsviewer(),
    },
  ));
}
