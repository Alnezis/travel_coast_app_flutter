import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/user_change_notifer.dart';


class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<TestScreen> {
  // final userRepository = UserRepository();
  // late Future<List<User>?> userFuture;

  @override
  void initState() {
    UserChangeNotifier().transfer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Error Handling'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Consumer<UserChangeNotifier>(
              builder: (_, notifier, __) {
                if (notifier.state == NotifierState.initial) {
                  return const Text(
                    'Press the button 👇',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 40),
                  );
                } else if (notifier.state == NotifierState.loading) {
                  return const CircularProgressIndicator();
                } else {
                  if (notifier.failure != null) {
                    return Text(
                      notifier.failure.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 40),
                    );
                  } else {
                    return Column(
                      children: notifier.users.map(
                            (user) =>
                            Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Text(
                                user.phoneNumber.toString(),
                                style: const TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                      )
                          .toList(),
                    );
                  }
                }
              },
            ),
            ElevatedButton(
              child: const Text('Get Users'),
              onPressed: () async {
                setState(() {
                  // userFuture = userRepository.getUsers();
                  context.read<UserChangeNotifier>().transfer();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}