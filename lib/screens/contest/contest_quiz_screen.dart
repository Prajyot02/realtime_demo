import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:realtime_demo/screens/contest/contest_result_screen.dart';
import 'package:realtime_demo/screens/result_screen.dart';

import '../../models/contest_model.dart';
import '../quiz/quiz_section_quiz_screen.dart';



class ContestQuizScreen extends StatefulWidget {

  final String contestId;

  const ContestQuizScreen({super.key, required this.contestId});

  @override
  State<ContestQuizScreen> createState() => _ContestQuizScreenState();
}

class _ContestQuizScreenState extends State<ContestQuizScreen> {



  final _database = FirebaseDatabase.instance.ref();
  late String contestId;


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
            builder: (context) => ContestResultScreen(
              contestId: contestId,
              userPercentage: userPercentage,
              totalRight: totalRight,
              wrongQ: wrongQ,
              ommitedQuestion: ommitedQuestion,
              coins : totalRight *4-wrongQ*1,
            ),
          ),
              (Route<dynamic> route) => false);
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


  @override
  void dispose() {
    super.dispose();
  }

    Widget build(BuildContext context) {

      double width = MediaQuery. of(context). size. width ;
      bool showFloatingButton = false;
      bool isImagePresent = false;
      bool isAudioPresent = false;

      return WillPopScope(
        onWillPop:_onBackPressed ,
        child: Scaffold(
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
                        if(quizListData[index]['imageUrl']!="") {
                          isImagePresent = true;
                        };
                        if(quizListData[index]['audioUrl']!="") {
                          isAudioPresent = true;
                        };
                        return SingleChildScrollView(
                          child: Column(
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
                              Visibility(
                                child: Center(
                                  child: Container(
                                    child: quizListData[index]['imageUrl'] != ""
                                        ? Image.network(
                                      quizListData[index]['imageUrl'],
                                      fit: BoxFit.fill,
                                    )
                                        : SizedBox(height: 10), // Empty SizedBox if imgurl is null

                                    height: 150,
                                    width: 200,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                                visible: isImagePresent,
                              ),
                              // Visibility(
                              //   child: Center(
                              //     child: Container(
                              //       child: quizListData[index]['audioUrl'] != ""
                              //           ? Image.network(
                              //         quizListData[index]['audioUrl'],
                              //         fit: BoxFit.fill,
                              //       )
                              //           : SizedBox(height: 10), // Empty SizedBox if imgurl is null
                              //
                              //       heig ht: 150,
                              //       width: 200,
                              //       decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                              //     ),
                              //   ),
                              //   visible: isAudioPresent,
                              // ),
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
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          floatingActionButton:FloatingActionButton.extended(
              onPressed: () {
                showFloatingButton = (questionINdex == quizListData.length - 1 ? true : false);
                if (questionINdex == quizListData.length - 1) {
                  print("Submit ");
                  handleSubmitButton();
                  quizResult(context);
                } else {

                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
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
                    ),
                  );
                  // print("ELSE PART");
                  // _pageController.nextPage(
                  //   duration: const Duration(milliseconds: 300),
                  //   curve: Curves.easeIn,
                  // );

                }
              },icon:Icon(Icons.skip_next_outlined),
              label:
              Text("Submit" )  ,
            ),
        ),
      );
    }
  }
