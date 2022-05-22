import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:test3_0_0/provider/user_change_notifer.dart';
import 'package:test3_0_0/screen/auth/auth_screen.dart';
import 'package:test3_0_0/screen/home/home_screen.dart';
import 'package:test3_0_0/screen/scanner/scanner_screen.dart';

const SERVER_IP = 'http://192.168.1.167:5000';
final storage = FlutterSecureStorage();


class MyAppTest extends StatelessWidget {
  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if(jwt == null) return "";
    return jwt;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authentication Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
          future: jwtOrEmpty,
          builder: (context, snapshot) {
            if(!snapshot.hasData) return CircularProgressIndicator();
            if(snapshot.data != "") {
              var str = snapshot.data;
              var jwt = str.toString().split(".");

              if(jwt.length !=3) {
                return AuthScreen();
              } else {
                var payload = json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));
                if(DateTime.fromMillisecondsSinceEpoch(payload["exp"]*1000).isAfter(DateTime.now())) {
                  //str, payload
                  return HomeScreen();
                } else {
                  return AuthScreen();
                }
              }
            } else {
              return AuthScreen();
            }
          }
      ),
    );
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyAppTest());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserChangeNotifier>(
        create: (context) => UserChangeNotifier(),
        child: MaterialApp(
        title: 'Test App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // textTheme: ,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AuthScreen(),
        routes: {
          'home_screen': (context) => HomeScreen(),
          'scanner_screen': (context) => ScannerScreen(),
        }),
    );
  }
}
