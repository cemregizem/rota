class UserModel {
  final String name;
  final String surname;
  final String licensePlate;
  final int packageCount;
  final int deliveredPackageCount;

  UserModel({
    required this.name,
    required this.surname,
    required this.licensePlate,
    required this.packageCount,
    required this.deliveredPackageCount,
  });

  // Factory method to create a UserModel from a Firebase snapshot
  factory UserModel.fromMap(Map<dynamic, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      surname: map['surname'] as String,
      licensePlate: map['licensePlate'] as String,
      packageCount: map['packageCount'] as int? ?? 0,
      deliveredPackageCount: map['deliveredPackageCount'] as int? ?? 0,
    );
  }

  // Method to convert UserModel to a Map for saving to Firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'surname': surname,
      'licensePlate': licensePlate,
      'packageCount': packageCount,
      'deliveredPackageCount':deliveredPackageCount,
    };
  }
}
