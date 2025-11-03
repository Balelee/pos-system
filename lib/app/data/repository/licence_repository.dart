import 'package:get_storage/get_storage.dart';
import 'package:pos/app/data/provider/pack_provider.dart';
import 'package:pos/app/models/subscription.dart';

class LicenceRepository {
  final _box = GetStorage();
  final _provider = PackProvider();
  Future<Subscription> consumeLicence(String key) async {
    final response = await _provider.consumeLicence(key);
    final sub = response.subscription;
    await _box.write('pack_key', sub.packKey);
    await _box.write('licence_key', sub.licence);
    await _box.write('expired_at', sub.expiredAt?.toIso8601String());
    await _box.write('features', sub.features);
    await _box.write('features_details', sub.featuresDetails);
    return sub;
  }

  Future<LicenceData?> getSavedLicence() async {
    final packKey = _box.read('pack_key');
    final key = _box.read('licence_key');
    final exp = _box.read('expired_at');
    final featuresDetails =
        Map<String, dynamic>.from(_box.read('features_details') ?? {});
    if (key == null || exp == null) return null;
    final expDate = DateTime.tryParse(exp);
    if (expDate == null) return null;
    return LicenceData(
      licenceKey: key,
      expirationDate: expDate,
      isValid: expDate.isAfter(DateTime.now()),
      packKey: packKey,
      featuresDetails: featuresDetails
    );
  }

  Future<void> clearLicence() async {
    await _box.erase();
  }

  List<String> getFeatures() =>
      _box.read<List<dynamic>>('features')?.cast<String>() ?? [];

  String getPackKey() => _box.read('pack_key') ?? '';
  Map<String, dynamic> getFeaturesDetails() {
    final stored = _box.read('features_details');
    if (stored == null) return {};
    return Map<String, dynamic>.from(stored);
  }
}

class LicenceData {
  final String licenceKey;
  final DateTime expirationDate;
  final bool isValid;
  final String? packKey;
  final Map<String, dynamic>? featuresDetails;

  LicenceData({
    required this.licenceKey,
    required this.expirationDate,
    required this.isValid,
    this.packKey,
    this.featuresDetails,
  });
}
