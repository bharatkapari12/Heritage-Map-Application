import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heritage_map/data/model/place_model.dart';

class SiteRepo {
  FirebaseFirestore storage = FirebaseFirestore.instance;
  Future addSite({required PlaceModel model}) async {
    var user = storage.collection('sites').doc(model.name);
    await user.set({
      'name': model.name,
      'lat': model.lat,
      'lon': model.lon,
      'info': model.info,
      'about': model.about,
      'location': model.location,
      'rating': model.rating,
      "category": model.category,
      'explorePeople': [],
      'images': [],
      'review': [],
      'photo': '',
      'logo': ''
    });
  }

  Future updateSite({required PlaceModel model}) async {
    var user = storage.collection('sites').doc(model.name);
    await user.update({
      'name': model.name,
      'lat': model.lat,
      'lon': model.lon,
      'info': model.info,
      'about': model.about,
      'location': model.location,
      'rating': model.rating,
      "category": model.category,
      'explorePeople': model.explorePeople,
      'images': model.images,
      'review': model.review,
      'photo': model.photo,
      'logo': model.logo,
    });
  }

  Future<void> addExplore(String id, String email) async {
    var user = storage.collection('sites').doc(id);
    user.update({
      "explorePeople": FieldValue.arrayUnion([email])
    });
  }

  Future<void> deleteImage(String id, String image) async {
    var user = storage.collection('sites').doc(id);
    user.update({
      "images": FieldValue.arrayRemove([image])
    });
  }

  Future<void> deleteSite(String id) async {
    await storage.collection('sites').doc(id).delete();
  }
}
