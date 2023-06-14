import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:realtime_demo/screens/contest/contest_quiz_screen.dart';
import 'package:realtime_demo/screens/result_screen.dart';

import '../../models/contest_model.dart';
import '../../widgets/bullet_list.dart';
import '../quiz/quiz_section_quiz_screen.dart';



class ContestIntroScreen extends StatefulWidget {

  final String contestId;
  final String displayName;
  final String description;

  const ContestIntroScreen({super.key, required this.contestId, required this.description,required this.displayName});

  @override
  State<ContestIntroScreen> createState() => _ContestIntroScreenState();
}

class _ContestIntroScreenState extends State<ContestIntroScreen> {

  final _database = FirebaseDatabase.instance.ref();
  late String contestId;
  late String description;
  late String displayName;



  List quizListData = QuestionDataHolder.questionDataList;

  final _pageController = PageController(initialPage: 0,keepPage: true,);
  int questionINdex = 0;

  int userPercentage = 0;
  int wrongQ = 0;
  int ommitedQuestion = 0;
  int totalRight = 0;

  late Timer _timer;
  int _start = 90 ;
  int _quizTimerStart = 30 ;
  int _duration = 30;


  void _activateListners() {
    _database.child('contestInfo').child('$contestId').child('questions').onValue.listen((event) {
      print('ContestId is: $contestId');
      final dynamicValue = event.snapshot.value;
      if(dynamicValue is Map){
        final data = Map<String, dynamic>.from(dynamicValue);
        // print('This is data : $data');
        List<Map<String, dynamic>> questionDataList = [];
        // data.forEach((key, value) {
        //
        // });
        questionDataList.clear();
        data.forEach((questionId, questionData) {
          final correctOption = questionData['correctOption'] as int;
          final option1 = questionData['option1'] as String;
          final option2 = questionData['option2'] as String;
          final option3 = questionData['option3'] as String;
          final option4 = questionData['option4'] as String;
          final question = questionData['question'] as String;
          final audioUrl = questionData['audioUrl'] as String;
          final imageUrl = questionData['imageUrl'] as String;
          // print('question ID: $questionId');
          // print('question: $question');
          // print('correctOption: $correctOption');
          final formattedData = {
            "questionId": questionId,
            "correctOption": correctOption as int,
            "option1": option1,
            "option2": option2,
            "option3": option3,
            "option4": option4,
            "question": question,
            "audioUrl": audioUrl,
            "imageUrl": imageUrl,
          };
          questionDataList.add(formattedData);
        });


        List mytransformData= transformData(questionDataList);

        setState(() {
          QuestionDataHolder.questionDataList = mytransformData;
          // print(QuestionDataHolder.questionDataList);
        });
        // print(questionDataList);
      }else{
        print('THis data is not map');
      }
    });

    // _database.child('dailySpecial/price').onValue.listen((event) {
    //   final Object? price = event.snapshot.value;
    //   setState(() {
    //     _displayPrice = 'Todays spcecial is : $price';
    //   });
    // });

  }

