import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class Imageview extends StatefulWidget {
  final String url;
  //if you have multiple values add here
  Imageview(this.url, {Key key}) : super(key: key);
  @override
  _ImageviewState createState() => _ImageviewState();
}

class _ImageviewState extends State<Imageview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          child: PhotoView(
        imageProvider: NetworkImage(widget.url),
      )),
    );
  }
}
