class Configuration {
  final int? id;
  final String name;
  final String phone;
  final String? logoPath;

  Configuration({
    this.id,
    required this.name,
    required this.phone,
    this.logoPath,
  });

  factory Configuration.fromMap(Map<String, dynamic> map) {
    return Configuration(
      name: map['name'],
      phone: map['phone'],
      logoPath: map['logoPath'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'logoPath': logoPath,
    };
  }
}
