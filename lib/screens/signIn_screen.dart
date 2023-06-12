
import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth.dart';

class LoginPage extends StatefulWidget {



  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String? errorMessage='';
  bool isLogin=true;
  List gender=["Male","Female","Other"];

  String? select;

  FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _controllerEmail=TextEditingController();
  final TextEditingController _controllerPassword= TextEditingController();
  final TextEditingController _controllerFrName= TextEditingController();
  final TextEditingController _controllerLsName= TextEditingController();
  final TextEditingController _controllerCoins= TextEditingController();
  // final TextEditingController _controllerAge= TextEditingController();
  ValueNotifier<int> myCoins = ValueNotifier<int>(10);


  Future<void> signInWithEmailAndPassword() async{
    try {
      await Auth().signInWithEmailAndPassword(
          email: _controllerEmail.text,
          password: _controllerPassword.text
      );
    } on FirebaseAuthException catch (e){
      setState(() {
        errorMessage=e.message;
      });
    }
  }

  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Theme.of(context).primaryColor,
          value: gender[btnValue],
          groupValue: select,
          onChanged: (value){
            setState(() {
              print(value);
              select=value;
            });
          },
        ),
        Text(title)
      ],
    );
  }

  Future<User?> createUserWithEmailAndPassword() async{
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _controllerEmail.text,
          password: _controllerPassword.text,
        // age:int.parse(_controllerAge.text),
        // gender:int.parse(_controllerAge.text),

      );
      User? user = userCredential.user;

      DatabaseReference _database = FirebaseDatabase.instance.ref();

// Create a new user node in the Realtime Database with the userId as the key
      DatabaseReference userRef = _database.child('userInfo').child(user!.uid);
      userRef.set({
        'email': user.email,
        'imageUrl' : user.photoURL,
        // 'coins' : myCoins,
        'fname' : _controllerFrName.text,
        'sname': _controllerLsName.text,
        'coins': _controllerCoins.text
        // Add any other user data fields as needed
      });

      return user;
    } on FirebaseAuthException catch (e){
      setState(() {
        errorMessage=e.message;
      });
    }
    return null;
  }

  Widget _title(){
    return Text('Contest Demo');
  }

  Widget _entryField(
      String title,
      TextEditingController controller,
      ){
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title ,
      ),
    );
  }



  Widget _errorMessage(){
    return Text(errorMessage==''?'':'What? $errorMessage');
  }

  Widget _submitButton(){
    return ElevatedButton(
        onPressed: isLogin? signInWithEmailAndPassword : createUserWithEmailAndPassword,
        child: Text(isLogin? 'Login':'Register'),
    );
  }

  Widget _loginOrRegisterationButton(){
    return TextButton(
        onPressed: (){
          setState(() {
            isLogin=!isLogin;
          });
        }, child: Text(isLogin?'Register':'Already have an account?'),
    );

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget> [
            _entryField('email', _controllerEmail),
            _entryField('password', _controllerPassword),
            isLogin? SizedBox() : _entryField('firstName', _controllerFrName),
            isLogin? SizedBox() : _entryField('Last Name', _controllerLsName),
            isLogin? SizedBox() : _entryField('Coins You want', _controllerCoins),
            _errorMessage(),
            _submitButton(),
            _loginOrRegisterationButton()
          ],
        ),
      ),
    );
  }
}
