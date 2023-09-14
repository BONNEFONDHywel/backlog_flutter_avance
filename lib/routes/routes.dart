import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'package:ecurie/routes/router_handler.dart';


class Routes {
  static FluroRouter router = FluroRouter();

  static void initRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
          print("La route n'est pas trouvée");
          return;
        });

    router.define('/', handler: screen1, transitionType: TransitionType.inFromBottom);
    router.define('page2', handler: screen2, transitionType: TransitionType.inFromLeft);

  }
}