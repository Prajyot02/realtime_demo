import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:realtime_demo/screens/home_page.dart';

import '../services/auth.dart';

class ResultScreen extends StatelessWidget {
  final int userPercentage;
  final int totalRight;
  final int wrongQ;
  final int ommitedQuestion;
  final int coins;

  ResultScreen(
      {super.key,
        required this.userPercentage,
        required this.totalRight,
        required this.wrongQ,
        required this.ommitedQuestion,
        required this.coins,
      }
      );


  final User? user=Auth().currentUser;

  void updateCoins(String uid, int newCoins) {
    DatabaseReference userRef = FirebaseDatabase.instance.ref().child('userInfo').child(uid);
    userRef.update({'coins': newCoins});
    print ('$newCoins coins have been added to $uid');
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

  @override
  Widget build(BuildContext context) {
    // addCoinsToUser(user!.uid,coins);
   incrementCoins(user!.uid,coins);
    // int newcoins = oldcoins + coins ;
    // print(oldcoins);
    // updateCoins(user!.uid, newcoins);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Your Result"),
      ),
      body: Column(children: [
        const SizedBox(
          height: 20,
        ),
        Column(
          children: [
            Text(
              userPercentage < 50
                  ? "Don't Give up "
                  "! Try Again !!"
                  : userPercentage >= 50 && userPercentage <= 99
                  ? "You have Passed"
                  : "Perfect Score ",
              style: TextStyle(
                  fontFamily: 'TanseekModernProArabic',
                  fontSize: 22,
                  letterSpacing: 1,
                  color: userPercentage < 50 ? Colors.red : Colors.blue,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularPercentIndicator(
                  radius: 80.0,
                  lineWidth: 20.0,
                  animation: true,
                  percent: userPercentage / 100,
                  center: Text(
                    '  $userPercentage% ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: userPercentage < 60
                          ? Colors.red
                          : const Color(0xFF437B85),
                    ),
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: userPercentage < 60
                      ? Colors.red
                      : const Color(0xFF437B85),
                  backgroundColor: const Color(0xFFE8914F),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Your Final Result is $userPercentage%',
              style: TextStyle(
                fontFamily: 'TanseekModernProArabic',
                fontSize: 22,
                color: userPercentage < 50 ? Colors.red : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Total Right Answers : $totalRight",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Total Wrong Answers : $wrongQ",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Total Unattempted Questions : $ommitedQuestion",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Coins earned : $coins',
              style: TextStyle(
                fontFamily: 'TanseekModernProArabic',
                fontSize: 22, fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                        (Route<dynamic> route) => false);
              },
              child: const Text("Start Quiz Again"),
            )
          ],
        )
      ]),
    );
  }
}
