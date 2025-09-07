class Urunler {
  int? urun_id;
  String urun_barkod;
  String urun_description;
  int urun_adet;
  double urun_fiyat;
  String category;
  String marka;

  Urunler({
    this.urun_id,
    required this.urun_barkod,
    required this.urun_description,
    required this.urun_adet,
    required this.urun_fiyat,
    required this.category,
    required this.marka,
  });

  factory Urunler.fromMap(Map<String, dynamic> map) {
    double toDouble(dynamic value) => value is int ? value.toDouble() : value;

    return Urunler(
      urun_id: map['urun_id'],
      urun_barkod: map['urun_barkod'],
      urun_description: map['urun_description'],
      urun_adet: map['urun_adet'],
      urun_fiyat: toDouble(map['urun_fiyat']),
      category: map["category"],
      marka: map["marka"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'urun_id': urun_id,
      'urun_barkod': urun_barkod,
      'urun_description': urun_description,
      'urun_adet': urun_adet,
      'urun_fiyat': urun_fiyat,
      "category": category,
      "marka": marka,
    };
  }
}
