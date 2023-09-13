import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DbMongo {
  var db;

  Future<void> connectToDb() async {
    String dbURl =
        'mongodb+srv://${dotenv.env['DB_USERNAME']}:${dotenv.env['DB_PASSWORD']}@${dotenv.env['DB_HOST']}/?retryWrites=true&w=majority';

    this.db = await Db.create(dbURl);
    try {
      await this.db.open();
      print('Connexion établie');
    } catch (e) {
      print('Erreur lors de la connexion : $e');
    }

  }
  Future<void> insertInDb(Map<String, dynamic> item, String nameCollection) async {
    var collection = db.collection(nameCollection);
    try {
      await collection.insert(item);
      print('Contact inséré avec succès');
    } catch (e) {
      print('Erreur lors de l\'insertion : $e');
    }
  }

  Future fetchAllItems(String nameCollection) async {
    var collection = db.collection(nameCollection);
    List items = [];
    try {
      var result = await collection.find().toList();
      return result;
      /*for (var doc in result) {
        items.add(Contact.fromJson(doc));
      }*/
    } catch (e) {
      print('Erreur lors de la récupération : $e');
    }
    return false;
  }
  /*Future<void> deleteItem(String nameCollection, Map<String, dynamic>item) async{
    var collection = db.collection(nameCollection);

    try{
      await collection.remove();

    }catch(e){

    }
  }*/

}
