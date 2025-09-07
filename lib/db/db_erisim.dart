import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class VeritabaniYardimcisi {
  static const String veritabaniAdi = "kirtasiye.sqlite";

  static Future<Database> veritabaniErisim() async {
    String veritabaniYolu = join(await getDatabasesPath(), veritabaniAdi);

    // İlk çalıştırmada assets'ten kopyala
    if (!await databaseExists(veritabaniYolu)) {
      try {
        ByteData data = await rootBundle.load("veritabani/$veritabaniAdi");
        List<int> bytes = data.buffer.asUint8List(
          data.offsetInBytes,
          data.lengthInBytes,
        );
        await File(veritabaniYolu).writeAsBytes(bytes, flush: true);
        print("✅ Veritabani kopyalandı");
      } catch (e) {
        print("❌ Veritabani kopyalanırken hata: $e");
      }
    }

    // Veritabanını aç
    var db = await openDatabase(veritabaniYolu);

    // Eksik tabloları oluştur (varsa dokunmaz)
    await _createTablesIfNotExists(db);

    return db;
  }

  static Future<void> _createTablesIfNotExists(Database db) async {
    // Urunler tablosu
    await db.execute('''
    CREATE TABLE IF NOT EXISTS urunlerListe (
      urun_id INTEGER PRIMARY KEY AUTOINCREMENT,
      urun_barkod TEXT NOT NULL,
      urun_description TEXT,
      urun_adet INTEGER NOT NULL,
      urun_fiyat REAL NOT NULL,
      category TEXT,
      marka TEXT
    )
  ''');

    // GecmisSiparis tablosu
    await db.execute('''
    CREATE TABLE IF NOT EXISTS GecmisSiparis (
      gecmis_id INTEGER PRIMARY KEY AUTOINCREMENT,
      urun_id INTEGER NOT NULL,
      urun_barkod TEXT NOT NULL,
      urun_description TEXT,
      urun_adet INTEGER NOT NULL,
      urun_fiyat REAL NOT NULL,
      category TEXT,
      marka TEXT,
      sepet_birim INTEGER NOT NULL,
      toplam_tutar REAL NOT NULL,
      tarih TEXT NOT NULL
    )
  ''');

    // Sepet tablosu
    await db.execute('''
    CREATE TABLE IF NOT EXISTS sepetList (
      urun_id INTEGER PRIMARY KEY,
      urun_barkod TEXT NOT NULL,
      urun_description TEXT,
      urun_adet INTEGER NOT NULL,
      urun_fiyat REAL NOT NULL,
      category TEXT,
      marka TEXT,
      sepet_birim INTEGER NOT NULL,
      ilkToplam REAL NOT NULL
    )
  ''');

    // StokLimit tablosu
    await db.execute('''
    CREATE TABLE IF NOT EXISTS stokLimit (
      limit_id INTEGER PRIMARY KEY AUTOINCREMENT,
      stok_limit INTEGER NOT NULL
    )
  ''');
  }
}
