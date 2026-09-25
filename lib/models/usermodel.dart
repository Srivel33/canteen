class UserModel {
  final String id;
  final String name;
  final String email;
  final String rollNumber;
  final String userType; // 'student' or 'staff'
  
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.rollNumber,
    required this.userType,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      rollNumber: json['rollNumber'],
      userType: json['userType'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'rollNumber': rollNumber,
      'userType': userType,
    };
  }
}
