// import 'dart:async';
// import 'dart:convert';
//
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:realtime_demo/models/user_model.dart';
// import 'package:realtime_demo/screens/result_screen.dart';
// class RandomContest extends StatefulWidget {
//   const RandomContest({super.key});
//
//   @override
//   State<RandomContest> createState() => _RandomContestState();
// }
//
// class _RandomContestState extends State<RandomContest> {
//   // late StreamSubscription _myContestsStream;
//
//   String _displayContest ='Contests will go here';
//   String _displayQuestion ='Question go here';
//   List<dynamic> newQuizListData = [];
//
//
//   final _database = FirebaseDatabase.instance.ref().child('contestInfo').child('contestId21324');
//   final _databaseContest = FirebaseDatabase.instance.ref();
//   final DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('contestInfo');
//   // late StreamSubscription _myContestsStream;
//   final ref = FirebaseDatabase.instance.ref();
//
//
//   @override
//   void initState(){
//     super.initState();
//     _activateListerns();
//   }
//
//
//
//   // @override
//   // void deactivate(){
//   //   _myContestsStream.cancel();
//   //   super.deactivate();
//   // }
//
//   void _activateListerns(){
//     _databaseContest.child('contestInfo').onValue.listen((event) {
//       final dynamicValue = event.snapshot.value;
//       if(dynamicValue is Map){
//
//         final data = Map<String, dynamic>.from(dynamicValue);
//         print(data);
//         print('successful');
//
//         Map<String, dynamic> mydata = jsonDecode(jsonEncode(event.snapshot.value))  as Map<String, dynamic>;
//
//
//         print('Converted list is : $mydata' );
//         // List<Map<String, dynamic>> list = [];
//         // mydata.forEach((key, value) {
//         //   if (value is Map<String, dynamic>) {
//         //     // Handle the case when the value is an internal map
//         //     list.add({key: [value]});
//         //   } else {
//         //     // Handle the case when the value is not an internal map
//         //     list.add({key: value});
//         //   }
//         // });
//         // print(list);
//
//         List<Contest> contests = [];
//         final questionsData = data['questions'] as Map<dynamic, dynamic>;
//         final questions = <String, Question>{};
//
//         data.forEach((contestId, data) {
//           questionsData.forEach((questionId, questionData) {
//           final question = Question(
//           audioUrl : questionData['audioUrl'],
//           correctOption: questionData['correctOption'],
//           imageUrl: questionData['imageUrl'],
//           option1: questionData['option1'],
//           option2: questionData['option2'],
//           option3: questionData['option3'],
//           option4: questionData['option4'],
//           question: questionData['question'],
//           );
//           final audioUrl = questionData['audioUrl'] as double;
//           final option1 = questionData['option1'] as String;
//           questions[questionId.toString()] = question;
//           print('audioUrl: $audioUrl');
//           print('option1: $option1');
//           });
//
//           final contest = Contest(
//             contestId: contestId,
//             contestTime : data['contestTime'],
//             contestEndTime: data['contestEndTime'],
//             description: data['description'],
//             displayName: data['displayName'],
//             imageUrl: data['imageUrl'],
//             // question: questions,
//           );
//           contests.add(contest);
//           });
//         print(contests);
//
//         // data.forEach((key, value) {
//         //
//
//         // });
//         print('dynamic value is :$dynamicValue');
//         data.forEach((contestId, contestData) {
//           final time = contestData['contestTime'] as double;
//           final description = contestData['description'] as String;
//           print('contest ID: $contestId');
//           print('Time: $time');
//           print('Description: $description');
//         });
//         print('Executed');
//       }else{
//         print('THis data is not map');
//       }
//
//
//
//       // final data  = new Map<String,dynamic>.from (event.snapshot.value);
//       // final description = data ['description'] as String ;
//       // setState(() {
//       //   _displayText = 'Todays spcecial is : $description';
//       // });
//     });
//   }
//
//
//   // Future<void> _activateListerns() async {
//   //
//   //
//   //   _databasecontest.child('contestInfo').onValue.listen((event) {
//   //
//   //
//   //     final dynamicValue = event.snapshot.value;
//   //     if(dynamicValue is Map){
//   //       print(dynamicValue);
//   //     }
//   //     else{
//   //       print('Nahi hai map');
//   //     }
//   //     // print('Converted list is : $mydata' );
//   //     // List<Map<String, dynamic>> quizlist = [];
//   //     // mydata.forEach((key, value) {
//   //     //   if (value is Map<String, dynamic>) {
//   //     //     // Handle the case when the value is an internal map
//   //     //     quizlist.add({key: [value]});
//   //     //   } else {
//   //     //     // Handle the case when the value is not an internal map
//   //     //     quizlist.add({key: value});
//   //     //   }
//   //     // });
//   //     // print(quizlist);
//   //
//   //   });
//   //
//   //
//   //   final snapshot = await ref.child('contestInfo/contestId21324').get();
//   //   if (snapshot.exists) {
//   //     print(snapshot.value);
//   //   }
//   //   else {
//   //     print('No data available.');
//   //
//   //   }
//   //   // _myContestsStream= _database.child('myContests').child('idwdaerdawda123').onValue.listen((event)  {
//   //   //   final data= new Map<String,dynamic>.from(event.snapshot.value as Map<String, dynamic>);
//   //   //   final contests = data['displayName'] as String;
//   //   //   final questionList = data['contestTime'] as int;
//   //   //   // final data = new Map <dynamic, dynamic>.from(event.snapshot.value.);
//   //   //   // final contestNames = data[''];
//   //   //   setState(() {
//   //   //     _displayContest = 'Contests ongoing: $contests';
//   //   //
//   //   //     _displayQuestion = 'Questions : $questionList';
//   //   //   });
//   //   // });
//   //   _myContestsStream= _database.child('contestInfo').child('contestId1234').onValue.listen((event)  {
//   //     final data= new Map<String,dynamic>.from(event.snapshot.value as Map<String, dynamic>);
//   //     final contests = data['displayName'] as String;
//   //     final questionList = data['contestTime'] as int;
//   //     // final data = new Map <dynamic, dynamic>.from(event.snapshot.value.);
//   //     // final contestNames = data[''];
//   //     setState(() {
//   //       _displayContest = 'Contests ongoing: $contests';
//   //
//   //       _displayQuestion = 'Questions : $questionList';
//   //     });
//   //   });
//   // }
//
//
//
//
//   List quizListData = [
//     {
//       "id": 1,
//       "answer": "30%",
//       "answer_discription": "",
//       "is_answered": 0,
//       "is_answer_status_right_wrong_omitted": 0,
//       "title":
//       "A mine or part there of may be treated as naturally wet if the roadway dust sample \r\ncontain_______or more of moisture by weight.",
//       "options": [
//         {
//           "option": "a",
//           "value": "10%",
//           "color": "0xFFFFFFFF",
//         },
//         {
//           "option": "b",
//           "value": "15%",
//           "color": "0xFFFFFFFF",
//         },
//         {
//           "option": "c",
//           "value": "20%",
//           "color": "0xFFFFFFFF",
//         },
//         {
//           "option": "d",
//           "value": "30%",
//           "color": "0xFFFFFFFF",
//         },
//       ],
//     },
//     {
//       "id": 2,
//       "answer": "25 cm",
//       "answer_discription": "",
//       "is_answered": 0,
//       "is_answer_status_right_wrong_omitted": 0,
//       "title":
//       "The thickness of ventilation stopping constructed of masonary or brickwork shall be _______cms \r\nin thickness",
//       "options": [
//         {
//           "option": "a",
//           "value": "20 cm",
//           "color": "0xFFFFFFFF",
//         },
//         {
//           "option": "b",
//           "value": "15 cm",
//           "color": "0xFFFFFFFF",
//         },
//         {
//           "option": "c",
//           "value": "25 cm",
//           "color": "0xFFFFFFFF",
//         },
//         {
//           "option": "d",
//           "value": "10 cm",
//           "color": "0xFFFFFFFF",
//         },
//         {
//           "option": "e",
//           "value": "18 cm",
//           "color": "0xFFFFFFFF",
//         }
//       ],
//     },
//     {
//       "id": 3,
//       "answer": "Mine Managers",
//       "answer_discription": "",
//       "is_answered": 0,
//       "is_answer_status_right_wrong_omitted": 0,
//       "title": "M.V.T. Rules 1966 shall not apply to the following persons",
//       "options": [
//         {
//           "option": "a",
//           "value": "Timber man",
//           "color": "0xFFFFFFFF",
//         },
//         {
//           "option": "b",
//           "value": "Coal driller",
//           "color": "0xFFFFFFFF",
//         },
//         {
//           "option": "c",
//           "value": "Coal driller",
//           "color": "0xFFFFFFFF",
//         },
//         {
//           "option": "d",
//           "value": "Mine Managers",
//           "color": "0xFFFFFFFF",
//         },
//         {
//           "option": "e",
//           "value": "Haulage attendents",
//           "color": "0xFFFFFFFF",
//         }
//       ],
//     },
//     {
//       "id": 4,
//       "answer": "3",
//       "answer_discription": "",
//       "is_answered": 0,
//       "is_answer_status_right_wrong_omitted": 0,
//       "title": "Mine Managers",
//       "options": [
//         {
//           "option": "a",
//           "value": "3",
//           "color": "0xFFFFFFFF",
//         },
//         {
//           "option": "b",
//           "value": "2",
//           "color": "0xFFFFFFFF",
//         },
//         {
//           "option": "c",
//           "value": "1",
//           "color": "0xFFFFFFFF",
//         },
//         {
//           "option": "e",
//           "value": "Not required",
//           "color": "0xFFFFFFFF",
//         }
//       ],
//     },
//     {
//       "id": 5,
//       "answer": "1 year",
//       "answer_discription": "",
//       "is_answered": 0,
//       "is_answer_status_right_wrong_omitted": 0,
//       "title":
//       "As per M.V.T. Rules 1966 every person holding a gast testing certificate shall once in __________ \r\nundergo a course of training as detailed in 8th schedule of M V T Rules 1966.",
//       "options": [
//         {
//           "option": "a",
//           "value": "5 years",
//           "color": "0xFFFFFFFF",
//         },
//         {
//           "option": "b",
//           "value": "1 year",
//           "color": "0xFFFFFFFF",
//         },
//         {
//           "option": "c",
//           "value": "2 years",
//           "color": "0xFFFFFFFF",
//         },
//         {
//           "option": "d",
//           "value": "3years",
//           "color": "0xFFFFFFFF",
//         },
//         {
//           "option": "e",
//           "value": "4years",
//           "color": "0xFFFFFFFF",
//         }
//       ],
//     },
//     {
//       "id": 6,
//       "answer": "8m",
//       "answer_discription": "",
//       "is_answered": 0,
//       "is_answer_status_right_wrong_omitted": 0,
//       "title":
//       "Main Mechanical Ventilator of a mine shall be installed on the surface at a distance of not less \r\nthan _____ from the opening of the shaft or inlcine",
//       "options": [
//         {
//           "option": "a",
//           "value": "10m",
//           "color": "0xFFFFFFFF",
//         },
//         {
//           "option": "b",
//           "value": "8m",
//           "color": "0xFFFFFFFF",
//         },
//         {
//           "option": "c",
//           "value": "7m",
//           "color": "0xFFFFFFFF",
//         },
//         {
//           "option": "d",
//           "value": "5m",
//           "color": "0xFFFFFFFF",
//         },
//         {
//           "option": "e",
//           "value": "4m",
//           "color": "0xFFFFFFFF",
//         }
//       ],
//     },
//   ];
//
//   final _pageController = PageController(initialPage: 0);
//   int questionINdex = 0;
//
//   int userPercentage = 0;
//   int wrongQ = 0;
//   int ommitedQuestion = 0;
//   int totalRight = 0;
//
//   quizResult(context) {
//     userPercentage = 0;
//     wrongQ = 0;
//     ommitedQuestion = 0;
//     totalRight = 0;
//
//     for (int i = 0; i < quizListData.length; i++) {
//       if (quizListData[i]['is_answer_status_right_wrong_omitted'] == 0) {
//         ommitedQuestion++;
//       }
//       if (quizListData[i]['is_answer_status_right_wrong_omitted'] == 1) {
//         totalRight++;
//       }
//       if (quizListData[i]['is_answer_status_right_wrong_omitted'] == 2) {
//         wrongQ++;
//       }
//     }
//
//     userPercentage = ((totalRight / quizListData.length) * 100).round();
//     Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(
//           builder: (context) => ResultScreen(
//             userPercentage: userPercentage,
//             totalRight: totalRight,
//             wrongQ: wrongQ,
//             coins : totalRight *4-wrongQ*1,
//             ommitedQuestion: ommitedQuestion,
//           ),
//         ),
//             (Route<dynamic> route) => false);
//   }
//
//   @override
//
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Read Examples'),),
//       body: Center(
//         child:Padding(
//           padding: const EdgeInsets.only(top: 15.0,),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text('Result is : $_displayContest'),
//               Text('Price is : $_displayQuestion'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
