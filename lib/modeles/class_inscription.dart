class User {
  final String name;
  final String password;
  final String email;
  final String? picture;
  String? phone;
  int? age;
  String? ffe;

  User(
    {required this.name, required this.password, required this.email, required this.picture, this.phone, this.age, this.ffe});
}