import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final userIndividualDataProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, documentId) async {
//   if (documentId.isEmpty) {
//     return {};
//   }
//   CollectionReference collectionReference = FirebaseFirestore.instance.collection('user');
//   DocumentReference documentReference = collectionReference.doc(documentId);

//   try {
//     DocumentSnapshot documentSnapshot = await documentReference.get();

//     if (documentSnapshot.exists) {
//       return documentSnapshot.data() as Map<String, dynamic>;
//     } else {
//       throw ('Document does not exist');
//     }
//   } catch (e) {
//     throw ('Error retrieving document: $e');
//   }
// });
final userIndividualDataProvider = StreamProvider.family<Map<String, dynamic>, String>((ref, documentId) {
  if (documentId.isEmpty) {
    return Stream.value({});
  }

  final DocumentReference documentReference = FirebaseFirestore.instance.collection('user').doc(documentId);

  return documentReference.snapshots().map((documentSnapshot) {
    if (documentSnapshot.exists) {
      return documentSnapshot.data() as Map<String, dynamic>;
    } else {
      return {};
    }
  });
});

final messageDocumentsProvider = FutureProvider.autoDispose.family<List<DocumentSnapshot>, String>((ref, id) async {
  CollectionReference mainCollection = FirebaseFirestore.instance.collection('messages').doc(id).collection('chats');
  QuerySnapshot mainCollectionSnapshot = await mainCollection.get();
  return mainCollectionSnapshot.docs;
});

final allmessageProvider = StreamProvider<QuerySnapshot>((ref) {
  return FirebaseFirestore.instance.collection('messages').snapshots();
});
