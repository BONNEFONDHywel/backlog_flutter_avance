import 'package:flutter/material.dart';

class Screen1 extends StatelessWidget {
  const Screen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion'),
      ),
      body: const Center(
        child: Text('Page de Connexion'),
      ),
      bottomNavigationBar: ElevatedButton(
          onPressed: () {
        Navigator.pushNamed(context, 'page2');
      },
          child: const Text('Pas encore inscrit?'),
      ),
    );
  }
}