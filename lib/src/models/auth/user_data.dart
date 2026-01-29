class UserData {
  final int id;
  final String name;
  final String email;
  final String phone;
  final DateTime? dateOfBirth;
  final String gender;
  final String country;
  final String language;
  final bool isActive;
  final String subscriptionStatus;
  final DateTime? lastLoginAt;
  final String? lastLoginIp;
  final String? avatarUrl;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.dateOfBirth,
    required this.gender,
    required this.country,
    required this.language,
    required this.isActive,
    required this.subscriptionStatus,
    this.lastLoginAt,
    this.lastLoginIp,
    this.avatarUrl,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.tryParse(json['date_of_birth'] as String)
          : null,
      gender: json['gender'] as String? ?? '',
      country: json['country'] as String? ?? '',
      language: json['language'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? false,
      subscriptionStatus: json['subscription_status'] as String? ?? '',
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.tryParse(json['last_login_at'] as String)
          : null,
      lastLoginIp: json['last_login_ip'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'date_of_birth': dateOfBirth?.toIso8601String(),
    'gender': gender,
    'country': country,
    'language': language,
    'is_active': isActive,
    'subscription_status': subscriptionStatus,
    'last_login_at': lastLoginAt?.toIso8601String(),
    'last_login_ip': lastLoginIp,
    'avatar_url': avatarUrl,
  };

  @override
  String toString() => '''
UserData(
  id: $id,
  name: $name,
  email: $email,
  phone: $phone,
  dateOfBirth: $dateOfBirth,
  gender: $gender,
  country: $country,
  language: $language,
  isActive: $isActive,
  subscriptionStatus: $subscriptionStatus,
  lastLoginAt: $lastLoginAt,
  lastLoginIp: $lastLoginIp,
  avatarUrl: $avatarUrl
)''';
}