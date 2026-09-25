class UserModel {
  final String id;
  final String name;
  final String email;
  final String rollNumber;
  final String userType; // 'student', 'staff', 'admin'
  final double walletBalance;
  final String phone;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.rollNumber,
    required this.userType,
    this.walletBalance = 250.0,
    this.phone = '',
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? rollNumber,
    String? userType,
    double? walletBalance,
    String? phone,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      rollNumber: rollNumber ?? this.rollNumber,
      userType: userType ?? this.userType,
      walletBalance: walletBalance ?? this.walletBalance,
      phone: phone ?? this.phone,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      rollNumber: json['rollNumber'] ?? '',
      userType: json['userType'] ?? 'student',
      walletBalance: (json['walletBalance'] as num?)?.toDouble() ?? 250.0,
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'rollNumber': rollNumber,
      'userType': userType,
      'walletBalance': walletBalance,
      'phone': phone,
    };
  }

  bool get isStudent => userType == 'student';
  bool get isStaff => userType == 'staff';
  bool get isAdmin => userType == 'admin';
}
