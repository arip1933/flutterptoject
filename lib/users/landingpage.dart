import 'package:flutter/material.dart';
import 'package:flutter_tokoonline/constans.dart';
import 'package:flutter_tokoonline/users/akunpage.dart';
import 'package:flutter_tokoonline/users/beranda.dart';
import 'package:flutter_tokoonline/users/keranjangpage.dart';
import 'package:flutter_tokoonline/users/chat.dart';

class LandingPage extends StatefulWidget {
  final Widget child;
  final String nav;

  LandingPage({this.nav, Key key, this.child}) : super(key: key);
  
  @override
  _BottomNaviState createState() => _BottomNaviState();
}

class _BottomNaviState extends State<LandingPage> {
int _bottomNavCurrentIndex = 0;
final List<Widget> _container = [
  new Beranda(),
  new KeranjangPage(),
  new TransaksiPage(),
  new ProfilePage(),
];

@override
  void initState() {
    super.initState();
    if (widget.nav == "1") {
      _bottomNavCurrentIndex = 1;
    }
  }

  @override
  void dispose() {
    _bottomNavCurrentIndex = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _container[ _bottomNavCurrentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Palette.orange,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
                     _bottomNavCurrentIndex = index; 
                    });
        },
        currentIndex: _bottomNavCurrentIndex,
        items: [
          BottomNavigationBarItem(
             icon: new Icon(
              Icons.home,
              color: Colors.grey,
            ),
            activeIcon: new Icon(
              Icons.home,
              color: Palette.orange,
            ),
            label: 'Beranda',
          ),
          
            BottomNavigationBarItem(
              
            icon: new Icon(
              Icons.shopping_cart,
              color: Colors.grey,
            ),
            activeIcon: new Icon(
              Icons.shopping_cart,
              color: Palette.orange,
            ),
          label: 'Keranjang',
          ),
            BottomNavigationBarItem(
            icon: new Icon(
              Icons.swap_horiz_sharp,
              color: Colors.grey,
            ),
            activeIcon: new Icon(
              Icons.swap_horiz_sharp,
              color: Palette.orange,
            ),
          label: 'Chat',
          ),
            BottomNavigationBarItem(
            icon: new Icon(
              Icons.person_outline,
              color: Colors.grey,
            ),
            activeIcon: new Icon(
              Icons.person,
              color: Palette.orange,
            ),
          label: 'Profile',
          ),
        ],
      ),
    );
  }
}
