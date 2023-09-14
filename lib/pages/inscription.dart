import 'package:ecurie/component/appbar.dart';
import 'package:flutter/material.dart';

class Screen2 extends StatelessWidget {
  const Screen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildApp(context, 'Inscription'),
      body: Center(
        child: Form(
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(hintText: 'Prénom'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez écrire un prénom';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: 'Nom'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez écrire un nom';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: 'Téléphone'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez écrire un numéro de téléphone';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez écrire un mail';
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
                      Navigator.of(context).pop();
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