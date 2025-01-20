class UserModel {
  final String name;
  final String surname;
  final String licensePlate;

  UserModel({
    required this.name,
    required this.surname,
    required this.licensePlate,
  });

  // Factory method to create a UserModel from a Firebase snapshot
  factory UserModel.fromMap(Map<dynamic, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      surname: map['surname'] as String,
      licensePlate: map['licensePlate'] as String,
    );
  }

  // Method to convert UserModel to a Map for saving to Firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'surname': surname,
      'licensePlate': licensePlate,
    };
  }
}
