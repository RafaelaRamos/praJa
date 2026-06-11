enum UserType {
  client,
  provider;

  String get value => name;

  static UserType fromString(String value) {
    return UserType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => UserType.client,
    );
  }
}
