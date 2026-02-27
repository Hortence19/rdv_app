import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  final String? id;
  final String fname, lname;
  final String email, password;

  MyUser({
    this.id,
    required this.fname,
    required this.lname,
    required this.email,
    required this.password,
  });

  // factory MyUser.fromJson(Map<String, dynamic> json) {
  //   return MyUser(
  //       id: json['id'],
  //       fname: json['firstname'],
  //       lname: json['lastname'],
  //       email: json['email'],
  //       password: json['password']);
  // }

  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      'firstname': fname,
      'lastname': lname,
      'email': email,
      'password': password,
    };
  }

  static MyUser fromSnapshot(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;

    return MyUser(
      id: snapshot.id,
      fname: snap['firstname'],
      lname: snap['lastname'],
      email: snap['email'],
      password: snap['password'],
    );
  }
}

List<MyUser> mUsers = [
] ;
