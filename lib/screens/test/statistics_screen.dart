// import 'dart:convert';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
//
// import '../../models/user_model.dart';
//
//
// class StatisticsScreen extends StatefulWidget {
//   const StatisticsScreen({super.key});
//
//   @override
//   State<StatisticsScreen> createState() => _StatisticsScreenState();
// }
//
// class _StatisticsScreenState extends State<StatisticsScreen> {
//
//   String _displayText ='Result go here';
//   String _displayPrice ='Price Result go here';
//   final ref = FirebaseDatabase.instance.ref();
//
//
//   @override
//   void initState(){
//     super.initState();
//     _activateListerns();
//   }
//
//   Future<void> _activateListerns() async {
//
//     final snapshot = await ref.child('userCoinInfo').get();
//     List<User> _userList = [];
//     if (snapshot.exists) {
//       print(snapshot.value);
//     } else {
//       print('No data available.');
//     }
//     String snapshotString = snapshot.value.toString();
//     print(snapshotString);
//     Map<dynamic, Map<String,dynamic>> jsonData = jsonDecode(snapshotString );
//
//     jsonData['users']?.forEach((key, value) {
//       User user = User.fromJson({
//         'id': key,
//         'coins': value['coins'],
//       });
//       _userList.add(user);
//     });
//
//     // Sort the users based on coins in descending order
//     _userList.sort((a, b) => b.coins.compareTo(a.coins));
//
//     // Get the top three users
//     List<User> topThreeUsers = _userList.take(3).toList();
//     print('Top 3 winners are $topThreeUsers');
//     final mostViewedPosts = FirebaseDatabase.instance.ref('userCoinInfo').orderByValue();
//     print (mostViewedPosts);
//   }
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Read Examples'),),
//       body: Center(
//         child:Padding(
//           padding: const EdgeInsets.only(top: 15.0,),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text('User  : $_displayText'),
//               Text('has $_displayPrice Coins ')
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
