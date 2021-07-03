import 'package:flutter/material.dart';
import 'package:newsapp/bodywidgets/signuppopup.dart';

class Welcomeweb extends StatefulWidget {
  @override
  _WelcomewebState createState() => _WelcomewebState();
}

class _WelcomewebState extends State<Welcomeweb> {

  @override
  Widget build(BuildContext context) {
    return Padding(
                    padding: const EdgeInsets.fromLTRB(50, 15, 50, 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
             children: [ 
               Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(
                 'NewsiFy',
                 style: TextStyle(color: Colors.white,fontFamily:'OpenSans',fontSize: 30 ),
               ),
               SizedBox(height: 15,),
               Container(
                  width: 550,
                 child: Text(
                   'NewsFy is a news app that presents the latest news in crisp format from trusted national and international publishers. Read the latest India News, Breaking News from across the world, viral videos & more in English and Indic languages ',
                   style: TextStyle(color: Colors.white,fontFamily:'OpenSans',fontSize: 20 ),
                 ),
               ),
                 ],
               ),      
             ],
           ),
                          
          SizedBox(width: 50,),
           Container(
            width: 550,
            height: 550,
            child:  Center(
              child: InkWell(
                          onTap: (){
                               showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: signuppopup(),
                  );
                });
          },                      
                              child: Container(
                            width: 200,
                            height: 40.0,
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              shadowColor: Colors.greenAccent,
                              color: Colors.blueAccent,
                              elevation: 7.0,
                                child: Center(
                                  child: Text(
                                    'join us now',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat'),
                                  ),
                                ),
                              
                            ),
                          ),
                        ),
            ),
          ),
                      ],
                    ),
                  );
  }
}