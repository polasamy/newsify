import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:fluttertoast/fluttertoast.dart';

class Popupuploadingvideo extends StatefulWidget {
  DocumentReference docref;
  Popupuploadingvideo(this.docref, {Key key}) : super(key: key);

  @override
  _PopupuploadingvideoState createState() => _PopupuploadingvideoState();
}

class _PopupuploadingvideoState extends State<Popupuploadingvideo> {
  Uint8List uploadfile;
  bool load_image = false,
      load_video = false,
      createnew = false,
      issave = false;
  String fileName;
  Future<String> myDownloadURL(String filename) async {
    return firebase_storage.FirebaseStorage.instance
        .refFromURL('gs://helloworld-fa4cc.appspot.com')
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

  Future<Null> uploadtofirestore(String type) async {
    try {
      setState(() {
        if (type == 'videoImg') {
          load_image = true;
        } else if (type == 'video') {
          load_video = true;
        }
      });
      DateTime nowtime = DateTime.now();
      final firebase_storage.Reference ref = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('${widget.docref.id}-$nowtime-$fileName');
      //for web
      //final firebase_storage.UploadTask uploadTask = ref.putData(uploadfile);
      // for android
      final firebase_storage.UploadTask uploadTask =
          ref.putFile(File(platformFile.path));
      String docUrl;
      uploadTask.whenComplete(() async {
        docUrl = await myDownloadURL('${widget.docref.id}-$nowtime-$fileName');
        if (type == 'videoImg') {
          widget.docref.collection('videos').doc(widget.docref.id).update({
            'videoImgUrl': docUrl,
          });
        } else {
          await widget.docref
              .collection('videos')
              .doc(widget.docref.id)
              .update({
            'videourl': docUrl,
            'videonamename': fileName,
            'view': 'yes',
          });
          Navigator.pop(context);
          Fluttertoast.showToast(
              msg: "video uploaded",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM_RIGHT,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);
        }
        setState(() {
          if (type == 'videoImg') {
            load_image = false;
          } else if (type == 'video') {
            load_video = false;
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

  String videopic, videourl;
  bool image_done = false;
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('news')
        .doc(widget.docref.id)
        .collection('videos')
        .snapshots()
        .listen((data) => data.docs.forEach((doc) {
              videopic = doc['videoImgUrl'];
              videourl = doc['videourl'];
            }));
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('news')
            .doc(widget.docref.id)
            .collection('videos')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: videopic == ''
                              ? Center(
                                  child: Text('select pic'),
                                )
                              : Image.network(
                                  videopic,
                                  width: 350,
                                  height: 250,
                                ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 120),
                            child: load_image
                                ? CircularProgressIndicator()
                                : IconButton(
                                    icon: Icon(Icons.camera_alt),
                                    onPressed: () async {
                                      await getimg();
                                      await uploadtofirestore('videoImg');
                                      setState(() {
                                        image_done = true;
                                      });
                                    },
                                  ))
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    load_video
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: !image_done
                                  ? MaterialStateProperty.all<Color>(
                                      Colors.grey[400])
                                  : MaterialStateProperty.all<Color>(
                                      Colors.blueAccent),
                            ),
                            onPressed: () async {
                              if (image_done) {
                                await getvideo();
                                await uploadtofirestore('video');
                              } else {
                                print('');
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'upload video',
                                  style: TextStyle(
                                      color: !image_done
                                          ? Colors.grey[50]
                                          : Colors.white),
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Icon(
                                  Icons.upload_outlined,
                                  color: image_done
                                      ? Colors.grey[50]
                                      : Colors.white,
                                ),
                              ],
                            )),
                  ],
                )
              ],
            ),
          );
        });
  }
}
