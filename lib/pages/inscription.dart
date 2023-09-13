import 'package:flutter/material.dart';

import 'package:ecurie/modeles/class_inscription.dart';

class Screen2 extends StatelessWidget {
  const Screen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscription'),
      ),
      body: Center(
        child: Form(
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(hintText: 'Nom'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez renseigner un nom';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: 'Mot de passe'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez renseigner un mot de passe';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez renseigner un email';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: 'Photo de profil'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez renseigner une photo de profil';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  TextButton(
                    child: const Text('Valider'),
                    onPressed: () {
                      print('Inscription réussie');
                    },
                  ),
                  TextButton(
                    child: const Text('Annuler'),
                    onPressed: () {
                      print('pas réussi');
                      // Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}