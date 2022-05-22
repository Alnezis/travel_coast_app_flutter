import 'package:flutter/material.dart';
import 'package:test3_0_0/api_clients/api_client.dart';

import '../../constants.dart';
import '../details/details_screen.dart';
import 'components/item_card.dart';


class ShopScreen extends StatefulWidget {
  var code;

  ShopScreen({required this.code});

  @override
  State<StatefulWidget> createState() {
    return _ShopScreenState ();
  }
}

class _ShopScreenState extends State<ShopScreen> {

  late Future<List<Item>> _value;

  @override
  initState() {
    super.initState();
    _value = ApiClient().items(widget.code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test app'),
      ),
      body: FutureBuilder<List<Item>>(
        future: _value,
        // initialData: 'App Name',
        builder: (BuildContext context,
            AsyncSnapshot<List<Item>> snapshot,) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Visibility(
                  visible: snapshot.hasData,
                  child: Text(
                    snapshot.data.toString(),
                    style: const TextStyle(color: Colors.black,
                        fontSize: 24),
                  ),
                )
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return Text(snapshot.error.toString());
            } else if (snapshot.hasData) {
              return buildContent(snapshot);
            } else {
              return const Text('Empty data');
            }
          } else {
            return Text('State: ${snapshot.connectionState}');
          }
        },
      ),
    );
  }

  SingleChildScrollView buildContent(AsyncSnapshot<List<Item>> snapshot) {
    return SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(kDefaultPadding / 4),
            //   child: Image.asset("assets/images/promo.png"),
            // ),

            Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Text(
                "Товары и услуги",
                style: Theme
                    .of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(fontWeight: FontWeight.normal),
              ),
            ),
            //   Categories(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: GridView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: kDefaultPadding,
                    crossAxisSpacing: kDefaultPadding,
                    crossAxisCount: 2,
                    childAspectRatio: 1
                ),
                itemBuilder: (context, index) =>
                    ItemCard(
                      i: snapshot.data![index],
                      // press: () => Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => DetailsScreen(
                      //               product: products[index],
                      //             ))
                      press: () {
                        //todo
                      },
                    ),
              ),
            ),

          ],
        ));
  }
}