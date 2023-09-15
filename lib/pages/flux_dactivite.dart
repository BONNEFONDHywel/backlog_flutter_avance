import 'dart:convert';
import 'dart:typed_data';

import 'package:ecurie/component/appbar.dart';
import 'package:ecurie/db/db.dart';
import 'package:ecurie/routes/routes.dart';
import 'package:ecurie/component/drawerApp.dart';

import 'package:flutter/material.dart';

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
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: Routes.router.generator,
       home: Scaffold(appBar:buildApp(context,'Accueil'),drawer: buildDrawer(context),
         body:ListView(
           children: [
             const SectionTitle('Les Cavaliers qui viennent de nous rejoindre :'),
             listeCavaliers(),
             const SectionTitle('Les Cours :'),
             listeCours(),
             const SectionTitle('Les Concours :'),
             listeConcours(),
             const SectionTitle('Les Soirées :'),
             listeSoirees(),
           ],
         ),

       ),
    );
  }
  Widget listeCavaliers() {
    return FutureBuilder(
      future: DbMongo.fetchAllItems('Inscription'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Erreur lors du chargement des données : ${snapshot.error}');
        } else {
          final items = snapshot.data as List;
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length > 4 ? 4 : items.length,
            itemBuilder: (context, index) {
              return ListTile(title: Text(items[index]['name']));
            }
          );
        }
      },
    );
  }

  Widget listeCours() {
    return FutureBuilder(
      future: DbMongo.fetchAllItems('Cours'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Erreur lors du chargement des données : ${snapshot.error}');
        } else {
          final items = snapshot.data as List;
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length > 4 ? 4 : items.length,
            itemBuilder: (context, index) {
              return ListTile(title: Text('Cours de ' + items[index]['terrain']));
            },
          );
        }
      },
    );
  }

  Widget listeConcours() {
    return FutureBuilder(
      future: DbMongo.fetchAllItems('Concours'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Erreur lors du chargement des données : ${snapshot.error}');
        } else {
          final items = snapshot.data as List;
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length > 4 ? 4 : items.length,
            itemBuilder: (context, index) {
              return ListTile(title: Text(items[index]['name']));
            },
          );
        }
      },
    );
  }

  Widget listeSoirees() {
    return FutureBuilder(
      future: DbMongo.fetchAllItems('Soirees'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Erreur lors du chargement des données : ${snapshot.error}');
        } else {
          final items = snapshot.data as List;
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length > 4 ? 4 : items.length,
            itemBuilder: (context, index) {
              return ListTile(title: Text(items[index]['title']));
            },
          );
        }
      },
    );
  }
}



class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}