class UserModel {
  final String userCode;
  final String displayName;
  final String email;
  final String employeeCode;
  final String companyCode;

  UserModel({
    required this.userCode,
    required this.displayName,
    required this.email,
    required this.employeeCode,
    required this.companyCode,
  });

  /// Factory method to create a `UserModel` from a JSON object.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      throw ArgumentError("JSON data cannot be empty");
    }
    return UserModel(
      userCode: json['User_Code'] ?? '',
      displayName: json['User_Display_Name'] ?? '',
      email: _validateEmail(json['Email']),
      employeeCode: json['User_Employee_Code'] ?? '',
      companyCode: json['Company_Code'] ?? '',
    );
  }

  /// Convert a `UserModel` instance to a Map for database storage.
  Map<String, dynamic> toMap() {
    return {
      'user_code': userCode,
      'display_name': displayName,
      'email': email,
      'employee_code': employeeCode,
      'company_code': companyCode,
    };
  }

  /// Factory method to create a `UserModel` from a database Map.
  factory UserModel.fromMap(Map<String, dynamic> map) {
    if (map.isEmpty) {
      throw ArgumentError("Database map cannot be empty");
    }
    return UserModel(
      userCode: map['user_code'] ?? '',
      displayName: map['display_name'] ?? '',
      email: _validateEmail(map['email']),
      employeeCode: map['employee_code'] ?? '',
      companyCode: map['company_code'] ?? '',
    );
  }

  @override
  String toString() {
    return 'UserModel(userCode: $userCode, displayName: $displayName, email: $email, employeeCode: $employeeCode, companyCode: $companyCode)';
  }

  /// Private helper method to validate email format.
  static String _validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      throw ArgumentError("Email cannot be null or empty");
    }
    final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    if (!emailRegex.hasMatch(email)) {
      throw FormatException("Invalid email format: $email");
    }
    return email;
  }
}
