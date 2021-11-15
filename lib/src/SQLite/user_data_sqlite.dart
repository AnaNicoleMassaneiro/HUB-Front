import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class UserDataSqlite {
  late Future<Database> database = initSQLite();

  Future<Database> initSQLite() async {
    return openDatabase(
      join(await getDatabasesPath(), 'user_data.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE userData ('
            'idUser INTEGER PRIMARY KEY, '
            'idVendedor INTEGER, '
            'idCliente INTEGER, '
            'locationLat FLOAT, '
            'locationLon FLOAT,'
            'token TEXT)'
        );
      },
      version: 1,
    );
  }

  Future<void> insertUserData(Map<String, dynamic> userData) async {
    final db = await database;
    await db.insert(
      'userData',
      userData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>> getUserData() async {
    final db = await database;

    final List<Map<String, dynamic>> u = await db.query('userData');

    if (u.isNotEmpty) {
      return u.first;
    }
    else {
      return { 'idUser': null };
    }
  }

  Future<void> updateUserData(Map<String, dynamic> u) async {
    final db = await database;

    await db.update(
      'userData',
      u,
      where: 'idUser = ?',
      whereArgs: [u["idUser"]],
    );
  }

  Future<void> deleteUserData(int id) async {
    final db = await database;

    await db.delete(
      'userData',
      where: 'idUser = ?',
      whereArgs: [id],
    );
  }
}

final userDataSqlite = UserDataSqlite();