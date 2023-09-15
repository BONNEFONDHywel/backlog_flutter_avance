import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../db/db.dart';

bool isUserRegistered(List participants, String userId) {
  for (var participant in participants) {
    if (participant['user'] == userId) {
      return true;
    }
  }
  return false;
}

Widget buildListConcours(_dataUpdated, user, callback, listConcours) {
  String _niveauParticipants = '';
  bool error = false;
  final _formKey = GlobalKey<FormState>();
  _niveauParticipants = '';
  return Container(
    child: Column(
      children: [
        FutureBuilder<List<dynamic>>(
          future: DbMongo.fetchAllItems('Concours'),
          key: ValueKey(_dataUpdated),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Expanded(child: Text('Erreur: Relancer la page'));
            } else {
              listConcours = snapshot.data;
              return Expanded(
                  child: ListView.builder(
                      itemCount: listConcours?.length,
                      itemBuilder: (BuildContext context, int index) {
                        String newFormat = DateFormat('dd/MM/yyyy hh:mm')
                            .format(listConcours?[index]["date"]);
                        var photo = listConcours?[index]["photo"] == 'assets/myGentleMan.jpg';

                        return Container(
                          child: Card(
                            color: Colors.white,
                            child: Row(
                              children: [
                                photo == true ? const CircleAvatar(
                            radius: 80.0,
                                backgroundImage:
                                AssetImage( 'assets/myGentleMan.jpg')
                            ): Image(
                                  image:  MemoryImage(
                                      base64Decode(listConcours?[index]["photo"])),
                                  width: 100,

                                ),
                                Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Concours de ${listConcours?[index]['name']}',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text('Horaire : $newFormat'),
                                        Text(
                                            'Adresse : ${listConcours?[index]['adresse']}'),
                                        PopupMenuButton(
                                          itemBuilder: (BuildContext context) {
                                            List<PopupMenuItem> itemPopUp = [];

                                            for (var i = 0;
                                                i <
                                                    listConcours?[index]
                                                            ['participants']
                                                        .length;
                                                i++) {
                                              itemPopUp.add(PopupMenuItem(
                                                  child: Text(
                                                      " - ${listConcours?[index]['participants'][i]["user"]} => niveau : ${listConcours?[index]['participants'][i]["niveau"]}")));
                                            }
                                            return itemPopUp;
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Text(
                                              'Liste de Cavaliers',
                                              style: TextStyle(
                                                  backgroundColor: Colors.grey),
                                            ),
                                          ),
                                        ),
                                        !isUserRegistered(
                                                listConcours?[index]
                                                    ['participants'],
                                                user)
                                            ? TextButton(
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return SizedBox(
                                                            width:
                                                                double.infinity,
                                                            child: AlertDialog(
                                                                title: const Text(
                                                                    'Participer au concours'),
                                                                content: StatefulBuilder(builder:
                                                                    (BuildContext
                                                                            context,
                                                                        StateSetter
                                                                            setState) {
                                                                  List<DropdownMenuItem<String>>
                                                                      menuItemsTerrain =
                                                                      [];
                                                                  menuItemsTerrain
                                                                      .add(
                                                                    const DropdownMenuItem(
                                                                        value:
                                                                            "",
                                                                        child: Text(
                                                                            "Sélectionner")),
                                                                  );
                                                                  for (var i =
                                                                          0;
                                                                      i <
                                                                          listConcours?[index]["niveaux_possibles"]!
                                                                              .length;
                                                                      i++) {
                                                                    menuItemsTerrain.add(DropdownMenuItem(
                                                                        value: listConcours?[index]["niveaux_possibles"]
                                                                            ?[
                                                                            i],
                                                                        child: Text(listConcours?[index]["niveaux_possibles"]
                                                                            ?[
                                                                            i])));
                                                                  }

                                                                  return Form(
                                                                      key:
                                                                          _formKey,
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          // Affichage d'erreur s'il y a un problème avec les inputs
                                                                          error
                                                                              ? const Text(
                                                                                  'Il y a une erreur avec les inputs.',
                                                                                  style: TextStyle(backgroundColor: Colors.redAccent),
                                                                                )
                                                                              : SizedBox.shrink(),
                                                                          DropdownButtonFormField(
                                                                              decoration: const InputDecoration(labelText: 'Niveau'),
                                                                              value: _niveauParticipants,
                                                                              onChanged: (String? newValue) {
                                                                                _niveauParticipants = newValue!;
                                                                              },
                                                                              items: menuItemsTerrain),
                                                                          TextButton(
                                                                            onPressed: () =>
                                                                                Navigator.pop(context, 'Cancel'),
                                                                            child:
                                                                                const Text('Cancel'),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(vertical: 16),
                                                                            child:
                                                                                ElevatedButton(
                                                                              onPressed: () async {
                                                                                if (_niveauParticipants == '') {
                                                                                  setState(() {
                                                                                    error = true;
                                                                                  });
                                                                                  await Future.delayed(Duration(seconds: 5));
                                                                                  setState(() {
                                                                                    error = false;
                                                                                  });
                                                                                } else {
                                                                                  // Enregistrement dans BDD et update liste des concours
                                                                                  setState(() {
                                                                                    error = false;
                                                                                  });
                                                                                  if (_formKey.currentState!.validate()) {
                                                                                    callback();
                                                                                    print(listConcours?[index]["participants"]);

                                                                                    List new_participant = [
                                                                                      ...listConcours?[index]["participants"],
                                                                                      {
                                                                                        'user': user,
                                                                                        'niveau': _niveauParticipants
                                                                                      }
                                                                                    ];
                                                                                    print(new_participant);
                                                                                    DbMongo.updateConcoursParticipants(listConcours?[index]["name"], new_participant);
                                                                                    Navigator.of(context).pop();
                                                                                  }
                                                                                }
                                                                              },
                                                                              child: const Text('Submit'),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ));
                                                                })));
                                                      });
                                                },
                                                child: const Text('Participer'))
                                            : Text('Déjà Inscrit'),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        );
                      }));
            }
          },
        )
      ],
    ),
  );
}
