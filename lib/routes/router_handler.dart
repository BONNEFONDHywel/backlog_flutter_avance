import 'package:ecurie/modeles/session.dart';
import 'package:ecurie/pages/concours.dart';
import 'package:ecurie/pages/cours.dart';
import 'package:ecurie/pages/flux_dactivite.dart';
import 'package:ecurie/pages/inscription.dart';
import 'package:ecurie/pages/soiree.dart';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import '../pages/login.dart';

var homePageHandler =
    Handler(handlerFunc: ((BuildContext? context, Map<String, dynamic> params) {
  return const MyApp();
}));

var inscriptionHandler =
    Handler(handlerFunc: ((BuildContext? context, Map<String, dynamic> params) {
  return Inscription();
}));

var coursHandler =
    Handler(handlerFunc: ((BuildContext? context, Map<String, dynamic> params) {
    return Cours();

}));
var connexionHandler =
    Handler(handlerFunc: ((BuildContext? context, Map<String, dynamic> params) {
  return MyStatefulWidget();
}));
var concoursHandler =
    Handler(handlerFunc: ((BuildContext? context, Map<String, dynamic> params) {
    return Concours();

}));
var soireeHandler =
Handler(handlerFunc: ((BuildContext? context, Map<String, dynamic> params) {
  return Soiree();

}));