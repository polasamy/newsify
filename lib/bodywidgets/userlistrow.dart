import 'package:flutter/material.dart';

class Userlistrow extends StatefulWidget {
  String pic,name,email,level;
  Color color;
  Userlistrow(this.pic,this.name,this.email,this.level,this.color,{Key key}):super(key: key);
  @override
  _UserlistrowState createState() => _UserlistrowState();
}

class _UserlistrowState extends State<Userlistrow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Card(
        color: widget.color,
        margin: EdgeInsets.fromLTRB(1, 1, 1, 0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:  Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
                 CircleAvatar(
                        backgroundColor: Colors.white,
                        child: ClipOval(
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: Image.network(
                            widget.pic,
                          ), 
                        ),
                      ),
                        radius: 25,
                      ),
                  SizedBox(width: 7,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          widget.name,
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,fontFamily: 'Montserrat'),
                        ),
                        Text(
                          widget.email,
                          style: TextStyle(color: Colors.grey,fontSize: 9,fontFamily: 'Montserrat'),
                        ),
                      ],
                    ),
                    SizedBox(width: 15,),
                    Text(widget.level,style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                  ],
                ),
            ],
          ),
        
              ),
      ),
    );
  }
}