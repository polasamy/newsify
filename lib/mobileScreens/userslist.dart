import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/bodywidgets/userlistrow.dart';
import 'package:newsapp/mobileScreens/userinfo.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
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
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color.fromRGBO(0, 160, 170, 1.0),
                          Color.fromRGBO(0, 255, 110, 1.0)
                        ]),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/pic.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Choose a user',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                  fontSize: 25),
                            ),
                            SizedBox(
                              height: 120,
                              width: 5,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height - 155,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: ListView(
                          children: snapshot.data.docs
                              .map((DocumentSnapshot document) {
                            return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Scaffold(
                                            body: Userinfo(document['uid']))),
                                  );
                                },
                                child: Userlistrow(
                                    document['pic'],
                                    document['name'],
                                    document['email'],
                                    document['level'],
                                    Colors.white));
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
