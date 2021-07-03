import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:newsapp/bodywidgets/Navbar.dart';
import 'package:newsapp/bodywidgets/createnewnews.dart';
import 'package:newsapp/bodywidgets/newcatpopup.dart';
import 'package:newsapp/bodywidgets/sidewidgetview.dart';
import 'package:newsapp/bodywidgets/userinfo.dart';
import 'package:newsapp/bodywidgets/userlistrow.dart';
import 'package:newsapp/methods/FirebaseAuth.dart';
import 'package:newsapp/mobileScreens/allcat.dart';
import 'package:newsapp/mobileScreens/allnews.dart';
import 'package:newsapp/mobileScreens/userslist.dart';

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  Firebasemethods firebasemethods = Firebasemethods();
  final ScrollController _controllerdivf = ScrollController();
  bool isnewnews = false, iscat = false, isuser = false;
  bool isuserselected = false;
  String selecteduseruid;
  User user;
  Future getUserInfo() async {
    await firebasemethods.getUser().then((User userget) {
      if (userget != null) {
        setState(() {
          user = userget;
        });
      }
    });
    setState(() {});
  }

  DocumentReference docref =
      FirebaseFirestore.instance.collection('news').doc();
  Widget list_row(
    String name,
    String title,
    Icon icon,
    String path,
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Card(
        shadowColor: Colors.blue,
        margin: EdgeInsets.fromLTRB(1, 1, 1, 0),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: InkWell(
            onTap: () async {
              if (name == 'Create new category') {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Newcatpopup(),
                      );
                    });
              } else if (name == 'Create new news') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Scaffold(body: Createnewnews())),
                );
              } else if (name == 'view all news') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Scaffold(body: Allnews(user, level))),
                );
              } else if (name == 'users') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Scaffold(body: UserList())),
                );
              } else if (name == 'view all categorys') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Scaffold(body: Allcat())),
                );
              }
            },
            child: Column(
              children: [
                icon,
                SizedBox(
                  height: 7,
                ),
                Text(
                  name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      fontFamily: 'Montserrat'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserInfo();
    super.initState();
  }

  Widget mainGride(
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
                Navigator.pushNamed(context, '/news', arguments: {
                  'newsid': id,
                  'user': user,
                  'type': level,
                });
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

  String level;
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('users')
        .where("uid", isEqualTo: user.uid)
        .snapshots()
        .listen((data) => data.docs.forEach((doc) => level = doc['level']));
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: user.uid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          default:
            return Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: MediaQuery.of(context).size.width < 1200
                    ? level == 'admin'
                        ? Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color.fromRGBO(0, 160, 170, 1.0),
                                    Color.fromRGBO(0, 255, 110, 1.0)
                                  ]),
                            ),
                            child: ListView(
                              children: [
                                NavBar('home'),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height - 300,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
                                    child: GridView.count(
                                      mainAxisSpacing: 5,
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 5,
                                      primary: false,
                                      children: [
                                        list_row(
                                            'Create new news',
                                            '',
                                            Icon(Icons.post_add_outlined),
                                            '/doclist'),
                                        list_row(
                                          'view all news',
                                          '',
                                          Icon(Icons.post_add_outlined),
                                          '/nursemasterlist',
                                        ),
                                        list_row(
                                          'Create new category',
                                          '',
                                          Icon(Icons.category_outlined),
                                          '/dispatchermasterlis',
                                        ),
                                        list_row(
                                          'view all news',
                                          '',
                                          Icon(Icons
                                              .featured_play_list_outlined),
                                          '/adminmasterlist',
                                        ),
                                        list_row(
                                          'view all categorys',
                                          '',
                                          Icon(Icons.list),
                                          '/patientmasterlist',
                                        ),
                                        list_row(
                                          'users',
                                          '',
                                          Icon(Icons.person),
                                          '/newusermasterlist',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('news')
                                .where('view', isEqualTo: 'yes')
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError)
                                return Text('Error: ${snapshot.error}');
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return Center(
                                      child: CircularProgressIndicator());
                                default:
                                  return Padding(
                                    padding: EdgeInsets.fromLTRB(15, 5, 15, 0),
                                    child: MediaQuery.of(context).size.width <
                                            850
                                        ? GridView.count(
                                            mainAxisSpacing: 10,
                                            crossAxisCount: 1,
                                            crossAxisSpacing: 10,
                                            primary: false,
                                            controller: _controllerdivf,
                                            children: snapshot.data.docs.map(
                                                (DocumentSnapshot document) {
                                              return mainGride(
                                                  document['pannerurl'],
                                                  document['id'],
                                                  document['title'],
                                                  document['subtitle'],
                                                  document['createddate']);
                                            }).toList(),
                                          )
                                        : CupertinoScrollbar(
                                            isAlwaysShown: true,
                                            thickness: 14,
                                            controller: _controllerdivf,
                                            child: GridView.count(
                                              mainAxisSpacing: 10,
                                              crossAxisCount: 5,
                                              crossAxisSpacing: 10,
                                              primary: false,
                                              controller: _controllerdivf,
                                              children: snapshot.data.docs.map(
                                                  (DocumentSnapshot document) {
                                                return mainGride(
                                                    document['pannerurl'],
                                                    document['id'],
                                                    document['title'],
                                                    document['subtitle'],
                                                    document['createddate']);
                                              }).toList(),
                                            ),
                                          ),
                                  );
                              }
                            },
                          )
                    : Container(
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
                              NavBar('home'),
                              SizedBox(
                                height: 15,
                              ),
                              level == 'admin'
                                  ? Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          width: 150,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              100,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      isnewnews = true;
                                                      iscat = false;
                                                      isuser = false;
                                                    });
                                                  },
                                                  child: Sideview(
                                                      'Create new news',
                                                      Icon(Icons
                                                          .post_add_outlined),
                                                      Colors.blue)),
                                              InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            content:
                                                                Newcatpopup(),
                                                          );
                                                        });
                                                  },
                                                  child: Sideview(
                                                      'Create new category',
                                                      Icon(Icons
                                                          .category_outlined),
                                                      Colors.blue)),
                                              InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      isnewnews = false;
                                                      iscat = false;
                                                      isuser = false;
                                                    });
                                                  },
                                                  child: Sideview(
                                                      'view all news',
                                                      Icon(Icons
                                                          .featured_play_list_outlined),
                                                      Colors.blue)),
                                              InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      isnewnews = false;
                                                      iscat = true;
                                                      isuser = false;
                                                    });
                                                  },
                                                  child: Sideview(
                                                      'view all categorys',
                                                      Icon(Icons.list),
                                                      Colors.blue)),
                                              InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      isnewnews = false;
                                                      iscat = false;
                                                      isuser = true;
                                                    });
                                                  },
                                                  child: Sideview(
                                                      'Users',
                                                      Icon(Icons.person),
                                                      Colors.blue)),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 25,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              250,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              100,
                                          child: isnewnews
                                              ? Createnewnews()
                                              : iscat
                                                  ? Allcat()
                                                  : isuser
                                                      ? Row(
                                                          children: [
                                                            StreamBuilder<
                                                                QuerySnapshot>(
                                                              stream: FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'users')
                                                                  .snapshots(),
                                                              builder: (BuildContext
                                                                      context,
                                                                  AsyncSnapshot<
                                                                          QuerySnapshot>
                                                                      snapshot) {
                                                                if (snapshot
                                                                    .hasError)
                                                                  return Text(
                                                                      'Error: ${snapshot.error}');
                                                                switch (snapshot
                                                                    .connectionState) {
                                                                  case ConnectionState
                                                                      .waiting:
                                                                    return Center(
                                                                      child:
                                                                          CircularProgressIndicator(),
                                                                    );
                                                                  default:
                                                                    return Container(
                                                                      width: (MediaQuery.of(context).size.width -
                                                                              250) *
                                                                          0.49,
                                                                      height: MediaQuery.of(context)
                                                                              .size
                                                                              .height -
                                                                          100,
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              image: DecorationImage(
                                                                                image: AssetImage("assets/pic.png"),
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                            ),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Text(
                                                                                  'Choose a user',
                                                                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Montserrat', fontSize: 25),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 125,
                                                                                  width: 5,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            height:
                                                                                MediaQuery.of(context).size.height - 250,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.white,
                                                                            ),
                                                                            child:
                                                                                ListView(
                                                                              children: snapshot.data.docs.map((DocumentSnapshot document) {
                                                                                return InkWell(
                                                                                    onTap: () {
                                                                                      setState(() {
                                                                                        selecteduseruid = document['uid'];
                                                                                        isuserselected = true;
                                                                                      });
                                                                                    },
                                                                                    child: Userlistrow(document['pic'], document['name'], document['email'], document['level'], selecteduseruid == document['uid'] ? Colors.grey[350] : Colors.white));
                                                                              }).toList(),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                }
                                                              },
                                                            ),
                                                            isuserselected
                                                                ? StreamBuilder<
                                                                    QuerySnapshot>(
                                                                    stream: FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'users')
                                                                        .where(
                                                                            'uid',
                                                                            isEqualTo:
                                                                                selecteduseruid)
                                                                        .snapshots(),
                                                                    builder: (BuildContext
                                                                            context,
                                                                        AsyncSnapshot<QuerySnapshot>
                                                                            snapshot) {
                                                                      if (snapshot
                                                                          .hasError)
                                                                        return Text(
                                                                            'Error: ${snapshot.error}');
                                                                      switch (snapshot
                                                                          .connectionState) {
                                                                        case ConnectionState
                                                                            .waiting:
                                                                          return Center(
                                                                            child:
                                                                                CircularProgressIndicator(),
                                                                          );
                                                                        default:
                                                                          return Container(
                                                                            width:
                                                                                (MediaQuery.of(context).size.width - 250) * 0.49,
                                                                            height:
                                                                                MediaQuery.of(context).size.height - 100,
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Container(
                                                                                  height: MediaQuery.of(context).size.height - 250,
                                                                                  decoration: BoxDecoration(
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                  child: ListView(
                                                                                    children: snapshot.data.docs.map((DocumentSnapshot document) {
                                                                                      return Userprofile(document['pic'], document['name'], document['email'], document['level'], document['uid']);
                                                                                    }).toList(),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          );
                                                                      }
                                                                    },
                                                                  )
                                                                : Container(
                                                                    width: (MediaQuery.of(context).size.width -
                                                                            250) *
                                                                        0.49,
                                                                    height: MediaQuery.of(context)
                                                                            .size
                                                                            .height -
                                                                        100,
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                            'no user selected yet')
                                                                      ],
                                                                    ),
                                                                  ),
                                                          ],
                                                        )
                                                      : StreamBuilder<
                                                          QuerySnapshot>(
                                                          stream:
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'news')
                                                                  .where('view',
                                                                      isEqualTo:
                                                                          'yes')
                                                                  .snapshots(),
                                                          builder: (BuildContext
                                                                  context,
                                                              AsyncSnapshot<
                                                                      QuerySnapshot>
                                                                  snapshot) {
                                                            if (snapshot
                                                                .hasError)
                                                              return Text(
                                                                  'Error: ${snapshot.error}');
                                                            switch (snapshot
                                                                .connectionState) {
                                                              case ConnectionState
                                                                  .waiting:
                                                                return Center(
                                                                    child:
                                                                        CircularProgressIndicator());
                                                              default:
                                                                return Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          15,
                                                                          5,
                                                                          15,
                                                                          0),
                                                                  child: MediaQuery.of(context)
                                                                              .size
                                                                              .width <
                                                                          850
                                                                      ? GridView
                                                                          .count(
                                                                          mainAxisSpacing:
                                                                              10,
                                                                          crossAxisCount:
                                                                              1,
                                                                          crossAxisSpacing:
                                                                              10,
                                                                          primary:
                                                                              false,
                                                                          controller:
                                                                              _controllerdivf,
                                                                          children: snapshot
                                                                              .data
                                                                              .docs
                                                                              .map((DocumentSnapshot document) {
                                                                            return mainGride(
                                                                                document['pannerurl'],
                                                                                document['id'],
                                                                                document['title'],
                                                                                document['subtitle'],
                                                                                document['createddate']);
                                                                          }).toList(),
                                                                        )
                                                                      : CupertinoScrollbar(
                                                                          isAlwaysShown:
                                                                              true,
                                                                          thickness:
                                                                              14,
                                                                          controller:
                                                                              _controllerdivf,
                                                                          child:
                                                                              GridView.count(
                                                                            mainAxisSpacing:
                                                                                10,
                                                                            crossAxisCount:
                                                                                5,
                                                                            crossAxisSpacing:
                                                                                10,
                                                                            primary:
                                                                                false,
                                                                            controller:
                                                                                _controllerdivf,
                                                                            children:
                                                                                snapshot.data.docs.map((DocumentSnapshot document) {
                                                                              return mainGride(document['pannerurl'], document['id'], document['title'], document['subtitle'], document['createddate']);
                                                                            }).toList(),
                                                                          ),
                                                                        ),
                                                                );
                                                            }
                                                          },
                                                        ),
                                        ),
                                      ],
                                    )
                                  : level == 'user'
                                      ? Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.85,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              100,
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
                                              switch (
                                                  snapshot.connectionState) {
                                                case ConnectionState.waiting:
                                                  return Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                default:
                                                  return Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            15, 5, 15, 0),
                                                    child: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width <
                                                            850
                                                        ? GridView.count(
                                                            mainAxisSpacing: 10,
                                                            crossAxisCount: 1,
                                                            crossAxisSpacing:
                                                                10,
                                                            primary: false,
                                                            controller:
                                                                _controllerdivf,
                                                            children: snapshot
                                                                .data.docs
                                                                .map((DocumentSnapshot
                                                                    document) {
                                                              return mainGride(
                                                                  document[
                                                                      'pannerurl'],
                                                                  document[
                                                                      'id'],
                                                                  document[
                                                                      'title'],
                                                                  document[
                                                                      'subtitle'],
                                                                  document[
                                                                      'createddate']);
                                                            }).toList(),
                                                          )
                                                        : CupertinoScrollbar(
                                                            isAlwaysShown: true,
                                                            thickness: 14,
                                                            controller:
                                                                _controllerdivf,
                                                            child:
                                                                GridView.count(
                                                              mainAxisSpacing:
                                                                  10,
                                                              crossAxisCount: 5,
                                                              crossAxisSpacing:
                                                                  10,
                                                              primary: false,
                                                              controller:
                                                                  _controllerdivf,
                                                              children: snapshot
                                                                  .data.docs
                                                                  .map((DocumentSnapshot
                                                                      document) {
                                                                return mainGride(
                                                                    document[
                                                                        'pannerurl'],
                                                                    document[
                                                                        'id'],
                                                                    document[
                                                                        'title'],
                                                                    document[
                                                                        'subtitle'],
                                                                    document[
                                                                        'createddate']);
                                                              }).toList(),
                                                            ),
                                                          ),
                                                  );
                                              }
                                            },
                                          ),
                                        )
                                      : Center(
                                          child: Text('you are disabled user'),
                                        )
                            ],
                          ),
                        ),
                      ),
              ),
            );
        }
      },
    );
  }
}
