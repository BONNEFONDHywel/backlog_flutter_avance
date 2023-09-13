import 'package:mongo_dart/mongo_dart.dart';

class DbMongo {
  Future<void> connectToDb() async {
    String dbURl =
        'mongodb+srv://contact:DHT4WIsFEmqELpyd@cluster0.zdj1sbf.mongodb.net/?retryWrites=true&w=majority';
    var db = await Db.create(dbURl);
    try {
      await db.open();
      print('Connexion établie');
    } catch (e) {
      print('Erreur lors de la connexion : $e');
    }
    await db.close();
  }
}
