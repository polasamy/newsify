import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

 class Firebasemethods{
   final FirebaseAuth _auth = FirebaseAuth.instance;
   Future<User> signupemail(String name,String email,String password,String pic)async{
      UserCredential userCredential=await _auth.createUserWithEmailAndPassword(email: email, password: password);
     User user=userCredential.user;
     FirebaseFirestore.instance.collection('users').doc(user.uid).set({
       'pic':pic,
       'name':name,
       'email':email,
       'level':'user',
       'uid':user.uid.toString()
     });
     return user;
   }
   Future <User>signinemail(String email,String password)async{
     UserCredential userCredential=await _auth.signInWithEmailAndPassword(email: email, password: password);
       User user=userCredential.user;
        return user;
   }
   Future<User> getUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final User user = _auth.currentUser;
  return user;

}
Future signout()async{
  await _auth.signOut();
}
 }