import 'dart:io';

import 'package:date_field/date_field.dart';
import 'package:ecurie/component/appbar.dart';
import 'package:ecurie/component/concours_utils.dart';
import 'package:ecurie/component/drawerApp.dart';
import 'package:ecurie/component/picture.dart';
import 'package:ecurie/db/db.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class Concours extends StatefulWidget {
  const Concours({super.key});

  @override
  State<Concours> createState() => _ConcoursState();
}

class _ConcoursState extends State<Concours> {
  int user = 2;
  List? _selectedNiveauPossible = [];
  bool _dataUpdated = false;

  List<DropdownMenuItem<String>> get dropdownItemsConcours {
    List<DropdownMenuItem<String>> menuItemsTerrain = [];
    menuItemsTerrain.add(
      const DropdownMenuItem(value: "", child: Text("Sélectionner")),
    );
    for (var i = 0; i < _selectedNiveauPossible!.length; i++) {
      menuItemsTerrain.add(DropdownMenuItem(
          value: _selectedNiveauPossible?[i],
          child: Text(_selectedNiveauPossible?[i])));
    }
    ;
    return menuItemsTerrain;
  }

  // participer et le niveau choisi
  bool? _Isparticiping = true;
  String _niveauParticipants = '';
  var _selectedImagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildApp(context, 'Concours'),
        drawer: buildDrawer(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _buildFormConcours(
            context,
          ),
          child: Icon(Icons.add),
        ),
        body: Padding(
            padding: EdgeInsets.all(12),
            child: buildListConcours(_dataUpdated, user, () {
              setState(() {
                _dataUpdated = !_dataUpdated;
              });
            })));
  }

  _buildFormConcours(BuildContext context) async {
    _selectedImagePath;
    String? _name = '';
    String? _adresse = '';
      DateTime dateinput = DateTime.now();
    Map<String, dynamic> addConcours = Map();
    // Multi selection de niveau form
    List? _niveauPossible = ["Amateur", "Club1", "Club2", "Club3", "Club4"];
    _selectedNiveauPossible = [];
    _niveauParticipants = '';
    final _formKey = GlobalKey<FormState>();
print('helloe $_selectedImagePath');
    bool error = false;
    return showDialog(
        context: context,
        builder: (context) {
          return Container(
            width: double.infinity,
            child: AlertDialog(
                title: Text('Ajouter un concours'),
                content: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Affichage d'erreur s'il y a un problème avec les inputs
                          error
                              ? const Text(
                                  'Il y a une erreur avec les inputs.',
                                  style: TextStyle(
                                      backgroundColor: Colors.redAccent),
                                )
                              : SizedBox.shrink(),
                          PictureForm(
                            selectedImagePath: _selectedImagePath,
                            onImageSelected: (path) {
                              setState(() {
                                _selectedImagePath = path;
                              });
                            },
                          ),
                          // Nom du concours
                          TextFormField(
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Nom du concours',
                              ),
                              onChanged: (value) => _name = value,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              }),
                          //Adresse du concours
                          TextFormField(
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Adresse du concours',
                              ),
                              onChanged: (value) => _adresse = value,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              }),
                          //Multi Selectionneur pour les niveaux
                          MultiSelectChipField(
                            title: Text('Niveau'),
                            items: _niveauPossible!
                                .map(
                                    (niveau) => MultiSelectItem(niveau, niveau))
                                .toList(),
                            icon: Icon(Icons.check),
                            onTap: (values) {
                              setState(() {
                              _selectedNiveauPossible = values;
                              });
                            },
                          ),
                          // Radio pour savoir si le créateur participe au concours
                          Text('Participez-vous ?'),
                          Container(
                              width: 190,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: RadioListTile(
                                        title: Text('yes'),
                                        value: true,
                                        groupValue: _Isparticiping,
                                        onChanged: (value) {
                                          setState(() {
                                            _Isparticiping = value;
                                          });
                                          print(_Isparticiping);
                                        }),
                                  ),
                                  Expanded(
                                    child: RadioListTile(
                                        title: Text('no'),
                                        value: false,
                                        groupValue: _Isparticiping,
                                        onChanged: (value) {
                                          setState(() {
                                            _Isparticiping = value;
                                          });
                                          print(_Isparticiping);
                                        }),
                                  )
                                ],
                              )),
                          // S'il participe on lui demande le niveau avec lequel il veut participer
                          (_Isparticiping == true
                              ? DropdownButtonFormField(
                                  key: ValueKey(_selectedNiveauPossible),
                                  decoration:
                                      InputDecoration(labelText: 'Niveau'),
                                  value: _niveauParticipants,
                                  onChanged: (String? newValue) {
                                    _niveauParticipants = newValue!;
                                  },
                                  items: dropdownItemsConcours)
                              : SizedBox.shrink()),
                          // Input date et heure
                          DateTimeFormField(
                            mode: DateTimeFieldPickerMode.dateAndTime,
                            decoration: const InputDecoration(
                              hintStyle: TextStyle(color: Colors.black45),
                              errorStyle: TextStyle(color: Colors.redAccent),
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.event_note),
                              labelText: 'Horaire du concours',
                            ),
                            firstDate:
                                DateTime.now().add(const Duration(days: 0)),
                            initialDate:
                                DateTime.now().add(const Duration(days: 0)),
                            onDateSelected: (DateTime value) {
                              dateinput = value.toLocal();
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please choose a date';
                              } else if (DateTime.now().isAfter(value)) {
                                return 'Please choose another Date';
                              }
                              return null;
                            },
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: ElevatedButton(
                              onPressed: () async {
                                // Si les inputs ont été mal rempli, on met error à true et au bout de 5 seconde elle repasse à false
                                if (_selectedNiveauPossible!.isEmpty ||
                                    (_Isparticiping! == true &&
                                        _niveauParticipants == '')) {
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
                                    print('hello ${_selectedImagePath}');

                                    compressAndSaveImage(_selectedImagePath!)
                                        .then((compressedImageBase64) async {
                                      if (_selectedImagePath != null) {
                                        addConcours = {
                                          "name": _name,
                                          "adresse": _adresse,
                                          "photo": compressedImageBase64,
                                          "date": dateinput,
                                          "participants": _Isparticiping == true
                                              ? [
                                                  {
                                                    'user': user,
                                                    'niveau':
                                                        _niveauParticipants
                                                  }
                                                ]
                                              : [],
                                          "niveaux_possibles":
                                              _selectedNiveauPossible
                                        };
                                      } else {
                                        addConcours = {
                                          "name": _name,
                                          "adresse": _adresse,
                                          "photo": null,
                                          "date": dateinput,
                                          "participants": _Isparticiping == true
                                              ? [
                                                  {
                                                    'user': user,
                                                    'niveau':
                                                        _niveauParticipants
                                                  }
                                                ]
                                              : [],
                                          "niveaux_possibles":
                                              _selectedNiveauPossible
                                        };
                                      }
                                      print(addConcours);
                                      await DbMongo.insertInDb(
                                          addConcours, 'Concours');
                                      setState(() {
                                        _dataUpdated = !_dataUpdated;
                                      });
                                      Navigator.pop(context);
                                    });
                                  }
                                }
                                ;
                              },
                              child: const Text('Submit'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                })),
          );
        });
  }
}
