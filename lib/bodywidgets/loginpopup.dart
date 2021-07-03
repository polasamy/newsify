import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/methods/FirebaseAuth.dart';

class loginpopup extends StatefulWidget {
  BuildContext context;
  loginpopup(this.context, {Key key}) : super(key: key);
  @override
  _loginpopupState createState() => _loginpopupState();
}

class _loginpopupState extends State<loginpopup> {
  final _formKey = GlobalKey<FormState>();
  Firebasemethods firebasemethods = Firebasemethods();
  bool issignin = false;
  String _username, _password;
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _emailcon = TextEditingController();

  bool validateandsave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  Future validateandsubmit() async {
    if (validateandsave()) {
      try {
        setState(() {
          issignin = true;
        });
        await firebasemethods
            .signinemail(_username, _password)
            .then((User user) {
          if (user != null) {
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            print('some thing went wrong');
          }
        });

        setState(() {
          issignin = false;
        });
      } catch (e) {
        setState(() {
          issignin = false;
        });
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Positioned(
            right: -40.0,
            top: -40.0,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: CircleAvatar(
                child: Icon(Icons.close),
                backgroundColor: Colors.red,
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                      child: Text(
                        'Sign in',
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(5, 15, 5, 0),
                      child: Text(
                        '.',
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 9,
                ),
                TextFormField(
                  cursorColor: Color(0xFF009FD6),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color(0xFF009FD6), width: 2.0),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                      const Radius.circular(10),
                    )),
                    icon: Icon(
                      Icons.email,
                      color: Color(0xFF009FD6),
                    ),
                    hintText: 'Email',
                    labelText: 'Email *',
                    labelStyle: TextStyle(
                      color: Color(0xFF009FD6),
                    ),
                  ),
                  controller: _emailcon,
                  validator: (val) {
                    return val.isEmpty ? 'email canot be empty' : null;
                  },
                  onSaved: (value) => _username = value,
                ),
                SizedBox(
                  height: 2,
                ),
                TextFormField(
                  cursorColor: Color(0xFF009FD6),
                  obscureText: true,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color(0xFF009FD6), width: 2.0),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                      const Radius.circular(10),
                    )),
                    icon: Icon(
                      Icons.lock,
                      color: Color(0xFF009FD6),
                    ),
                    hintText: 'Password',
                    labelText: 'Password *',
                    labelStyle: TextStyle(
                      color: Color(0xFF009FD6),
                    ),
                  ),
                  controller: _pass,
                  validator: (val) {
                    return val.isEmpty ? 'password canot be empty' : null;
                  },
                  onSaved: (value) => _password = value,
                ),
                SizedBox(
                  height: 15,
                ),
                issignin
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        width: 250,
                        height: 130,
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              validateandsubmit();
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
                                    'Login',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                SizedBox(height: 5.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
