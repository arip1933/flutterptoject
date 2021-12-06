class User {
  final String imagePath;
  final String name;
  final String email;
  final String about;
  final String handphone;
  final bool isDarkMode;

  const User({
     this.imagePath,
     this.name,
     this.email,
     this.about,
     this.handphone,
     this.isDarkMode,
  });

  User copy({
    String imagePath,
    String name,
    String email,
    String about,
    String handphone,
    bool isDarkMode,
  }) =>
      User(
        imagePath: imagePath ?? this.imagePath,
        name: name ?? this.name,
        email: email ?? this.email,
        about: about ?? this.about,
        handphone: handphone ?? this.handphone,
        isDarkMode: isDarkMode ?? this.isDarkMode,
      );

  static User fromJson(Map<String, dynamic> json) => User(
        imagePath: json['imagePath'],
        name: json['name'],
        email: json['email'],
        about: json['about'],
        handphone: json['handphone'],
        isDarkMode: json['isDarkMode'],
      );

  Map<String, dynamic> toJson() => {
        'imagePath': imagePath,
        'name': name,
        'email': email,
        'about': about,
        'handphone': handphone,
        'isDarkMode': isDarkMode,
      };
}
