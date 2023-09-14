import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecurie/routes/routes.dart';

buildApp(BuildContext context, name) {
print(Navigator.defaultRouteName );
  Map<String, dynamic> tabRoutesA = {
    "Accueil": '/',
    'Cours': '/cours',
    'Inscription': '/inscription'
  };
  List<TextButton> button = [];
  tabRoutesA.forEach((key, value) {
    //if(key != name){
    button.add(TextButton(
        onPressed: () => {
              if (ModalRoute.of(context)?.settings.name != value)
                {
                  if(value == '/'){
                    Navigator.pushNamed(context, '/')
                  }else{
                    Routes.router.navigateTo(context, value)

                  }
                }
            },
        child: Text(key)));
    //}
  });

  return AppBar(
      actions: button,
      backgroundColor: const Color.fromARGB(255, 226, 40, 105),
      title: Text(name,
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))));
}
