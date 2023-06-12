import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContestLeaderBoardCard extends StatefulWidget {
  var contestId;

  ContestLeaderBoardCard({super.key, required this.contestId});


  @override
  State<ContestLeaderBoardCard> createState() => _ContestLeaderBoardCardState();

}

class _ContestLeaderBoardCardState extends State<ContestLeaderBoardCard> {


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



  Future<void> getTopUsers(int limit) async {
    DatabaseReference userRef = FirebaseDatabase.instance.ref().child('userInfo');

    List<Map<String, dynamic>> topUsers = [];

    userRef.orderByChild('coins')
        .limitToLast(limit)
        .once()
        .then((DataSnapshot snapshot) async {

      if (snapshot.value != null) {
        Map<dynamic, dynamic>? usersData = snapshot.value as Map<dynamic, dynamic>?;


        // Sort the users based on coins in descending order
        List<MapEntry<dynamic, dynamic>> sortedUsers = usersData!.entries.toList()
          ..sort((a, b) => b.value['coins'].compareTo(a.value['coins']));

        // Retrieve the top users
        List<MapEntry<dynamic, dynamic>> topUsers = sortedUsers.sublist(0, limit);

        // Print or process the top users
        topUsers.forEach((user) {
          print('User: ${user.key}');
          print('Coins: ${user.value['coins']}');
        });
      } else {
        print('No users found');
      }
    } as FutureOr Function(DatabaseEvent value)).catchError((error) {
      print('Error retrieving top users: $error');
    });
  }





  @override
  Widget build(BuildContext context) {
    return
      Padding(
        padding: const EdgeInsets.only(left: 15,),
        child: Container(
          width: 382,
          height: 260,
          decoration:
          BoxDecoration(
            borderRadius : BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            boxShadow : [
              BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.25),
                  offset: Offset(0,0),
                  blurRadius: 6
              )],
            border : Border.all(
              color: Color.fromRGBO(255, 255, 255, 1),
              width: 1,
            ),
            gradient : LinearGradient(
                begin: Alignment(1.0230568647384644,0.08680927753448486),
                end: Alignment(-0.58680928498506546,0.50095678269863129),
                // stops: [1.0,1.0,1.0],
                colors: [
                  Color(0xFF81E5EC),
                  Color(0xFFF0C3F6),

                  Color(0xFFF6D0AD),
                ]
            ),
          ),
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10 ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text('2',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          // fontFamily: 'Inter',
                          fontSize: 16,
                          letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.bold,
                          // height: 1
                        ),
                      ),
                    ),
                    Container(
                        width: 78,
                        height: 78,
                        decoration: BoxDecoration(
                          boxShadow : [
                            BoxShadow(
                                color: Color.fromRGBO(176, 109, 228, 1),
                                offset: Offset(0,0),
                                blurRadius: 23
                            )],
                          color : Color.fromRGBO(217, 217, 217, 1),
                          border : Border.all(
                            color: Color.fromRGBO(165, 107, 227, 1),
                            width: 4,
                          ),
                          image : DecorationImage(
                              image: AssetImage('assets/images/contestant.jpg'),
                              fit: BoxFit.fitWidth
                          ),
                          borderRadius : BorderRadius.all(Radius.elliptical(98, 98)),
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text('Akshay Kanade',
                          textAlign: TextAlign.left,
                          style:
                          GoogleFonts.inter(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontSize: 15,
                              letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.bold,
                              height: 1
                          )
                        // TextStyle(
                        //     color: Color.fromRGBO(0, 0, 0, 1),
                        //     fontFamily: 'Inter',
                        //     fontSize: 15,
                        //     letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                        //     fontWeight: FontWeight.bold,
                        //     height: 1
                        // ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text('#125 pts', textAlign: TextAlign.left, style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          fontFamily: 'Inter',
                          fontSize: 12,
                          letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.normal,
                          height: 1
                      ),),
                    )
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text('1',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              // fontFamily: 'Inter',
                              fontSize: 16,
                              letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.bold,
                              // height: 1
                            ),
                          ),
                        ),
                        Container(
                            width: 98,
                            height: 98,
                            decoration: BoxDecoration(
                              boxShadow : [
                                BoxShadow(
                                    color: Color.fromRGBO(176, 109, 228, 1),
                                    offset: Offset(0,0),
                                    blurRadius: 23
                                )],
                              color : Color.fromRGBO(217, 217, 217, 1),
                              border : Border.all(
                                color: Color.fromRGBO(165, 107, 227, 1),
                                width: 4,
                              ),
                              image : DecorationImage(
                                  image: AssetImage('assets/images/contestant.jpg'),
                                  fit: BoxFit.fitWidth
                              ),
                              borderRadius : BorderRadius.all(Radius.elliptical(98, 98)),
                            )
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text('Aneesh Anchan',
                              textAlign: TextAlign.left,
                              style:
                              GoogleFonts.inter(
                                  color: Colors.black,
                                  fontSize: 15,
                                  letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.bold,
                                  height: 1
                              )
                            //   TextStyle(
                            //     color: Color.fromRGBO(0, 0, 0, 1),
                            //     fontFamily: 'Inter',
                            //     fontSize: 15,
                            //     letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                            //     fontWeight: FontWeight.bold,
                            //     height: 1
                            // ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text('#125 pts',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                fontFamily: 'Inter',
                                fontSize: 12,
                                letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              image : DecorationImage(
                                  image: AssetImage('assets/images/chart_horizontal.png'),
                                  fit: BoxFit.fitWidth
                              ),
                              borderRadius : BorderRadius.all(Radius.elliptical(98, 98)),
                            )
                        ),
                        Text('Leaderboard', textAlign: TextAlign.left,
                          style:
                          GoogleFonts.inter(
                            fontStyle: FontStyle.normal,
                            fontSize: 16 , fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(173, 105, 227, 1.0),),
                          //     TextStyle(
                          //     // color: Color.fromRGBO(123, 36, 191, 1),
                          //     // fontFamily:
                          //     // fontSize: 16,
                          //     // letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                          //     // fontWeight: FontWeight.normal,
                          //     // height: 1
                          // ),
                        ),

                      ],
                    ),
                  )

                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text('3',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          // fontFamily: 'Inter',
                          fontSize: 16,
                          letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.bold,
                          // height: 1
                        ),
                      ),
                    ),
                    Container(
                        width: 78,
                        height: 78,
                        decoration: BoxDecoration(
                          boxShadow : [
                            BoxShadow(
                                color: Color.fromRGBO(176, 109, 228, 1),
                                offset: Offset(0,0),
                                blurRadius: 23
                            )],
                          color : Color.fromRGBO(217, 217, 217, 1),
                          border : Border.all(
                            color: Color.fromRGBO(165, 107, 227, 1),
                            width: 4,
                          ),
                          image : DecorationImage(
                              image: AssetImage('assets/images/contestant.jpg'),
                              fit: BoxFit.fitWidth
                          ),
                          borderRadius : BorderRadius.all(Radius.elliptical(98, 98)),
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text('Alisa Brown',
                          textAlign: TextAlign.left,
                          style:
                          GoogleFonts.inter(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontSize: 15,
                              letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.bold,
                              height: 1
                          )
                        // TextStyle(
                        //     color: Color.fromRGBO(0, 0, 0, 1),
                        //     fontFamily: 'Inter',
                        //     fontSize: 15,
                        //     letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                        //     fontWeight: FontWeight.bold,
                        //     height: 1
                        // ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text('#125 pts', textAlign: TextAlign.left, style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          fontFamily: 'Inter',
                          fontSize: 12,
                          letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.normal,
                          height: 1
                      ),),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }
}
