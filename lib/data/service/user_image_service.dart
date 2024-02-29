import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageStorageService {
  FirebaseFirestore storage = FirebaseFirestore.instance;
  Future profilesetup({
    required File photo,
    required String name,
    required String email,
  }) async {
    try {
      UploadTask? uploadTask;
      var ref = FirebaseStorage.instance.ref().child('user_photo').child(name);
      ref.putFile(photo);
      uploadTask = ref.putFile(photo);
      final snap = await uploadTask.whenComplete(() {});
      final urls = await snap.ref.getDownloadURL();
      var user = storage.collection('user').doc(email);
      await user.update({'image': urls});
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
