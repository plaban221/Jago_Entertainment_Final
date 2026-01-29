class RegisterParams {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String passwordConfirmation;
  final DateTime? dateOfBirth;
  final String gender;
  final String country;
  final String language;

  RegisterParams({
    this.name = "",
    this.email = "",
    this.phone = "",
    this.password = "",
    this.passwordConfirmation = "",
    this.dateOfBirth,
    this.gender = "",
    this.country = "",
    this.language = "",
  });

  factory RegisterParams.fromJson(Map<String, dynamic> json) {
    return RegisterParams(
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      phone: json['phone'] ?? "",
      password: json['password'] ?? "",
      passwordConfirmation: json['password_confirmation'] ?? "",
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.tryParse(json['date_of_birth'])
          : null,
      gender: json['gender'] ?? "",
      country: json['country'] ?? "",
      language: json['language'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'country': country,
      'language': language,
    };
  }

  @override
  String toString() {
    return '''
RegisterParams(
  name: $name,
  email: $email,
  phone: $phone,
  password: $password,
  passwordConfirmation: $passwordConfirmation,
  dateOfBirth: $dateOfBirth,
  gender: $gender,
  country: $country,
  language: $language
)
''';
  }
}
