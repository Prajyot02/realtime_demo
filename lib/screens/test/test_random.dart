
import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';


class FirebaseDataScreen extends StatefulWidget {
  @override
  _FirebaseDataScreenState createState() => _FirebaseDataScreenState();
}

class _FirebaseDataScreenState extends State<FirebaseDataScreen> {


  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('contestInfo');
  late StreamSubscription _myContestsStream;
  final ref = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _activateListerns();
  }


  // @override
  // void deactivate(){
  //   _myContestsStream.cancel();
  //   super.deactivate();
  // }


  Future<void> _activateListerns() async {


    final snapshot = await ref.child('contestInfo/contestId21324').get();
    if (snapshot.exists) {
      print(snapshot.value);
    } else {
      print('No data available.');
    }

  }


  @override
  Widget build(BuildContext context)  {
    return Scaffold(
      appBar: AppBar(title: Text('Read Examples'),),
      body: Center(
        child:Padding(
          padding: const EdgeInsets.only(top: 15.0,),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            ],
          ),
        ),
      ),
    );
  }
}
