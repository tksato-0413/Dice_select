import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/src/exception.dart'; // 修正：例外クラスの正しいインポート
import 'package:path/path.dart';

class FavoriteCondition {
  final int id;
  final String name;
  final int diceCount;
  final int minSide;
  final int maxSide;

  const FavoriteCondition(this.id, this.name, this.diceCount, this.minSide, this.maxSide);
}

List<FavoriteCondition> favoriteConditions = [];

FavoriteCondition? getFavorite(int index) {
  if (index < 0 || index >= favoriteConditions.length) {
    return null;
  }
  return favoriteConditions[index];
}

class FavoriteDatabase {
  Future<Database> create() async {
    var databasePath = await getDatabasesPath();
    final path = join(databasePath, 'favorite.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE ${FavoriteHelper._name} (
            ${FavoriteHelper._id} INTEGER PRIMARY KEY,
            ${FavoriteHelper._name} TEXT,
            ${FavoriteHelper._diceCount} INTEGER,
            ${FavoriteHelper._minSide} INTEGER,
            ${FavoriteHelper._maxSide} INTEGER
          )
        ''');
      },
    );
  }
}

class FavoriteHelper {
  static const _tableName = 'favorites';
  static const _id = 'id';
  static const _name = 'name';
  static const _diceCount = 'diceCount';
  static const _minSide = 'minSide';
  static const _maxSide = 'maxSide';

  late Database _db;

  final DatabaseFactory _factory;

  FavoriteHelper(this._factory);

  Future<void> open() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'favorite.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE $_tableName ('
          '$_id INTEGER PRIMARY KEY, '
          '$_name TEXT, '
          '$_diceCount INTEGER, '
          '$_minSide INTEGER, '
          '$_maxSide INTEGER'
          ')',
        );
      },
    );
  }

  Future<FavoriteCondition?> fetch(int id) async {
    List<Map> maps = await _db.query(
      _tableName,
      columns: [_id, _name, _diceCount, _minSide, _maxSide],
      where: '$_id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return FavoriteCondition(
        maps.first[_id],
        maps.first[_name],
        maps.first[_diceCount],
        maps.first[_minSide],
        maps.first[_maxSide],
      );
    }
    return null;
  }

  Future<void> insert(int id, String name, int diceCount, int minSide, int maxSide) async {
    await _db.insert(
      _tableName,
      {
        _id: id,
        _name: name,
        _diceCount: diceCount,
        _minSide: minSide,
        _maxSide: maxSide,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(int id) async {
    await _db.delete(
      _tableName,
      where: '$_id = ?',
      whereArgs: [id],
    );
  }

  Future<void> update(int id, String name, int diceCount, int minSide, int maxSide) async {
    await _db.update(
      _tableName,
      {
        _id: id,
        _name: name,
        _diceCount: diceCount,
        _minSide: minSide,
        _maxSide: maxSide,
      },
      where: '$_id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async => _db?.close();
}

class Favorite {
  final DatabaseFactory factory;

  const Favorite(this.factory);

  Future<void> save(int id, String name, int diceCount, int minSide, int maxSide) async {
    var helper = FavoriteHelper(factory);
    try {
      await helper.open();
      final result = await helper.fetch(id);
      if (result == null) {
        await helper.insert(id, name, diceCount, minSide, maxSide);
      } else {
        await helper.update(id, name, diceCount, minSide, maxSide);
      }
    } on SqfliteDatabaseException catch (e) {
      print(e.message);
    } finally {
      await helper.close();
    }
  }

  Future<FavoriteCondition?> fetch(int id) async {
    var helper = FavoriteHelper(factory);
    try {
      await helper.open();
      return await helper.fetch(id);
    } on SqfliteDatabaseException catch (e) {
      print(e.message);
      return null;
    } finally {
      await helper.close();
    }
  }

  Future<void> delete(int id) async {
    var helper = FavoriteHelper(factory);
    try {
      await helper.open();
      await helper.delete(id);
    } on SqfliteDatabaseException catch (e) {
      print(e.message);
    } finally {
      await helper.close();
    }
  }
}
