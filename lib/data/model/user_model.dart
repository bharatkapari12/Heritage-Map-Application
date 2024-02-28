// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  String? fname;
  String? lname;
  String? email;
  String? address;
  String? image;
  String? city;
  bool? needInfo;
  List<dynamic>? explore;
  UserModel({
    this.fname,
    this.needInfo,
    this.lname,
    this.address,
    this.city,
    this.image,
    this.email,
    this.explore,
  });
}
