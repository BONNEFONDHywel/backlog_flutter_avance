import 'dart:convert';

import 'package:date_field/date_field.dart';
import 'package:ecurie/component/appbar.dart';
import 'package:ecurie/component/drawerApp.dart';
import 'package:ecurie/component/picture.dart';
import 'package:ecurie/db/db.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecurie/modeles/soiree_class.dart';
import 'package:intl/intl.dart';

class Soiree extends StatefulWidget {
  const Soiree({super.key});

  @override
  State<Soiree> createState() => _SoireeState();
}

class _SoireeState extends State<Soiree> {
  List<SoireeData> items = [];
  _showForm() async {
    final result = await showDialog<SoireeData>(
      context: context,
      builder: (context) => ItemFormDialog(),
    );

    if (result != null) {
      setState(() {
        items.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildApp(context, 'Soirée'),
      drawer: buildDrawer(context),
      body: FutureBuilder<List<dynamic>>(
          future: DbMongo.fetchAllItems('Soirees'),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return  Text('Erreur: Relancer la page');
            } else {
              return  ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  print(snapshot.data![index]['title']);

                  return Container(
                    child: Card(
                      color: Colors.white,
                      child: Row(
                        children: [
                          Expanded(
                            child: snapshot.data![index]["picture"] == 'assets/myGentleMan.jpg'
                                ? const CircleAvatar(
                              radius: 80.0,
                              backgroundImage: AssetImage('assets/myGentleMan.jpg'),
                            )
                                : Image(
                              image: MemoryImage(
                                base64Decode(snapshot.data![index]["picture"]),
                              ),
                              width: 100,
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: Text(snapshot.data![index]['title']),
                              leading: Column(children: [
                                Text(snapshot.data![index]['type']),
                                Text('${DateFormat('dd/MM/yyyy hh:mm')
                      .format(snapshot.data![index]['datetime'])}'),
                              ],),
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _showForm,
        child: Icon(Icons.add),
      ),
    );
  }
}

class ItemFormDialog extends StatefulWidget {
  @override
  _ItemFormDialogState createState() => _ItemFormDialogState();
}

class _ItemFormDialogState extends State<ItemFormDialog> {
  String? selectedImagePath;
  DateTime? dateInput;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Ajouter une soirée'),
      content: SingleChildScrollView( // Pour permettre le défilement si le contenu dépasse l'espace disponible
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PictureForm(
                selectedImagePath: selectedImagePath,
                onImageSelected: (value) {
                  setState(() {
                    selectedImagePath = value;
                  });
                }
            ),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Titre'),
          ),
          TextField(
            controller: _typeController,
            decoration: const InputDecoration(labelText: 'Thème'),
          ),DateTimeFormField(
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
              dateInput = value.toLocal();
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
        ],
      ),),
      actions: [
        TextButton(
          child: Text('Annuler'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Ajouter'),
          onPressed: () async {
            if (selectedImagePath != null) {
              compressAndSaveImage(selectedImagePath!)
                  .then((compressedImageBase64) async {
                final item = SoireeData(
                  title: _titleController.text,
                  imagePath: compressedImageBase64!,
                  type: _typeController.text, datetime: dateInput,
                ).toMap();
                await DbMongo.insertInDb(item, 'Soirees');
                Navigator.of(context).pop();

              });
            } else {
              final item = SoireeData(
                datetime: dateInput,
                title: _titleController.text,
                imagePath: 'assets/myGentleMan.jpg'!,
                type: _typeController.text,
              ).toMap();
               DbMongo.insertInDb(item, 'Soirees');
              Navigator.of(context).pop();

            }
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _typeController.dispose();
    super.dispose();
  }
}
