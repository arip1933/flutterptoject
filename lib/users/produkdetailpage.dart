import 'package:flutter/material.dart';
import 'package:flutter_tokoonline/constans.dart';
import 'package:flutter_tokoonline/helper/dbhelper.dart';
import 'package:flutter_tokoonline/models/cabang.dart';
import 'package:flutter_tokoonline/models/keranjang.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class ProdukDetailPage extends StatefulWidget {
  final Widget child;
  final int id;
  final String judul;
  final String harga;
  final String hargax;
  final String thumbnail;
  final bool valstok;

  ProdukDetailPage(this.id, this.judul, this.harga, this.hargax, this.thumbnail,
      this.valstok,
      {Key key, this.child})
      : super(key: key);

  @override
  _ProdukDetailPageState createState() => _ProdukDetailPageState();
}

class _ProdukDetailPageState extends State<ProdukDetailPage> {
  List<Cabang> cabanglist = [];
  String _valcabang;
  bool instok = false;
  String userid;
  DbHelper dbHelper = DbHelper();

  @override
  void initState() {
    super.initState();
    fetchCabang();
    if (widget.valstok == true) {
      instok = widget.valstok;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }


  Future<List<Cabang>> fetchCabang() async {
    List<Cabang> usersList;
    var params = "/cabang";
    try {
      var jsonResponse = await http.get(Palette.sUrl + params);
      if (jsonResponse.statusCode == 200) {
        final jsonItems =
            json.decode(jsonResponse.body).cast<Map<String, dynamic>>();

        usersList = jsonItems.map<Cabang>((json) {
          return Cabang.fromJson(json);
        }).toList();
        setState(() {
          cabanglist = usersList;
        });
      }
    } catch (e) {}
    return usersList;
  }

  _cekProdukCabang(String idproduk, String idcabang) async {
    var params =
        "/cekprodukbycabang?idproduk=" + idproduk + "&idcabang=" + idcabang;
    try {
      var res = await http.get(Palette.sUrl + params);
      if (res.statusCode == 200) {
        if (res.body == "OK") {
          setState(() {
            instok = true;
          });
        } else {
          setState(() {
            instok = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        instok = false;
      });
    }
  }

  saveKeranjang(Keranjang _keranjang) async {
    Database db = await dbHelper.database;
    var batch = db.batch();
    db.execute(
        'insert into keranjang(idproduk,judul,harga,hargax,thumbnail,jumlah,userid,idcabang) values(?,?,?,?,?,?,?,?)',
        [
          _keranjang.idproduk,
          _keranjang.judul,
          _keranjang.harga,
          _keranjang.hargax,
          _keranjang.thumbnail,
          _keranjang.jumlah,
          _keranjang.userid,
          _keranjang.idcabang
        ]);
    await batch.commit();
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/keranjangusers', (Route<dynamic> route) => false);
  }
  
  Widget _body() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            child: Image.network(Palette.sUrl +"/"+ widget.thumbnail,
                    fit: BoxFit.fitWidth),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: Text(widget.judul),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: Text(widget.harga),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: DropdownButtonFormField(
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(top: 10, left: 12.0, bottom: 10),
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(5.0),
                    ),
                    borderSide: new BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                  fillColor: Colors.black,
                  filled: false),
              hint: Text("Pilih Cabang"),
              value: _valcabang,
              items: cabanglist.map((item) {
                return DropdownMenuItem(
                  child: Text(item.nama.toString()),
                  value: item.id.toString(),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _valcabang = value;
                  _cekProdukCabang(widget.id.toString(), _valcabang);
                });
              },
            ),
          ),
        
      Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.only(top: 10, left: 10, right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 12),
                              Divider(height: 1),
                              SizedBox(height: 6),
                              _buildUlasanProduk(),
                            ],
                          ),
                        ),
                        SizedBox(height: 12),
                        Container(
                          height: 16,
                          color: Colors.grey[200],
                        ),
                        SizedBox(height: 12),
                        _buildInformasiProduk(),
                        SizedBox(height: 12),
                        Container(
                          height: 8,
                          color: Colors.grey[200],
                        ),
                        SizedBox(height: 12),
                        _buildDeskripsiProduk(),
                        SizedBox(height: 12),
                        Container(
                          height: 8,
                          color: Colors.grey[200],
                        ),
                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            );
  }

  // cobaan
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaksi'),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _body(),
              ],
            ),
          ),
        ],
      ),      
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: Container(
          child: Row(
            children: [
              // Padding(
              //     padding: EdgeInsets.only(right: 20.0),
              //     child: GestureDetector(
              //       onTap: (){},
              //       child: Container(
              //         child: Icon(
              //           Icons.favorite_border,
              //           size: 40.0,
              //         ),
              //         decoration: BoxDecoration(
              //           color: Colors.grey[100],
              //           boxShadow: [
              //             BoxShadow(color: Colors.grey[500], spreadRadius: 1),
              //           ],
              //         ),
              //       ),
              //     )),
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/keranjangusers', (Route<dynamic> route) => false);
                    },
                    child: Container(
                      child: Icon(
                        Icons.shopping_cart,
                        size: 40.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        boxShadow: [
                          BoxShadow(color: Colors.grey[500], spreadRadius: 1),
                        ],
                      ),
                    ),
                  )),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (instok == true) {
                      Keranjang _keranjangku = Keranjang(
                          idproduk: widget.id,
                          judul: widget.judul,
                          harga: widget.harga,
                          hargax: widget.hargax,
                          thumbnail: widget.thumbnail,
                          jumlah: 1,
                          userid: userid,
                          idcabang: _valcabang);
                      saveKeranjang(_keranjangku);
                    }
                  },
                  child: Container(
                    height: 40.0,
                    child: Center(
                      child: Text('Beli Sekarang',
                          style: TextStyle(color: Colors.white)),
                    ),
                    decoration: BoxDecoration(
                      color: instok == true ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                            color: instok == true ? Colors.blue : Colors.grey,
                            spreadRadius: 1),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          height: 60.0,
          padding:
              EdgeInsets.only(left: 10.0, right: 10.0, top: 2.0, bottom: 2.0),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            boxShadow: [
              BoxShadow(color: Colors.grey[100], spreadRadius: 1),
            ],
          ),
        ),
        elevation: 0,
      ),
    );
  }
}
Padding _buildDeskripsiProduk() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Deskripsi Produk',
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(
              'Terobosan baru untuk smartphone berbasis android dengan spesifikasi yang sangar luar biasa diera 2020. Wow briliant ide untuk membuat smartphone se power full ini. Sehingga...',
              style: TextStyle(fontSize: 12)),
          SizedBox(height: 12),
          Text('Baca Selengkapnya',
              style: TextStyle(fontSize: 12, color: Colors.green)),
        ],
      ),
    );
  }

  Padding _buildInformasiProduk() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Informasi Produk',
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Berat', style: TextStyle(fontSize: 12)),
              Text('100 Gram', style: TextStyle(fontSize: 12)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Kondisi', style: TextStyle(fontSize: 12)),
              Text('Baru', style: TextStyle(fontSize: 12)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Asuransi', style: TextStyle(fontSize: 12)),
              Text('Ya', style: TextStyle(fontSize: 12)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Pemesanan Min', style: TextStyle(fontSize: 12)),
              Text('1 Buah', style: TextStyle(fontSize: 12)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Kategori', style: TextStyle(fontSize: 12)),
              Text('Smartphone Handphone',
                  style: TextStyle(fontSize: 12, color: Colors.green)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Etalase', style: TextStyle(fontSize: 12)),
              Text('Hydrogel',
                  style: TextStyle(fontSize: 12, color: Colors.green)),
            ],
          ),
        ],
      ),
    );
  }

  Column _buildUlasanProduk() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Stok tersedia', style: TextStyle(fontSize: 11)),
        SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      '4.7',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.star, color: Colors.yellow, size: 14),
                    Text('/5', style: TextStyle(fontSize: 10)),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  '375 Ulasan',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Text(
                  'Q&A',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  '210 Diskusi',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Icon(Icons.train, color: Colors.green, size: 18),
                SizedBox(height: 6),
                Text(
                  'Pengiriman',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      'Dilihat',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[500],
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '30,7rb',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      'Transaksi Berhasil',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[500],
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '99,2% (1.246)',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      'Wishlist',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[500],
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '827',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  

  // code cobaan