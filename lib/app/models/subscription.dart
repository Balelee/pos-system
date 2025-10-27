class Subscription {
  final int id;
  final String packKey;
  final String licence;
  final String createdAt;
  final String updatedAt;
  final String consumedAt;
  final String expiredAt;
  final List<String> features; 

  Subscription({
    required this.id,
    required this.packKey,
    required this.licence,
    required this.createdAt,
    required this.updatedAt,
    required this.consumedAt,
    required this.expiredAt,
    required this.features,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
   List<String> featuresList = [];
    if (json['features'] != null) {
      // Assure-toi que c'est bien une liste
      featuresList = List<String>.from(json['features']);
    }

    return Subscription(
      id: json['id'] ?? 0,
      packKey: json['pack_key'] ?? '',
      licence: json['licence'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      consumedAt: json['consumed_at'] ?? '',
      expiredAt: json['expired_at'] ?? '',
      features: featuresList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pack_key': packKey,
      'licence': licence,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'consumed_at': consumedAt,
      'expired_at': expiredAt,
      'features': features,
    };
  }
}

class PackSubscribeResponse {
  final String message;
  final Subscription subscription;

  PackSubscribeResponse({
    required this.message,
    required this.subscription,
  });

  factory PackSubscribeResponse.fromJson(Map<String, dynamic> json) {
    return PackSubscribeResponse(
      message: json['message'] ?? '',
      subscription: json['subscription'] != null
          ? Subscription.fromJson(json['subscription'])
          : Subscription(
              id: 0,
              packKey: '',
              licence: '',
              createdAt: '',
              updatedAt: '',
              consumedAt: '',
              expiredAt: '',
              features: [],
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'subscription': subscription.toJson(),
    };
  }
}
