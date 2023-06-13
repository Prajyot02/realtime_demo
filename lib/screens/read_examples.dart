import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';

class ReadExamples extends StatefulWidget {
  const ReadExamples({super.key});

  @override
  State<ReadExamples> createState() => _ReadExamplesState();
}

class _ReadExamplesState extends State<ReadExamples> {

  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('contestInfo');
  late StreamSubscription _myContestsStream;
  final ref = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _activateListerns();
  }

  String _displayText ='Result go here';
  String _displayPrice ='Price Result go here';
  String _displayTextString ='String Result go here';
  final _database = FirebaseDatabase.instance.ref();

  void _activateListerns() {
    _database.child('dailySpecial/description').onValue.listen((event) {
      final Object? description = event.snapshot.value;
      setState(() {
        _displayText = '$description';
      });
    });

    _database.child('orders').onValue.listen((event) {
      final dynamicValue = event.snapshot.value;
      if(dynamicValue is Map){

        final data = Map<String, dynamic>.from(dynamicValue);
        print(data);
        print('successful');

        Map<String, dynamic> mydata = jsonDecode(jsonEncode(event.snapshot.value))  as Map<String, dynamic>;


        print('Converted list is : $mydata' );
        List<Map<String, dynamic>> list = [];
        mydata.forEach((key, value) {
          if (value is Map<String, dynamic>) {
            // Handle the case when the value is an internal map
            list.add({key: [value]});
          } else {
            // Handle the case when the value is not an internal map
            list.add({key: value});
          }
        });
        print(list);

        List<Order> orders = [];
        data.forEach((orderId, value) {
          final order = Order(
            price: value['price'],
            description: value['description'],
            time: value['time'],
            customer: value['customer'],
            orderId: '',
          );
          orders.add(order);
        });
        print(orders);

        print('dynamic value is :$dynamicValue');
        data.forEach((orderId, orderData) {
          final price = orderData['price'] as double;
          final description = orderData['description'] as String;
          print('Order ID: $orderId');
          print('Price: $price');
          print('Description: $description');

        });
        print('Executed');
      }else{
        print('THis data is not map');
      }
    });



    _database.child('dailySpecial/price').onValue.listen((event) {
      final Object? price = event.snapshot.value;
      setState(() {
        _displayPrice = 'Todays spcecial is : $price';
      });
    });

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Read Examples'),),
      body: Center(
        child:Padding(
          padding: const EdgeInsets.only(top: 15.0,),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Result is : $_displayText'),
              Text('Price is : $_displayPrice'),
              Text('$_displayTextString'),
              SizedBox(height: 50,),
            ],
          ),
        ),
      ),
    );
  }
}



