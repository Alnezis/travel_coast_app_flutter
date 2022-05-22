import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../failure.dart';

class User {
  User({required this.phoneNumber, required this.id});
  final String phoneNumber; // non-nullable
  final int id; // non-nullable

  factory User.fromJson(Map<String, dynamic> data) {
    final phoneNumber = data['phone_number'] as String; // cast as non-nullable String
    final id = data['id'] as int; // cast as non-nullable String
    return User(phoneNumber: phoneNumber, id: id);
  }
}

class ApiClient {

  Future<List<User>>  users() async {
    String url = 'https://alnezis.riznex.ru:1337/users';
    try {
      var response = await Dio().get(url);

      print('Response status: ${response.statusCode}');
      if(response.statusCode != 200){
        return Future.error("Error: response.statusCode "+response.statusCode.toString());
      }

      if(response.data['error'] != null) {
        return Future.error("Error: "+response.data['error']['message'].toString());
      }
      var result = <User>[];
      response.data['result'].forEach((v) {
        result.add(new User.fromJson(v));
      });
      return result;

    } on SocketException catch (e) {
       return Future.error("Error: No Internet connection 😑");
    } on DioError catch (e) {
        print(e.type);
        print(e.message);
    return Future.error("DIO Error: "+e.message);
    }
  }


  Future<int?> getCode(number) async {
    String url = 'https://alnezis.riznex.ru:1337/auth/code';
    try {
      var response = await Dio().post(url, data: '{"number_phone": "$number"}');

      print('Response status: ${response.data}');
      if(response.statusCode != 200){
        return Future.error("Error: response.statusCode "+response.statusCode.toString());
      }

      if(response.data['error'] != null) {
        return Future.error("Error: "+response.data['error']['message'].toString());
      }
      if (response.data['result']['status'] == 'OK') {
        return int.parse(response.data['result']['user_id']);
      }

    } on SocketException catch (e) {
      return Future.error("Error: No Internet connection 😑");
    } on DioError catch (e) {
      print(e.type);
      print(e.message);
      return Future.error("DIO Error: "+e.message);
    }
  }

  Future<dynamic> sendCode(id, code) async {
    print(code);
    String url = 'https://alnezis.riznex.ru:1337/auth/checkCode';
    try {
      var response = await Dio().post(url, data: '{"user_id": $id, "code": "$code"}');

      print('Response status: ${response.data}');
      if(response.statusCode != 200){
        return Future.error("Error: response.statusCode "+response.statusCode.toString());
      }

      if(response.data['error'] != null) {
        return Future.error("Error: "+response.data['error']['message'].toString());
      }
      if (response.data['result']['status'] == 'OK') {
        return response.data['result'];
      }

    } on SocketException catch (e) {
      return Future.error("Error: No Internet connection 😑");
    } on DioError catch (e) {
      print(e.type);
      print(e.message);
      return Future.error("DIO Error: "+e.message);
    }
  }





  Future<List<Item>>  items(String code) async {
    String url = 'https://alnezis.riznex.ru:1337/items/'+code;
    try {
      var response = await Dio().get(url);

      print('Response status: ${response.statusCode}');
      if(response.statusCode != 200){
        return Future.error("Error: response.statusCode "+response.statusCode.toString());
      }

      if(response.data['error'] != null) {
        return Future.error("Error: ${response.data['error']['message']}");
      }
      var result = <Item>[];
      print(response.data);
      response.data['result'].forEach((v) {
        result.add(new Item.fromJson(v));
      });
      return result;

    } on SocketException catch (e) {
      return Future.error("Error: No Internet connection 😑");
    } on DioError catch (e) {
      print(e.type);
      print(e.message);
      return Future.error("DIO Error: "+e.message);
    }
  }
}


class Item {
  Item({required this.shopID, required this.name, required this.description, required this.count, required this.price, required this.created, required this.status, required this.timeUpdated, required this.id, required this.image});
  final int id;
  final int shopID;
  final String name;
  final String description;
  final int count;
  final double price;
  final String image;
  final DateTime created;
  final int status;
  final DateTime timeUpdated;

  factory Item.fromJson(Map<String, dynamic> data) {
    final id = data['id'] as int;
    final shopID = data['shop_id'] as int;
    final name = data['name'] as String;
    final description = data['description'] as String;
    final count = data['count'] as int;
    final price = data['price'] as double;
    final image = data['image'] as String;
    final created = DateTime.parse(data['created']);
    final status = data['status'] as int;
    final timeUpdated = DateTime.parse(data['time_updated']);


    return Item(shopID: shopID, name: name, description: description, count: count, price: price, image: image, created: created, status: status, timeUpdated: timeUpdated, id: id);
  }
}


