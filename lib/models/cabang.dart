class Cabang {
  final int id;
  final String nama;
  final String alamat;
  final String kota;
  final String provinsi;
  final String kodepos;
  final String telp;
  final String email;

 
  Cabang({this.id,this.nama,this.alamat,this.kota,this.provinsi,this.kodepos, this.telp, this.email});
 
  factory Cabang.fromJson(Map<String, dynamic> json) {
    return Cabang(
      id: json['id'] as int,
      nama: json['nama'] as String,
      alamat: json['alamat'] as String,
      kota: json['kota'] as String,
      provinsi: json['provinsi'] as String,
      kodepos: json['kodepos'] as String,
      telp: json['telp'] as String,
      email: json['email'] as String

    );
  }
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = id;
    map['nama'] = nama;
    map['alamat'] = alamat;
    map['kota'] = kota;
    map['provinsi'] = provinsi;
    map['kodepos'] = kodepos;
    map['telp'] = telp;
    map['email'] = email;
    return map;
  }
}