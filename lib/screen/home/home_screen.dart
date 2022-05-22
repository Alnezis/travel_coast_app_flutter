import 'package:flutter/material.dart';
import 'package:test3_0_0/screen/scanner/scanner_screen.dart';

import '../../constants.dart';

class HomeScreen extends StatelessWidget {
  static const String id = 'home_screen';
  const HomeScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Body(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: kDefaultPadding / 2),
        child: Icon(Icons.qr_code_scanner),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ScannerScreen()));
          },
          icon: const Icon(Icons.qr_code_scanner),
          color: kTextColor,
        ),
      ],
    );
  }

}

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: Text("Главный экран")));
  }
}
