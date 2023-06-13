//
// import 'dart:async';
//
// import 'package:firebase_database/firebase_database.dart';
//
// import 'package:firebase_database/firebase_database.dart';
//
// class MyClass {
//
//   late final _database = FirebaseDatabase.instance.ref();
//   StreamSubscription<Event>? _subscription;
//   bool _isValueChanged = false;
//
//   void startListening() {
//     _database = FirebaseDatabase.instance.reference().child('your_database_path');
//     _subscription = _database.onChildAdded.listen((event) {
//       // Handle the new child added event here
//       // You can update the state or trigger any necessary actions
//       _isValueChanged = true;
//       // Perform additional logic based on the new value
//       var newValue = event.snapshot.value;
//       // ...
//     });
//   }
//
//   void stopListening() {
//     _subscription?.cancel();
//   }
// }
//
// class Contest{
//
//   final _database = FirebaseDatabase.instance.ref();
//   final _database= _database.child('contestInfo').onValue.listen();
//
//   Contest? get currentContest => _firebaseContest.currentContest;
//
//   Stream<Contest?> get ContestStateChanges => _firebaseContest.ContestStateChanges();
//
// }