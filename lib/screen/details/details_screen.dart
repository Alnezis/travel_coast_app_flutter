import 'package:flutter/material.dart';
import 'package:test3_0_0/screen/scanner/scanner_screen.dart';

import '../../constants.dart';


class DetailsScreen extends StatelessWidget {
  static const String id = 'details_screen';

  var code;

   DetailsScreen({required this.code});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Center(child: Text("QR: "+code)),
    );
  }


  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
          color: kTextColor,
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back)),
      actions: [
        IconButton(
          color: kTextColor,
          icon: Icon(Icons.info_outline),
          onPressed: () {
            // context.read<UserChangeNotifier>().setCamera();
          },
          iconSize: 32.0,
        ),
        SizedBox(width: kDefaultPadding / 2,)
      ],
    );
  }

}
