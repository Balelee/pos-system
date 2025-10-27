class Pack {
  final String key;
  final String label;
  final int price;
  final int duration;
  final List<String> features;

  Pack({
    required this.key,
    required this.label,
    required this.price,
    required this.duration,
    required this.features,
  });

  factory Pack.fromJson(Map<String, dynamic> json) {
    return Pack(
      key: json['key'] ?? '',
      label: json['label'] ?? '',
      price: json['price'] ?? 0,
      duration: json['duration'] ?? 0,
      features: List<String>.from(json['features'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'label': label,
      'price': price,
      'duration': duration,
      'features': features,
    };
  }
}
