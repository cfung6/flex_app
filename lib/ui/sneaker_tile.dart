import 'package:flex/models/sneaker.dart';
import 'package:flutter/material.dart';

class SneakerTile extends StatelessWidget {
  final Sneaker sneaker;
  final Future<void> Function(Sneaker s) onTap;

  const SneakerTile({@required this.sneaker, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
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
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  await onTap(sneaker);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
