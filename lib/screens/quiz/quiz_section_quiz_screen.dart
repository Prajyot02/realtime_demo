import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:realtime_demo/screens/dashboard_screen.dart';
import 'package:realtime_demo/screens/home_page.dart';
import 'package:realtime_demo/screens/result_screen.dart';

import '../../models/contest_model.dart';
import '../../models/user_model.dart';
import '../../utils/quiztimer.dart';
import '../contest/contest_quiz_screen.dart';



class QuizSectionQuizScreen extends StatefulWidget {

  // ValueNotifier<List<Map<String, dynamic>>> questionDataList= ValueNotifier<List<Map<String, dynamic>>>([{}]);

  final String quizSectionId;



  QuizSectionQuizScreen({super.key, required this.quizSectionId});

  @override
  State<QuizSectionQuizScreen> createState() => _QuizSectionQuizScreenState();
}

class _QuizSectionQuizScreenState extends State<QuizSectionQuizScreen> {

  final _database = FirebaseDatabase.instance.ref();
  late String quizSectionId;

  late Timer _timer;
  int _start = 90 ;
  int _quizTimerStart = 30 ;
  int _duration = 30;


  List<dynamic> updateValue(List<dynamic> transformedData) {
    QuestionDataHolder.questionDataList = transformedData;
    return QuestionDataHolder.questionDataList;
  }

  void _activateListners() {
    _database.child('quizSection').child('$quizSectionId').child('questions').onValue.listen((event) {
      print('quizSectionId is: $quizSectionId');
      final dynamicValue = event.snapshot.value;
      if(dynamicValue is Map){
        final data = Map<String, dynamic>.from(dynamicValue);
        print('This is data : $data');

        List<Question> questions = [];

        List<Map<String, dynamic>> questionDataList = [];
        // data.forEach((key, value) {
        //

        // });
        questionDataList.clear();
        print('dynamic value is :$dynamicValue');
        data.forEach((questionId, questionData) {
          final correctOption = questionData['correctOption'] as int;
          final option1 = questionData['option1'] as String;
          final option2 = questionData['option2'] as String;
          final option3 = questionData['option3'] as String;
          final option4 = questionData['option4'] as String;
          final question = questionData['question'] as String;
          final audioUrl = questionData['audioUrl'] as String;
          final imageUrl = questionData['imageUrl'] as String;
          print('question ID: $questionId');
          print('question: $question');
          print('correctOption: $correctOption');
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
         updateValue(mytransformData);
        // print(QuestionDataHolder.questionDataList);

        // setState(() {
        //   QuestionDataHolder.questionDataList = mytransformData;
        //   print(QuestionDataHolder.questionDataList);
        // });
        print(questionDataList);
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
          title:  Text('You are about to Quit !!'),
          content:  Text('''"Don't Quit" - Unknown'''),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () =>quizResult(context),
              child: const Text('Confirm'),
            ),
          ],
        )
    );
  }



  @override
  void initState(){
    super.initState();
    quizSectionId = widget.quizSectionId;
    _activateListners();
    startTimer();
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


  void startTimer() {
    const onsec = Duration(seconds: 1);
    Timer timer = Timer.periodic(onsec, (timer) {
      if(_start == 0 ) {
        setState(() {
          handleSubmitButton();
          quizResult(context);
        });
      }
      else
      {
        setState(() {
          _start--;
        });
      }
      if(_start % _duration==0){
        print(quizListData.length);
        print(_start);
        _pageController.nextPage(
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeIn,
        );
      }
    });
  }
  void eachQuizStartTimer() {
    const onsec = Duration(seconds: 1);
    Timer timer = Timer.periodic(onsec, (timer) {
      if(_quizTimerStart == 0 ) {
      }
      else
      {
        setState(() {
          _quizTimerStart--;
        });
      }
    });
  }

void handleSubmitButton() {
  int currentTime = _start; // Get the current value of _start
  print('Current time: $currentTime');
}



List quizListData = QuestionDataHolder.questionDataList;

  final _pageController = PageController(initialPage: 0);
  int questionINdex = 0;

  int userPercentage = 0;
  int wrongQ = 0;
  int ommitedQuestion = 0;
  int totalRight = 0;

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
            coins : (totalRight *4-wrongQ*1)>0?(totalRight *4-wrongQ*1):0 ,
            wrongQ: wrongQ,
            ommitedQuestion: ommitedQuestion,
          ),
        ),
            (Route<dynamic> route) => false);
  }

  @override

  Widget build(BuildContext context) {

    double width = MediaQuery. of(context). size. width ;

    return Scaffold(
      backgroundColor:  Color(0xFF6D2359),
      // appBar: AppBar(
      // ),
      body: WillPopScope(
        onWillPop: _onBackPressed,
        child: Padding(
          padding: const EdgeInsets.only(top: 100,left: 20,right: 20),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            color: Color(0xFFFFFFFF),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Level 1",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6D2359),
                        ),),
                      Text(
                        "${questionINdex + 1}/${quizListData.length}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFCB0000),
                        ),
                      ),
                      Text(
                        "$_start",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6D2359),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                  child: LinearPercentIndicator(
                    width: width- 100,
                    lineHeight: 8.0,
                    percent: _start/100,
                    barRadius: Radius.circular(10),
                    progressColor: Color(0xFF6D2359),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    itemCount: quizListData.length,
                    onPageChanged: (page) {
                      print("Current page $page");
                      setState(
                            () {
                          questionINdex = page;
                        },
                      );
                    },
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(35.0),
                              child: Text(
                                quizListData[index]['title'],
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF6D2359)
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          quizListData[index]
                          ['is_answer_status_right_wrong_omitted'] ==
                              2
                              ? Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Text(
                              "Sorry : Right answer is -> ${quizListData[index]['answer']} ",
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                              : const SizedBox(),
                          SizedBox(
                            height: 20,
                          ),
                          ...quizListData[index]['options']
                              .map(
                                (data) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 30,right: 30),
                                  child: Card(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Color(
                                          int.parse(
                                            data['color'],
                                          ),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                      ),
                                      onPressed: () {
                                        if (quizListData[index]['is_answered'] ==
                                            0) {
                                          setState(() {
                                            if (data['option'] ==
                                                (quizListData[index]['answer'])
                                            ) {
                                              data['color'] = "0xFFEE5588";
                                              quizListData[index][
                                              'is_answer_status_right_wrong_omitted'] = 1;
                                            } else {
                                              data['color'] = "0xFFFF0000";
                                              quizListData[index][
                                              'is_answer_status_right_wrong_omitted'] = 2;
                                            }
                                            quizListData[index]['is_answered'] =
                                            1;
                                          });
                                          if(questionINdex == quizListData.length - 1){
                                            quizResult(context);
                                          }
                                          else{
                                            _pageController.nextPage(
                                              duration: const Duration(milliseconds: 300),
                                              curve: Curves.easeIn,
                                            );
                                          }
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 0),
                                            child: Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                color: Color(
                                                  int.parse(
                                                    data['color'],
                                                  ),
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  data['option'].toUpperCase(),
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              data['value'],
                                              style: const TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                              .toList(),
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (questionINdex == quizListData.length - 1) {
            print("Submit ");
            quizResult(context);
          } else {
            print("ELSE PART");
            _pageController.nextPage(
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeIn,
            );
          }
        },icon:Icon(Icons.skip_next_outlined),
        label:
        Text(questionINdex == quizListData.length - 1 ? "Submit" : "Next"),
      ),
    );
  }
}

