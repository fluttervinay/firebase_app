class UserModel {
  final String email;
  final String name;
  final String status;

  UserModel({required this.email, required this.name, required this.status});

  factory UserModel.fromJson(Map<dynamic, dynamic> json) {
    return UserModel(
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      status: json['status'] ?? 'Offline', // Default status
    );
  }
}
