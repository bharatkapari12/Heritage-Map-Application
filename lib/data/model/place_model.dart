// ignore_for_file: public_member_api_docs, sort_constructors_first
class PlaceModel {
  String? id;
  String? name;
  String? email;
  String? location;
  String? rating;
  String? photo;
  String? category;
  String? about;
  String? info;
  String? logo;
  double? lat;
  double? lon;
  bool? isfav;
  List<dynamic>? explorePeople;
  List<dynamic>? images;
  List<dynamic>? review;
  PlaceModel({
    this.name,
    this.id,
    this.location,
    this.email,
    this.rating,
    this.about,
    this.logo,
    this.info,
    this.lat,
    this.lon,
    this.isfav,
    this.category,
    this.photo,
    this.explorePeople,
    this.review,
    this.images,
  });
}
