import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:realtime_demo/screens/contest/contest_carousel.dart';
import 'package:realtime_demo/screens/quiz/quiz_intro.dart';
import 'package:realtime_demo/screens/quiz/quiz_section_quiz_screen.dart';
import 'package:realtime_demo/widgets/leader_board.dart';
import '../models/contest_model.dart';
import '../services/auth.dart';

class DashBoardPage extends StatefulWidget {
  DashBoardPage({Key? key}) : super(key: key);

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {

  final User? user=Auth().currentUser;
  final _database = FirebaseDatabase.instance.ref();
  bool isDataFetched = false;

  // void updateCoins(String uid, int newCoins) {
  //   DatabaseReference userRef = FirebaseDatabase.instance.ref().child('userInfo').child(uid);
  //   userRef.update({'coins': newCoins});
  //   print ('$newCoins coins have been added to $uid');
  // }

  Future<List<dynamic>> getUserInfo(String uid) async {
    final ref = FirebaseDatabase.instance.ref();
    // DatabaseReference userRef = FirebaseDatabase.instance.ref().child('userInfo').child(uid);
    final snapshot = await ref.child('userInfo').child(uid).get();
    if (snapshot.exists) {
      // print(snapshot.value);
      Map<String, dynamic>? userData = snapshot.value as Map<String, dynamic>?;
      if (userData != null) {
        List<dynamic> userInfo = userData.values.toList();
        // print('This is userInfo $userInfo');
        return userInfo;
      } else {
        return [];
      }
    } else {
      return [];
    }

  }

  void _activateListeners() {
    _database.child('quizSection').onValue.listen((event) {
      final dynamicValue = event.snapshot.value;
      if(dynamicValue is Map){

        final data = Map<String, dynamic>.from(dynamicValue);

        // List<quizSection> quizSections = [];
        List<Map<String, dynamic>> quizSectionDataList = [];

        quizSectionDataList.clear();
        // data.forEach((key, value) {
        //

        // });
        data.forEach((quizSectionId, quizSectionData) {
          final time = quizSectionData['dataCreated'] as int;
          final description = quizSectionData['description'] as String;
          final name = quizSectionData['name'] as String;
          final shortDescription = quizSectionData['shortDescription'] as String;
          final imageUrl = quizSectionData['imageUrl'] as String;
          final mask = quizSectionData['mask'] as int;
          // print('quizSection ID: $quizSectionId');
          // print('Time: $time');
          // print('Description: $description');
          final formattedData = {
            "quizSectionId": quizSectionId,
            "time": time.toString(),
            "description": description,
            "shortDescription": shortDescription,
            "name": name,
            "imageUrl": imageUrl,
            "mask": mask.toString(),
            "color" :  getRandomColor().toString(),
          };
          quizSectionDataList.add(formattedData);
        });

        setState(() {
          quizSectionDataHolder.quizSectionDataList = quizSectionDataList;
        });
      }else{
        print('THis data is not map');
      }
    });
    _database.child('contestInfo').onValue.listen((event) {
      final dynamicValue = event.snapshot.value;
      if(dynamicValue is Map){

        final data = Map<String, dynamic>.from(dynamicValue);

        List<Map<String, dynamic>> contestDataList = [];
        contestDataList.clear();
        data.forEach((contestId, contestData) {
          final time = contestData['contestTime'] as int;
          final description = contestData['description'] as String;
          final displayName = contestData['displayName'] as String;
          final imageUrl = contestData['imageUrl'] as String;
          final leaderboard = contestData['leaderBoard'] ;

          print('contest ID: $contestId');
          // print('Time: $time');
          // print('Description: $description');
          // print('leaderboard: $leaderboard');
          final formattedData = {
            "contestId": contestId,
            "time": time.toString(),
            "description": description,
            "displayName": displayName,
            "imageUrl": imageUrl,
            "color" :  getRandomColor().toString(),
          };
          contestDataList.add(formattedData);
        });


        setState(() {
          ContestDataHolder.contestDataList = contestDataList;
          // print(ContestDataHolder.contestDataList);
        });
        // print(contestDataList);
      }else{
        // print('THis data is not map');
      }
    });

    _database.child('quizSection').onValue.listen((event) {
      final dynamicValue = event.snapshot.value;
      if(dynamicValue is Map){

        final data = Map<String, dynamic>.from(dynamicValue);
        // print(data);

        List<Map<String, dynamic>> quizSectionDataList = [];

        quizSectionDataList.clear();

        data.forEach((quizSectionId, quizSectionData) {
          // print(quizSectionId);
          // print(quizSectionData);
          final time = quizSectionData['dataCreated'] as int;
          final description = quizSectionData['description'] as String;
          final name = quizSectionData['name'] as String;
          final shortDescription = quizSectionData['shortDescription'] as String;
          final imageUrl = quizSectionData['imageUrl'] as String;
          final mask = quizSectionData['mask'] as int;
          print('quizSection ID: $quizSectionId');
          print('Time: $time');
          print('Description: $description');
          final formattedData = {
            "quizSectionId": quizSectionId,
            "time": time.toString(),
            "description": description,
            "shortDescription": shortDescription,
            "name": name,
            "imageUrl": imageUrl,
            "mask": mask.toString(),
            "color" :  getRandomColor().toString(),
          };
          quizSectionDataList.add(formattedData);
        });

        setState(() {
          quizSectionDataHolder.quizSectionDataList = quizSectionDataList;
          // print(quizSectionDataHolder.quizSectionDataList);
        });
        // print(quizSectionDataList);
      }else{
        print('THis data is not map');
      }
    });
    isDataFetched = true;
  }


  void incrementCoins(String uid, int incrementAmount) async {
    final userRef = FirebaseDatabase.instance.ref().child('userInfo').child(uid).child('coins');

    // Retrieve the current value of coins
    // final snapshot = await userRef.once();
    DatabaseEvent event = await userRef.once();
    final int currentCoins = event.snapshot.value as int;

    // Increment the coins value
    final int newCoins = currentCoins + incrementAmount;

    // Update the new value in the database
    await userRef.set(newCoins);
  }

  Color hexToColor(String hexCode) {
    String x = hexCode.replaceAll("Color(0x", "");
    String formattedHexCode = x.replaceAll(")", "");
    int parsedColor = int.parse(formattedHexCode, radix: 16);
    // print('this is formatted color :$parsedColor');
    return Color(parsedColor);
  }

  String getRandomColor () {
    final customColors = [
      "Color(0xFFFBBBB5)",
      "Color(0xFFCDD7E7)",
      "Color(0xFFE6E7CD)",
      "Color(0xFFCDE7CE)",
    ];
    return customColors[Random().nextInt(customColors.length)];
  }
  final List<Color> customColors = [
    Color(0xFFFBBBB5),
    Color(0xFFCDD7E7),
    Color(0xFFE6E7CD),
    Color(0xFFCDE7CE),// Add more custom colors as needed
  ];


  List<String> images = [
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQTIZccfNPnqalhrWev-Xo7uBhkor57_rKbkw&usqp=CAU",
    "https://wallpaperaccess.com/full/2637581.jpg"
  ];

  Future <void> signOut() async{
    await Auth().signOut();
  }


  Widget _signOutButton(){
    return ElevatedButton(
        onPressed: signOut,
        child: const Text('Sign Out')
    );
  }

  @override
  void initState() {
    super.initState();
    getUserInfo(user!.uid);
    _activateListeners();
  }


  Future<void> fetchData() async {
     _activateListeners();
    setState(() {
      isDataFetched = true;
    });
  }



  @override
  Widget build(BuildContext context) {

    if (!isDataFetched) {
      // If the data has not been fetched yet, call fetchTopUsers() to retrieve it
     return Center(child: CircularProgressIndicator()); // Show a loading indicator
    }
    final List<Map<String, dynamic>> quizSectionData = quizSectionDataHolder.quizSectionDataList;

    int numberOfIds = quizSectionData.length;

    double width = MediaQuery. of(context). size. width ;
    double height = MediaQuery. of(context). size. height ;

    String selectedQuizSectionId;
    String description;
    String displayName;

    return Scaffold(
      // appBar: AppBar(
      //   // title: _title(),
      // ) ,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 50) ,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 10,left: 10),
              child: Container(
                width: width ,
                height: height*0.1,
                color: Colors.transparent,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CircleAvatar(
                        radius: 34,
                        backgroundImage:
                        NetworkImage('https://picsum.photos/id/237/200/300'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5,),
                            child: RichText(
                              text: TextSpan(
                                text: 'Welcome, ',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    // text: user?.email?? ''+'Welcome',
                                    text: user!.photoURL,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    // text: user?.email?? ''+'Welcome',
                                    text: ' \u{1F44B}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Image.asset('assets/images/Coin.png',
                                height: 23.0,
                                width: 23.0,
                                fit: BoxFit.cover,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  user?.email?? ''+'Welcome',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),),
                              ),
                            ],
                          ),
                        ],

                      ),
                    )
                  ],
                ),
              ),
            ),
            LeaderBoardCard(),
            Padding(
              padding: const EdgeInsets.only(left: 15,top: 24),
              child: Text('Contest',
                style: GoogleFonts.inter(
                    color: Colors.black,
                    fontWeight:FontWeight.bold,
                    fontSize: 18
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Container(
                height:250,
                width: width,
                child: ContestCarouselWidget(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15,top: 20),
              child: Text('Choose a topic',
                style: GoogleFonts.inter(
                    color: Colors.black,
                    fontWeight:FontWeight.bold,
                    fontSize: 18
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15,top: 0),
              child: SingleChildScrollView(
                child: SizedBox(
                  height: 208 * numberOfIds +1,
                  width: width,
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 0,
                    children: [
                      ...quizSectionData.map((e) =>
                          Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: GestureDetector(
                              onTap: () {
                                selectedQuizSectionId = e['quizSectionId'];
                                description = e['description'];
                                displayName = e['name'];

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QuizIntroScreen(quizSectionId: selectedQuizSectionId, description: description, displayName: displayName,),
                                  ),
                                );
                              },
                              child:  SizedBox(
                                  width: 183,
                                  height: 118,

                                  child: Stack(
                                      children: <Widget>[
                                        Positioned(
                                            top: 0,
                                            left: 0,
                                            child: Container(
                                                width: 183,
                                                height: 118,
                                                decoration: BoxDecoration(
                                                  borderRadius : BorderRadius.only(
                                                    topLeft: Radius.circular(8),
                                                    topRight: Radius.circular(8),
                                                    bottomLeft: Radius.circular(8),
                                                    bottomRight: Radius.circular(8),
                                                  ),
                                                  boxShadow : [
                                                    BoxShadow(
                                                        color: Color.fromRGBO(0, 0, 0, 0.30000001192092896),
                                                        offset: Offset(1,1),
                                                        blurRadius: 2
                                                    )],
                                                  color :hexToColor(e['color']),
                                                )
                                            )
                                        ),
                                        Positioned(
                                            top: 11,
                                            left: 104,
                                            child: Container(
                                                width: 68,
                                                height: 68,
                                                decoration: BoxDecoration(
                                                  color : Color.fromRGBO(0, 0, 0, 0.20000000298023224),
                                                  borderRadius : BorderRadius.all(Radius.elliptical(68, 68)),
                                                )
                                            )
                                        ),
                                        // Positioned(
                                        //   top: 11,
                                        //   left: 104,
                                        //   child: Container(
                                        //     child:
                                        //     Image.asset('assets/images/sample.png',
                                        //       height: 200.0,
                                        //       width: 200.0,
                                        //       fit: BoxFit.cover,
                                        //     ),
                                        //   ),
                                        // ),
                                        Positioned(
                                            top: 29,
                                            left: 122,
                                            child: Container(
                                                width: 32,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  color : Colors.transparent,
                                                ),
                                                child: Stack(
                                                    children: <Widget>[
                                                      // Positioned(
                                                      //     top: 4,
                                                      //     left: 6,
                                                      //     child: SvgPicture.asset(
                                                      //         'assets/images/vector2.svg',
                                                      //         semanticsLabel: 'vector'
                                                      //     ),
                                                      // ),
                                                      Positioned(
                                                        top: 3,
                                                        left: 5,
                                                        child: SvgPicture.asset(
                                                            'assets/images/vector2.svg',
                                                            semanticsLabel: 'vector'
                                                        ),
                                                      ),
                                                    ]
                                                )
                                            )
                                        ),
                                        Positioned(
                                          top: 85,
                                          left: 16,
                                          child: Text(e['quizSectionId'], textAlign: TextAlign.left,
                                              style: GoogleFonts.inter(
                                                  color: Color.fromRGBO(0, 0, 0, 1),
                                                  fontSize: 20,
                                                  letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                                  fontWeight: FontWeight.bold,
                                                  height: 1
                                              )
                                          ),
                                        ),
                                      ]
                                  )
                              ),
                              // Card(
                              //   color: Colors.amber,
                              //   child: Text(e['subject_name'],) ,
                              // ),
                            ) ,
                          ))
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
                width: 50,
                height: 8,),

            Center(child: _signOutButton()),
          ],
        ),
      ),
    );
  }
}
