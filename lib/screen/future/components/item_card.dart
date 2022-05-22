import 'package:flutter/material.dart';
import 'package:test3_0_0/api_clients/api_client.dart';

class ItemCard extends StatelessWidget {
  final Item i;
  final Function()? press;

  const ItemCard({
    Key? key,
    required this.i,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        //border: Border.all(color: Color(0xffe41145), width: 2),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
      //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            child: Text(
              i.name,
              softWrap: true,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Image.network(i.image, width: 100, height: 100),
          ),
          Row(children: [
            Icon(Icons.remove),
            Text(" 0 "),
            Icon(Icons.add),

          ],)

        ],
      ),
    );
  }
}
