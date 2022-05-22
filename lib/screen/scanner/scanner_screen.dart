

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../constants.dart';
import '../details/details_screen.dart';
import '../future/future_screen.dart';
import '../test/test_screen.dart';

class ScannerScreen extends StatelessWidget {
  static const String id = 'scanner_screen';
   ScannerScreen({Key? key}) : super(key: key);

  MobileScannerController cameraController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Body(context),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
          color: kTextColor,
          onPressed: () {
            cameraController.stop();
            Navigator.pop(context);
          },
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

  Widget Body(BuildContext context) {
    cameraController.start();
    return MobileScanner(
        allowDuplicates: false,
        controller: cameraController,
        onDetect: (barcode, args) {
          if (barcode.rawValue == null) {
            debugPrint('Failed to scan Barcode');
          } else {
            final String code = barcode.rawValue!;

            // setState(() {
            //   text = code;
            // });

            debugPrint('Barcode found! $code');
            cameraController.stop();
            Navigator.pushReplacement(
              //DetailsScreen(code: code)
              context,MaterialPageRoute(builder: (context) => ShopScreen(code: code)),);
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) =>  DetailsScreen(code: code)));
          }
        });
  }
}

