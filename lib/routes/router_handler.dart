import 'package:ecurie/pages/cours.dart';
import 'package:ecurie/pages/flux_dactivite.dart';
import 'package:ecurie/pages/inscription.dart';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';


var homePageHandler = Handler(
    handlerFunc: ((BuildContext? context, Map<String, dynamic> params) {
      return const MyApp();
    }));

var inscriptionHandler = Handler(
    handlerFunc: ((BuildContext? context, Map<String, dynamic> params) {
      return Inscription();
    }));

var coursHandler = Handler(
    handlerFunc: ((BuildContext? context, Map<String, dynamic> params) {
      return Cours();
    }));