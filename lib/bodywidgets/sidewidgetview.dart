import 'package:flutter/material.dart';

class Sideview extends StatefulWidget {
   String title;
   Icon icon;
  Color color;
  Sideview(this.title,this.icon,this.color, {Key key}):super(key: key);
  @override
  _SideviewState createState() => _SideviewState();
}

class _SideviewState extends State<Sideview> {
  @override
  Widget build(BuildContext context) {
    return Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 15,),
                                widget.icon,
                                SizedBox(height: 10,),
                                Text(widget.title,style: TextStyle(color: widget.color,fontWeight: FontWeight.bold),),
                              ],
                            ),
                          );
  }
}