  Future<bool> _onBackPressed() async {
    return await showDialog(
        context: context, builder: (context) =>
        AlertDialog(
          title: const Text('You are about to submit test'),
          content: const Text('By clicking Confirm your marked answers will only get considered'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => quizResult(context),
              child: const Text('Confirm'),
            ),
          ],
        )
    );
  }




  @override
  void initState(){
    super.initState();
    contestId = widget.contestId;
    description = widget.description;
    displayName = widget.displayName;
    _activateListners();
  }

  String convertNumberToAlphabet(int number) {
    // ASCII value of 'A'
    final int asciiValueOfa = 'a'.codeUnitAt(0);

    // Convert the number to the corresponding character
    final String alphabet = String.fromCharCode(asciiValueOfa + number - 1);

    return alphabet;
  }

  // Future<String> correctAnswerValue(String correctAnswer, List<Map<String, dynamic>> options) async {
  //   try {
  //     for (var option in options) {
  //       if (option["option"] == correctAnswer) {
  //         correctAnswer = option["value"];
  //         return correctAnswer;
  //         break;
  //       } else {
  //         throw Future.error(Text('No Option mentioned'));
  //       }
  //     }
  //   }catch(Exc)
  //   {
  //     print(Exc);
  //     rethrow;
  //   }
  // }


  List<Map<String, dynamic>> transformData(List<Map<String, dynamic>> originalData) {
    List<Map<String, dynamic>> transformedData = [];

    int idCounter = 1;

    for (var item in originalData) {
      Map<String, dynamic> transformedItem = {
        "id": idCounter,
        "questionId": item["questionId"],
        "answer": convertNumberToAlphabet(item["correctOption"]),
        "audioUrl": item["audioUrl"],
        "imageUrl": item["imageUrl"],
        "is_answered": 0,
        "is_answer_status_right_wrong_omitted": 0,
        "title": item["question"],
        "options": [
          {
            "option": "a",
            "value": item["option1"],
            "color": "0xFFFFFFFF",
          },
          {
            "option": "b",
            "value": item["option2"],
            "color": "0xFFFFFFFF",
          },
          {
            "option": "c",
            "value": item["option3"],
            "color": "0xFFFFFFFF",
          },
          {
            "option": "d",
            "value": item["option4"],
            "color": "0xFFFFFFFF",
          },
        ],
      };

      transformedData.add(transformedItem);
      idCounter++;
    }

    return transformedData;
  }


  quizResult(context) {
    userPercentage = 0;
    wrongQ = 0;
    ommitedQuestion = 0;
    totalRight = 0;

    for (int i = 0; i < quizListData.length; i++) {
      if (quizListData[i]['is_answer_status_right_wrong_omitted'] == 0) {
        ommitedQuestion++;
      }
      if (quizListData[i]['is_answer_status_right_wrong_omitted'] == 1) {
        totalRight++;
      }
      if (quizListData[i]['is_answer_status_right_wrong_omitted'] == 2) {
        wrongQ++;
      }
    }

    userPercentage = ((totalRight / quizListData.length) * 100).round();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            userPercentage: userPercentage,
            totalRight: totalRight,
            wrongQ: wrongQ,
            ommitedQuestion: ommitedQuestion,
            coins : totalRight *4-wrongQ*1,
          ),
        ),
            (Route<dynamic> route) => false);
  }





  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {

    double width = MediaQuery. of(context). size. width ;
    bool showFloatingButton = false;
    return Scaffold(
      backgroundColor:  Color(0xFF6D2359),
      // appBar: AppBar(
      // ),
      body: Padding(
        padding: const EdgeInsets.only(top: 100,left: 20,right: 20,bottom: 100 ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          color: Color(0xFFFFFFFF),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 20),
                  child: Text(
                    "Instructions",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color:Color(0xFF6D2359),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(05.0),
                  child: Text(displayName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xC76D2359),
                    ),),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    width: width-100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment:CrossAxisAlignment.start ,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Description :',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6D2359),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                              '$description ',
                              softWrap: true,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF6D2359),
                              ),
                            ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20 ),
                    child: Text('Guidelines',
                      softWrap: true,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6D2359),
                      ),
                    )
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 5 ),
                  child: Container(
                    height: 327,
                    decoration: BoxDecoration(
                        color: Color(0xCFC7C7C7),
                        borderRadius: BorderRadius.circular(14)),
                    child: SingleChildScrollView(

                      child: BulletList([
                        'If you want to go back or exit the quiz, you can do so at any time by clicking the "Submit" button.',
                        'If you want to go back or exit the quiz, you can do so at any time by clicking the "Submit" button.',
                        "The quiz has a timer of 60 minutes. If you don't complete the quiz within the given time, it will be automatically submitted.",
                        "Take your time, read each question carefully, and choose the option you believe is correct.",
                        "Good luck! Enjoy the quiz and have fun!",
                      ]),
                    ),
                  ),
                ),

                // Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10 ),
                //     child: Text('You must use a functioning webcam and microphone \n '
                //         'No cell phones or other secondary devices in the room or test area '
                //         '\n Your desk/table must be clear or any materials except your test-taking device '
                //         '\n No one else can be in the room with you '
                //         '\n No talking  '
                //         '\n The testing room must be well-lit and you must be clearly visible '
                //         '\n No dual screens/monitors  '
                //         '\n  Do not leave the camera '
                //         '\n No use of additional applications or internet',
                //       softWrap: true,
                //       style: const TextStyle(
                //         fontSize: 15,
                //         fontWeight: FontWeight.w400,
                //         color: Color(0xFF6D2359),
                //       ),
                //     )
                // ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton:FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ContestQuizScreen(contestId: contestId)));

        },icon:Icon(Icons.start),
        label:
        Text("Start" )  ,
      ),
    );
  }
}

