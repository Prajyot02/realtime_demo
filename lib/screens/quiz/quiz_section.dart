// import 'dart:convert';
// import 'dart:math';
//
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:realtime_demo/screens/contest/contest_quiz_screen.dart';
// import 'package:realtime_demo/screens/quiz/quiz_section_quiz_screen.dart';
//
// import '../../models/user_model.dart';
//
// class QuizSection extends StatefulWidget {
//   const QuizSection({super.key});
//
//   @override
//   State<QuizSection> createState() => _QuizSectionState();
// }
//
//
// class _QuizSectionState extends State<QuizSection> {
//
//
//   final _database = FirebaseDatabase.instance.ref();
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
//     _database.child('quizSection').onValue.listen((event) {
//       final dynamicValue = event.snapshot.value;
//       if(dynamicValue is Map){
//
//         final data = Map<String, dynamic>.from(dynamicValue);
//         print(data);
//
//         // List<quizSection> quizSections = [];
//         List<Map<String, dynamic>> quizSectionDataList = [];
//
//         quizSectionDataList.clear();
//         // data.forEach((key, value) {
//         //
//
//         // });
//         print('dynamic value is :$dynamicValue');
//         data.forEach((quizSectionId, quizSectionData) {
//           print(quizSectionId);
//           print(quizSectionData);
//           final time = quizSectionData['dataCreated'] as int;
//           final description = quizSectionData['description'] as String;
//           final name = quizSectionData['name'] as String;
//           final shortDescription = quizSectionData['shortDescription'] as String;
//           final imageUrl = quizSectionData['imageUrl'] as String;
//           final mask = quizSectionData['mask'] as int;
//           print('quizSection ID: $quizSectionId');
//           print('Time: $time');
//           print('Description: $description');
//           final formattedData = {
//             "quizSectionId": quizSectionId,
//             "time": time.toString(),
//             "description": description,
//             "shortDescription": shortDescription,
//             "name": name,
//             "imageUrl": imageUrl,
//             "mask": mask.toString(),
//             "color" :  getRandomColor().toString(),
//           };
//           quizSectionDataList.add(formattedData);
//         });
//
//         setState(() {
//           quizSectionDataHolder.quizSectionDataList = quizSectionDataList;
//           print(quizSectionDataHolder.quizSectionDataList);
//         });
//         // print(quizSectionDataList);
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
//
//   final List<Map<String, dynamic>> quizSectionData = quizSectionDataHolder.quizSectionDataList;
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
//     int numberOfIds = quizSectionData.length;
//     String selectedQuizSectionId;
//
//     double width = MediaQuery. of(context). size. width ;
//     double height = MediaQuery. of(context). size. height ;
//     if (quizSectionData==null) {
//       return CircularProgressIndicator() ; // Display loading widget while data is being fetched
//     } else {
//       // Build your widget based on contestDataList
//       return SizedBox(
//         height: 208 * numberOfIds+10,
//         child:
//       );
//     }
//   }
// }
