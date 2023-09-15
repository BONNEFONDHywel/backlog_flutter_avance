import 'package:ecurie/modeles/session.dart';
import 'package:ecurie/pages/concours.dart';
import 'package:ecurie/pages/cours.dart';
import 'package:ecurie/pages/flux_dactivite.dart';
import 'package:ecurie/pages/inscription.dart';
import 'package:ecurie/pages/profile.dart';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';


import '../pages/login.dart';

var homePageHandler = Handler(
    handlerFunc: ((BuildContext? context, Map<String, dynamic> params) {
      return const MyApp();
    }));

var inscriptionHandler = Handler(
    handlerFunc: ((BuildContext? context, Map<String, dynamic> params) {
      return Inscription();
    }));
var profilHandler = Handler(
    handlerFunc: ((BuildContext? context, Map<String, dynamic> params) {
      return ProfilePage();
    }));
var coursHandler = Handler(
    handlerFunc: ((BuildContext? context, Map<String, dynamic> params) {
      print(Session().getSession("name"));
if(Session().getSession("name") != null){
  return Cours();
}
      return MyApp();
    }));
var connexionHandler = Handler(
    handlerFunc: ((BuildContext? context, Map<String, dynamic> params) {
      return MyStatefulWidget();
    }));
var concoursHandler = Handler(
    handlerFunc: ((BuildContext? context, Map<String, dynamic> params) {
      if(Session().getSession("name") != null){
        return Concours();

      }return MyApp();
    }));