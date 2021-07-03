import 'package:flutter/material.dart';
import 'package:newsapp/bodywidgets/editelevelpopup.dart';

class Userprofile extends StatefulWidget {
  String pic,name,email,level,uid;
  Userprofile(this.pic,this.name,this.email,this.level,this.uid,{Key key}):super(key: key);
  @override
  _UserprofileState createState() => _UserprofileState();
}

class _UserprofileState extends State<Userprofile> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                   Align(
                     alignment: Alignment.center,
                     child: CircleAvatar(
                                   backgroundColor: Colors.white,
                          child: ClipOval(
                          child: SizedBox(
                            width: 200,
                            height: 200,
                            child: Image.network(
                              widget.pic,
                            ), 
                          ),
                        ),
                          radius: 100,
                        ),
                   ),
                ],
              ),
                    Divider(color: Colors.blue,indent: 16,),
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text('User Name',style: TextStyle(fontFamily:'Montserrat',fontWeight: FontWeight.bold,fontSize: 14 ),),
                      subtitle: Text(widget.name,style: TextStyle(fontFamily: 'Montserrat',fontSize: 19),),
                    ),
                    ListTile(
                      leading: Icon(Icons.email),
                      title: Text('Email',style: TextStyle(fontFamily:'Montserrat',fontWeight: FontWeight.bold,fontSize: 14 ),),
                      subtitle: Text(widget.email,style: TextStyle(fontFamily: 'Montserrat',fontSize: 14),),
                      
                    ),
                    ListTile(
                      leading: Icon(Icons.upload_sharp),
                      title: Text('Level',style: TextStyle(fontFamily:'Montserrat',fontWeight: FontWeight.bold,fontSize: 14 ),),
                      subtitle: Text(widget.level,style: TextStyle(fontFamily: 'Montserrat',fontSize: 14),),
                      trailing: IconButton
                      (
                        icon: Icon(Icons.edit),
                        onPressed: (){
                         showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Editelevelpopup(widget.uid,widget.level),
                  );
                });
                        },
                      ),
                    ),
                    
                     
                  ],
                ), 
    );
  }
}