class User {
  final String name;
  final String password;
  final String email;
  final String? picture;
  String? phone;
  int? age;
  String? ffe;
  int role;

  User(
    {required this.name, required this.password, required this.email, this.picture = 'assets/myGentleMan.jpg', this.phone, this.age, this.ffe, this.role = 1});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'password': password,
      'email': email,
      'picture': picture,
      'phone': phone,
      'age': age,
      'ffe': ffe,
      'role': role,
    };
  }
}