import 'package:flutter/material.dart';
import 'package:realtime_demo/services/auth.dart';

import '../screens/home_page.dart';
import '../screens/signIn_screen.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context,snapshot){
          if(snapshot.hasData){
            return HomePage();
          }
          else {
            return LoginPage();
          }
        }
    );
  }
}
