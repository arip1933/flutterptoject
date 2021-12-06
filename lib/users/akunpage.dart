import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tokoonline/helper/model/user.dart';
import 'package:flutter_tokoonline/helper/page/edit_profile_page.dart';
import 'package:flutter_tokoonline/helper/utils/user_preferences.dart';
import 'package:flutter_tokoonline/helper/widget/appbar_widget.dart';
import 'package:flutter_tokoonline/helper/widget/button_widget.dart';
import 'package:flutter_tokoonline/helper/widget/numbers_widget.dart';
import 'package:flutter_tokoonline/helper/widget/profile_widget.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final user = UserPreferences.getUser();

    return ThemeSwitchingArea(
      child: Builder(
        builder: (context) => Scaffold(
          appBar: buildAppBar(context),
          body: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              ProfileWidget(
                imagePath: user.imagePath,
                onClicked: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => EditProfilePage()),
                  );
                  setState(() {});
                },
              ),
              const SizedBox(height: 24),
              buildName(user),
              const SizedBox(height: 24),
          Center(child: buildUpgradeButton()),
              const SizedBox(height: 24),
              const SizedBox(height: 24),
              NumbersWidget(),
              const SizedBox(height: 48),
              buildAbout(user),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildName(User user) => Column(
        children: [
          Text(
            user.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: TextStyle(color: Colors.grey),
          ),
           const SizedBox(height: 4),
          Text(
            user.handphone,
            style: TextStyle(color: Colors.grey),
          )
        ],
      );
       Widget buildUpgradeButton() => ButtonWidget(
        text: 'ISI SALDO',
        onClicked: () {},
      );

      
  Widget buildAbout(User user) => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Alamat Lengkap',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              user.about,
              style: TextStyle(fontSize: 18, height: 1.4),
            ),
             const SizedBox(height: 24),
                ButtonWidget(
                  text: 'Logout',
                  onClicked: () {
                    // UserPreferences.setUser(user);
                    // Navigator.of(context).pop();
                  },
                )
          ],
          
        ),
      );
}
