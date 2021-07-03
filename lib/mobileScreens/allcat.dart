import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Allcat extends StatefulWidget {
  @override
  _AllcatState createState() => _AllcatState();
}

class _AllcatState extends State<Allcat> {
  Future<void> _showMyDialogdelete(String catid) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("yes", style: TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.pop(context);
                await FirebaseFirestore.instance
                    .collection('cat')
                    .doc(catid)
                    .delete();
              },
            ),
            FlatButton(
              child: Text('No', style: TextStyle(color: Colors.green)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget details(String catid, String catname) {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Card(
          child: ListTile(
            onLongPress: () {
              _showMyDialogdelete(catid);
            },
            title: Text(catname),
            trailing: IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                _showMyDialogdelete(catid);
              },
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('cat').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              default:
                return Column(
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'All categories',
                            style: TextStyle(
                                color: Colors.green[600],
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                                fontSize: 25),
                          ),
                          SizedBox(
                            height: 90,
                            width: 5,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height - 190,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(25, 10, 25, 0),
                        child: Center(
                          child: Container(
                            height: MediaQuery.of(context).size.height - 120,
                            width: 800,
                            child: ListView(
                              children: snapshot.data.docs
                                  .map((DocumentSnapshot document) {
                                return details(
                                    document['id'], document['catname']);
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
            }
          },
        ),
      ),
    );
  }
}
