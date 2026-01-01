class Country {
  const Country({
    required this.name,
    required this.dialCode,
    required this.flag,
  });

  final String name;
  final String dialCode;
  final String flag;

  String get displayName => '$name ($dialCode)';
}
