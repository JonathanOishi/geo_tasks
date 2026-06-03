class User {
  final String id;
  final String name;
  final String email;
  final String? avatarBase64;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarBase64,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarBase64,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarBase64: avatarBase64 ?? this.avatarBase64,
    );
  }

  factory User.fromAuth({
    required String id,
    required String? name,
    required String? email,
    String? avatarBase64,
  }) {
    final safeEmail = (email ?? '').trim();
    final safeName = (name ?? '').trim();

    if (safeName.isNotEmpty) {
      return User(
        id: id,
        name: safeName,
        email: safeEmail,
        avatarBase64: avatarBase64,
      );
    }

    if (safeEmail.contains('@')) {
      return User(
        id: id,
        name: safeEmail.split('@').first,
        email: safeEmail,
        avatarBase64: avatarBase64,
      );
    }

    return User(
      id: id,
      name: 'Usuario',
      email: safeEmail,
      avatarBase64: avatarBase64,
    );
  }

  factory User.fromFirestore({
    required String id,
    required Map<String, dynamic>? data,
    String? fallbackName,
    String? fallbackEmail,
  }) {
    final map = data ?? <String, dynamic>{};
    return User.fromAuth(
      id: id,
      name: (map['name'] as String?) ?? fallbackName,
      email: (map['email'] as String?) ?? fallbackEmail,
      avatarBase64: map['avatarBase64'] as String?,
    );
  }
}
