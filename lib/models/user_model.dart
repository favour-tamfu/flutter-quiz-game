// lib/models/user_model.dart

class User {
  final int id;
  final String pseudoName;
  final String email;
  final int xp;
  final int level;

  User({
    required this.id,
    required this.pseudoName,
    required this.email,
    required this.xp,
    required this.level,
  });

  // This factory constructor allows us to create a User object
  // from a map, which is how data is retrieved from the sqflite database.
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      pseudoName: map['pseudo_name'],
      email: map['email'],
      xp: map['xp'],
      level: map['level'],
    );
  }
}