import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/bodywidgets/Navbar.dart';
import 'package:newsapp/bodywidgets/welcomweb.dart';
import 'package:newsapp/mobileScreens/welcommobile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:newsapp/methods/FirebaseAuth.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Firebasemethods firebasemethods = Firebasemethods();
  User user1;
  Future getUserInfo() async {
    await firebasemethods.getUser().then((User user) {
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/home', arguments: {
          'user': user,
          'useruid': user.uid.toString(),
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello World',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color.fromRGBO(0, 160, 170, 1.0),
                          Color.fromRGBO(0, 255, 110, 1.0)
                        ]),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: ListView(
                      children: [
                        NavBar('start'),
                        Container(
                            constraints: BoxConstraints(maxWidth: 1200),
                            child: MediaQuery.of(context).size.width < 1200
                                ? Welcomemobile()
                                : Welcomeweb())
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            print('some thing went wrong');
          }
        },
      ),
    );
  }
}
