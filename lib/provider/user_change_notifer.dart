import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../api_clients/api_client.dart';

import '../failure.dart';


enum NotifierState { initial, loading, loaded }


class UserChangeNotifier extends ChangeNotifier {
  final _userRepository = ApiClient();

  // notifyListeners();
  var camera = false;

  late List<User> users;
  void setCamera() {
    camera = !camera;
    print("set сам");
        notifyListeners();
  }
  void display() {
  //print("Name: $name Age: $age");
  }

  NotifierState _state = NotifierState.initial;

  NotifierState get state => _state;

  void _setState(NotifierState state) {
    _state = state;
    notifyListeners();
  }

  Failure? _failure;

  Failure? get failure => _failure;

  void _setFailure(Failure failure) {
    _setState(NotifierState.initial);
    _failure = failure;
    notifyListeners();
  }

  void transfer() async {
    _setState(NotifierState.loading);

    try {
      final uses = await _userRepository.users();
      print(uses);
      if (uses != null) {
          users = uses;
          _setState(NotifierState.loaded);
      }

      //   _setUsers(users);
    } on Failure catch (f) {
      _setFailure(f);
      //player.authError = f.message
    }


  }
}

