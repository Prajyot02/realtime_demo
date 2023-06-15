// import 'dart:convert';
// import 'dart:math';
//
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:realtime_demo/screens/contest/contest_quiz_screen.dart';
//
// import '../../models/user_model.dart';
//
// class ContestCarousel extends StatefulWidget {
//   const ContestCarousel({super.key});
//
//   @override
//   State<ContestCarousel> createState() => _ContestCarouselState();
// }
//
//
// class _ContestCarouselState extends State<ContestCarousel> {
//
//
//   final _database = FirebaseDatabase.instance.ref();
//   List<Map<String, dynamic>> contestDataList = [];
//
//
//   final List<Color> customColors = [
//     Color(0xFFFBBBB5),
//     Color(0xFFCDD7E7),
//     Color(0xFFE6E7CD),
//     Color(0xFFCDE7CE),
//     // Add more custom colors as needed
//   ];
//
//
//   @override
//   void initState(){
//     super.initState();
//     _activateListerns();
//   }
//
//   // @override
//   // void dispose() {
//   //   // Clean up resources and break references here
//   //
//   //   super.dispose();
//   // }
//
//
//   void _activateListerns() {
//     _database.child('contestInfo').onValue.listen((event) {
//       final dynamicValue = event.snapshot.value;
//       if(dynamicValue is Map){
//
//         final data = Map<String, dynamic>.from(dynamicValue);
//         print(data);
//
//          List<Map<String, dynamic>> contestDataList = [];
//         // data.forEach((key, value) {
//         //
//
//         // });
//         contestDataList.clear();
//         print('dynamic value is :$dynamicValue');
//         data.forEach((contestId, contestData) {
//           final time = contestData['contestTime'] as int;
//           final description = contestData['description'] as String;
//           final displayName = contestData['displayName'] as String;
//           final imageUrl = contestData['imageUrl'] as String;
//           print('contest ID: $contestId');
//           print('Time: $time');
//           print('Description: $description');
//           final formattedData = {
//             "contestId": contestId,
//             "time": time.toString(),
//             "description": description,
//             "displayName": displayName,
//             "imageUrl": imageUrl,
//             "color" :  getRandomColor().toString(),
//           };
//           contestDataList.add(formattedData);
//         });
//
//
//         setState(() {
//           ContestDataHolder.contestDataList = contestDataList;
//           print(ContestDataHolder.contestDataList);
//         });
//         // print(contestDataList);
//       }else{
//         print('THis data is not map');
//       }
//     });
//
//     // _database.child('dailySpecial/price').onValue.listen((event) {
//     //   final Object? price = event.snapshot.value;
//     //   setState(() {
//     //     _displayPrice = 'Todays spcecial is : $price';
//     //   });
//     // });
//
//   }
//
//   final List<Map<String, dynamic>> contestData = ContestDataHolder.contestDataList;
//
//
//   // Color getRandomColor() {
//   //   final random = Random();
//   //   final index = random.nextInt(customColors.length);
//   //   return customColors[index];
//   // }
//   Color hexToColor(String hexCode) {
//     String x = hexCode.replaceAll("Color(0x", "");
//     String formattedHexCode = x.replaceAll(")", "");
//     int parsedColor = int.parse(formattedHexCode, radix: 16);
//     print('this is formatted color :$parsedColor');
//     return Color(parsedColor);
//   }
//
//   String getRandomColor () {
//     final customColors = [
//       "Color(0xFFFBBBB5)",
//       "Color(0xFFCDD7E7)",
//       "Color(0xFFE6E7CD)",
//       "Color(0xFFCDE7CE)",
//     ];
//     return customColors[Random().nextInt(customColors.length)];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     int numberOfIds = contestData.length;
//     String selectedContestId;
//
//     double width = MediaQuery. of(context). size. width ;
//     double height = MediaQuery. of(context). size. height ;
//
//     return
//       SizedBox(
//         height: 118 * numberOfIds+10,
//         child: GridView.count(
//           crossAxisCount: 2,
//           childAspectRatio: 1.5,
//           mainAxisSpacing: 10,
//           crossAxisSpacing: 0,
//           children: [
//             ...contestData.map((e) =>
//                 Padding(
//                   padding: EdgeInsets.only(bottom: 8),
//                   child: GestureDetector(
//                     onTap: () {
//                       print(e['contestId']);
//                       selectedContestId = e['contestId'];
//
//                       print(hexToColor(e['color']));
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ContestQuizScreen(contestId: selectedContestId),
//                         ),
//                       );
//                     },
//                     child:  SizedBox(
//                         width: 183,
//                         height: 118,
//
//                         child: Stack(
//                             children: <Widget>[
//                               Positioned(
//                                   top: 0,
//                                   left: 0,
//                                   child: Container(
//                                       width: 183,
//                                       height: 118,
//                                       decoration: BoxDecoration(
//                                         borderRadius : BorderRadius.only(
//                                           topLeft: Radius.circular(8),
//                                           topRight: Radius.circular(8),
//                                           bottomLeft: Radius.circular(8),
//                                           bottomRight: Radius.circular(8),
//                                         ),
//                                         boxShadow : [
//                                           BoxShadow(
//                                               color: Color.fromRGBO(0, 0, 0, 0.30000001192092896),
//                                               offset: Offset(1,1),
//                                               blurRadius: 2
//                                           )],
//                                         color :hexToColor(e['color']),
//                                       )
//                                   )
//                               ),
//                               Positioned(
//                                   top: 11,
//                                   left: 104,
//                                   child: Container(
//                                       width: 68,
//                                       height: 68,
//                                       decoration: BoxDecoration(
//                                         color : Color.fromRGBO(0, 0, 0, 0.20000000298023224),
//                                         borderRadius : BorderRadius.all(Radius.elliptical(68, 68)),
//                                       )
//                                   )
//                               ),
//                               // Positioned(
//                               //   top: 11,
//                               //   left: 104,
//                               //   child: Container(
//                               //     child:
//                               //     Image.asset('assets/images/sample.png',
//                               //       height: 200.0,
//                               //       width: 200.0,
//                               //       fit: BoxFit.cover,
//                               //     ),
//                               //   ),
//                               // ),
//                               Positioned(
//                                   top: 29,
//                                   left: 122,
//                                   child: Container(
//                                       width: 32,
//                                       height: 32,
//                                       decoration: BoxDecoration(
//                                         color : Colors.transparent,
//                                       ),
//                                       child: Stack(
//                                           children: <Widget>[
//                                             // Positioned(
//                                             //     top: 4,
//                                             //     left: 6,
//                                             //     child: SvgPicture.asset(
//                                             //         'assets/images/vector2.svg',
//                                             //         semanticsLabel: 'vector'
//                                             //     ),
//                                             // ),
//                                             Positioned(
//                                               top: 3,
//                                               left: 5,
//                                               child: SvgPicture.asset(
//                                                   'assets/images/vector2.svg',
//                                                   semanticsLabel: 'vector'
//                                               ),
//                                             ),
//                                           ]
//                                       )
//                                   )
//                               ),
//                               Positioned(
//                                 top: 85,
//                                 left: 16,
//                                 child: Text(e['contestId'], textAlign: TextAlign.left,
//                                     style: GoogleFonts.inter(
//                                         color: Color.fromRGBO(0, 0, 0, 1),
//                                         fontSize: 20,
//                                         letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
//                                         fontWeight: FontWeight.bold,
//                                         height: 1
//                                     )
//                                 ),
//                               ),
//                             ]
//                         )
//                     ),
//                     // Card(
//                     //   color: Colors.amber,
//                     //   child: Text(e['subject_name'],) ,
//                     // ),
//                   ) ,
//                 ))
//
//
//             // Column(
//             //   children: [
//             //     ...contestData
//             //         .map(
//             //           (e) => Padding(
//             //         padding: const EdgeInsets.only(bottom: 8),
//             //         child: ListTile(
//             //           onTap: () {
//             //             print(e['contestId']);
//             //
//             //             Navigator.push(
//             //               context,
//             //               MaterialPageRoute(
//             //                 builder: (context) => const QuizScreen(),
//             //               ),
//             //             );
//             //           },
//             //           tileColor: Colors.teal,
//             //           textColor: Colors.white,
//             //           iconColor: Colors.white,
//             //           title: Text(
//             //             e['subject_name'],
//             //           ),
//             //           trailing: const Icon(Icons.arrow_forward),
//             //         ),
//             //       ),
//             //     )
//             //         .toList()
//             //   ],
//             // ),
//
//           ],
//         ),
//       );
//   }
// }
