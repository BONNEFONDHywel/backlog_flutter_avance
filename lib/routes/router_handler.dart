import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'package:ecurie/pages/connexion.dart';
import 'package:ecurie/pages/inscription.dart';

var screen1 = Handler(
    handlerFunc: ((BuildContext? context, Map<String, dynamic> params) {
      return const Screen1();
    }));

var screen2 = Handler(
    handlerFunc: ((BuildContext? context, Map<String, dynamic> params) {
      return Screen2();
    }));