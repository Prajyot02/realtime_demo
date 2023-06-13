import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaderBoardCard extends StatefulWidget {
  const LeaderBoardCard({super.key});

  @override
  State<LeaderBoardCard> createState() => _LeaderBoardCardState();
}

class _LeaderBoardCardState extends State<LeaderBoardCard> {

  List<Map<String, dynamic>> topUsers = [];

  Future<List<Map<String, dynamic>>> getLeaders(int limit) async {
    final userRef = FirebaseDatabase
        .instance.ref()
        .child('userInfo')
        .limitToLast(limit)
        .orderByChild('coins');
    List<Map<String, dynamic>> topUsers = [];

    DatabaseEvent event = await userRef.once();
    Map<dynamic, dynamic>? data = event.snapshot.value as  Map<dynamic, dynamic>?;
    print('These are top 2 people: $data');
    if (data != null) {
      data.forEach((key, value) {
        final coins = value['coins'] ;
        final firstname = value['fname'] as String;

        print('coins: $coins');
        print('Name: $firstname');
        final formattedData = {
          "name": firstname,
          "coins": coins,
        };
        topUsers.add(formattedData);
        // print('added $formattedData');
      }
      );
    }
    return topUsers;
  }

  @override
  void initState() {
    super.initState();
    fetchTopUsers();
  }


