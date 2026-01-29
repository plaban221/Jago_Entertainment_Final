class LoginParams {
  final String email;
  final String password;
  // final String signUpMethod;

  LoginParams({
    this.email = "",
    this.password = "",
    // this.signUpMethod = ""
  });

  factory LoginParams.fromJson(Map<String, dynamic> json) {
    return LoginParams(
      email: json['email'],
      password: json['password'],
      // signUpMethod: json['signUpMethod'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      // 'signUpMethod': signUpMethod
    };
  }

  @override
  String toString() {
    return "email:$email\npassword:$password";
  }
}
