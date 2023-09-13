import 'package:flutter/material.dart';

import 'package:ecurie/routes/routes.dart';

/*
* Mettre à la place de cette, la page de flux d'activité
* */

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    Routes.initRoutes(Routes.router);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: Routes.router.generator,
      // home: Screen1(),
    );
  }
}