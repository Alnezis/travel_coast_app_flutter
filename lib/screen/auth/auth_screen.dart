import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:test3_0_0/screen/home/home_screen.dart';

import '../../api_clients/api_client.dart';
import '../../main.dart';


const SERVER_IP = 'https://alnezis.riznex.ru:1337';



class AuthScreen extends StatefulWidget  {

  static const String id = 'auth_screen';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _numberPhoneController = TextEditingController();
  final TextEditingController _code = TextEditingController();

  final formGlobalKey = GlobalKey<FormState>();
  var code = 2;
  var idUser = null;

  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                SizedBox(height: 250,),
                Padding(
                  padding: (code == 2) ? EdgeInsets.all(50.0) :  EdgeInsets.only(left: 150, right: 150, top: 50, bottom: 50),
                  child: (code == 1) ? buildFormNUM() : (code == 0) ? CircularProgressIndicator() : buildForm(),),


                SizedBox(height: 100,),
                SizedBox(
                  width: 315,
                  height: 64,
                  child: ElevatedButton(
                    child: Text('ПРОДОЛЖИТЬ', textAlign: TextAlign.center, style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      letterSpacing: 4.681318283081055,
                      fontWeight: FontWeight.bold,
                    )),

                    style: ButtonStyle(
                      shape:  MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(34.0),
                          )
                      ),
                      backgroundColor: MaterialStateProperty.all(
                        const Color(0xff525298),
                      ),

                      foregroundColor:
                      MaterialStateProperty.all(Colors.white),
                    ),
                    onPressed: () async {
                       var num = _numberPhoneController.text;

                       if (formGlobalKey.currentState!.validate()) {
                         var n = num.replaceAll(RegExp('[- ]'), "");



                         if (code == 2) {
                           setState(() {
                           code = 0;
                         });
                           idUser = await ApiClient().getCode("7" + n);
                           if (idUser != null) {
                             setState(() {
                               code = 1;
                             });
                           }
                         } else {
                           var cod = _code.text;
                         print("code " + cod);

                         var i = await ApiClient().sendCode(idUser, cod);
                           if(i['token'] != null) {
                             setState(() {
                               code = 1;
                             });
                             print(i);
                             var jwt = i['token'];
                               storage.write(key: "jwt", value: jwt);
                             // setState((){
                             //   code = 1;
                             // });
                             Navigator.pushReplacement(
                               //DetailsScreen(code: code)
                               context,MaterialPageRoute(builder: (context) => HomeScreen()),);
                             } else {
                               displayDialog(context, "An Error Occurred",
                                   "No account was found matching");
                             }
                           }
                       }




                    },
                  ),
                ),
              ],
            ),
          ),
      )
      ),
    );
  }

  Form buildForm() {
    return Form(
                  key: formGlobalKey,
                  child: TextFormField(
                      controller: _numberPhoneController,
                      validator: (number) {

                        if (number == null || number.isEmpty) {
                          return 'Введите действительный номер.';
                        }
                        var n = number.replaceAll(RegExp('[- ]'), "");
                        if (n.length != 10) {
                          return 'Введите действительный номер.';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          border: InputBorder.none,
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide.none
                          ),
                          labelText: '+7 9XX XXX XXXX',

                          prefixText: "+7 "),
                      style: TextStyle(
                        color: Color.fromRGBO(126, 139, 149, 1),
                        fontFamily: 'Poppins',
                        fontSize: 35,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,

                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        MaskedInputFormatter('000 000 00-00')
                      ]),
                );
  }


  Form buildFormNUM() {
    _code.text = "";
    return Form(
      key: formGlobalKey,
      child: TextFormField(
          controller: _code,
          validator: (number) {

            if (number == null || number.isEmpty) {
              return 'Введите код.';
            }
            var n = number.replaceAll(RegExp('[- ]'), "");
            if (n.length != 4) {
              return 'Введите код.';
            }
            return null;
          },
          decoration: const InputDecoration(
              contentPadding: EdgeInsets.zero,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border: InputBorder.none,
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide.none
              ),
              labelText: 'XXXX',

              prefixText: ""),
          style: TextStyle(
            color: Color.fromRGBO(126, 139, 149, 1),
            fontFamily: 'Poppins',
            fontSize: 35,
            letterSpacing: 0,
            fontWeight: FontWeight.normal,

          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            MaskedInputFormatter('0000')
          ]),
    );
  }
}

// class Code extends StatelessWidget {
//   const Code({Key? key}) : super(key: key);
//
//   Future<String> get jwtOrEmpty async {
//     var jwt = await storage.read(key: "jwt");
//     if(jwt == null) return "";
//     return jwt;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Authentication Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: FutureBuilder(
//           future: jwtOrEmpty,
//           builder: (context, snapshot) {
//             if(!snapshot.hasData) return CircularProgressIndicator();
//             if(snapshot.data != "") {
//               var str = snapshot.data;
//               var jwt = str.split(".");
//
//               if(jwt.length !=3) {
//                 return LoginPage();
//               } else {
//                 var payload = json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));
//                 if(DateTime.fromMillisecondsSinceEpoch(payload["exp"]*1000).isAfter(DateTime.now())) {
//                   return HomePage(str, payload);
//                 } else {
//                   return LoginPage();
//                 }
//               }
//             } else {
//               return LoginPage();
//             }
//           }
//       ),
//     );
//   }
// }


//var jwt = await authCod(username, password);
//                         if (jwt != null) {
//                           storage.write(key: "jwt", value: jwt);