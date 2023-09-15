import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DbMongo {
  static var db;
  static Future<void> connectToDb() async {
    String dbURl =
        'mongodb+srv://${dotenv.env['DB_USERNAME']}:${dotenv.env['DB_PASSWORD']}@${dotenv.env['DB_HOST']}/?retryWrites=true&w=majority';

     db = await Db.create(dbURl);
    try {
      await db.open();
      inspect(db);
      print('Connexion établie');
    } catch (e) {
      print('Erreur lors de la connexion : $e');
    }

  }
  static Future<void> insertInDb(Map<String, dynamic> item, String nameCollection, ) async {
    var collection = db.collection(nameCollection);
    try {
      await collection.insert(item);
      print('Contact inséré avec succès');
    } catch (e) {
      print('Erreur lors de l\'insertion : $e');
    }
  }


  static Future<List> fetchAllItems(String nameCollection) async {
    var collection = db.collection(nameCollection);
    List result = [];
    try {
       result = await collection.find().toList();
       if(nameCollection == 'Cours'){
         result.sort((a, b) => b["datetime"].compareTo(a["datetime"] ) );

    }else{
         result.sort((a, b) =>b["date"].compareTo(a["date"] ) );

       }

    } catch (e) {
      print('Erreur lors de la récupération : $e');
    }
    return result;

  }

  static Future<void> updateConcoursParticipants(String id, List participants) async {
    var collection = db.collection('Concours');
    try {
      await collection.update(
          where.eq('name', id), modify.set('participants', participants));
      print('Concours mis à jour avec succès');
    } catch (e) {
      print('Erreur lors de la mise à jour : $e');
    }
  }

  static Future<List> userAccount(nameController, passwordController) async {
    var coll = db.collection('Inscription');
    print(nameController);
    var userList = [];
    try {
      userList = await coll.find(where.eq('name', nameController.text)).toList();
    } catch(e) {
      print('Erreur lors de la récupération : $e');
    }

    return userList;
  }
  /*Future<void> deleteItem(String nameCollection, Map<String, dynamic>item) async{
    var collection = db.collection(nameCollection);

    try{
      await collection.remove();

    }catch(e){

    }
  }*/

}
