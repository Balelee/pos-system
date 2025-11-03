import 'package:intl/intl.dart';

class Subscription {
  final int id;
  final String packKey;
  final String licence;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? consumedAt;
  final DateTime? expiredAt;
  final List<String> features;
  final Map<String, dynamic> featuresDetails;

  Subscription({
    required this.id,
    required this.packKey,
    required this.licence,
    required this.createdAt,
    required this.updatedAt,
    required this.consumedAt,
    required this.expiredAt,
    required this.features,
    required this.featuresDetails,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'] ?? 0,
      packKey: json['pack_key'] ?? '',
      licence: json['licence'] ?? '',
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
      consumedAt: _parseDate(json['consumed_at']),
      expiredAt: _parseDate(json['expired_at']),
      features: (json['features'] != null)
          ? List<String>.from(json['features'])
          : <String>[],
      featuresDetails: (json['features_details'] != null)
          ? Map<String, dynamic>.from(json['features_details'])
          : <String, dynamic>{},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pack_key': packKey,
      'licence': licence,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'consumed_at': consumedAt?.toIso8601String(),
      'expired_at': expiredAt?.toIso8601String(),
      'features': features,
      'features_details': featuresDetails,
    };
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null || value.toString().isEmpty) return null;
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return null;
    }
  }

  bool get isValid => expiredAt != null && expiredAt!.isAfter(DateTime.now());

  String get expiredAtFormatted {
    if (expiredAt == null) return "";
    return DateFormat('dd-MM-yyyy').format(expiredAt!);
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
              createdAt: null,
              updatedAt: null,
              consumedAt: null,
              expiredAt: null,
              features: const [],
              featuresDetails: const {},
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
