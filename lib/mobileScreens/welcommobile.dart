import 'package:flutter/material.dart';
import 'package:newsapp/bodywidgets/loginpopup.dart';
import 'package:newsapp/bodywidgets/signuppopup.dart';

class Welcomemobile extends StatefulWidget {
  @override
  _WelcomemobileState createState() => _WelcomemobileState();
}

class _WelcomemobileState extends State<Welcomemobile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 15, 5, 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 30,
          ),
          Text(
            'NewsiFy',
            style: TextStyle(
                color: Colors.white, fontFamily: 'OpenSans', fontSize: 30),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.93,
            child: Text(
              'NewsFy is a news app that presents the latest news in crisp format from trusted national and international publishers. Read the latest India News, Breaking News from across the world, viral videos & more in English and Indic languages ',
              style: TextStyle(
                  color: Colors.white, fontFamily: 'OpenSans', fontSize: 20),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: signuppopup(),
                    );
                  });
            },
            child: Container(
              width: 200,
              height: 40.0,
              child: Material(
                borderRadius: BorderRadius.circular(20.0),
                shadowColor: Colors.greenAccent,
                color: Colors.blueAccent,
                elevation: 7.0,
                child: Center(
                  child: Text(
                    'join us now',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
