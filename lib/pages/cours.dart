import 'package:ecurie/component/appbar.dart';
import 'package:ecurie/db/db.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_field/date_field.dart';
import 'package:table_calendar/table_calendar.dart';
class Cours extends StatefulWidget {
  const Cours({super.key});

  @override
  State<Cours> createState() => _CoursState();
}

class _CoursState extends State<Cours> {
  int user = 2;
  //var _selectedDay;
  //var _focusedDay;
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

  List<DropdownMenuItem<String>> get dropdownItemsCours {
    List<DropdownMenuItem<String>> menuItemsTerrain = [
      DropdownMenuItem(child: Text("Cours de la semaine"), value: "active"),
      DropdownMenuItem(child: Text("Cours Terminés"), value: "inactive"),
      DropdownMenuItem(child: Text("Mes Cours"), value: "moi"),
    ];
    return menuItemsTerrain;
  }

  bool _dataUpdated = false;
  String _StatusCours = 'active';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildApp(context, 'Cours'),
      body: Container(
          child: Column(
        children: [
          TextButton(
            child: Text('Ajouter un cours'),
            onPressed: () => _buildFormCours(context),
          ),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.all(12), child: _buildListCours())),
          /*TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: DateTime.now(),
            selectedDayPredicate: (day) {
              print('day $day');
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              print(selectedDay);
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // update `_focusedDay` here as well
              });
            },
          ),*/],
      )
      ,
      ),
    );
  }

  _buildListCours() {

    List? listCours = [];
    List listCoursActive = [];
    List listCoursInactive = [];
    List listMyCours = [];
    Color _colorOfCard = Colors.white;

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
                return Expanded(child: Text('Erreur: Relancer la page'));
              } else {
                listCoursInactive = [];
                listCoursActive = [];
                listMyCours = [];

                for (var item in snapshot.data!) {
                  if (_StatusCours == "active" || _StatusCours == 'inactive') {
                    if (item['statut'] == 'Accept') {
                      if (DateTime.now().isAfter(item['datetime'])) {
                        listCoursInactive.add(item);
                      } else {
                        listCoursActive.add(item);
                      }
                    }
                  } else {
                    if (item['user'] == user) {
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
                          if (_StatusCours == 'moi') {
                            if (listCours?[index]['statut'] == 'Refuse') {
                              _colorOfCard = Colors.red;
                            } else if (listCours?[index]['statut'] ==
                                'Pending') {
                              _colorOfCard = Colors.grey;
                            } else {
                              _colorOfCard = Colors.lightGreen;
                            }
                          } else {
                            if (listCours?[index]['user'] == user) {
                              _colorOfCard = Colors.lightBlue;
                            } else {
                              _colorOfCard = Colors.white;
                            }
                          }
                          return Container(
                              child: Card(
                            color: _colorOfCard,
                            child: Padding(
                                padding: EdgeInsets.all(18),
                                child: Column(
                                  children: [
                                    Text(
                                      'Cours de ${listCours?[index]['discipline']}',
                                      style: const TextStyle(
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

  _buildFormCours(BuildContext context) {
    String? _terrain = '';
    String? _discipline = '';
    String? _duration = '';
    DateTime dateinput = DateTime.now();
    Map<String, dynamic> addCours = Map();

    final _formKey = GlobalKey<FormState>();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Ajouter un contact'),
              content: Form(
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
                        onPressed: () {
                          addCours = {
                            "terrain": _terrain,
                            "duration": _duration,
                            "discipline": _discipline,
                            "datetime": dateinput,
                            "user": user,
                            "statut": "Refuse"
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
              ));
        });
  }
}
