import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:newsapp/bodywidgets/imageviewer.dart';
import 'package:newsapp/bodywidgets/popUpPlayingvideo.dart';
import 'package:newsapp/bodywidgets/popupchoosecat.dart';
import 'popUpUploadingVideo.dart';

class Createnewnews extends StatefulWidget {
  @override
  _CreatenewnewsState createState() => _CreatenewnewsState();
}

class _CreatenewnewsState extends State<Createnewnews> {
  Uint8List uploadfile;
  String fileName;
  bool load_image = false,
      load_video = false,
      load_banner = false,
      createnew = false,
      issave = false,
      cat_error = false,
      bannerpic_error = false;
  String title = '', subtitle = '', desc = '', art = '';
  final TextEditingController _titlecon = TextEditingController();
  final TextEditingController _subtitlecon = TextEditingController();
  final TextEditingController _descon = TextEditingController();
  final TextEditingController _artcon = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
        if (catname == '' || picurl == '') {
          if (catname == '') {
            Fluttertoast.showToast(
                msg: "please frist choose category",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM_RIGHT,
                timeInSecForIosWeb: 2,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0);
            setState(() {
              cat_error = true;
            });
          } else if (picurl == '') {
            Fluttertoast.showToast(
                msg: "please frist choose panner picture",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM_RIGHT,
                timeInSecForIosWeb: 2,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0);
            bannerpic_error = true;
          } else {
            Fluttertoast.showToast(
                msg: "please choose category and banner picture",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM_RIGHT,
                timeInSecForIosWeb: 2,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0);
            setState(() {
              bannerpic_error = true;
              cat_error = true;
            });
          }
        } else {
          setState(() {
            issave = true;
          });
          await docref.update({
            'title': title,
            'desc': desc,
            'subtitle': subtitle,
            'createddate': DateTime.now().toString(),
            'view': 'yes',
          });
          Fluttertoast.showToast(
              msg: "news is created",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM_RIGHT,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);
          setState(() {
            createnew = false;
            _titlecon.clear();
            _subtitlecon.clear();
            _descon.clear();
            _artcon.clear();
            title = '';
            subtitle = '';
            desc = '';
            art = '';
          });

          setState(() {
            issave = false;
          });
        }
      } catch (e) {
        setState(() {
          issave = false;
        });
        print(e);
      }
    }
  }

  Future<String> myDownloadURL(String filename) async {
    return firebase_storage.FirebaseStorage.instance
        .refFromURL('gs://newsapp-4534f.appspot.com')
        .child(filename)
        .getDownloadURL();
  }

  PlatformFile platformFile;
  Future getimg() async {
    try {
      FilePickerResult result =
          await FilePicker.platform.pickFiles(type: FileType.image);
      uploadfile = result.files.single.bytes;
      platformFile = result.files.single;
      fileName = result.files.single.name;
    } catch (e) {
      print('error==> $e');
    }
  }

  Future getvideo() async {
    try {
      FilePickerResult result =
          await FilePicker.platform.pickFiles(type: FileType.video);
      uploadfile = result.files.single.bytes;
      fileName = result.files.single.name;
      platformFile = result.files.single;
    } catch (e) {
      print(e);
    }
  }

  DocumentReference docref =
      FirebaseFirestore.instance.collection('news').doc();
  Future<Null> uploadtofirestore(String type) async {
    try {
      setState(() {
        if (type == 'image') {
          load_image = true;
        } else if (type == 'video') {
          load_video = true;
        } else {
          load_banner = true;
        }
      });
      DateTime nowtime = DateTime.now();
      final firebase_storage.Reference ref = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('${docref.id}-$nowtime-$fileName');
      //for web
      //final firebase_storage.UploadTask uploadTask = ref.putData(uploadfile);
      // for android
      final firebase_storage.UploadTask uploadTask = ref.putFile(File(platformFile.path));
      String docUrl;
      uploadTask.whenComplete(() async {
        docUrl = await myDownloadURL('${docref.id}-$nowtime-$fileName');
        if (type == 'banner') {
          docref.update({
            'pannerurl': docUrl,
          });
        } else if (type == 'image') {
          docref.collection('img').doc().set({
            'url': docUrl,
            'filename': fileName,
          });
        } else if (type == 'videoImg') {
          docref.collection('videos').doc(docref.id).set({
            'videoImgUrl': docUrl,
            'videourl': '',
            'videonamename': '',
            'view': 'no'
          });
        } else {
          docref.collection('videos').doc(docref.id).update({
            'videourl': docUrl,
            'videonamename': fileName,
            'view': 'yes',
          });
        }
        setState(() {
          if (type == 'image') {
            load_image = false;
          } else if (type == 'video') {
            load_video = false;
          } else {
            load_banner = false;
          }
        });
      });
    } catch (e) {
      setState(() {
        load_image = false;
        load_video = false;
      });
      print('error===> ${e.toString()}');
    }
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

  String catname, picurl = '';
  @override
  Widget build(BuildContext context) {
    createnew
        ? FirebaseFirestore.instance
            .collection('news')
            .where("id", isEqualTo: docref.id)
            .snapshots()
            .listen((data) => data.docs.forEach((doc) {
                  picurl = doc['pannerurl'];
                  catname = doc['catname'];
                }))
        : print('');
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('news').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          default:
            return !createnew
                ? Center(
                    child: InkWell(
                      onTap: () {
                        docref.set({
                          'id': docref.id,
                          'title': '',
                          'catname': '',
                          'pannerurl': '',
                          'view': 'no',
                        });
                        setState(() {
                          createnew = true;
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.40,
                        height: 60.0,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(15.0)),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Create new news',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat'),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.create,
                                  color: Colors.white,
                                ),
                              ]),
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                    child: Container(
                      child: ListView(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: picurl == ''
                                    ? Center(
                                        child: Text(
                                          'select pic',
                                          style: TextStyle(
                                              color: bannerpic_error
                                                  ? Colors.red
                                                  : Colors.black,
                                              fontWeight: bannerpic_error
                                                  ? FontWeight.bold
                                                  : FontWeight.normal),
                                        ),
                                      )
                                    : Image.network(
                                        picurl,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                370,
                                        height: 300,
                                      ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(top: 120),
                                  child: load_banner
                                      ? CircularProgressIndicator()
                                      : IconButton(
                                          icon: Icon(Icons.camera_alt),
                                          onPressed: () async {
                                            await getimg();
                                            await uploadtofirestore('banner');
                                          },
                                        ))
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 400,
                                  height: 70,
                                  child: TextFormField(
                                    cursorColor: Color(0xFF009FD6),
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color(0xFF009FD6),
                                            width: 2.0),
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                        const Radius.circular(10),
                                      )),
                                      icon: Icon(
                                        Icons.title,
                                        color: Color(0xFF009FD6),
                                      ),
                                      hintText: 'Title',
                                      labelText: 'Title *',
                                      labelStyle: TextStyle(
                                        color: Color(0xFF009FD6),
                                      ),
                                    ),
                                    controller: _titlecon,
                                    onSaved: (value7) => title = value7,
                                    validator: (val) {
                                      return val.isEmpty
                                          ? 'title canot be empty'
                                          : null;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Container(
                                  width: 400,
                                  height: 70,
                                  child: TextFormField(
                                    cursorColor: Color(0xFF009FD6),
                                    maxLength: 65,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color(0xFF009FD6),
                                            width: 2.0),
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                        const Radius.circular(10),
                                      )),
                                      icon: Icon(
                                        Icons.subtitles,
                                        color: Color(0xFF009FD6),
                                      ),
                                      hintText: 'Subtitle',
                                      labelText: 'Subtitle *',
                                      labelStyle: TextStyle(
                                        color: Color(0xFF009FD6),
                                      ),
                                    ),
                                    controller: _subtitlecon,
                                    onSaved: (value7) => subtitle = value7,
                                    validator: (val) {
                                      return val.isEmpty
                                          ? 'subtitle canot be empty'
                                          : null;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Card(
                                  color: Colors.white,
                                  shadowColor: Colors.blue,
                                  child: ListTile(
                                    onTap: () async {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              content:
                                                  Popupchoosecat(docref.id),
                                            );
                                          });
                                    },
                                    title: Text(
                                      catname == ''
                                          ? 'choose Category'
                                          : catname,
                                      style: TextStyle(
                                          color: cat_error
                                              ? Colors.red
                                              : Colors.black,
                                          fontWeight: cat_error
                                              ? FontWeight.bold
                                              : FontWeight.normal),
                                    ),
                                    leading: Icon(
                                      catname == ''
                                          ? Icons.category_outlined
                                          : Icons.check,
                                      color: catname == ''
                                          ? Colors.blue
                                          : Colors.green,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Container(
                                  width: 700,
                                  height: 250,
                                  child: TextFormField(
                                    cursorColor: Color(0xFF009FD6),
                                    maxLines: 150,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color(0xFF009FD6),
                                            width: 2.0),
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                        const Radius.circular(10),
                                      )),
                                      icon: Icon(
                                        Icons.description,
                                        color: Color(0xFF009FD6),
                                      ),
                                      hintText: 'description',
                                      labelText: 'description *',
                                      labelStyle: TextStyle(
                                        color: Color(0xFF009FD6),
                                      ),
                                    ),
                                    controller: _descon,
                                    onSaved: (value7) => desc = value7,
                                    validator: (val) {
                                      return val.isEmpty
                                          ? 'description canot be empty'
                                          : null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 25,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  await getimg();
                                  await uploadtofirestore('image');
                                },
                                child: Text('Add pic'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Center(
                              child: Text(
                            'Images',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          )),
                          Container(
                            height: 450,
                            child: StreamBuilder<QuerySnapshot>(
                              stream: docref.collection('img').snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError)
                                  return Text('Error: ${snapshot.error}');

                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting:
                                    return Center(
                                        child: CircularProgressIndicator());
                                  default:
                                    return snapshot.hasData &&
                                            snapshot.data.size != 0
                                        ? Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(5, 7, 5, 5),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height -
                                                  500,
                                              child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 0, 10, 0),
                                                child: GridView.count(
                                                  mainAxisSpacing: 5,
                                                  crossAxisCount: 4,
                                                  crossAxisSpacing: 5,
                                                  primary: false,
                                                  children: snapshot.data.docs
                                                      .map((DocumentSnapshot
                                                          document) {
                                                    return list_row_img(
                                                        document['url'],
                                                        document['filename'],
                                                        document.id.toString());
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Center(
                                            child:
                                                Text('No image uploaded yet'),
                                          );
                                }
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 25,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  await docref
                                      .collection('videos')
                                      .doc(docref.id)
                                      .set({
                                    'videoImgUrl': '',
                                    'videourl': '',
                                    'videonamename': '',
                                    'view': 'no'
                                  });
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Popupuploadingvideo(docref),
                                        );
                                      });
                                },
                                child: Text('Add video'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Center(
                              child: Text(
                            'videos',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          )),
                          Container(
                            height: 450,
                            child: StreamBuilder<QuerySnapshot>(
                              stream: docref
                                  .collection('videos')
                                  .where('view', isEqualTo: 'yes')
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError)
                                  return Text('Error: ${snapshot.error}');

                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting:
                                    return CircularProgressIndicator();
                                  default:
                                    return snapshot.hasData &&
                                            snapshot.data.size != 0
                                        ? Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(5, 7, 5, 5),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height -
                                                  500,
                                              child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 0, 10, 0),
                                                child: GridView.count(
                                                  mainAxisSpacing: 5,
                                                  crossAxisCount: 4,
                                                  crossAxisSpacing: 5,
                                                  primary: false,
                                                  children: snapshot.data.docs
                                                      .map((DocumentSnapshot
                                                          document) {
                                                    return list_row_video(
                                                        document['videourl'],
                                                        document[
                                                            'videonamename'],
                                                        document.id.toString(),
                                                        document[
                                                            'videoImgUrl']);
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Center(
                                            child:
                                                Text('No videos uploaded yet'),
                                          );
                                }
                              },
                            ),
                          ),
                          Center(
                            child: InkWell(
                              onTap: () {
                                validateandsubmit();
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.40,
                                height: 60.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius:
                                          BorderRadius.circular(15.0)),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Create',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Montserrat'),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(
                                          Icons.create,
                                          color: Colors.white,
                                        ),
                                      ]),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
        }
      },
    );
  }
}
