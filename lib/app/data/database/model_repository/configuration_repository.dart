import 'package:pos/app/data/database/database_pos.dart';
import 'package:pos/app/models/configuration.dart';

class CompanyRepository {
  final dbProvider = DatabaseHelper.instance;

  Future<Configuration?> getCompany() async {
    final db = await dbProvider.database;
    final result = await db.query(
      'configuration',
      limit: 1,
    );
    if (result.isNotEmpty) {
      return Configuration.fromMap(result.first);
    }
    return null;
  }

  Future<Configuration> insertCompany(Configuration company) async {
    final db = await dbProvider.database;
    final id = await db.insert('configuration', company.toMap());
    return Configuration(
      id: id,
      name: company.name,
      phone: company.phone,
      logoPath: company.logoPath,
    );
  }

  Future<int> updateCompany(Configuration company) async {
    final db = await dbProvider.database;
    return await db.update(
      'configuration',
      company.toMap(),
      where: 'id = ?',
      whereArgs: [company.id],
    );
  }

  Future<int> deleteCompany(int id) async {
    final db = await dbProvider.database;
    return await db.delete(
      'configuration',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