  Future<void> fetchTopUsers() async {
    List<Map<String, dynamic>> users = await getLeaders(3); // Adjust the limit as per your requirement
    setState(() {
      topUsers = users;
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
                      child: Text('2+',
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
          // Stack(
          //   children: [
          //     Positioned(
          //         left:width*0.3333 ,
          //         top: 13,
          //         child:
          //         Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             Padding(
          //               padding: const EdgeInsets.only(bottom: 5),
          //               child: Text('1',
          //                 textAlign: TextAlign.center,
          //                 style: TextStyle(
          //                   color: Color.fromRGBO(255, 255, 255, 1),
          //                   // fontFamily: 'Inter',
          //                   fontSize: 16,
          //                   letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
          //                   fontWeight: FontWeight.bold,
          //                   // height: 1
          //                 ),
          //               ),
          //             ),
          //             Container(
          //                 width: 98,
          //                 height: 98,
          //                 decoration: BoxDecoration(
          //                   boxShadow : [
          //                     BoxShadow(
          //                         color: Color.fromRGBO(176, 109, 228, 1),
          //                         offset: Offset(0,0),
          //                         blurRadius: 23
          //                     )],
          //                   color : Color.fromRGBO(217, 217, 217, 1),
          //                   border : Border.all(
          //                     color: Color.fromRGBO(165, 107, 227, 1),
          //                     width: 4,
          //                   ),
          //                   image : DecorationImage(
          //                       image: AssetImage('assets/images/contestant.jpg'),
          //                       fit: BoxFit.fitWidth
          //                   ),
          //                   borderRadius : BorderRadius.all(Radius.elliptical(98, 98)),
          //                 )
          //             ),
          //             Padding(
          //               padding: const EdgeInsets.only(top: 5),
          //               child: Text('Aneesh Anchan',
          //                   textAlign: TextAlign.left,
          //                   style:
          //                   GoogleFonts.inter(
          //                       color: Colors.black,
          //                       fontSize: 15,
          //                       letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
          //                       fontWeight: FontWeight.bold,
          //                       height: 1
          //                   )
          //                 //   TextStyle(
          //                 //     color: Color.fromRGBO(0, 0, 0, 1),
          //                 //     fontFamily: 'Inter',
          //                 //     fontSize: 15,
          //                 //     letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
          //                 //     fontWeight: FontWeight.bold,
          //                 //     height: 1
          //                 // ),
          //               ),
          //             ),
          //             Padding(
          //               padding: const EdgeInsets.all(5.0),
          //               child: Text('#125 pts',
          //                 textAlign: TextAlign.left,
          //                 style: TextStyle(
          //                     color: Color.fromRGBO(255, 255, 255, 1),
          //                     fontFamily: 'Inter',
          //                     fontSize: 12,
          //                     letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
          //                     fontWeight: FontWeight.normal,
          //                     height: 1
          //                 ),
          //               ),
          //             )
          //           ],
          //         )
          //     ),
          //     Positioned(
          //         left:width*0.50 ,
          //         top: 25,
          //         child:
          //         Container(
          //             width: 41,
          //             height: 40,
          //             decoration: BoxDecoration(
          //               image : DecorationImage(
          //                   image: AssetImage('assets/images/crown.png'),
          //                   fit: BoxFit.fitWidth
          //               ),
          //               borderRadius : BorderRadius.all(Radius.elliptical(98, 98)),
          //             )
          //         )
          //     ),
          //     Positioned(
          //         left:width*0.06 ,
          //         top: 80,
          //         child:
          //         Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             Padding(
          //               padding: const EdgeInsets.only(bottom: 5),
          //               child: Text('2',
          //                 textAlign: TextAlign.center,
          //                 style: TextStyle(
          //                   color: Color.fromRGBO(255, 255, 255, 1),
          //                   // fontFamily: 'Inter',
          //                   fontSize: 16,
          //                   letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
          //                   fontWeight: FontWeight.bold,
          //                   // height: 1
          //                 ),
          //               ),
          //             ),
          //             Container(
          //                 width: 78,
          //                 height: 78,
          //                 decoration: BoxDecoration(
          //                   boxShadow : [
          //                     BoxShadow(
          //                         color: Color.fromRGBO(176, 109, 228, 1),
          //                         offset: Offset(0,0),
          //                         blurRadius: 23
          //                     )],
          //                   color : Color.fromRGBO(217, 217, 217, 1),
          //                   border : Border.all(
          //                     color: Color.fromRGBO(165, 107, 227, 1),
          //                     width: 4,
          //                   ),
          //                   image : DecorationImage(
          //                       image: AssetImage('assets/images/contestant.jpg'),
          //                       fit: BoxFit.fitWidth
          //                   ),
          //                   borderRadius : BorderRadius.all(Radius.elliptical(98, 98)),
          //                 )
          //             ),
          //             Padding(
          //               padding: const EdgeInsets.only(top: 5),
          //               child: Text('Akshay Kanade',
          //                   textAlign: TextAlign.left,
          //                   style:
          //                   GoogleFonts.inter(
          //                       color: Color.fromRGBO(0, 0, 0, 1),
          //                       fontSize: 15,
          //                       letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
          //                       fontWeight: FontWeight.bold,
          //                       height: 1
          //                   )
          //                 // TextStyle(
          //                 //     color: Color.fromRGBO(0, 0, 0, 1),
          //                 //     fontFamily: 'Inter',
          //                 //     fontSize: 15,
          //                 //     letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
          //                 //     fontWeight: FontWeight.bold,
          //                 //     height: 1
          //                 // ),
          //               ),
          //             ),
          //             Padding(
          //               padding: const EdgeInsets.all(5.0),
          //               child: Text('#125 pts', textAlign: TextAlign.left, style: TextStyle(
          //                   color: Color.fromRGBO(255, 255, 255, 1),
          //                   fontFamily: 'Inter',
          //                   fontSize: 12,
          //                   letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
          //                   fontWeight: FontWeight.normal,
          //                   height: 1
          //               ),),
          //             )
          //           ],
          //         )
          //     ),
          //     Positioned(
          //         left:width*0.60 ,
          //         top: 80,
          //         child:
          //         Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             Padding(
          //               padding: const EdgeInsets.only(bottom: 5),
          //               child: Text('3',
          //                   textAlign: TextAlign.center,
          //                   style:
          //                   GoogleFonts.inter(
          //                       color: Colors.white,
          //                       fontSize: 15,
          //                       letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
          //                       fontWeight: FontWeight.bold,
          //                       height: 1
          //                   )
          //                 // TextStyle(
          //                 //   color: Color.fromRGBO(255, 255, 255, 1),
          //                 //   // fontFamily: 'Inter',
          //                 //   fontSize: 16,
          //                 //   letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
          //                 //   fontWeight: FontWeight.bold,
          //                 //   // height: 1
          //                 // ),
          //               ),
          //             ),
          //             Container(
          //                 width: 78,
          //                 height: 78,
          //                 decoration: BoxDecoration(
          //                   boxShadow : [
          //                     BoxShadow(
          //                         color: Color.fromRGBO(176, 109, 228, 1),
          //                         offset: Offset(0,0),
          //                         blurRadius: 23
          //                     )],
          //                   color : Color.fromRGBO(217, 217, 217, 1),
          //                   border : Border.all(
          //                     color: Color.fromRGBO(165, 107, 227, 1),
          //                     width: 4,
          //                   ),
          //                   image : DecorationImage(
          //                       image: AssetImage('assets/images/contestant.jpg'),
          //                       fit: BoxFit.fitWidth
          //                   ),
          //                   borderRadius : BorderRadius.all(Radius.elliptical(98, 98)),
          //                 )
          //             ),
          //             Padding(
          //               padding: const EdgeInsets.only(top: 5),
          //               child: Text('Alisa Jain',
          //                 textAlign: TextAlign.left,
          //                 style: GoogleFonts.inter(
          //                     color: Color.fromRGBO(0, 0, 0, 1),
          //                     fontSize: 15,
          //                     letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
          //                     fontWeight: FontWeight.bold,
          //                     height: 1
          //                 )
          //                 //   TextStyle(
          //                 //       fontFamily: 'Inter',
          //                 //     color: Color.fromRGBO(0, 0, 0, 1),
          //                 //     fontSize: 15,
          //                 //     letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
          //                 //     fontWeight: FontWeight.bold,
          //                 //     height: 1
          //                 // )
          //                 ,),
          //             ),
          //             Padding(
          //               padding: const EdgeInsets.all(5.0),
          //               child: Text('#125 pts', textAlign: TextAlign.left, style: TextStyle(
          //                   color: Color.fromRGBO(255, 255, 255, 1),
          //                   fontFamily: 'Inter',
          //                   fontSize: 12,
          //                   letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
          //                   fontWeight: FontWeight.normal,
          //                   height: 1
          //               ),),
          //             )
          //           ],
          //         )
          //     ),
          //     Positioned(
          //         left:width*0.35 ,
          //         bottom:15,
          //         child:
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             Text('Leaderboard', textAlign: TextAlign.left,
          //               style:
          //               GoogleFonts.inter(
          //                 fontStyle: FontStyle.normal,
          //                 fontSize: 16 , fontWeight: FontWeight.bold,
          //                 color: Color.fromRGBO(173, 105, 227, 1.0),),
          //               //     TextStyle(
          //               //     // color: Color.fromRGBO(123, 36, 191, 1),
          //               //     // fontFamily:
          //               //     // fontSize: 16,
          //               //     // letterSpacing: 0 /*percentages not used in flutter. defaulting to zero*/,
          //               //     // fontWeight: FontWeight.normal,
          //               //     // height: 1
          //               // ),
          //             ),
          //
          //           ],
          //         )
          //     ),
          //
          //   ],
          //
          // ),
        ),
      );
  }
}
