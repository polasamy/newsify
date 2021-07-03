import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Newcatpopup extends StatefulWidget {
  @override
  _NewcatpopupState createState() => _NewcatpopupState();
}

class _NewcatpopupState extends State<Newcatpopup> {
  final _formKey = GlobalKey<FormState>();
  bool issave = false;
  String catname;
  final TextEditingController _catnamecon = TextEditingController();

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
        DocumentReference documentReference =
            FirebaseFirestore.instance.collection('cat').doc();
        await documentReference.set({
          'catname': catname,
          'id': documentReference.id,
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
                        'New category',
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
                      Icons.list,
                      color: Color(0xFF009FD6),
                    ),
                    hintText: 'Category name',
                    labelText: 'Category name *',
                    labelStyle: TextStyle(
                      color: Color(0xFF009FD6),
                    ),
                  ),
                  controller: _catnamecon,
                  validator: (val) {
                    return val.isEmpty ? 'category name canot be empty' : null;
                  },
                  onSaved: (value) => catname = value,
                ),
                SizedBox(
                  height: 5,
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
