import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:newsapp/bodywidgets/loginpopup.dart';
import 'package:newsapp/methods/FirebaseAuth.dart';

class NavBar extends StatefulWidget {
  final String page;
  NavBar(this.page, {Key key}) : super(key: key);
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  Color hovColorlogin = Colors.black;
  Color hovColoraboutus = Colors.black;
  Firebasemethods firebasemethods = Firebasemethods();
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 1200),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'NewsiFy',
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 5,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: Row(
              children: [
                InkWell(
                  onTap: () {},
                  onHover: (isHover) {
                    setState(() {
                      isHover
                          ? hovColoraboutus = Colors.white
                          : hovColoraboutus = Colors.black;
                    });
                  },
                  child: Text(
                    'About us',
                    style: TextStyle(color: hovColoraboutus),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                InkWell(
                  onTap: () async {
                    if (widget.page == 'home') {
                      await firebasemethods.signout();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/', (Route<dynamic> route) => false);
                    } else if (widget.page == 'start') {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: loginpopup(context),
                            );
                          });
                    }
                  },
                  onHover: (isHover) {
                    setState(() {
                      isHover
                          ? hovColorlogin = Colors.white
                          : hovColorlogin = Colors.black;
                    });
                  },
                  child: widget.page == 'home'
                      ? Text('Signout', style: TextStyle(color: hovColorlogin))
                      : Text(
                          'login',
                          style: TextStyle(color: hovColorlogin),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
