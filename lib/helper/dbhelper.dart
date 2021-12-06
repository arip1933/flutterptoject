import 'dart:async';
import 'dart:io';
import 'package:flutter_tokoonline/models/keranjang.dart';
import 'package:flutter_tokoonline/users/profilemodel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static DbHelper _dbHelper;
  static Database _database;

  DbHelper._createObject();

  factory DbHelper() {
    if (_dbHelper == null) {
      _dbHelper = DbHelper._createObject();
    }
    return _dbHelper;
  }

  Future<Database> initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'tokoonline.db';

    var todoDatabase = openDatabase(path, version: 1, onCreate: _createDb);

    return todoDatabase;
  }

  //buat tabel baru
  void _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE keranjang (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        idproduk INTEGER,
        judul TEXT,
        harga TEXT,
        hargax TEXT,
        thumbnail TEXT,
        jumlah INTEGER,
        userid TEXT,
        idcabang TEXT
      );  
    ''');
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }
    return _database;
  }



  
Future<List<Map<String, dynamic>>> select() async {
    Database db = await this.database;
    var mapList = await db.query('profil', orderBy: 'nama');
    return mapList;
  }
  Future<int> insert(Profil object) async {
    Database db = await this.database;
    db.execute('delete from profil');
    int count = await db.insert('profil', object.toMap());
    return count;
  }
   Future<int> update(String nama, String alamat, String id) async {
    Database db = await this.database;
    db.execute(
        'update profil set nama=?,alamat=? where id=?', [nama, alamat, id]);
    int count = 1;
    return count;
  }

  Future<int> delete(int id) async {
    Database db = await this.database;
    int count = await db.delete('profil', where: 'id=?', whereArgs: [id]);
    return count;
  }

  Future<List<Profil>> getProfil() async {
    var profilMapList = await select();
    int count = profilMapList.length;
    // ignore: deprecated_member_use
    List<Profil> profilList = List<Profil>();
    for (int i = 0; i < count; i++) {
      profilList.add(Profil.fromMap(profilMapList[i]));
    }
    return profilList;
  }

  
  Future<List<Map<String, dynamic>>> selectkeranjang() async {
    Database db = await this.database;
    var mapList = await db.query('keranjang');
    return mapList;
  }

  Future<List<Keranjang>> getkeranjang() async {
    var mapList = await selectkeranjang();
    int count = mapList.length;
    // ignore: deprecated_member_use
    List<Keranjang> list = List<Keranjang>();
    for (int i = 0; i < count; i++) {
      list.add(Keranjang.fromMap(mapList[i]));
    }
    return list;
  }

}