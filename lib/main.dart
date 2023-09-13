import 'package:flutter/material.dart';
import 'db/db.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'pages/cours.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:ecurie/pages/flux_dactivite.dart';

void main() async  {
  await dotenv.load(fileName: "assets/.env");
  DbMongo.connectToDb();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Ecurie',
      home: MyApp(),
    );
  }
}
