import 'package:ecurie/pages/concours.dart';
import 'package:ecurie/pages/cours.dart';
import 'package:ecurie/pages/flux_dactivite.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:ecurie/pages/inscription.dart';

import '../pages/connexion.dart';

var homePageHandler = Handler(
    handlerFunc: ((BuildContext? context, Map<String, dynamic> params) {
      return const MyApp();
    }));

var inscriptionHandler = Handler(
    handlerFunc: ((BuildContext? context, Map<String, dynamic> params) {
      return Screen2();
    }));

var coursHandler = Handler(
    handlerFunc: ((BuildContext? context, Map<String, dynamic> params) {
      return Cours();
    }));
var connexionHandler = Handler(
    handlerFunc: ((BuildContext? context, Map<String, dynamic> params) {
      return Screen1();
    }));
var concoursHandler = Handler(
    handlerFunc: ((BuildContext? context, Map<String, dynamic> params) {
      return Concours();
    }));