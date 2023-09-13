import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DbMongo {
  Future<void> connectToDb() async {
    String dbURl =
        'mongodb+srv://${dotenv.env['DB_USERNAME']}:${dotenv.env['DB_PASSWORD']}@${dotenv.env['DB_HOST']}/?retryWrites=true&w=majority';
    var db = await Db.create(dbURl);
    try {
      await db.open();
      print('Connexion établie');
    } catch (e) {
      print('Erreur lors de la connexion : $e');
    }

  }
}
