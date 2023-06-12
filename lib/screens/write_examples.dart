import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WriteExamples extends StatefulWidget {
  const WriteExamples({super.key});

  @override
  State<WriteExamples> createState() => _WriteExamplesState();
}

class _WriteExamplesState extends State<WriteExamples> {

  final database = FirebaseDatabase.instance.ref();

  String getRandomName () {
    final customerNames=[
      'Prajyot',
      'Yash',
      'Abhay',
      'Prashant',
      'Bhavesh',
      'Karunesh'
    ];
    return customerNames[Random().nextInt(customerNames.length)];
  }
  String getRandomDrink () {
    final drinkNames=[
      'Coffee',
      'Late',
      'PaniPuri',
      'Chhat',
      'Espresso',
      'Mocha',
      'Milk',
      'Yougurt',
    ];
    return drinkNames[Random().nextInt(drinkNames.length)];
  }

  @override
  Widget build(BuildContext context) {
    final dailySpecialRef = database.child('/dailySpecial');
    final contestInfoRef = database.child('/contestInfo');


    return Scaffold(
      appBar: AppBar(title: Text('Write Examples'),),
        body: Center(
          child:Padding(
            padding: const EdgeInsets.only(top: 15.0,),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: ()async{
                  try{
                      await dailySpecialRef
                          .set({'description': 'you are so mad ', 'price': 100.00});
                      print('updated a description');
                    }
                    catch(e){
                    print('You got an error');
                    }
                  },
                    child: Text('Add assumed description')),
                ElevatedButton(onPressed: ()async{
                  try{
                      final nextOrder = <String, dynamic>{
                        'description' : getRandomDrink(),
                        'price' : Random().nextInt(800)/100,
                        'customer' : getRandomName(),
                        'time': DateTime.now().millisecondsSinceEpoch
                      };
                      database
                          .child('orders')
                      .push()
                      .set(nextOrder)
                      .then((_) => print('Drink has been added'))
                      .catchError((error) => print('You got an error $error'));
                     }
                    catch(e){
                    if (kDebugMode) {
                      print('You got an error');
                    }
                    }
                  },
                    child: Text('Add New Order')),
                ElevatedButton(onPressed: ()async{
                  try{
                      final nextContest = <String, dynamic>{
                        'contestEndTime' : (DateTime.now().millisecondsSinceEpoch).toInt(),
                        'description' : getRandomName(),
                        'displayName' : getRandomName(),
                        'contestTime' :(DateTime.now().millisecondsSinceEpoch).toInt(),
                        'imageUrl' : getRandomName(),
                      };
                      database
                          .child('contestInfo')
                      .push()
                      .set(nextContest)
                      .then((_) => print('Contest has been added'))
                      .catchError((error) => print('You got an error $error'));
                     }
                    catch(e){
                    if (kDebugMode) {
                      print('You got an error');
                    }
                    }
                  },
                    child: Text('Add New Contest')),
              ],
            ),
        ),
      ),
    );
  }
}
