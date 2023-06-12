
class UserInfo {
  final String uid;
  final String email;
  final String fname;
  final String sname;
  final int coins;

  UserInfo(
      this.uid,
      this.email,
      this.fname,
      this.sname,
      this.coins,
      );
}


// class Contest {
//   final String contestId;
//   final int contestTime;
//   final int contestEndTime;
//   final String description;
//   final String displayName;
//   final String imageUrl;
//   // final Map<String,Question> question;
//
//   Contest({
//     required this.contestId,
//     required this.contestTime,
//     required this.contestEndTime,
//     required this.description,
//     required this.displayName,
//     required this.imageUrl,
//     // required this.question,
//   });
//
//   factory Contest.fromRTDB(String contestId, Map<String, dynamic> data) {
//     return Contest(
//       contestId: contestId,
//       contestTime : data['contestTime'],
//       contestEndTime: data['contestEndTime'],
//       description: data['description'],
//       displayName: data['displayName'],
//       imageUrl: data['imageUrl'],
//       // question: data['question'] as Map<String,Question>,
//     );
//   }
//
//   String fancyOrders (){
//     return 'Today\'s Contest is : $description from $contestTime';
//   }
// }

class Question {
  final String audioUrl;
  final int correctOption;
  final String imageUrl;
  final String option1;
  final String option2;
  final String option3;
  final String option4;
  final String question;

  Question({
    required this.audioUrl,
    required this.correctOption,
    required this.imageUrl,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.option4,
    required this.question,
  });


  factory Question.fromRTDB(String questionId, Map<String, dynamic> questionData) {
    return Question(
      audioUrl : questionData['audioUrl'],
      correctOption: questionData['correctOption'],
      imageUrl: questionData['imageUrl'],
      option1: questionData['option1'],
      option2: questionData['option2'],
      option3: questionData['option3'],
      option4: questionData['option4'],
      question: questionData['question'],
    );
  }
}



class Order {
  final String orderId;
  final String customer;
  final String description;
  final double price;
  final int time;

  Order({
    required this.orderId,
    required this.customer,
    required this.description,
    required this.price,
    required this.time,
  });

  factory Order.fromRTDB(String orderId, Map<String, dynamic> data) {
    return Order(
      orderId: orderId,
      customer: data['customer'],
      description: data['description'],
      price: data['price'],
      time: data['time'],
    );
  }

  String fancyOrders (){
    return 'Today\'s Orders are : $description from $customer';
  }
}



// class newOrder {
//   late final String customer;
//   late final String description;
//   late final double price;
//   late final int time;
//
//   newOrder({
//     required this.customer,
//     required this.description,
//     required this.price,
//     required this.time,
//   });
//
//   factory newOrder.fromRTDB(String orderId, Map<String, dynamic> data) {
//     return newOrder(
//       customer: data['customer']??'Drink',
//       description: data['description']?? 0.0,
//       price: data['price']??'Unknown',
//       time: data['time'],
//     );
//   }
//
//   String fancyOrders (){
//     return 'Today\'s Orders are : $description from $customer';
//   }
// }


