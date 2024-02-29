

import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:heritage_map/data/model/user_model.dart';

class UserRecordService {
  FirebaseFirestore storage = FirebaseFirestore.instance;
  Future userinfo({required UserModel model}) async {
    var user = storage.collection('user').doc(model.email);
    await user.set({
      'fname': model.fname,
      'lname': model.lname,
      'email': model.email,
      'address': model.address,
      'city': model.city,
      'explore': model.explore,
      "needInfo": model.needInfo,
      'image': 'null',
    });
  }

  Future updateuserinfo({required UserModel model, required String email}) async {
    var user = storage.collection('user').doc(email);
    await user.set({
      'fname': model.fname,
      'lname': model.lname,
      'address': model.address,
      'email': model.email,
      'explore': model.explore,
      "needInfo": model.needInfo,
      'city': model.city,
      'image': model.image,
    });
  }

  // Future<void> sendMessage({required String reciverId, required String message, required String snap}) async {
  //   List<String> ids = [snap, reciverId];

  //   ids.sort();
  //   String roomId = ids.join();
  //   final Timestamp timestamp = Timestamp.now();
  //   MessageModel model = MessageModel(senderID: snap, reciverId: reciverId, message: message, timestamp: timestamp);
  //   await storage.collection('chat_form').doc(roomId).set({
  //     'id': reciverId,
  //     'timestamp': timestamp,
  //   });
  //   await storage.collection('chat_form').doc(roomId).collection("messages").add(
  //         model.toMap(),
  //       );
  // }
}
