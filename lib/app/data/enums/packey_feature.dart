enum PackType {
  yshopFree,
  yshopPro,
  yshopPrenium,
}

extension PackTypeExtension on PackType {
  String get key {
    switch (this) {
      case PackType.yshopFree:
        return "yshop-free";
      case PackType.yshopPrenium:
        return "yshop-premium";
      case PackType.yshopPro:
        return "yshop-pro";
    }
  }

  String get displayName {
    switch (this) {
      case PackType.yshopFree:
        return "YShop Free";
      case PackType.yshopPrenium:
        return "YShop Prenium";
      case PackType.yshopPro:
        return "YShop Pro";
    }
  }
}

const Map<PackType, Map<String, String>> packFeatures = {
  PackType.yshopFree: {
    "free1": "Gestion des produits"
    },
  PackType.yshopPrenium: {
    'prenium1': 'Gestion complète des caissiers',
    'prenium2': 'consulter les sessions',
    'prenium3': 'Voir l\'historique des ventes',
  },
  PackType.yshopPro: {
    "pro1": "Toutes les fonctionnalités PREMIUM",
    "pro2": "Acces gratuit a un printer",
    "pro3": "Gerer les ventes",
    "pro4": "Generer les factures de ventes",
  },
};

extension PackFeaturesExtension on PackType {
  Map<String, String> get features => packFeatures[this] ?? {};
}

PackType? packTypeFromKey(String key) {
  for (var pack in PackType.values) {
    if (pack.key == key) return pack;
  }
  return null;
}
