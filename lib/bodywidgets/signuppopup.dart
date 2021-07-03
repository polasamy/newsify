import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/methods/FirebaseAuth.dart';
class signuppopup extends StatefulWidget {
  @override
  _signuppopupState createState() => _signuppopupState();
}

class _signuppopupState extends State<signuppopup> {
      final _formKey = GlobalKey<FormState>();
      Firebasemethods firebasemethods=Firebasemethods();
      bool issignup=false;
String _username,_password,_pass2,_name,gender='Male',_jop=' ',_phonenumber=' ',_status='New',_visable='no',_level='disable';
  String pic='https://firebasestorage.googleapis.com/v0/b/newsapp-4534f.appspot.com/o/user.png?alt=media&token=0c10a6cb-d5f5-469d-a641-f9e89e7075fe';
    final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  final TextEditingController _emailcon = TextEditingController();
  final TextEditingController _namecon = TextEditingController();
    bool validateandsave(){
    final form =_formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }else{
      return false;  
  }}
   Future validateandsubmit() async{
    if(validateandsave()){
      try{
          setState(() {
            issignup=true;
          });
          await firebasemethods.signupemail(_name, _username, _password,pic).then((User user){
            if(user!=null){
              Navigator.pushReplacementNamed(context, '/home');
            }
          });
          setState(() {
            issignup=false;
          });
     }catch(e){
       setState(() {
            issignup=false;
          });
          print(e);
     }
    }
  }
  @override
  Widget build(BuildContext context) {
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
                          Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                   Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    padding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                    child: Text(
                      'Sign up',
                      style:
                          TextStyle(fontSize: 45.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(7, 30, 7, 0),
                    child: Text(
                      '.',
                      style: TextStyle(
                          fontSize: 55,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  ),
              ],
            ),
                 
           SizedBox(height: 15,),
           TextFormField(
                        cursorColor: Color(0xFF009FD6),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xFF009FD6), width: 2.0),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                            const Radius.circular(10),
                          )),
                          icon: Icon(
                            Icons.email,
                            color: Color(0xFF009FD6),
                          ),
                          hintText: 'Email',
                          labelText: 'Email *',
                          labelStyle: TextStyle(
                            color: Color(0xFF009FD6),
                          ),
                        ),
                        controller: _emailcon,
                        validator: (val) {
                          return val.isEmpty ? 'email canot be empty' : null;
                        },
                        onSaved: (value) => _username = value,
                      ),
          SizedBox(height: 5,),
          TextFormField(
                        cursorColor: Color(0xFF009FD6),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xFF009FD6), width: 2.0),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                            const Radius.circular(10),
                          )),
                          icon: Icon(
                            Icons.person,
                            color: Color(0xFF009FD6),
                          ),
                          hintText: 'name',
                          labelText: 'name *',
                          labelStyle: TextStyle(
                            color: Color(0xFF009FD6),
                          ),
                        ),
                        controller: _namecon,
                        validator: (val) {
                          return val.isEmpty ? 'name canot be empty' : null;
                        },
                        onSaved: (value) => _name = value,
                      ),
          SizedBox(height: 5,),
          TextFormField(
                        cursorColor: Color(0xFF009FD6),
                        obscureText:true,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xFF009FD6), width: 2.0),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                            const Radius.circular(10),
                          )),
                          icon: Icon(
                            Icons.lock,
                            color: Color(0xFF009FD6),
                          ),
                          hintText: 'Password',
                          labelText: 'Password *',
                          labelStyle: TextStyle(
                            color: Color(0xFF009FD6),
                          ),
                        ),
                        controller: _pass,
                        validator: (val){
           return val.isEmpty? 'password canot be empty':null;
           },
                        onSaved: (value) => _password = value,
                      ),
           SizedBox(height: 5,),
           TextFormField(
                        cursorColor: Color(0xFF009FD6),
                        obscureText:true,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xFF009FD6), width: 2.0),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                            const Radius.circular(10),
                          )),
                          icon: Icon(
                            Icons.check,
                            color: Color(0xFF009FD6),
                          ),
                          hintText: 'Comfirm Password',
                          labelText: 'Comfirm Password *',
                          labelStyle: TextStyle(
                            color: Color(0xFF009FD6),
                          ),
                        ),
                        controller: _confirmPass,
                        validator: (val){
                    if(val.isEmpty){return 'password canot be empty';}
                     else if(val != _pass.text){return 'Not Match';}
                     else{return null;}
                    },
                        onSaved: (value) => _pass2 = value,
                      ),
           SizedBox(height: 15,), 
           issignup? Center(child: CircularProgressIndicator(),):Container(
              width: 250,
              height: 150,
              child:  Center(
                child: InkWell(
                            onTap: (){
                                validateandsubmit();
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
                                      'Signup now',
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
            SizedBox(height: 10.0),
                              ],
                            ),
                          ),
                        ],
                      ),
    );
  }
}