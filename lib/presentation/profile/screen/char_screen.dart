import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heritage_map/core/const/app_color.dart';
import 'package:heritage_map/data/%20local%20storage/local_save_data.dart';
import 'package:heritage_map/data/%20local%20storage/local_storge.dart';
import 'package:heritage_map/widget/message_bubble.dart';
import 'package:heritage_map/widget/text_widget.dart';

// class ChatScreen extends StatelessWidget {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final TextEditingController _messageController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             child: FutureBuilder(
//                 future: LocalStorage().gettoken(value: LocalSaveData.email),
//                 builder: (context, snap) {
//                   return StreamBuilder<QuerySnapshot>(
//                       stream: _firestore
//                           .collection('messages')
//                           .doc(snap.data.toString())
//                           .collection('chats')
//                           .orderBy('timestamp', descending: false)
//                           .snapshots(),
//                       // stream: _firestore.collection('messages').doc(snap.data.toString()).collection('chats').snapshots(),
//                       builder: (context, snapshot) {
//                         if (!snapshot.hasData) {
//                           return const Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         }

//                         final messages = snapshot.data?.docs.reversed ?? [];
//                         List<Widget> messageWidgets = [];
//                         for (var message in messages) {
//                           final messageText = message['text'];
//                           final messageSender = message['sender'];
//                           bool isSender = snap.data == messageSender;

//                           // Only add messages where snap.data == message['sender']
//                           if (snap.data == messageSender) {
//                             final messageWidget = MessageBubble(
//                               sender: messageSender,
//                               text: messageText,
//                               isSender: isSender,
//                             );

//                             messageWidgets.add(messageWidget);
//                           }
//                         }

//                         return ListView(
//                           reverse: true,
//                           padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
//                           children: messageWidgets,
//                         );
//                       });
//                 }),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: const InputDecoration(
//                       hintText: 'Enter your message...',
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: () {
//                     final messageText = _messageController.text.trim();
//                     final currentUser = FirebaseAuth.instance.currentUser;
//                     if (currentUser != null) {
//                       _firestore.collection('messages').doc(currentUser.email).set(
//                         {"id": currentUser.email},
//                       );
//                       _firestore.collection('messages').doc(currentUser.email).collection('chats').add({
//                         'text': messageText,
//                         'sender': currentUser.email,
//                         "receiver": LocalSaveData.adminEmail,
//                         'timestamp': FieldValue.serverTimestamp(),
//                       });
//                       // _firestore.collection('messages').add({
//                       //   'text': messageText,
//                       //   'sender': currentUser.email,
//                       //   "receiver": LocalSaveData.adminEmail,
//                       //   'timestamp': FieldValue.serverTimestamp(),
//                       // });
//                       _messageController.clear();
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class AdminChat extends StatelessWidget {
  final String sendId;
  final bool isAdmin;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();

  AdminChat({super.key, required this.sendId, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Ctext(
          text: "Forum",
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder(
                future: LocalStorage().gettoken(value: LocalSaveData.email),
                builder: (context, snap) {
                  return StreamBuilder<QuerySnapshot>(
                      stream: _firestore.collection('messages').doc(sendId).collection('chats').orderBy('timestamp', descending: false).snapshots(),
                      // stream: _firestore.collection('messages').doc(snap.data.toString()).collection('chats').snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final messages = snapshot.data?.docs.reversed ?? [];
                        List<Widget> messageWidgets = [];
                        for (var message in messages) {
                          final messageText = message['text'];
                          final messageSender = message['sender'];
                          // final messageRecever = message['receiver'];
                          bool isSender = snap.data == messageSender;

                          // Only add messages where snap.data == message['sender']
                          // if (snap.data == messageSender) {
                          final messageWidget = MessageBubble(
                            sender: messageSender,
                            text: messageText,
                            isSender: isSender,
                          );

                          messageWidgets.add(messageWidget);
                          // }
                        }
                        return ListView(
                          reverse: true,
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                          children: messageWidgets,
                        );
                      });
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter your message...',
                      border: AppColor.outlineBorderStyle,
                      enabledBorder: AppColor.enableBorderStyle,
                      focusedBorder: AppColor.focusedBorderStyle,
                      errorBorder: AppColor.errorBorderStyle,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          final messageText = _messageController.text.trim();
                          final currentUser = FirebaseAuth.instance.currentUser;
                          if (currentUser != null) {
                            if (isAdmin) {
                              //admin
                              _firestore.collection('messages').doc(sendId).collection('chats').add({
                                'text': messageText,
                                'sender': LocalSaveData.adminEmail,
                                "receiver": sendId,
                                'timestamp': FieldValue.serverTimestamp(),
                              });
                            } else {
                              _firestore.collection('messages').doc(sendId).set({"id": sendId});

                              _firestore.collection('messages').doc(sendId).collection('chats').add({
                                'text': messageText,
                                'sender': sendId,
                                "receiver": LocalSaveData.adminEmail,
                                'timestamp': FieldValue.serverTimestamp(),
                              });
                            }
                            //user

                            // _firestore.collection('messages').add({
                            //   'text': messageText,
                            //   'sender': currentUser.email,
                            //   "receiver": LocalSaveData.adminEmail,
                            //   'timestamp': FieldValue.serverTimestamp(),
                            // });
                            _messageController.clear();
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
