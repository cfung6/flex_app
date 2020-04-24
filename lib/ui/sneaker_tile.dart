import 'package:flutter/cupertino.dart';

import 'file:///C:/Users/chris/StudioProjects/flex/lib/ui/sneaker.dart';

class SneakerTile extends StatelessWidget {
  final Sneaker sneaker;

  const SneakerTile({
    @required this.sneaker,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FadeInImage.assetNetwork(
                  height: 150,
                  width: 150,
                  image: sneaker.smallImage,
                  placeholder: 'assets/images/no_image.png',
                ),
              ],
            ),
          ),
          SizedBox(height: 5.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(
                  sneaker.name,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
