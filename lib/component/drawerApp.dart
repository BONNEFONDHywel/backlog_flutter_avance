import 'package:ecurie/routes/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

buildDrawer(BuildContext context) {
  int _selectedIndex = 0;
  int count = 0;
  Map<String, dynamic> tabRoutesA = {
    "Accueil": '/',
    'Cours': '/cours',
    'Inscription': '/inscription',
    'Connexion': '/connexion',
    'Soirée': '/soiree',
    'Concours': '/concours'
  };
  void _onItemTapped(int index) {
    _selectedIndex = index;
  }

  List button = [];
  tabRoutesA.forEach((key, value) {
    button.add(
      ListTile(
        title: Text(key),
        selected: _selectedIndex == count,
        onTap: () {
          _onItemTapped(count);
          Navigator.pop(context);
          if (ModalRoute.of(context)?.settings.name != value)
          {
            if(value == '/'){
              Navigator.pushNamed(context, '/');
            }else{
              Routes.router.navigateTo(context, value);
            }
          }
        },
      ),
    );
    count += 1;
    //}
  });

  return Drawer(
      child: ListView(
    padding: EdgeInsets.zero,
    children:
   [
       const DrawerHeader(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 226, 40, 105),
        ),
        child: Text('My Little Pony'),
      ), ...button

    ],
  ));
}
