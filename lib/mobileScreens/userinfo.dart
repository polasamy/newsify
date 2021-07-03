import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/bodywidgets/userinfo.dart';

class Userinfo extends StatefulWidget {
  final String selecteduseruid;
  //if you have multiple values add here
  Userinfo(this.selecteduseruid, {Key key}) : super(key: key);
  @override
  _UserinfoState createState() => _UserinfoState();
}

class _UserinfoState extends State<Userinfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('uid', isEqualTo: widget.selecteduseruid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              default:
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 100,
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height - 250,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: ListView(
                          children: snapshot.data.docs
                              .map((DocumentSnapshot document) {
                            return Userprofile(
                                document['pic'],
                                document['name'],
                                document['email'],
                                document['level'],
                                document['uid']);
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
