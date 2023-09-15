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
    //router.define('/', handler: homePageHandler, transitionType: TransitionType.inFromLeft);
    router.define('/inscription', handler: inscriptionHandler, transitionType: TransitionType.inFromRight);
    router.define('/cours', handler: coursHandler, transitionType: TransitionType.inFromRight);
    router.define('/concours', handler: concoursHandler, transitionType: TransitionType.inFromRight);

  }
}