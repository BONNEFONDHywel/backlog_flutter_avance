import 'package:ecurie/db/db.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_field/date_field.dart';

class Cours extends StatefulWidget {
  const Cours({super.key});

  @override
  State<Cours> createState() => _CoursState();
}

class _CoursState extends State<Cours> {
  int user = 2;
  List<DropdownMenuItem<String>> get dropdownItemsTerrain {
    List<DropdownMenuItem<String>> menuItemsTerrain = [
      DropdownMenuItem(child: Text("Sélectionner"), value: ""),
      DropdownMenuItem(child: Text("Manège"), value: "Manège"),
      DropdownMenuItem(child: Text("Carrière"), value: "Carrière"),
    ];
    return menuItemsTerrain;
  }

  List<DropdownMenuItem<String>> get dropdownItemsDuration {
    List<DropdownMenuItem<String>> menuItemsDuration = [
      DropdownMenuItem(child: Text("Sélectionner"), value: ""),
      DropdownMenuItem(child: Text("30 min"), value: "30m"),
      DropdownMenuItem(child: Text("1 heure"), value: "1h"),
    ];
    return menuItemsDuration;
  }

  List<DropdownMenuItem<String>> get dropdownItemsDiscipline {
    List<DropdownMenuItem<String>> menuItemsDiscipline = [
      DropdownMenuItem(child: Text("Sélectionner"), value: ""),
      DropdownMenuItem(child: Text("Dressage"), value: "dressage"),
      DropdownMenuItem(child: Text("Saut d'obstacle"), value: "saut obstacle"),
      DropdownMenuItem(child: Text("Endurance"), value: "endurance"),
    ];
    return menuItemsDiscipline;
  }

  List listCoursActive = [];
  List listCoursInactive = [];
  List listMyCours = [];

  bool _dataUpdated = false;
  String _StatusCours = 'active';
  List<DropdownMenuItem<String>> get dropdownItemsCours {
    List<DropdownMenuItem<String>> menuItemsTerrain = [
      DropdownMenuItem(child: Text("Cours de la semaine"), value: "active"),
      DropdownMenuItem(child: Text("Cours Terminés"), value: "inactive"),
      DropdownMenuItem(child: Text("Mes Cours"), value: "moi"),
    ];
    return menuItemsTerrain;
  }

  List? listCours = [];

  /*fetchdata() async {
    List listCours = await DbMongo.fetchAllItems('Cours');
    for (var item in listCours){
      if(item["datetime"].millisecondsSinceEpoch <= DateTime.now().millisecondsSinceEpoch){
        listCoursInactive.add(item);
      }else{
        listCoursActive.add(item);
        }
    }
 }*/
  // await DbMongo.fetchAllItems('Cours').then(())
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 226, 40, 105),
        title: const Text('Cours',
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
      ),
      body: Container(
          child: Row(
        children: [
          Expanded(
              child: Padding(
                  padding: EdgeInsets.all(12), child: _buildListCours())),
          Expanded(child: _buildFormCours(context))
        ],
      )),
    );
  }

  _buildListCours() {
    return Container(
      child: Column(
        children: [
          DropdownButtonFormField(
              decoration: InputDecoration(labelText: 'Cours'),
              value: _StatusCours,
              onChanged: (String? newValue) {
                setState(() {
                  _StatusCours = newValue!;
                });
              },
              items: dropdownItemsCours),
          FutureBuilder<List<dynamic>>(
            future: DbMongo.fetchAllItems('Cours'),
            key: ValueKey(_dataUpdated),
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Erreur: ${snapshot.error}');
              } else {
                listCoursInactive = [];
                listCoursActive = [];
                listMyCours = [];
                for (var item in snapshot.data!) {
                  if (_StatusCours == "active" || _StatusCours == 'inactive') {
                    if (item['statut'] == 'Accept') {
                      if (DateTime.now().isAfter(item['datetime'])) {
                        listCoursInactive.add(item);
                      } else if (DateTime.now().isBefore(item['datetime'])) {
                        listCoursActive.add(item);
                      }
                    }
                  } else {
                    if(item['user'] == user){
                      listMyCours.add(item);

                    }
                  }
                }

                if (_StatusCours == 'active') {
                  listCours = listCoursActive;
                } else if (_StatusCours == 'moi') {
                  listCours = listMyCours;
                } else {
                  listCours = listCoursInactive;
                }

                return Expanded(
                    child: ListView.builder(
                        itemCount: listCours?.length,
                        itemBuilder: (BuildContext context, int index) {
                          String newFormat = DateFormat('dd/MM/yyyy hh:mm')
                              .format(listCours?[index]["datetime"]);
                          return Container(
                              child: Card(
                            color: listCours?[index]['user'] == user
                                ? Colors.cyan
                                : Colors.white,
                            child: Padding(
                                padding: EdgeInsets.all(18),
                                child: Column(
                                  children: [
                                    Text(
                                      'Cours de ${listCours?[index]['discipline']}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text('Horaire : $newFormat'),
                                    Text(
                                        'Terrain : ${listCours?[index]['terrain']}'),
                                    Text(
                                        'Durée : ${listCours?[index]['duration']}'),
                                    Text(
                                        'Crée par ${listCours?[index]['user']}'),
                                  ],
                                )),
                          ));
                        }));
              }
            },
          )
        ],
      ),
    );
  }

  Widget _buildFormCours(BuildContext context) {
    String? _terrain = '';
    String? _discipline = '';
    String? _duration = '';
    DateTime dateinput = DateTime.now();
    Map<String, dynamic> addCours = Map();

    final _formKey = GlobalKey<FormState>();
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Text(
            "Ajouter un cours",
            style: TextStyle(fontSize: 18),
          ),
          Divider(),
          DropdownButtonFormField(
              decoration: InputDecoration(labelText: 'Terrain'),
              value: _terrain,
              onChanged: (String? newValue) {
                _terrain = newValue!;
              },
              items: dropdownItemsTerrain),
          DropdownButtonFormField(
              decoration: InputDecoration(labelText: 'Discipline'),
              value: _discipline,
              onChanged: (String? newValue) {
                _discipline = newValue!;
              },
              items: dropdownItemsDiscipline),
          DropdownButtonFormField(
              decoration: InputDecoration(labelText: 'Durée'),
              value: _duration,
              onChanged: (String? newValue) {
                _duration = newValue!;
              },
              items: dropdownItemsDuration),
          DateTimeFormField(
            mode: DateTimeFieldPickerMode.dateAndTime,
            //dateFormat: DateFormat.yMMMMEEEEd(),
            decoration: const InputDecoration(
              hintStyle: TextStyle(color: Colors.black45),
              errorStyle: TextStyle(color: Colors.redAccent),
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.event_note),
              labelText: 'Horaire de cours',
            ),
            firstDate: DateTime.now().add(const Duration(days: 0)),
            initialDate: DateTime.now().add(const Duration(days: 0)),
            autovalidateMode: AutovalidateMode.always,
            validator: (value) {
              if (value == null) {
                return 'Please choose a date';
              } else if (DateTime.now().isAfter(value)) {
                return 'Please choose another Date';
              }
              return null;
            },
            onDateSelected: (DateTime value) {
              dateinput = value.toLocal();
            },
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: () {
                addCours = {
                  "terrain": _terrain,
                  "duration": _duration,
                  "discipline": _discipline,
                  "datetime": dateinput,
                  "user": user,
                  "statut": "Pending"
                };
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _dataUpdated = !_dataUpdated;
                  });
                  DbMongo.insertInDb(addCours, 'Cours');
                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
