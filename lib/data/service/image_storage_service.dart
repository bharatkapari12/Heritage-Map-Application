import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class IamgeStorage{
  FirebaseFirestore storage = FirebaseFirestore.instance;

    Future storeImage({
    required File photo,
    required String name,
   

  }) async {
    try {
      UploadTask? uploadTask;
      var ref = FirebaseStorage.instance.ref().child('sites').child(name);
      ref.putFile(photo);

      uploadTask = ref.putFile(photo);

      final snap = await uploadTask.whenComplete(() {});
      final urls = await snap.ref.getDownloadURL();
      var user = storage.collection('sites').doc(name);
      await user.update({'photo': urls,});
    } catch (e) {
      throw Exception(e.toString());
    }
  }
    Future storeIcon({
    required File photo,
    required String name,
   

  }) async {
    try {
      UploadTask? uploadTask;
      var ref = FirebaseStorage.instance.ref().child('sites').child(name);
      ref.putFile(photo);

      uploadTask = ref.putFile(photo);

      final snap = await uploadTask.whenComplete(() {});
      final urls = await snap.ref.getDownloadURL();
      var user = storage.collection('sites').doc(name);
      await user.update({'logo': urls,});
    } catch (e) {
      throw Exception(e.toString());
    }
  }

 Future<void> addPhotos({
    required List<File> photos,
    required String name,
  }) async {
    try {
      List<String> imageUrls = [];

      for (int i = 0; i < photos.length; i++) {
        // print('Uploading file ${i + 1}...');
        // print("cloud =>" + photos.length.toString());

        UploadTask? uploadTask;
        var ref = FirebaseStorage.instance.ref().child('sites').child('${name}_$i');
        uploadTask = ref.putFile(photos[i]);
        await uploadTask.whenComplete(() {});
        final url = await ref.getDownloadURL();
        imageUrls.add(url);
        // print('File ${i + 1} uploaded successfully.');
      }

      var user = storage.collection('sites').doc(name);

      await user.update({'images': FieldValue.arrayUnion(imageUrls)});
    } catch (e) {
      throw Exception(e.toString());
    }
  }

}