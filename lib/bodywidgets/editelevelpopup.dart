import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:newsapp/methods/FirebaseAuth.dart';

class Editelevelpopup extends StatefulWidget {
  String useruid, level;
  Editelevelpopup(this.useruid, this.level, {Key key}) : super(key: key);
  @override
  _EditelevelpopupState createState() => _EditelevelpopupState();
}

class _EditelevelpopupState extends State<Editelevelpopup> {
  final _formKey = GlobalKey<FormState>();
  Firebasemethods firebasemethods = Firebasemethods();
  bool issave = false;
  String _level;

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
          issave = true;
        });
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.useruid)
            .update({
          'level': _level,
        });

        Fluttertoast.showToast(
            msg: "Saved complete",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM_RIGHT,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pop(context);

        setState(() {
          issave = false;
        });
      } catch (e) {
        setState(() {
          issave = false;
        });
        print(e);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _level = widget.level;
    });
    super.initState();
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
                      padding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                      child: Text(
                        'Edite user level',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(7, 30, 7, 0),
                      child: Text(
                        '.',
                        style: TextStyle(
                            fontSize: 55,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.trending_up,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    DropdownButton<String>(
                      value: _level,
                      focusColor: Colors.blue,
                      icon: Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.black),
                      underline: Container(
                        height: 1.55,
                        color: Colors.grey[500],
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          _level = newValue;
                        });
                      },
                      hint: Text('level'),
                      items: <String>['disable', 'admin', 'user']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                issave
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        width: 250,
                        height: 150,
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
                                    'Save',
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
                SizedBox(height: 10.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
