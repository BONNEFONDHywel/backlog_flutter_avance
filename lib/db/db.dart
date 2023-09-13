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
      var collections = db.collection('Cours');
      var result = await collections.find().toList();
      print(result);
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
      /*for (var doc in result) {
        items.add(Contact.fromJson(doc));
      }*/
    } catch (e) {
      print('Erreur lors de la récupération : $e');
    }
    return result;
  }
  /*Future<void> deleteItem(String nameCollection, Map<String, dynamic>item) async{
    var collection = db.collection(nameCollection);

    try{
      await collection.remove();

    }catch(e){

    }
  }*/

}
