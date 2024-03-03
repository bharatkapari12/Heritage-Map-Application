import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

final placeDataProvider = StreamProvider<QuerySnapshot>((ref) {
  return FirebaseFirestore.instance.collection('sites').snapshots();
});

final siteIndividualDataProvider = StreamProvider.family<Map<String, dynamic>, String>((ref, documentId) {
  if (documentId.isEmpty) {
    return Stream.value({});
  }
  CollectionReference collectionReference = FirebaseFirestore.instance.collection('sites');
  DocumentReference documentReference = collectionReference.doc(documentId);

  return documentReference.snapshots().map((documentSnapshot) {
    if (documentSnapshot.exists) {
      return documentSnapshot.data() as Map<String, dynamic>;
    } else {
      return {};
    }
  });
});

// You can define a Riverpod provider to manage the Polyline state
// final polylineValueProvider = StateProvider<Polyline?>((ref) {
//   return null;
// });
final tapLatLonValueProvider = StateProvider<LatLng>((ref) {
  return const LatLng(0.0, 0.0);
});
final currentLatLonValueProvider = StateProvider<LatLng>((ref) {
  return const LatLng(0.0, 0.0);
});

final selectedlatProvider = StateProvider<double>((ref) {
  return 0.0;
});
final selectedlonProvider = StateProvider<double>((ref) {
  return 0.0;
});
