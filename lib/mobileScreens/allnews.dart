import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Allnews extends StatefulWidget {
  final User user;
  String level;
  //if you have multiple values add here
  Allnews(this.user, this.level, {Key key}) : super(key: key);
  @override
  _AllnewsState createState() => _AllnewsState();
}

class _AllnewsState extends State<Allnews> {
  final ScrollController _controllerdivf = ScrollController();
  Widget mainGride(
    String pannerurl,
    String id,
    String title,
    String somedetails,
    String date,
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 20, 0),
      child: Container(
        child: Card(
          shadowColor: Colors.blue,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  Navigator.pushNamed(context, '/news', arguments: {
                    'newsid': id,
                    'user': widget.user,
                    'type': widget.level,
                  });
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network(
                    pannerurl,
                    height: 170,
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'Montserrat'),
                  ),
                  Text(
                    date,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontFamily: 'Montserrat'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('news')
            .where('view', isEqualTo: 'yes')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              return Padding(
                  padding: EdgeInsets.fromLTRB(25, 15, 20, 20),
                  child: GridView.count(
                    mainAxisSpacing: 5,
                    crossAxisCount: 1,
                    crossAxisSpacing: 5,
                    primary: false,
                    controller: _controllerdivf,
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                      return mainGride(
                          document['pannerurl'],
                          document['id'],
                          document['title'],
                          document['subtitle'],
                          document['createddate']);
                    }).toList(),
                  ));
          }
        },
      ),
    );
  }
}
