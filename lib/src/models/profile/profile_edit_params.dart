class ProfileEditParams {
  final String name;
  final String phone;
  final String email;
  final DateTime? dateOfBirth;
  final String gender;
  final String country;
  final String language;
  final Preferences? preferences;

  ProfileEditParams({
    this.name = "",
    this.phone = "",
    this.email = "",
    this.dateOfBirth,
    this.gender = "",
    this.country = "",
    this.language = "",
    this.preferences,
  });

  factory ProfileEditParams.fromJson(Map<String, dynamic> json) {
    return ProfileEditParams(
      name: json['name'] ?? "",
      phone: json['phone'] ?? "",
      email: json['email'] ?? "",
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.tryParse(json['date_of_birth'])
          : null,
      gender: json['gender'] ?? "",
      country: json['country'] ?? "",
      language: json['language'] ?? "",
      preferences: json['preferences'] != null
          ? Preferences.fromJson(json['preferences'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'country': country,
      'language': language,
      'preferences': preferences?.toJson(),
    };
  }

  @override
  String toString() {
    return '''
ProfileEditParams(
  name: $name,
  phone: $phone,
  email: $email,
  dateOfBirth: $dateOfBirth,
  gender: $gender,
  country: $country,
  language: $language,
  preferences: $preferences
)
''';
  }
}

class Preferences {
  final bool notifications;
  final bool autoPlay;
  final String videoQuality;

  Preferences({
    this.notifications = true,
    this.autoPlay = true,
    this.videoQuality = "hd",
  });

  factory Preferences.fromJson(Map<String, dynamic> json) {
    return Preferences(
      notifications: json['notifications'] ?? true,
      autoPlay: json['auto_play'] ?? true,
      videoQuality: json['video_quality'] ?? "hd",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notifications': notifications,
      'auto_play': autoPlay,
      'video_quality': videoQuality,
    };
  }

  @override
  String toString() {
    return '''
Preferences(
  notifications: $notifications,
  autoPlay: $autoPlay,
  videoQuality: $videoQuality
)
''';
  }
}
