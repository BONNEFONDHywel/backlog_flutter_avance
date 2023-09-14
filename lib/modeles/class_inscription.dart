import 'package:flutter/cupertino.dart';

class Inscription {
  final String name;
  final String password;
  final String email;
  final String picture;
  String? phone;
  int? age;
  String? ffe;

  Inscription(
    {required this.name, required this.password, required this.email, required this.picture, this.phone, this.age, this.ffe});
}