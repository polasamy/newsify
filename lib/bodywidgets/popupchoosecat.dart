import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Popupchoosecat extends StatefulWidget {
  String docid;
  Popupchoosecat(this.docid,{Key key}):super(key: key);
  @override
  _PopupchoosecatState createState() => _PopupchoosecatState();
}

class _PopupchoosecatState extends State<Popupchoosecat> {
  Widget details (String catid,String catname){
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Card(
      child: ListTile(
        onTap: ()async{
          await FirebaseFirestore.instance.collection('news').doc(widget.docid).update({
            'catname':catname,
          });
          Fluttertoast.showToast(
        msg: "Saved complete",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM_RIGHT,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
          Navigator.pop(context);

        },
        title: Text(catname),
      ),
    ));
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('cat').snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return Center(child: CircularProgressIndicator(),);
          default:
            return Padding(
                  padding: EdgeInsets.fromLTRB(25, 10, 25, 0),
                  child: Center(
                        child: Container(
                          height:MediaQuery.of(context).size.height-120 ,
                          width:800 ,
                          child: ListView(
                            children: snapshot.data.docs.map((DocumentSnapshot document) {
                                return details(document['id'], document['catname']);   
                        }).toList(),
                          ),
                        ),
                      ),
                );
        }
      },
    );
  }
}