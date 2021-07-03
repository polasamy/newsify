import 'package:flutter/material.dart';
import 'package:newsapp/methods/videoItem.dart';
import 'package:video_player/video_player.dart';


class Popupvideo extends StatefulWidget {
  String video_url;
  Popupvideo(this.video_url,{Key key}) : super(key: key);

  @override
  _PopupvideoState createState() => _PopupvideoState();
}

class _PopupvideoState extends State<Popupvideo> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
       child:  Scaffold(
      backgroundColor: Colors.blueGrey[100],
      
      body: VideoItem(
            videoPlayerController: VideoPlayerController.network(
                widget.video_url
            ),
            looping: false,
            autoplay: true,
          ),
    ),
    );
  }
}