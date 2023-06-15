import 'package:flutter/material.dart';
import 'package:realtime_demo/screens/dashboard_screen.dart';
import 'package:realtime_demo/screens/contest/contest_carousel_unused.dart';
import 'package:realtime_demo/screens/quiz/quiz_section.dart';
import 'package:realtime_demo/screens/quiz/random_contest.dart';
import 'package:realtime_demo/screens/read_examples.dart';
import 'package:realtime_demo/screens/contest/contest_carousel.dart';
import 'package:realtime_demo/screens/test/test_random.dart';
import 'package:realtime_demo/screens/write_examples.dart';

import '../models/user_model.dart';
import '../services/auth.dart';
import 'test/statistics_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          // title: Text(widget.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Check out samples ! '),
              ElevatedButton(onPressed: (){
                Navigator.push(
                    context,MaterialPageRoute(
                  builder: (context)=> ReadExamples(),
                )
                );
              }, child: Text("Read Examples")),
              ElevatedButton(onPressed: (){
                Navigator.push(
                    context,MaterialPageRoute(
                  builder: (context)=> WriteExamples(),
                )
                );
              },
                  child: Text("Write Examples")),
              ElevatedButton(onPressed: (){
                Navigator.push(
                    context,MaterialPageRoute(
                  builder: (context)=> ContestCarouselWidget(),
                )
                );
              },
                  child: Text("Go to Contest Category screen")),
              ElevatedButton(onPressed: (){
                Navigator.push(
                    context,MaterialPageRoute(
                  builder: (context)=> DashBoardPage(),
                )
                );
              },
                  child: Text("Go to Quiz Category screen")),
              ElevatedButton(onPressed: (){
                Navigator.push(
                    context,MaterialPageRoute(
                  builder: (context)=> HomePage(),
                )
                );
              },
                  child: Text("Create Random Contest")),
              ElevatedButton(onPressed: (){
                Navigator.push(
                    context,MaterialPageRoute(
                  builder: (context)=> FirebaseDataScreen(),
                )
                );
              },
                  child: Text("Carousel Screen")),
              ElevatedButton(onPressed: (){
                Navigator.push(
                    context,MaterialPageRoute(
                  builder: (context)=> ContestCarouselWidget(),
                )
                );
              },
                  child: Text("Statistics Screen")),
              ElevatedButton(onPressed: (){
                Navigator.push(
                    context,MaterialPageRoute(
                  builder: (context)=> DashBoardPage(),
                )
                );
              },
                  child: Text("DashBoard Screen")),
            ],
          ),
        ),// This trailing comma makes auto-formatting nicer for build methods.
      );
  }
}
