import 'package:flutter/cupertino.dart';

class Inscription {
  final String name;
  final String password;
  final String email;
  final AssetImage picture;

  Inscription(
      {required this.name, required this.password, required this.email, required this.picture});
}