import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/bodywidgets/Editenews.dart';
import 'package:newsapp/bodywidgets/Navbar.dart';
import 'package:newsapp/bodywidgets/imageviewer.dart';
import 'package:newsapp/bodywidgets/popUpPlayingvideo.dart';

class Newsviewer extends StatefulWidget {
  @override
  _NewsviewerState createState() => _NewsviewerState();
}

class _NewsviewerState extends State<Newsviewer> {
  Map data = {'user': 'user'};
  String title, subtitle, desc, createddate, pannerurl, catname;
  final ScrollController _controllerdivf = ScrollController();
  Future<void> _showMyDialogdelete(BuildContext context2) async {
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
                await FirebaseFirestore.instance
                    .collection('news')
                    .doc(data['newsid'])
                    .delete();
                Navigator.pop(context);
                Navigator.pop(context2);
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

  Widget sideGride(
    String pannerurl,
    String id,
    String title,
    String somedetails,
    String date,
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Card(
        shadowColor: Colors.blue,
        margin: EdgeInsets.fromLTRB(1, 0, 1, 0),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: InkWell(
            onTap: () {
              setState(() {
                data['newsid'] = id;
              });
            },
            child: Column(
              children: [
                Image.network(
                  pannerurl,
                  width: 170,
                  height: 110,
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
    );
  }

  Widget list_row_comment(String comment, String by, String time, String id) {
    String name, pic;
    FirebaseFirestore.instance
        .collection('users')
        .where("uid", isEqualTo: by)
        .snapshots()
        .listen((data) => data.docs.forEach((doc) {
              name = doc['name'];
              pic = doc['pic'];
            }));
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('uid', isEqualTo: by)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              return ListTile(
                leading: Image.network(
                  pic,
                  width: 75,
                  height: 75,
                ),
                title: Text(name),
                subtitle: Text(comment),
              );
          }
        },
      ),
    );
  }

  Widget list_row_img(String url, String filename, String id) {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
        child: InkWell(
            onTap: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Imageview(
                  url,
                );
              }));
            },
            onLongPress: () {
              //_showMyDialog(filename, type, id);
            },
            child: Image.network(
              url,
              width: 45,
              height: 45,
            )));
  }

  Widget list_row_video(
      String url, String filename, String id, String videoImgUrl) {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
        child: InkWell(
            onTap: () async {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Popupvideo(url),
                    );
                  });
            },
            child: Container(
              width: 175,
              height: 175,
              child: Stack(
                overflow: Overflow.visible,
                children: [
                  Image.network(
                    videoImgUrl,
                    width: 175,
                    height: 175,
                  ),
                  Center(
                    child: Icon(
                      Icons.play_circle_fill,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )));
  }

  final TextEditingController _commentcon = TextEditingController();
  String comment;
  User user;
  bool allowedite = false;
  @override
  Widget build(BuildContext context) {
    data = data.isEmpty ? data : ModalRoute.of(context).settings.arguments;
    user = data['user'];
    FirebaseFirestore.instance
        .collection('news')
        .where("id", isEqualTo: data['newsid'])
        .snapshots()
        .listen((data) => data.docs.forEach((doc) {
              title = doc['title'];
              subtitle = doc['subtitle'];
              pannerurl = doc['pannerurl'];
              desc = doc['desc'];
              createddate = doc['createddate'];
            }));
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('news').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            return Scaffold(
              body: SafeArea(
                  child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color.fromRGBO(0, 160, 170, 1.0),
                        Color.fromRGBO(0, 255, 110, 1.0)
                      ]),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: ListView(
                    children: [
                      MediaQuery.of(context).size.width > 850
                          ? NavBar('home')
                          : SizedBox(
                              height: 9,
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MediaQuery.of(context).size.width > 850
                              ? Column(
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 250,
                                      child: Center(
                                          child: Text(
                                        'More news',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )),
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.white)),
                                    ),
                                    Container(
                                      width: 250,
                                      height:
                                          MediaQuery.of(context).size.height -
                                              147,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      child: StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('news')
                                            .where('view', isEqualTo: 'yes')
                                            .snapshots(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<QuerySnapshot>
                                                snapshot) {
                                          if (snapshot.hasError)
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          switch (snapshot.connectionState) {
                                            case ConnectionState.waiting:
                                              return Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            default:
                                              return Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      5, 5, 5, 0),
                                                  child: GridView.count(
                                                    semanticChildCount: 2,
                                                    mainAxisSpacing: 2,
                                                    crossAxisCount: 1,
                                                    crossAxisSpacing: 2,
                                                    primary: false,
                                                    controller: _controllerdivf,
                                                    children: snapshot.data.docs
                                                        .map((DocumentSnapshot
                                                            document) {
                                                      return sideGride(
                                                          document['pannerurl'],
                                                          document['id'],
                                                          document['title'],
                                                          document['subtitle'],
                                                          document[
                                                              'createddate']);
                                                    }).toList(),
                                                  ));
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              : SizedBox(
                                  width: 1,
                                ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width > 850
                                ? MediaQuery.of(context).size.width - 320
                                : MediaQuery.of(context).size.width - 56,
                            height: MediaQuery.of(context).size.height - 92,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: allowedite
                                ? Editenews(
                                    data['newsid'],
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: ListView(
                                      children: [
                                        data['type'] == 'admin'
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          allowedite = true;
                                                        });
                                                      },
                                                      icon: Icon(Icons.edit)),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  IconButton(
                                                      onPressed: () async {
                                                        _showMyDialogdelete(
                                                            context);
                                                      },
                                                      icon: Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                      )),
                                                ],
                                              )
                                            : SizedBox(
                                                height: 0.004,
                                              ),
                                        SizedBox(
                                          height: 7,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              330,
                                          child: Text(
                                            title,
                                            style: TextStyle(
                                              fontFamily: 'OpenSans',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 26,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 7,
                                        ),
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                330,
                                            child: Text(
                                              subtitle,
                                              style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                color: Colors.grey[600],
                                                fontSize: 21,
                                              ),
                                            )),
                                        SizedBox(
                                          height: 7,
                                        ),
                                        Text(createddate.substring(0, 16)),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Image.network(
                                          pannerurl,
                                        ),
                                        SizedBox(
                                          height: 13,
                                        ),
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                330,
                                            child: Text(
                                              desc,
                                              style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 18,
                                              ),
                                            )),
                                        SizedBox(
                                          height: 7,
                                        ),
                                        StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('news')
                                              .doc(data['newsid'])
                                              .collection('img')
                                              .snapshots(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  snapshot) {
                                            if (snapshot.hasError)
                                              return Text(
                                                  'Error: ${snapshot.error}');

                                            switch (snapshot.connectionState) {
                                              case ConnectionState.waiting:
                                                return Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              default:
                                                return snapshot.hasData &&
                                                        snapshot.data.size != 0
                                                    ? Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 15,
                                                          ),
                                                          Center(
                                                              child: Text(
                                                            'Images',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.blue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20),
                                                          )),
                                                          Container(
                                                            height: 250,
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          5,
                                                                          7,
                                                                          5,
                                                                          5),
                                                              child: Container(
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                height: 300,
                                                                child: Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          10,
                                                                          0,
                                                                          10,
                                                                          0),
                                                                  child: GridView
                                                                      .count(
                                                                    mainAxisSpacing:
                                                                        5,
                                                                    crossAxisCount:
                                                                        MediaQuery.of(context).size.width <
                                                                                850
                                                                            ? 2
                                                                            : 5,
                                                                    crossAxisSpacing:
                                                                        5,
                                                                    primary:
                                                                        false,
                                                                    children: snapshot
                                                                        .data
                                                                        .docs
                                                                        .map((DocumentSnapshot
                                                                            document) {
                                                                      return list_row_img(
                                                                          document[
                                                                              'url'],
                                                                          document[
                                                                              'filename'],
                                                                          document
                                                                              .id
                                                                              .toString());
                                                                    }).toList(),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : Container(
                                                        height: 5,
                                                      );
                                            }
                                          },
                                        ),
                                        StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('news')
                                              .doc(data['newsid'])
                                              .collection('videos')
                                              .where('view', isEqualTo: 'yes')
                                              .snapshots(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  snapshot) {
                                            if (snapshot.hasError)
                                              return Text(
                                                  'Error: ${snapshot.error}');

                                            switch (snapshot.connectionState) {
                                              case ConnectionState.waiting:
                                                return CircularProgressIndicator();
                                              default:
                                                return snapshot.hasData &&
                                                        snapshot.data.size != 0
                                                    ? Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 15,
                                                          ),
                                                          Center(
                                                              child: Text(
                                                            'videos',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.blue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20),
                                                          )),
                                                          Container(
                                                            height: 250,
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          5,
                                                                          7,
                                                                          5,
                                                                          5),
                                                              child: Container(
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height -
                                                                    500,
                                                                child: Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          10,
                                                                          0,
                                                                          10,
                                                                          0),
                                                                  child: GridView
                                                                      .count(
                                                                    mainAxisSpacing:
                                                                        5,
                                                                    crossAxisCount:
                                                                        MediaQuery.of(context).size.width <
                                                                                850
                                                                            ? 2
                                                                            : 5,
                                                                    crossAxisSpacing:
                                                                        5,
                                                                    primary:
                                                                        false,
                                                                    children: snapshot
                                                                        .data
                                                                        .docs
                                                                        .map((DocumentSnapshot
                                                                            document) {
                                                                      return list_row_video(
                                                                          document[
                                                                              'videourl'],
                                                                          document[
                                                                              'videonamename'],
                                                                          document
                                                                              .id
                                                                              .toString(),
                                                                          document[
                                                                              'videoImgUrl']);
                                                                    }).toList(),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : Container(
                                                        height: 5,
                                                      );
                                            }
                                          },
                                        ),
                                        Container(
                                          height: 100,
                                          child: TextField(
                                            textInputAction:
                                                TextInputAction.send,
                                            onSubmitted: (value) {
                                              try {
                                                FirebaseFirestore.instance
                                                    .collection('news')
                                                    .doc(data['newsid'])
                                                    .collection('comments')
                                                    .doc()
                                                    .set({
                                                  'comment': value,
                                                  'by': user.uid.toString(),
                                                  'view': 'yes',
                                                  'time': DateTime.now()
                                                      .toString()
                                                      .substring(0, 16),
                                                  'sendDate': DateTime.now(),
                                                });
                                                _commentcon.clear();
                                              } catch (e) {
                                                print('error: $e');
                                              }
                                            },
                                            controller: _commentcon,
                                            style:
                                                TextStyle(color: Colors.white),
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                              filled: true,
                                              fillColor: Colors.grey[700],
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  const Radius.circular(40),
                                                ),
                                                borderSide: const BorderSide(
                                                    color: Colors.grey,
                                                    width: 0.2),
                                              ),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    const Radius.circular(40),
                                                  ),
                                                  borderSide: const BorderSide(
                                                      color: Colors.grey,
                                                      width: 0.2)),
                                              hintText:
                                                  "Type your comment here",
                                              hintStyle: TextStyle(
                                                  color: Colors.grey[400]),
                                            ),
                                          ),
                                        ),
                                        StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('news')
                                              .doc(data['newsid'])
                                              .collection('comments')
                                              .snapshots(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  snapshot) {
                                            if (snapshot.hasError)
                                              return Text(
                                                  'Error: ${snapshot.error}');

                                            switch (snapshot.connectionState) {
                                              case ConnectionState.waiting:
                                                return CircularProgressIndicator();
                                              default:
                                                return snapshot.hasData &&
                                                        snapshot.data.size != 0
                                                    ? Container(
                                                        height: 350,
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  5, 7, 5, 5),
                                                          child: Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height -
                                                                500,
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          10,
                                                                          0,
                                                                          10,
                                                                          0),
                                                              child: ListView(
                                                                children: snapshot
                                                                    .data.docs
                                                                    .map((DocumentSnapshot
                                                                        document) {
                                                                  return list_row_comment(
                                                                    document[
                                                                        'comment'],
                                                                    document[
                                                                        'by'],
                                                                    document[
                                                                        'time'],
                                                                    document.id
                                                                        .toString(),
                                                                  );
                                                                }).toList(),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        height: 7,
                                                      );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )),
            );
        }
      },
    );
  }
}
